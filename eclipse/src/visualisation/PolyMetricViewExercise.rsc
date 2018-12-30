module visualisation::PolyMetricViewExercise

import vis::Figure;
import vis::Render;

import List;
import Set;
import Map;

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
private alias ClassInfoTuple = tuple[loc location, str className, int avgComplexity, int codeLines];
private alias ClassInfoMap = map[ClassInfoTuple clazz, UnitInfoList units];

//private loc project = |project://ComplexityTest/|;
//private loc project = |project://smallsql/|;
//private loc project = |project://DuplicationTest/|;
private loc project = |project://JabberPoint/|;

private RelComplexities complexities = cyclomaticComplexity(project);

// Toont een grid met een boom per klasse met de methoden als leaves van de klasse
// Alle bomen worden onder elkaar getoond, en hebben als root de klasse.
// De grootte van de nodes is afhankelijk van het aantal lines of code.
// De kleur van de nodes is afhankelijk van de (gewogen) complexiteit (donkerder = complexer).
public void showTrees() {
	// Verzamel info van alle klassen
	ClassInfoMap classInfo = getClassInfo(project);
	
	// Grid bestaat uit rows, die elk 1 column zullen bevatten
	rows = [];
	
	for (clazz <- classInfo) {
		// De root van de tree representeert de klasse. We stellen de root hier samen.
		root = createClassFigure(clazz, classInfo);
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

// Maakt een Figure representatie voor een klasse.
//   - de location van de klasse fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de (gewogen) complexiteit van de klasse.
private Figure createClassFigure(ClassInfoTuple clazz, ClassInfoMap classInfo) {
	str classId = "<clazz.location>";
	str className = clazz.className;
	int width = getClassSize(clazz.codeLines);
	Color clr = getClassFillColor(clazz.avgComplexity);
	return hcat([text(className), box(size(width, 10), fillColor(clr))], id(classId)); 
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
	return hcat([box(size(width, 10), fillColor(clr)), text(unitName, textAngle(0))], id(unitId), hgap(5));
}

// Bepaalt de kleur van een klasse op basis van de gewogen complexity
private Color getClassFillColor(int avgComplexity) {
	return getFillColor(avgComplexity, "purple");
}

// Bepaalt de kleur van een unit op basis van de complexity
private Color getUnitFillColor(int complexity) {
	return getFillColor(complexity, "orange");
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
    	// Location of compilation unit
    	loc classLocation = ast.src; 
    	ClassInfoTuple clazz = <ast.src, "?", 1, getLinesOfCode(classLocation).codeLines>;
    	UnitInfoList units = [];
    	int sumComplexityFactor = 0;

        visit(ast) {
        	// Get class name
            case \class(name, _, _, _) : {
		    	clazz.className = name; 
            }
        	// Skip interfaces
            case \interface(_, _, _, _) : {
            	continue;
            }
            // Get constructor info
            case \constructor(name, _, _, impl) : {
                int complexity = getComplexityMetric(impl.src);
            	int codeLines = getLinesOfCode(impl.src).codeLines;
				UnitInfoTuple unit = <impl.src, name, complexity, codeLines>;
            	units += unit;
            	sumComplexityFactor += complexity * codeLines;
            }
            // Get method info
            case \method(_, name, _, _, impl) : {
                int complexity = getComplexityMetric(impl.src);
            	int codeLines = getLinesOfCode(impl.src).codeLines;
				UnitInfoTuple unit = <impl.src, name, complexity, codeLines>;
            	units += unit;
            	sumComplexityFactor += complexity * codeLines;
            }
        }
        clazz.avgComplexity = sumComplexityFactor / clazz.codeLines;
        result += (clazz : units);
    }
    return result;
}

// Geeft de complexity metric terug voor een bepaalde unit
// TODO: hoort deze methode wellicht thuis in de Complexity module als een public methode?
private int getComplexityMetric(loc unit) {
	return head([complexity.complexity | complexity <- complexities, complexity.location == unit]);
}

