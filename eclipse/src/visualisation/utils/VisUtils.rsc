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
import metrics::Aggregate;

// Voor het bepalen van de codeLines
import utils::Utils;

import IO;

public alias UnitInfoTuple = tuple[loc location, str unitName, int complexity, str risk, int codeLines];
public alias UnitInfoList = list[UnitInfoTuple];
public alias ClassInfoTuple = tuple[loc location, str className, str pkgName, int avgComplexity, int codeLines];
public alias ClassInfoMap = map[ClassInfoTuple classInfoTuple, UnitInfoList units];
public alias PkgInfoMap = map[str pkgName, ClassInfoMap classInfoMap];
public alias ProjectInfoTuple = tuple[loc project, str projName, str riskRank, PkgInfoMap pkgInfo];

private Color simpleColor = color("yellowgreen");
private Color moderateColor = color("gold");
private Color complexColor = color("orange");
private Color untestableColor = color("crimson");

private Color rankPlusPlusColor = simpleColor;
private Color rankPlusColor = moderateColor;
private Color rankZeroColor = complexColor;
private Color rankMinusColor = color("darkorange");
private Color rankMinusMinusColor = untestableColor;

// Geeft de kleur van een project figure terug, op basis van de complexity rank waarin het project valt.
//   - rank: de risico rank (++, +, 0, -, --)
public Color getProjectRankIndicationColor(str rank) {
	if (rank == "++") return rankPlusPlusColor;
	if (rank == "+") return rankPlusColor;
	if (rank == "0") return rankZeroColor;
	if (rank == "-") return rankMinusColor;
	if (rank == "--") return rankMinusMinusColor;
	return rankMinusMinusColor;
	throw "Unexpected rank: <rank>";
}

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


// -------------------------------------------------------------------------------------------
//
// De onderstaande code heeft betrekking op het ophalen van data uit het onderhavige project.
// Deze code hoort in een aparte module thuis, die ook caching voor zijn rekening zou moeten
// nemen.
//
// -------------------------------------------------------------------------------------------


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
            	str risk = getCategoryDescription(complexity);
            	units += <impl.src, name, complexity, risk, codeLines>;
            	sumComplexityFactor += complexity * codeLines;
            	sumUnitCodeLines += codeLines;
            }
            // Get method info
            case \method(_, name, _, _, impl) : {
                int complexity = getComplexityMetric(complexities, impl.src);
            	int codeLines = getLinesOfCode(impl.src).codeLines;
            	str risk = getCategoryDescription(complexity);
            	units += <impl.src, name, complexity, risk, codeLines>;
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
public PkgInfoMap getPkgInfoMapFromClassInfoMap(ClassInfoMap classInfoMap) {
	PkgInfoMap result = ();
	for (classInfoTuple <- classInfoMap) {
		str pkgName = classInfoTuple.pkgName == "" ? "\<root\>" : classInfoTuple.pkgName;
		if (pkgName notin result) result += (pkgName : (classInfoTuple : classInfoMap[classInfoTuple]));
		else result[pkgName][classInfoTuple] = classInfoMap[classInfoTuple];
	}
	return result;
}

// TODO: hoort deze methode wellicht thuis in de Utils module als een public methode?
// Maakt uit een PkgInfoMap een ProjectInfoMap. Dit is een map met als key de projectlocatie, 
// en als values een lijst met PkgInfoMaps.
public ProjectInfoTuple getProjectInfoTupleFromPkgInfoMap(loc project, PkgInfoMap pkgInfoMap) {
	str projName = "<project>"[11..-1];
	str riskRank = getComplexityRank(getComplexityDistribution(project));
	return <project, projName, riskRank, pkgInfoMap>;
}

// Geeft de complexity metric terug voor een bepaalde unit
// TODO: hoort deze methode wellicht thuis in de Complexity module als een public methode?
public int getComplexityMetric(RelComplexities complexities, loc unit) {
	return head([complexity.complexity | complexity <- complexities, complexity.location == unit]);
}

