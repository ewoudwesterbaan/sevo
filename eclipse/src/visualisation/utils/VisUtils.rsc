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
import metrics::Volume;

// Voor het bepalen van de codeLines
import utils::Utils;

import IO;

public alias UnitInfoTuple = tuple[loc location, str unitName, int complexity, str risk, int totalLines, int commentLines, int codeLines];
public alias UnitInfoList = list[UnitInfoTuple];
public alias ClassInfoTuple = tuple[loc location, str className, str pkgName, str complexityRating, int totalLines, int commentLines, int codeLines, UnitInfoList units];
public alias ClassInfoMap = map[str classId, ClassInfoTuple classInfo];
public alias PkgInfoTuple = tuple[str pkgName, str complexityRating, int totalLines, int commentLines, int codeLines, ClassInfoMap classInfos];
public alias PkgInfoMap = map[str pkgId, PkgInfoTuple pkgInfo];
public alias ProjectInfoTuple = tuple[loc project, str projName, str complexityRating, int totalLines, int commentLines, int codeLines, PkgInfoMap pkgInfos];

private Color simpleColor = color("yellowgreen");
private Color moderateColor = color("gold");
private Color complexColor = color("orange");
private Color untestableColor = color("crimson");

private Color rankPlusPlusColor = simpleColor;
private Color rankPlusColor = moderateColor;
private Color rankZeroColor = complexColor;
private Color rankMinusColor = color("darkorange");
private Color rankMinusMinusColor = untestableColor;

// Geeft de kleur van een figure terug, op basis van de complexity rating waarin het project valt.
//   - rank: de risico rank (++, +, 0, -, --)
public Color getComplexityRatingIndicationColor(str rank) {
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
    	TupLinesOfCode lines = getLinesOfCode(classLocation);
    	ClassInfoTuple classInfo = <classLocation, "", "", "", lines.totalLines, lines.commentLines, lines.codeLines, []>;
    	UnitInfoList units = [];

        visit(ast) {
        	// Get package name
            case \package(parent, name) : {
            	if (classInfo.pkgName == "") classInfo.pkgName = "<parent.name>";
            	classInfo.pkgName += ".<name>";
            }
        	// Get class name
            case \class(name, _, _, _) : {
            	classInfo.className = name;
            } 
            // Get constructor info 
            case \constructor(name, _, _, impl) : {
                int complexity = getComplexityMetric(complexities, impl.src);
            	int totalLines = getLinesOfCode(impl.src).totalLines;
            	int commentLines = getLinesOfCode(impl.src).commentLines;
            	int codeLines = getLinesOfCode(impl.src).codeLines;
            	str risk = getCategoryDescription(complexity);
            	units += <impl.src, name, complexity, risk, totalLines, commentLines, codeLines>;
            }
            // Get method info
            case \method(_, name, _, _, impl) : {
                int complexity = getComplexityMetric(complexities, impl.src);
            	int totalLines = getLinesOfCode(impl.src).totalLines;
            	int commentLines = getLinesOfCode(impl.src).commentLines;
            	int codeLines = getLinesOfCode(impl.src).codeLines;
            	str risk = getCategoryDescription(complexity);
            	units += <impl.src, name, complexity, risk, totalLines, commentLines, codeLines>;
            }
        }
        classInfo.complexityRating = "0"; // TODO: bepalen of dit ++, +, 0, -, -- moet zijn
        classInfo.units = units;
        result += ("<classLocation>" : classInfo);
    }
    return result;
}

// TODO: hoort deze methode wellicht thuis in de Utils module als een public methode?
// Maakt uit een ClassInfoMap een PkgInfoMap. Dit is een map met als key de package naam, en 
// als values een lijst met ClassInfoMaps van klassen in de respectievelijke package.
public PkgInfoMap getPkgInfoMapFromClassInfoMap(ClassInfoMap classInfos) {
	PkgInfoMap result = ();
	for (classInfo <- range(classInfos)) {
		str pkgName = classInfo.pkgName == "" ? "\<root\>" : classInfo.pkgName;
		str classId = "<classInfo.location>";
		if (pkgName notin result) {
			str complexityRating = "0"; // TODO
			int totalLines = sum([classInfo.totalLines | classInfo <- range(classInfos)]);
			int commentLines = sum([classInfo.commentLines | classInfo <- range(classInfos)]);
			int codeLines = sum([classInfo.codeLines | classInfo <- range(classInfos)]);
			PkgInfoTuple pkgInfo = <pkgName, complexityRating, totalLines, commentLines, codeLines, (classId : classInfos[classId])>;
			result += (pkgName : pkgInfo);
		} else {
			PkgInfoTuple pkgInfo = result[pkgName];
			pkgInfo.classInfos += (classId : classInfos[classId]);
		}
	}
	return result;
}

// TODO: hoort deze methode wellicht thuis in de Utils module als een public methode?
// Maakt uit een PkgInfoMap een ProjectInfoTuple. 
public ProjectInfoTuple getProjectInfoTupleFromPkgInfoMap(loc project, PkgInfoMap pkgInfos) {
	str projName = "<project>"[11..-1];
	str complexityRating = getComplexityRank(getComplexityDistribution(project));
	RelLinesOfCode volumeMetrics = volumeMetrics(project);
	int totalLines = sum(volumeMetrics.totalLines);
	int commentLines = sum(volumeMetrics.commentLines);
	int codeLines = sum(volumeMetrics.codeLines);
	return <project, projName, complexityRating, totalLines, commentLines, codeLines, pkgInfos>;
}

// Geeft de complexity metric terug voor een bepaalde unit
// TODO: hoort deze methode wellicht thuis in de Complexity module als een public methode?
public int getComplexityMetric(RelComplexities complexities, loc unit) {
	return head([complexity.complexity | complexity <- complexities, complexity.location == unit]);
}

