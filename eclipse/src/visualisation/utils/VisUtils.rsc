module visualisation::utils::VisUtils

import vis::Figure;
import vis::Render;

import List;
import Set;
import Map;

// Voor het ophalen van klassen en methoden uit een project:
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;

// Voor hte ophalen van complexiteit en rank.
import metrics::Complexity;
import metrics::Rate;

// Voor het bepalen van de codeLines
import utils::Utils;

public alias UnitInfoTuple = tuple[loc location, str unitName, int complexity, int codeLines];
public alias UnitInfoList = list[UnitInfoTuple];
public alias ClassInfoTuple = tuple[loc location, str className, str pkgName, int avgComplexity, int codeLines];
public alias ClassInfoMap = map[ClassInfoTuple clazz, UnitInfoList units];
public alias PkgInfoMap = map[str pkgName, list[ClassInfoMap classInfo] clazzes];

private Color simpleColor = color("yellowgreen");
private Color moderateColor = color("gold");
private Color complexColor = color("orange");
private Color untestableColor = color("crimson");

private Color rankPlusPlusColor = simpleColor;
private Color rankPlusColor = moderateColor;
private Color rankZeroColor = complexColor;
private Color rankMinusColor = untestableColor;
private Color rankMinusMinusColor = color("darkred");

// Geeft de kleur van een unit figure terug, op basis van de risicocategorie waarin de unit valt.
public Color getUnitRiskIndicationColor(int complexity) {
	int simpleMax = getTupRiskCategoryByCategoryName("Simple").maxComplexity;
	int moderateMax = getTupRiskCategoryByCategoryName("Moderate").maxComplexity;
	int complexMax = getTupRiskCategoryByCategoryName("Complex").maxComplexity;
	if (complexity <= simpleMax) return simpleColor;
	if (complexity <= moderateMax) return moderateColor;
	if (complexity <= complexMax) return complexColor;
	return untestableColor;
}

// TODO: hoort deze methode wellicht thuis in de Utils module als een public methode?
// Haalt alle methoden en constructoren op, per java-klasse, voor het hele project.
public ClassInfoMap getClassInfo(loc project) {
	RelComplexities complexities = cyclomaticComplexity(project);

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
                int complexity = getComplexityMetric(complexities, impl.src);
            	int codeLines = getLinesOfCode(impl.src).codeLines;
            	units += <impl.src, name, complexity, codeLines>;
            	sumComplexityFactor += complexity * codeLines;
            	sumUnitCodeLines += codeLines;
            }
            // Get method info
            case \method(_, name, _, _, impl) : {
                int complexity = getComplexityMetric(complexities, impl.src);
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
public PkgInfoMap getPkgInfoMapFromClassInfoMap(ClassInfoMap classInfo) {
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
public int getComplexityMetric(RelComplexities complexities, loc unit) {
	return head([complexity.complexity | complexity <- complexities, complexity.location == unit]);
}

