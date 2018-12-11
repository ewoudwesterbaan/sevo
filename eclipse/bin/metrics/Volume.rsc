module metrics::Volume

import util::Resources;
import Set;
import IO;
import Relation;
import utils::Utils;

public RelLinesOfCode volumeMetrics(loc project) {
	Resource r = getProject(project);
	set[loc] javaFiles = { a | /file(a) <- r, a.extension == "java" };
	println(javaFiles);
	RelLinesOfCode x = { getLinesOfCode(file) | file <- javaFiles };
	return x;
}




