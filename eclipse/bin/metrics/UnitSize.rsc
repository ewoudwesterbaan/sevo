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
	rel[loc c, loc m] units = getUnits(model);
	RelLinesOfCode unitSizeMetrics = {getLinesOfCode(m) | <c, m> <- units};
	// println(unitSizeMetrics);
	return unitSizeMetrics;
}

// Haal alle methoden en constructoren op, per java-klasse
//     c = klasse
//     m = methode
private rel[loc, loc] getUnits(M3 model) {
	return { <c,m> | <c,m> <- model.containment,
	                 c.scheme  == "java+class", 
	                 m.scheme == "java+method" || 
	                 m.scheme == "java+constructor" };
}


