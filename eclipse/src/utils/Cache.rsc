//
// Verantwoordelijk voor het lezen en schrijven van de cache.
// 
module utils::Cache

// Voor het gerbuik van de alias ProjectInfoTuple.
import visualisation::utils::VisUtils;
// Voor het lezen en schrijven.
import ValueIO;
import IO;
import utils::Reader;

// Rootdirectory voor de opslag (user home).
private loc path = |home:///|;
// Extensie van de cache files.
private str extension = "rscdt";

// Schrijft een ProjectInfoTuple naar disk.
private void writeToCache(ProjectInfoTuple projectInfoTuple) {	
	str projectName = projectInfoTuple.projName;
	loc writePath = path + "<projectName>.<extension>";
	//println("Writing to <writePath>");
	writeBinaryValueFile(writePath, projectInfoTuple);
}

// Leest een ProjectInfoTuple van disk.
private ProjectInfoTuple readFromCache(str projectName) {
	loc readPath = path + "<projectName>.<extension>";
	//println("Reading from <readPath>");
	ProjectInfoTuple projectInfoTuple = readBinaryValueFile(#ProjectInfoTuple, readPath);
	return projectInfoTuple;
}

// Bepaalt of een project gecached is.
private bool projectIsCached(str projectName) {
	loc cacheName = path + "<projectName>.<extension>";
	return isFile(cacheName);
}

// Leest een project in en geeft de de benodigde data terug. De methode zal default lezen uit
// de cache. Alleen als deze niet bestaat, of de param forceReadFromSource = 'true', zal het 
// project vanaf de bron worden ingelezen.
// Als het project opnieuw is ingelezen, zal de eventuele bestaande cache overschreven worden.
// Params:
//    - projectLocation: locatie van het project
//    - forceReadFromSource: boolean waarde. Indien 'true': dan wordt de cache overgeslagen 
//      en het project wordt opnieuw vanaf de bron ingelezen. Default 'false'. Optioneel.
public ProjectInfoTuple readProject(loc projectLocation) {
    return readProject(projectLocation, false);
}

public ProjectInfoTuple readProject(loc projectLocation, bool forceReadFromSource) {
	str projectName = "<projectLocation>"[11..-1];
	if (projectIsCached(projectName) && !forceReadFromSource) {
		return projectInfo = readFromCache(projectName);
	} else {
		projectInfo = getProjectInfoTupleFromPkgInfoMap(projectLocation, getPkgInfoMapFromClassInfoMap(getClassInfo(projectLocation)));
		writeToCache(projectInfo);
		return projectInfo;
	};
}
