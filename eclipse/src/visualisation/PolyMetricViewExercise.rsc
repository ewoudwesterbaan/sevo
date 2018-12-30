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
private alias ClassInfoTuple = tuple[loc location, str className];
private alias ClassInfoMap = map[ClassInfoTuple clazz, UnitInfoList units];

//private loc project = |project://ComplexityTest/|;
//private loc project = |project://smallsql/|;
//private loc project = |project://DuplicationTest/|;
private loc project = |project://JabberPoint/|;


private RelComplexities complexities = cyclomaticComplexity(project);

// Toont een graaf van alle klassen met hun methoden
public void showGraph() {
	nodes = [];
	edges = [];

	// Verzamel info van alle klassen
	ClassInfoMap classInfo = getClassInfo(project);
	
	for (clazz <- classInfo) {
		// Voeg klasse toe aan de graaf
		Figure classFigure = createClassFigure(clazz);
		nodes += classFigure;
		println("*** <classFigure.id>");
		return;

		// Voeg de units in de klasse (en hun onderlinge relaties) toe aan de graaf
		UnitInfoList units = classInfo[clazz];
		for (unit <- units) {
			str unitId = "<unit.location>";
			str unitName = unit.unitName;
			int height = getUnitHeight(unit.codeLines);
			Color clr = getUnitFillColor(unit.complexity);
			Figure unitFigure = vcat([box(size(10, height), fillColor(clr)), text(unitName, textAngle(90))], id(unitId), gap(10));
	        nodes += unitFigure;
			edges += edge(classFigure.id, unitFigure.id);
		}
	}	

	// Render de gegereerde graaf	
	render(graph(nodes, edges, hint("layered"), gap(30)));
}

// Toont een grid met een boom per klasse met de methoden als leaves van de klasse
public void showTrees() {
	// Grid heeft vooralsnog 1 row
	row = [];

	// Verzamel info van alle klassen
	ClassInfoMap classInfo = getClassInfo(project);
	
	for (clazz <- classInfo) {
		// De root van de tree representeert de klasse. We stellen de root hier samen.
		str classId = "<clazz.location>";
		str className = clazz.className;
		UnitInfoList units = classInfo[clazz];
		Figure classFigure = vcat([text(className), box(size(30), fillColor(getClassFillColor()))], id(classId));
		root = classFigure;

		// De leaves van de tree representeren de units (methoden en constructoren). We stellen de leaves hier samen.
		leaves = [];
		for (unit <- units) {
			str unitId = "<unit.location>";
			str unitName = unit.unitName;
			int height = getUnitHeight(unit.codeLines);
			Color clr = getUnitFillColor(unit.complexity);
			Figure unitFigure = vcat([box(size(10, height), fillColor(clr)), text(unitName, textAngle(90))], id(unitId), gap(10));
	        leaves += unitFigure;
		}

		// Voeg column toe aan de row. Deze column bevat een tree, bestaande uit de root en de leaves
		t = tree(root, leaves, std(size(50)), std(gap(20)));
		row += t;
	}	

	// Render een grid met de gegenereerde row
	render(box(grid([row]),size(200)));
}

// Maakt een Figure representatie van een klasse
private Figure createClassFigure(ClassInfoTuple clazz) {
	str classId = "<clazz.location>";
	str className = clazz.className;
	return vcat([text(className), box(size(30), fillColor(getClassFillColor()))], id(classId)); 
}

// Bepaalt de kleur van een unit op basis van de complexity
private Color getUnitFillColor(int complexity) {
	real gradient = 0.2 + (0.8 / complexity);
	return gray(gradient);
}

// Bepaalt de hoogte van een unit op basis van de lines of code
private Color getUnitHeight(int codeLines) {
	return 30 + codeLines / 2;
}

// Bepaalt de kleur van een klasse
private Color getClassFillColor() {
	return color("lightgreen");
}

// Haal alle methoden en constructoren op, per java-klasse, op basis van het project
// Deze methode lijkt op de getUnits in de Utils klasse misschien die twee samenvoegen? TODO...
private ClassInfoMap getClassInfo(loc project) {
	ClassInfoMap result = ();	
    for (Declaration ast <- createAstsFromEclipseProject(project, true)) {
    	// Location of compilation unit
    	loc classLocation = ast.src; 
    	ClassInfoTuple clazz = <ast.src, "?">;
    	UnitInfoList units = [];

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
            }
            // Get method info
            case \method(_, name, _, _, impl) : {
                int complexity = getComplexityMetric(impl.src);
            	int codeLines = getLinesOfCode(impl.src).codeLines;
				UnitInfoTuple unit = <impl.src, name, complexity, codeLines>;
            	units += unit;
            }
        }
        result += (clazz : units);
    }
    return result;
}

// Geeft de complexity metric terug voor een bepaalde unit
// TODO: hoort deze methode wellicht thuis in de Complexity module als een public methode?
private int getComplexityMetric(loc unit) {
	return head([complexity.complexity | complexity <- complexities, complexity.location == unit]);
}

