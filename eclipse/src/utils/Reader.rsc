//
// Verantwoordelijk voor het lezen van structuren uit een project.
//
module utils::Reader

// Voor het ophalen van complexiteit en rank.
import metrics::Complexity;
import metrics::Rate;
import metrics::Aggregate;
import metrics::Volume;
import utils::Utils;

// Voor de aliases
import visualisation::DataTypes;

// Voor het ophalen van klassen en methoden uit een project:
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;

import List;
import Set;
import Map;
import IO;

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
        classInfo.complexityRating = getComplexityRankForClass(units, complexities);
        classInfo.units = units;
        result += ("<classLocation>" : classInfo);
    }
    return result;
}

// Maakt uit een ClassInfoMap een PkgInfoMap. Dit is een map met als key de package naam, en 
// als values een lijst met ClassInfoMaps van klassen in de respectievelijke package.
public PkgInfoMap getPkgInfoMapFromClassInfoMap(ClassInfoMap classInfos) {
	PkgInfoMap result = ();
	for (classInfo <- range(classInfos)) {
		str pkgName = classInfo.pkgName == "" ? "\<root\>" : classInfo.pkgName;
		str classId = "<classInfo.location>";
		if (pkgName notin result) {
			str complexityRating = "0"; // TODO
			int totalLines = classInfo.totalLines;
			int commentLines = classInfo.commentLines;
			int codeLines = classInfo.codeLines;
			PkgInfoTuple pkgInfo = <pkgName, complexityRating, totalLines, commentLines, codeLines, (classId : classInfos[classId])>;
			result += (pkgName : pkgInfo);
		} else {
			result[pkgName].classInfos += (classId : classInfo);
			result[pkgName].totalLines += classInfo.totalLines;
			result[pkgName].commentLines += classInfo.commentLines;
			result[pkgName].codeLines += classInfo.codeLines;
		}
	}
	return result;
}

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

// 1. Haal unit locations uit classInfoMap voor een bepaalde class
// 2. Haal uit RelComplexity de complexities en risk categorieen door te filteren op unit location (zie 1)
// 3. Maak een ComplexityDistributionMap voor de gefilterde units
//    - itereer over de units
//    - bepaal per risk categorie het aantal lines of code, en houd dat bij in een map[cat, lines of code], waarbij cat een TupComplexRiskCategory object is.
//    - doe daarmee een getComplexityRank(ComplexityDistributionMap cdMap)
private str getComplexityRankForClass(UnitInfoList units, RelComplexities complexities) {
	// Een map waarin we het totaal aantal LOC van alle units per complexiteitscategorie bijhouden
	ComplexityDistributionMap distributionMap = (rc : 0.0 | rc <- riskCategories);

	int classCodeLines = 0;
	for (unit <- units) {
		str categoryName = head([complexity.riskCategory  | complexity <- complexities, 0 == compareLocations(unit.location, complexity.location)]);
		TupComplexityRiskCategory riskCategory = getTupRiskCategoryByCategoryName(categoryName);
		distributionMap[riskCategory] += unit.codeLines;
		classCodeLines += unit.codeLines;
	}
	// We hebben nu een distributionMap met per risicocategorie het aantal unitcoderegels.
	// Bepaal nu de ratio/distributie van de regels per complexiteitscategorie
	for (key <- distributionMap.category) {
		distributionMap[key] = (distributionMap[key] * 100) / classCodeLines;
	}
	return getComplexityRank(distributionMap);
}

// TODO
private str getComplexityRankForPackage(PkgInfoTuple pkgInfoInfo) {
	return "0";
}












