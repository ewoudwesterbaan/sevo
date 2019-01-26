//
// Verantwoordelijk voor het lezen en schrijven van en naar de cache.
// 
module visualisation::visData::Cache

import visualisation::visData::DataTypes;
import visualisation::visData::Reader;

// Voor het lezen en schrijven.
import ValueIO;
import IO;

// Rootdirectory voor de opslag (user home).
private loc path = |home:///|;
// Extensie van de cache files.
private str extension = "rscdt";

// Schrijft een ProjectInfoTuple naar disk.
private void writeToCache(ProjectInfoTuple projectInfoTuple) {	
	str projectName = projectInfoTuple.projName;
	loc writePath = path + "<projectName>.<extension>";
	writeBinaryValueFile(writePath, projectInfoTuple);
}

// Leest een ProjectInfoTuple van disk.
private ProjectInfoTuple readFromCache(str projectName) {
	loc readPath = path + "<projectName>.<extension>";
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
	println("Laden project <projectName>.");
	if (projectIsCached(projectName) && !forceReadFromSource) {
		println("Projectgegevens in cache gevonden. Projectgegevens uit cache worden gebruikt.");
		return projectInfo = readFromCache(projectName);
	} else {
		println("Projectgegevens niet in cache gevonden. Project wordt geladen en gecached.");
		projectInfo = getProjectInfoTupleFromPkgInfoMap(projectLocation, getPkgInfoMapFromClassInfoMap(getClassInfo(projectLocation)));
		writeToCache(projectInfo);
		println("Project <projectName> is geladen.");
		return projectInfo;
	};
}
