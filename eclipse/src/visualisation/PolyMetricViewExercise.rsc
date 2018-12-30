module visualisation::PolyMetricViewExercise

import vis::Figure;
import vis::Render;

import List;
import Set;
import Map;

// Voor het ophalen van klassen en methoden uit een project:
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;

// Voor het bepalen van de complexity
import metrics::Complexity;

private alias UnitInfoTuple = tuple[loc location, str unitName, int complexity, int codeLines];
private alias UnitInfoRel = rel[loc location, str unitName, int complexity, int codeLines];
private alias ClassInfoTuple = tuple[loc location, str className];
private alias ClassInfoMap = map[ClassInfoTuple clazz, UnitInfoRel units];

private loc project = |project://ComplexityTest/|;
private RelComplexities complexities = cyclomaticComplexity(project);

// Toont een graaf van alle klassen met hun methoden
public void showGraph() {
	nodes = [];
	edges = [];

	// Verzamel info van alle klassen
	ClassInfoMap classInfo = getClassInfo(project);
	
	for (clazz <- classInfo) {
		// Voeg klasse toe aan de graaf
		str classId = "<clazz.location>";
		str className = clazz.className;
		UnitInfoRel units = classInfo[clazz];
		nodes += vcat([text(className), box(size(30), fillColor(getClassFillColor()))], id(classId));

		// Voeg de units in de klasse (en hun onderlinge relaties) toe aan de graaf
		for (unit <- units) {
			str unitId = "<unit.location>";
			str unitName = unit.unitName;
			int height = getUnitHeight(unit.codeLines);
			Color clr = getUnitFillColor(unit.complexity);
	        nodes += vcat([box(size(10, height), fillColor(clr)), text(unitName, textAngle(90))], id(unitId));
			edges += edge(classId, unitId);
		}
	}	

	// Render de gegereerde graaf	
	render(graph(nodes, edges, hint("layered"), gap(50)));
}

// Geeft de complexity metric terug voor een bepaalde unit
// TODO: hoort deze methode wellicht thuis in de Complexity module als een public methode?
private int getComplexityMetric(loc unit) {
	return head([complexity.complexity | complexity <- complexities, complexity.location == unit]);
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
    	UnitInfoRel units = {};

        visit(ast) {
        	// Get class name
            case \class(name, _, _, _) : {
		    	clazz.className = name; 
            }       
        	// Get interface name
            case \interface(name, _, _, _) : {
		    	clazz.className = "Interface: <name>"; 
            }       
            // Get constructor info
            case \constructor(name, _, _, impl) : {
                int complexity = getComplexityMetric(impl.src);
            	int codeLines = 5; // TODO
				UnitInfoTuple unit = <impl.src, name, complexity, codeLines>;
            	units += unit;
            }
            // Get method info
            case \method(_, name, _, _, impl) : {
                int complexity = getComplexityMetric(impl.src);
            	int codeLines = 5; // TODO
				UnitInfoTuple unit = <impl.src, name, complexity, codeLines>;
            	units += unit;
            }
        }
        result += (clazz : units);
    }
    return result;
}
