module tests::metrics::ComplexityTest

import metrics::Complexity;
import utils::Utils;
import Boolean;
import IO;
import Set;
import List;

private loc project = |project://Sevo/src/tests/testdata/complexity|;

// Test de methode metrics::Complexity::cyclomaticComplexity
test bool testCyclomaticComplexity() {
    RelComplexities complexities = cyclomaticComplexity(project);
    bool result = size(complexities) == 4;
    result = result && [1] == [cc.complexity | cc <- complexities, cc.unitName == "complexityOne"];
    result = result && [2] == [cc.complexity | cc <- complexities, cc.unitName == "complexityTwo"];
    result = result && [3] == [cc.complexity | cc <- complexities, cc.unitName == "complexityThree"];
    result = result && [4] == [cc.complexity | cc <- complexities, cc.unitName == "complexityFour"];
    return result;
}
