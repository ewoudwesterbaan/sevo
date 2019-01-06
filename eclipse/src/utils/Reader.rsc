//
// Verantwoordelijk voor het lezen van structuren uit een project.
//
module utils::Reader

// Voor het ophalen van complexiteit en rank.
import metrics::Complexity;
import metrics::Rate;
import metrics::Aggregate;
import metrics::Volume;
// Voor het bepalen van de codeLines
import utils::Utils;
// Voor de aliases
import visualisation::utils::VisUtils;
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
        classInfo.complexityRating = "0"; // TODO: bepalen of dit ++, +, 0, -, -- moet zijn
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