module visualisation::PolyMetricViewExercise

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

//private loc project = |project://VisualisationTest/|;
//private loc project = |project://ComplexityTest/|;
//private loc project = |project://smallsql/|;
//private loc project = |project://DuplicationTest/|;
private loc project = |project://JabberPoint/|;

private RelComplexities complexities = cyclomaticComplexity(project);

// Toont alle packages in het project (zonder de bijbhorende klassen). 
public void showPackages() {
    PkgInfoMap pkgInfo = getPkgInfoMapFromClassInfoMap(getClassInfo(project));
	rows = [];
	for (pkgName <- pkgInfo) rows += [[createTree(createPkgFigure(pkgName, pkgInfo, true), [])]];
	render(box(grid(rows),size(200)));
}

// Toont een boom van alle packages met hun classes in het project
private void showPackageTree(str packageName) {
	// Verzamel info van alle packages
    PkgInfoMap pkgInfo = getPkgInfoMapFromClassInfoMap(getClassInfo(project));

	// Grid bestaat uit rows, die elk 1 column zullen bevatten
	rows = [];
	
	for (pkgName <- pkgInfo) {
		// Filter op packagenaam
		if (pkgName != packageName) continue;
		
		// De root van de tree representeert de packagenaam. We stellen de root hier samen.
		root = createPkgFigure(pkgName, pkgInfo, false);
		// De leaves van de tree representeren de klassen. We stellen de leaves hier samen.
		leaves = [];
		for (classInfo <- pkgInfo[pkgName]) {
			for (clazz <- classInfo) {
    	    	leaves += createClassFigure(clazz, classInfo, true);
    		}
		}
		// Voeg column toe aan de row. Deze column bevat een tree, bestaande uit de root (class) en de leaves (units).
		rows += [[createTree(root, leaves)]];
	}	

	// Render een grid met de gegenereerde rows
	render(box(grid(rows),size(200)));
}

// Toont een grid met een boom per klasse met de methoden als leaves van de klasse
// Alle bomen worden onder elkaar getoond, en hebben als root de klasse.
// De grootte van de nodes is afhankelijk van het aantal lines of code.
// De kleur van de nodes is afhankelijk van de (gewogen) complexiteit (donkerder = complexer).
public void showClassTree(str classId) {
	// Verzamel info van alle classes
    ClassInfoMap classInfo = getClassInfo(project);
	
	// Grid bestaat uit rows, die elk 1 column zullen bevatten
	rows = [];
	
	for (clazz <- classInfo) {
		// Filter op classId (location)
		if (classId != "<clazz.location>") continue;
	
		// De root van de tree representeert de klasse. We stellen de root hier samen.
		root = createClassFigure(clazz, classInfo, false);
		// De leaves van de tree representeren de units (methoden en constructoren). We stellen de leaves hier samen.
		leaves = [];
		for (unit <- classInfo[clazz]) {
	        leaves += createUnitFigure(unit);
		}
		// Voeg column toe aan de row. Deze column bevat een tree, bestaande uit de root (class) en de leaves (units).
		rows += [[createTree(root, leaves)]];
	}	

	// Render een grid met de gegenereerde rows
	render(box(grid(rows),size(200)));
}

// Maakt een boom met de opgegeven root en leaves.
// Er wordt een aantal standaard properties aan de tree toegevoegd (grootte, tussenruimte, orientatie, ...)
// De orientatie is leftRight, en de bomen worden links uitgelijnd.
private Figure createTree(Figure root, list[Figure] leaves) {
	return tree(root, leaves, std(size(30)), std(hgap(30)), std(vgap(2)), orientation(leftRight()), left());
}

// Maakt een Figure representatie voor een package.
private Figure createPkgFigure(str pkgName, PkgInfoMap pkgInfo, bool isLeaf) {
	Color clr = getFillColor(1, "orange"); // TODO
	int width = 40; // TODO
	if (isLeaf) return hcat([box(size(width, 10), fillColor(clr), handlePackageClick(pkgName)), text(pkgName)], id(pkgName), hgap(5));
	return hcat([text(pkgName), box(size(width, 10), fillColor(clr), handlePackageClick(pkgName))], id(pkgName));
}

// Maakt een Figure representatie voor een klasse.
//   - de location van de klasse fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de (gewogen) complexiteit van de klasse.
private Figure createClassFigure(ClassInfoTuple clazz, ClassInfoMap classInfo, bool isLeaf) {
	str classId = "<clazz.location>";
	str className = "<clazz.className>";
	int width = getClassSize(clazz.codeLines);
	Color clr = getClassFillColor(clazz.avgComplexity);
	if (isLeaf) return hcat([box(size(width, 10), fillColor(clr), handleClassClick(classId)), text(className)], id(classId), hgap(5));
	return hcat([text(className), box(size(width, 10), fillColor(clr), handleClassClick(classId))], id(classId)); 
}

// Maak een Figure representatie voor een unit.
//   - de location van de unit fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de complexiteit van de unit.
private Figure createUnitFigure(UnitInfoTuple unit) {
	str unitId = "<unit.location>";
	str unitName = unit.unitName;
	int width = getUnitSize(unit.codeLines);
	Color clr = getUnitFillColor(unit.complexity);
	str popupText = "Unit: <unitName>, LOC: <unit.codeLines>, cyclomatic complexity: <unit.complexity>";
	return hcat([box(size(width, 10), fillColor(clr), popup(popupText)), text(unitName)], id(unitId), hgap(5));
}

// Handelt een click event af op een package 
private FProperty handlePackageClick(str pkgName) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		showPackageTree(pkgName);
		return true;
	});
}

// Handelt een click event af op een klasse 
private FProperty handleClassClick(str classId) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		showClassTree(classId);
		return true;
	});
}

// Bepaalt de kleur van een klasse op basis van de gewogen complexity
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
	return 30 + codeLines / 2;
}

// Bepaalt de grootte van een class op basis van de lines of code
private int getClassSize(int codeLines) {
	return 30 + codeLines / 8;
}

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

