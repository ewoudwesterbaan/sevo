module Volume

//import Generic;
import util::Resources;
import Set;
import List;
import IO;
import Map;
import String;
import Relation;
import lang::java::jdt::m3::Core;
import Utils;

public LocationMetrics volumeMetrics(loc project) {
	Resource r = getProject(project);
	set[loc] javaFiles = { a | /file(a) <- r, a.extension == "java" };
	
	// relatie met metrieken per file
	LocationMetrics relLineCountsFiles = { processLocation(file) | file <- javaFiles };
	println(relLineCountsFiles);
	return relLineCountsFiles;
}




