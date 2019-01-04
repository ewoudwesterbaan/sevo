module visualisation::PolyMetricTreeView

import vis::Figure;
import vis::Render;
import vis::KeySym;

import List;
import Set;
import Map;

import visualisation::widgets::Widgets;

import IO;

// Voor het ophalen van klassen en methoden uit een project:
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;

// Voor het bepalen van de complexity
import metrics::Complexity;

// Voor het bepalen van de codeLines
import utils::Utils;

private alias UnitInfoTuple = tuple[loc location, str unitName, int complexity, int codeLines];
private alias UnitInfoList = list[UnitInfoTuple];
private alias ClassInfoTuple = tuple[loc location, str className, str pkgName, int avgComplexity, int codeLines];
private alias ClassInfoMap = map[ClassInfoTuple clazz, UnitInfoList units];
private alias PkgInfoMap = map[str pkgName, list[ClassInfoMap classInfo] clazzes];

private loc project = |project://VisualisationTest/|;
//private loc project = |project://ComplexityTest/|;
//private loc project = |project://smallsql/|;
//private loc project = |project://DuplicationTest/|;
//private loc project = |project://JabberPoint/|;

private str projectName = "<project>"[11..-1];

private RelComplexities complexities = cyclomaticComplexity(project);

// Toont alle packages in het project (zonder de bijbhorende klassen). 
// De grootte van de nodes is afhankelijk van het aantal lines of code.
// De kleur van de nodes is afhankelijk van de (gewogen) complexiteit.
public void showProjectTree() {
	// Verzamel info van alle packages
    PkgInfoMap pkgInfo = getPkgInfoMapFromClassInfoMap(getClassInfo(project));
    
	// De root van de tree representeert het project.
	root = createProjectFigure(projectName);
	
	// De leaves van de tree representeren de packages. We stellen de leaves hier samen.
	leaves = [];
	for (pkgName <- pkgInfo) leaves += createPkgFigure(pkgName, pkgInfo, true);
	
	render(grid([[createTree(root, leaves)]]));
}

// Toont een boom van een package met de bijbehorende klassen.
// De grootte van de nodes is afhankelijk van het aantal lines of code.
// De kleur van de nodes is afhankelijk van de (gewogen) complexiteit.
private void showPackageTree(str packageName) {
	// Verzamel info van alle packages
    PkgInfoMap pkgInfo = getPkgInfoMapFromClassInfoMap(getClassInfo(project));
    
	for (pkgName <- pkgInfo) {
		// Filter op packagenaam
		if (pkgName != packageName) continue;
		
		// De root van de tree representeert de package. We stellen de root hier samen.
		root = createPkgFigure(pkgName, pkgInfo, false);
		
		// De leaves van de tree representeren de klassen. We stellen de leaves hier samen.
		leaves = [];
		for (classInfo <- pkgInfo[pkgName]) {
			for (clazz <- classInfo) leaves += createClassFigure(clazz, classInfo, true);
		}
		
		// Render een grid met de boom
		render(grid([[createTree(root, leaves)]]));
		return;
	}	
}

// Toont een boom van een klasse met de bijbehorende methoden.
// De grootte van de nodes is afhankelijk van het aantal lines of code.
// De kleur van de nodes is afhankelijk van de (gewogen) complexiteit.
public void showClassTree(str classId) {
	// Verzamel info van alle classes
    ClassInfoMap classInfo = getClassInfo(project);
	
	for (clazz <- classInfo) {
		// Filter op classId (location)
		if (classId != "<clazz.location>") continue;
	
		// De root van de tree representeert de klasse. We stellen de root hier samen.
		root = createClassFigure(clazz, classInfo, false);
		
		// De leaves van de tree representeren de units (methoden en constructoren). We stellen de leaves hier samen.
		leaves = [];
		for (unit <- classInfo[clazz]) leaves += createUnitFigure(unit);

		// Render een grid met de gegenereerde rows
		render(grid([[createTree(root, leaves)]]));
		return;
	}	

}

// Maakt een boom met de opgegeven root en leaves.
// Er wordt een aantal standaard properties aan de tree toegevoegd (grootte, tussenruimte, orientatie, ...)
// De orientatie is leftRight, en de bomen worden links uitgelijnd.
private Figure createTree(Figure root, list[Figure] leaves) {
	return tree(root, leaves, std(size(30)), std(hgap(30)), std(vgap(2)), orientation(leftRight()), left());
}

// Maakt een Figure representatie voor een project.
private Figure createProjectFigure(str projectName) {
	int width = 40; // TODO
	str popupText = "Project: <projectName>. "; // TODO: volume en gewogen complexiteit in de popup opnemen.
	Color clr = getProjectFillColor(1);; // TODO
	Figure b = box(size(width, 10), fillColor(clr), popup(popupText));
	Figure t = text(projectName);
	return hcat([t, b], id(projectName), hgap(5));
}

// Maakt een Figure representatie voor een package.
private Figure createPkgFigure(str pkgName, PkgInfoMap pkgInfo, bool isLeaf) {
	int width = 40; // TODO
	str popupText = "Package: <pkgName>. "; // TODO: volume en gewogen complexiteit in de popup opnemen.
	Color clr = getPkgFillColor(1);; // TODO
	Figure leafbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Click to zoom in.)"), handlePackageClick(pkgName));
	Figure rootbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Shift-click to zoom out.)"), handlePackageShiftClick());
	Figure t = text(pkgName);
	if (isLeaf) return hcat([leafbox, t], id(pkgName), hgap(5));
	return hcat([t, rootbox], id(pkgName), hgap(5));
}

// Maakt een Figure representatie voor een klasse.
//   - de location van de klasse fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de (gewogen) complexiteit van de klasse.
private Figure createClassFigure(ClassInfoTuple clazz, ClassInfoMap classInfo, bool isLeaf) {
	str classId = "<clazz.location>";
	str className = clazz.className;
	str pkgName = clazz.pkgName == "" ? "\<root\>" : clazz.pkgName;
	int width = getClassSize(clazz.codeLines);
	str popupText = "Class: <className>, LOC: <clazz.codeLines>, weighed complexity: <clazz.avgComplexity>. ";
	Color clr = getClassFillColor(clazz.avgComplexity);
	Figure leafbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Click to zoom in.)"), handleClassClick(classId));
	Figure rootbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Shift-click to zoom out.)"), handleClassShiftClick(pkgName));
	Figure t = text(className);
	if (isLeaf) return hcat([leafbox, t], id(classId), hgap(5));
	return hcat([t, rootbox], id(classId), hgap(5)); 
}

// Maak een Figure representatie voor een unit.
//   - de location van de unit fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de complexiteit van de unit.
private Figure createUnitFigure(UnitInfoTuple unit) {
	str unitId = "<unit.location>";
	str unitName = unit.unitName;
	int width = getUnitSize(unit.codeLines);
	str popupText = "Unit: <unitName>, LOC: <unit.codeLines>, cyclomatic complexity: <unit.complexity>";
	Color clr = getUnitFillColor(unit.complexity);
	Figure b = box(size(width, 10), fillColor(clr), popup(popupText));
	Figure t = text(unitName);
	return hcat([b, t], id(unitId), hgap(5));
}

// Handelt een click event af op een package 
private FProperty handlePackageClick(str pkgName) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) return false;
		if (modifiers[modCtrl()]) return false;
		if (modifiers[modAlt()]) return false;
		showPackageTree(pkgName);
		return true;
	});
}

// Handelt een shift-click event af op een package 
private FProperty handlePackageShiftClick() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) {
			showProjectTree();
			return true;
		}
		return false;
	});
}

// Handelt een click event af op een klasse 
private FProperty handleClassClick(str classId) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) return false;
		if (modifiers[modCtrl()]) return false;
		if (modifiers[modAlt()]) return false;
		showClassTree(classId);
		return true;
	});
}

// Handelt een shift-click event af op een klasse 
private FProperty handleClassShiftClick(str pkgName) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) {
			showPackageTree(pkgName);
			return true;
		}
		return false;
	});
}

// Bepaalt de kleur van een project figure op basis van de gewogen complexity
private Color getProjectFillColor(int avgComplexity) {
	return getFillColor(avgComplexity, "gold");
}

// Bepaalt de kleur van een package figure op basis van de gewogen complexity
private Color getPkgFillColor(int avgComplexity) {
	return getFillColor(avgComplexity, "crimson");
}

// Bepaalt de kleur van een klasse figure op basis van de gewogen complexity
private Color getClassFillColor(int avgComplexity) {
	return getFillColor(avgComplexity, "green");
}

// Bepaalt de kleur van een unit op basis van de complexity
private Color getUnitFillColor(int complexity) {
	return getFillColor(complexity, "purple");
}

// Bepaalt de kleur van een figuur op basis van de complexity en een basiskleur
private Color getFillColor(int complexity, str baseColor) {
	real gradient = 0.65 / (complexity < 1 ? 1 : complexity);
	return color(baseColor, 1 - gradient);
}

// Bepaalt de grootte van een unit op basis van de lines of code
private int getUnitSize(int codeLines) {
	return 25 + codeLines / 2;
}

// Bepaalt de grootte van een class op basis van de lines of code
private int getClassSize(int codeLines) {
	return 25 + codeLines / 6;
}

// TODO: hoort deze methode wellicht thuis in de Utils module als een public methode?
// Haalt alle methoden en constructoren op, per java-klasse, voor het hele project.
private ClassInfoMap getClassInfo(loc project) {
	// Initieel is het result leeg. Deze gaan we hieronder vullen.
	ClassInfoMap result = ();	
	
    for (Declaration ast <- createAstsFromEclipseProject(project, true)) {
    	loc classLocation = ast.src; 
    	ClassInfoTuple clazz = <classLocation, "", "", 1, getLinesOfCode(classLocation).codeLines>;
    	UnitInfoList units = [];
    	int sumComplexityFactor = 0;
    	int sumUnitCodeLines = 0;

        visit(ast) {
        	// Get package name
            case \package(parent, name) : {
            	if (clazz.pkgName == "") clazz.pkgName = "<parent.name>";
            	clazz.pkgName += ".<name>";
            }
        	// Get class name
            case \class(name, _, _, _) : {
            	clazz.className = name;
            } 
            // Get constructor info 
            case \constructor(name, _, _, impl) : {
                int complexity = getComplexityMetric(impl.src);
            	int codeLines = getLinesOfCode(impl.src).codeLines;
            	units += <impl.src, name, complexity, codeLines>;
            	sumComplexityFactor += complexity * codeLines;
            	sumUnitCodeLines += codeLines;
            }
            // Get method info
            case \method(_, name, _, _, impl) : {
                int complexity = getComplexityMetric(impl.src);
            	int codeLines = getLinesOfCode(impl.src).codeLines;
            	units += <impl.src, name, complexity, codeLines>;
            	sumComplexityFactor += complexity * codeLines;
            	sumUnitCodeLines += codeLines;
            }
        }
        clazz.avgComplexity = sumComplexityFactor / sumUnitCodeLines;
        result += (clazz : units);
    }
    return result;
}

// TODO: hoort deze methode wellicht thuis in de Utils module als een public methode?
// Maakt uit een ClassInfoMap een PkgInfoMap. Dit is een map met als key de package naam, en 
// als values een lijst met ClassInfoMaps van klassen in de respectievelijke package.
private PkgInfoMap getPkgInfoMapFromClassInfoMap(ClassInfoMap classInfo) {
	PkgInfoMap result = ();
	for (clazz <- classInfo) {
		str pkgName = clazz.pkgName == "" ? "\<root\>" : clazz.pkgName;
		if (pkgName notin result) result += (pkgName : [(clazz : classInfo[clazz])]);
		else result[pkgName] += (clazz : classInfo[clazz]);
	}
	return result;
}

// Geeft de complexity metric terug voor een bepaalde unit
// TODO: hoort deze methode wellicht thuis in de Complexity module als een public methode?
private int getComplexityMetric(loc unit) {
	return head([complexity.complexity | complexity <- complexities, complexity.location == unit]);
}

