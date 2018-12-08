module tests::metrics::DuplicationTest

import metrics::Duplication;
import metrics::UnitSize;
import utils::Utils;
import Boolean;
import Relation;
import Set;
import IO;

// Testobject
private loc project = |project://Sevo/src/tests/testdata/duplication|;

// TODO: Voeg hier unittesten toe om de Duplication module te testen
test bool testSizeComparePairs() {
	RelLinesOfCode unitSize = unitSizeMetrics(project);
	methodsForDuplication = { <m, cod> | <m, tot, com, cod> <- unitSize, cod >= 6 };
	rel[loc methodA, loc methodB] result = createComparePairs(domain(methodsForDuplication));
	println("Actual: <size(result)>");
	println("Expection: 21");
    return size(result) == 21;
}