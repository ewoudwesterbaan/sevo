module tests::metrics::UnitSizeTest

import tests::utils::TestUtils;
import metrics::UnitSize;
import utils::Utils;
import IO;
import Boolean;
import Set;
import List;

// De testdata voor deze testmodule bevindt zich in het complexity project
private loc project = |project://ComplexityTest/|;

// Test de methode tests::metrics::UnitSize::unitSizeMetrics
test bool testUnitSizeMetrics() {
	// Roep de methode aan die we willen testen
    RelLinesOfCode rloc = unitSizeMetrics(project);

	// Controleer het aantal verwerkte methodes in de testklassen in het project
    bool result = assertEqual(9, size(rloc), "Unexpected number of tuples."); 

	// Test resultaten voor ComplexityTestClass#complexityOne
	loc unitLocOfComplexityOne = |project://ComplexityTest/src/ComplexityTestClass.java|(123,48,<5,32>,<8,5>);
    result = result && assertTotalLines(4, rloc, unitLocOfComplexityOne);
    result = result && assertCommentLines(0, rloc, unitLocOfComplexityOne);
    result = result && assertCodeLines(1, rloc, unitLocOfComplexityOne);

	// Test resultaten voor ComplexityTestClass#complexityTwo
	loc unitLocOfComplexityTwo = |project://ComplexityTest/src/ComplexityTestClass.java|(222,68,<10,45>,<14,5>);
    result = result && assertTotalLines(5, rloc, unitLocOfComplexityTwo);
    result = result && assertCommentLines(0, rloc, unitLocOfComplexityTwo);
    result = result && assertCodeLines(3, rloc, unitLocOfComplexityTwo);

	// Test resultaten voor ComplexityTestClass#complexityThree
	loc unitLocOfComplexityThree = |project://ComplexityTest/src/ComplexityTestClass.java|(335,272,<16,39>,<29,5>);
    result = result && assertTotalLines(14, rloc, unitLocOfComplexityThree);
    result = result && assertCommentLines(1, rloc, unitLocOfComplexityThree);
    result = result && assertCodeLines(11, rloc, unitLocOfComplexityThree);

	// Test resultaten voor ComplexityTestClass#complexityFour
	loc unitLocOfComplexityFour = |project://ComplexityTest/src/ComplexityTestClass.java|(642,107,<31,33>,<39,5>);
    result = result && assertTotalLines(9, rloc, unitLocOfComplexityFour);
    result = result && assertCommentLines(0, rloc, unitLocOfComplexityFour);
    result = result && assertCodeLines(7, rloc, unitLocOfComplexityFour);

	// Test resultaten voor ComplexityTestClass#complexityFive
	loc unitLocOfComplexityFive = |project://ComplexityTest/src/ComplexityTestClass.java|(802,152,<41,47>,<48,5>);
    result = result && assertTotalLines(8, rloc, unitLocOfComplexityFive);
    result = result && assertCommentLines(0, rloc, unitLocOfComplexityFive);
    result = result && assertCodeLines(6, rloc, unitLocOfComplexityFive);

	// Test resultaten voor ComplexityTestClass#complexitySix
	loc unitLocOfComplexitySix = |project://ComplexityTest/src/ComplexityTestClass.java|(1009,162,<50,53>,<57,5>);
    result = result && assertTotalLines(8, rloc, unitLocOfComplexitySix);
    result = result && assertCommentLines(0, rloc, unitLocOfComplexitySix);
    result = result && assertCodeLines(6, rloc, unitLocOfComplexitySix);

	// Test resultaten voor ComplexityTestClass#complexityTwenty
	loc unitLocOfComplexityTwenty = |project://ComplexityTest/src/ComplexityTestClass.java|(1217,475,<59,40>,<85,5>);
    result = result && assertTotalLines(27, rloc, unitLocOfComplexityTwenty);
    result = result && assertCommentLines(3, rloc, unitLocOfComplexityTwenty);
    result = result && assertCodeLines(22, rloc, unitLocOfComplexityTwenty);

	// Test resultaten voor ComplexityTestClass#complexityTwentyOne
	loc unitLocOfComplexityTwentyOne = |project://ComplexityTest/src/ComplexityTestClass.java|(1737,1161,<87,43>,<143,5>);
    result = result && assertTotalLines(57, rloc, unitLocOfComplexityTwentyOne);
    result = result && assertCommentLines(2, rloc, unitLocOfComplexityTwentyOne);
    result = result && assertCodeLines(52, rloc, unitLocOfComplexityTwentyOne);

	// Test resultaten voor ComplexityTestClass#complexityFiftyOne
	loc unitLocOfComplexityFiftyOne = |project://ComplexityTest/src/ComplexityTestClass.java|(2942,1093,<145,42>,<199,5>);
    result = result && assertTotalLines(55, rloc, unitLocOfComplexityFiftyOne);
    result = result && assertCommentLines(0, rloc, unitLocOfComplexityFiftyOne);
    result = result && assertCodeLines(53, rloc, unitLocOfComplexityFiftyOne);

    return result;
}

// Test de methode tests::metrics::UnitSize::sumOfUnitSizeMetrics
test bool testSumOfUnitSizeMetrics() {
	// Roep de methode aan die we willen testen
	TupLinesOfCode sumMetrics = sumOfUnitSizeMetrics(project);

    int sumTotalLines = sumMetrics.totalLines;
    int sumCommentLines = sumMetrics.commentLines;
    int sumCodeLines = sumMetrics.codeLines;

	bool result = true;
    result = result && assertEqual(187, sumTotalLines, "Unexpected sum of totalLines (all units)."); 
    result = result && assertEqual(6, sumCommentLines, "Unexpected sum of commentLines (all units)."); 
    result = result && assertEqual(161, sumCodeLines, "Unexpected sum of codeLines (all units).");
    return result; 
}

private bool assertTotalLines(int expected, RelLinesOfCode rloc, loc unitLocation) {
    int actual = head([cc.totalLines | cc <- rloc, unitLocation == cc.location ]);
    return assertEqual(expected, actual, "Method has unexpected lines (total) of code.");
}

private bool assertCommentLines(int expected, RelLinesOfCode rloc, loc unitLocation) {
    int actual = head([cc.commentLines | cc <- rloc, unitLocation == cc.location ]);
    return assertEqual(expected, actual, "Method has unexpected nummber of commentlines.");
}

private bool assertCodeLines(int expected, RelLinesOfCode rloc, loc unitLocation) {
    int actual = head([cc.codeLines | cc <- rloc, unitLocation == cc.location ]);
    return assertEqual(expected, actual, "Method has unexpected lines of actual code.");
}

