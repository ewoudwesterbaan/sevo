//
// Verantwoordelijk voor het lezen van structuren uit een project.
//
module visualisation::visData::Reader

// Voor het ophalen van metrieken.
import metrics::Complexity;
import metrics::Rate;
import metrics::Aggregate;
import metrics::Volume;
import utils::Utils;

// Voor de aliases en datatypes t.b.v. visualisatie
import visualisation::visData::DataTypes;

// Voor het ophalen van klassen en methoden uit een project:
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;

import List;
import Set;
import Map;
import IO;

private RelComplexities complexities;

// Verzamelt de gegevens van alle klassen in het project, die van belang zijn voor de visualisatie.
// Haalt alle methoden en constructoren op per java-klasse, bepaalt het aantal regels, de complexiteit,
// risico categorieen van de units, complexity rank, etc.
public ClassInfoMap getClassInfo(loc project) {
	complexities = cyclomaticComplexity(project);

	// Initieel is het result leeg. Deze gaan we hieronder vullen.
	ClassInfoMap result = ();	

    for (Declaration ast <- createAstsFromEclipseProject(project, true)) {
    	loc classLocation = ast.src; 
    	TupLinesOfCode lines = getLinesOfCode(classLocation);
    	ClassInfoTuple classInfo = <classLocation, "", "", "", lines.totalLines, lines.commentLines, lines.codeLines, (), (), []>;
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
        classInfo.units = units;
        classInfo.complexityRating = getComplexityRankForClass(classInfo, complexities);
        classInfo.riskCats = getRiskCatDistribution(classInfo.units);
        classInfo.unitSizeCats = getUnitSizeDistribution(classInfo.units);
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
			str complexityRating = "0";
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
	
	// Nu alle info per package verzameld is, kunnen we de complexityRating bijwerken.
	for (pkgName <- result) {
		result[pkgName].complexityRating = getComplexityRankForPackage(result[pkgName], complexities);
	}
	
	return result;
}

// Maakt uit een PkgInfoMap een ProjectInfoTuple. 
public ProjectInfoTuple getProjectInfoTupleFromPkgInfoMap(loc project, PkgInfoMap pkgInfos) {
	str projName = "<project>"[11..-1];
	str complexityRating = getComplexityRank(getRiskCatDistribution(project));
	RelLinesOfCode volumeMetrics = volumeMetrics(project);
	int totalLines = sum(volumeMetrics.totalLines);
	int commentLines = sum(volumeMetrics.commentLines);
	int codeLines = sum(volumeMetrics.codeLines);
	return <project, projName, complexityRating, totalLines, commentLines, codeLines, pkgInfos>;
}

// Bepaalt de complexity rank/rating op klasseniveau.
private str getComplexityRankForClass(ClassInfoTuple classInfo, RelComplexities complexities) {
	// Bepaal de relatieve verdeling van de risico categorieen
	RiskCatDistributionMap distributionMap = getRiskCatDistribution(classInfo.units);

	// Bepaal de complexity rank bij de gevonden verdeling
	return getComplexityRank(distributionMap);
}

// Bepaalt de complexity rank/rating op packageniveau.
private str getComplexityRankForPackage(PkgInfoTuple pkgInfo, RelComplexities complexities) {
	// Verzamel alle units van de hele package, en bereken de codelines voor de hele package
	UnitInfoList units = [];
	int packageCodeLines = 0;
	for (ClassInfoTuple classInfo <- range(pkgInfo.classInfos)) {
		units += classInfo.units;
		packageCodeLines += classInfo.codeLines;
	}
	
	// Bepaal de relatieve verdeling van de risico categorieen
	RiskCatDistributionMap distributionMap = getRiskCatDistribution(units);

	// Bepaal de complexity rank bij de gevonden verdeling
	return getComplexityRank(distributionMap);
}

// Bepaalt de relatieve verdeling van de risico categorieen (simple, moderate, complex en untestable) over alle coderegels.
//   - units: de units in een class, package of project
private RiskCatDistributionMap getRiskCatDistribution(UnitInfoList units) {
	int totalCodeLines = sum([0] + [unit.codeLines | unit <- units]);

	// Een map waarin we het totaal aantal LOC van alle units per categorie bijhouden
	RiskCatDistributionMap distributionMap = (rc : 0.0 | rc <- riskCategories);
	for (unit <- units) {
		str categoryName = head([complexity.riskCategory  | complexity <- complexities, 0 == compareLocations(unit.location, complexity.location)]);
		TupComplexityRiskCategory riskCategory = getTupRiskCategoryByCategoryName(categoryName);
		distributionMap[riskCategory] += unit.codeLines;
	}
	
	// We hebben nu een distributionMap met per risicocategorie het aantal unitcoderegels.
	// Bepaal nu de ratio/distributie van de regels per complexiteitscategorie
	for (key <- distributionMap.category) {
		try
			distributionMap[key] = (distributionMap[key] * 100) / totalCodeLines;
		catch 
			ArithmeticException("Division undefined"): distributionMap[key] = 0.0;
	}
	
	return distributionMap;
}

// Bepaalt de relatieve verdeling van de unit size categorieen (small, medium, ...) over alle coderegels.
//   - units: de units in een class, package of project
private UnitSizeDistributionMap getUnitSizeDistribution(UnitInfoList units) {
	int totalCodeLines = sum([0] + [unit.codeLines | unit <- units]);
	RelLinesOfCode unitSizes = {<unit.location, unit.totalLines, unit.commentLines, unit.codeLines> | unit <- units};
	return getUnitSizeDistribution(totalCodeLines, unitSizes);
}












