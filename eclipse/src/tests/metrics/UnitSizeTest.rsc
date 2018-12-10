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
    RelLinesOfCode rloc = unitSizeMetrics(project);

    bool result = assertEqual(7, size(rloc), "Unexpected number of tuples."); 

    result = result && assertTotalLines(3, rloc, "complexityOne");
    result = result && assertCommentLines(0, rloc, "complexityOne");
    result = result && assertCodeLines(3, rloc, "complexityOne");

    result = result && assertTotalLines(5, rloc, "complexityTwo");
    result = result && assertCommentLines(0, rloc, "complexityTwo");
    result = result && assertCodeLines(5, rloc, "complexityTwo");

    result = result && assertTotalLines(14, rloc, "complexityThree");
    result = result && assertCommentLines(1, rloc, "complexityThree");
    result = result && assertCodeLines(13, rloc, "complexityThree");

    return true;
}

private bool assertTotalLines(int expected, RelLinesOfCode rloc, str unitName) {
    int actual = head([cc.totalLines | cc <- rloc, /<unitName>/ := cc.location.path ]);
    return assertEqual(expected, actual, "Method <unitName> has unexpected lines (total) of code.");
}

private bool assertCommentLines(int expected, RelLinesOfCode rloc, str unitName) {
    int actual = head([cc.commentLines | cc <- rloc, /<unitName>/ := cc.location.path ]);
    return assertEqual(expected, actual, "Method <unitName> has unexpected nummber of commentlines.");
}

private bool assertCodeLines(int expected, RelLinesOfCode rloc, str unitName) {
    int actual = head([cc.codeLines | cc <- rloc, /<unitName>/ := cc.location.path ]);
    return assertEqual(expected, actual, "Method <unitName> has unexpected lines of actual code.");
}

