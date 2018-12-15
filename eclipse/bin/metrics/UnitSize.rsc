module metrics::UnitSize

import Set;
import utils::Utils;

// Geeft het aantal regels terug per unit
//    project - het project dat moet worden geanalyseerd
public RelLinesOfCode unitSizeMetrics(loc project) {
	return {getLinesOfCode(m) | <c, m> <- getUnits(project)};
}

// Geeft het aantal regels (de som) terug van alle units van een project
//    project - het project dat moet worden geanalyseerd
public TupLinesOfCode sumOfUnitSizeMetrics(loc project) {
	int sumOfTotalLines = 0;
	int sumOfCommentLines = 0;
	int sumOfCodeLines = 0;
	for (metrics <- unitSizeMetrics(project)) {
		sumOfTotalLines += metrics.totalLines;
		sumOfCommentLines += metrics.commentLines;
		sumOfCodeLines += metrics.codeLines;
	}
	return <project, sumOfTotalLines, sumOfCommentLines, sumOfCodeLines>;
}


