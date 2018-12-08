module tests::metrics::ComplexityTest

import metrics::Complexity;
import utils::Utils;
import Boolean;
import IO;
import Set;
import List;

// De testdata voor deze testmodule bevindt zich in het complexity project
private loc project = |project://complexity/|;

// Test de methode metrics::Complexity::cyclomaticComplexity
test bool testCyclomaticComplexity() {
	// Voer de te testen methode uit
    RelComplexities complexities = cyclomaticComplexity(project);
    
    // Controleer de uitkomsten
    bool result = assertEqual(6, size(complexities), "Unexpected number of complexities."); 
    result = result && assertComplexity(1, complexities, "complexityOne");
    result = result && assertComplexity(2, complexities, "complexityTwo");
    result = result && assertComplexity(3, complexities, "complexityThree");
    result = result && assertComplexity(4, complexities, "complexityFour");
    result = result && assertComplexity(5, complexities, "complexityFive");
    result = result && assertComplexity(6, complexities, "complexitySix");
    return result;
}

private bool assertComplexity(int expected, RelComplexities complexities, str unitName) {
    int actual = head([cc.complexity | cc <- complexities, cc.unitName == unitName]);
    return assertEqual(expected, actual, "Method <unitName> returned unexpected value.");
}

private bool assertEqual(int expected, int actual, str msg) {
    if (expected != actual) {
        println("Test failed. Msg: <msg> Expected = <expected>, actual = <actual>");
    }
    return expected == actual;
}
