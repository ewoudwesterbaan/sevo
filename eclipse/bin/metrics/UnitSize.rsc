module metrics::UnitSize

import IO;
import Relation;
import Map;
import Set;
import List;
import String;
import util::Resources;
import lang::java::jdt::m3::Core;
import utils::Utils;

public RelLinesOfCode unitSizeMetrics(loc project) {
	M3 model = createM3FromEclipseProject(project);
	return {getLinesOfCode(m) | <c, m> <- getUnits(model)};
}


