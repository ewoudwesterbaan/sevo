module metrics::UnitSize

import Set;
import utils::Utils;

public RelLinesOfCode unitSizeMetrics(loc project) {
	return {getLinesOfCode(m) | <c, m> <- getUnits(project)};
}


