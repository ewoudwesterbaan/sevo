module tests::metrics::ComplexityTest

import tests::utils::TestUtils;
import metrics::Complexity;
import utils::Utils;
import Boolean;
import IO;
import Set;
import List;

// De testdata voor deze testmodule bevindt zich in het complexity project
private loc project = |project://ComplexityTest/|;

// Test de methode metrics::Complexity::getTupRiskCategoryByCategoryName
test bool testGetTupRiskCategoryByCategoryName() {
    bool result = true;
    
    TupComplexityRiskCategory simple = getTupRiskCategoryByCategoryName("Simple");
    result = result && assertEqual(1, simple.minComplexity, "Unexpected minComplexity for Simple category: <simple.minComplexity>.");
    result = result && assertEqual(10, simple.maxComplexity, "Unexpected maxComplexity for Simple category: <simple.maxComplexity>.");
    
    TupComplexityRiskCategory moderate = getTupRiskCategoryByCategoryName("Moderate");
    result = result && assertEqual(11, moderate.minComplexity, "Unexpected minComplexity for Moderate category: <moderate.minComplexity>.");
    result = result && assertEqual(20, moderate.maxComplexity, "Unexpected maxComplexity for Moderate category: <moderate.maxComplexity>.");
    
    TupComplexityRiskCategory complex = getTupRiskCategoryByCategoryName("Complex");
    result = result && assertEqual(21, complex.minComplexity, "Unexpected minComplexity for Complex category: <complex.minComplexity>.");
    result = result && assertEqual(50, complex.maxComplexity, "Unexpected maxComplexity for Complex category: <complex.maxComplexity>.");
    
    TupComplexityRiskCategory untestable = getTupRiskCategoryByCategoryName("Untestable");
    result = result && assertEqual(50, untestable.minComplexity, "Unexpected minComplexity for Untestable category: <untestable.minComplexity>.");
    result = result && assertEqual(-1, untestable.maxComplexity, "Unexpected maxComplexity for Untestable category: <untestable.maxComplexity>.");
    
    return result;
}

// Test de methode metrics::Complexity::cyclomaticComplexity
test bool testCyclomaticComplexity() {
    RelComplexities complexities = cyclomaticComplexity(project);
    bool result = assertEqual(9, size(complexities), "Unexpected number of complexities."); 

    result = result && assertComplexity(1, complexities, "complexityOne");
    result = result && assertRiskCategory("Simple", complexities, "complexityOne");

    result = result && assertComplexity(2, complexities, "complexityTwo");
    result = result && assertRiskCategory("Simple", complexities, "complexityTwo");

    result = result && assertComplexity(3, complexities, "complexityThree");
    result = result && assertRiskCategory("Simple", complexities, "complexityThree");

    result = result && assertComplexity(4, complexities, "complexityFour");
    result = result && assertRiskCategory("Simple", complexities, "complexityFour");

    result = result && assertComplexity(5, complexities, "complexityFive");
    result = result && assertRiskCategory("Simple", complexities, "complexityFive");

    result = result && assertComplexity(6, complexities, "complexitySix");
    result = result && assertRiskCategory("Simple", complexities, "complexitySix");

    result = result && assertComplexity(20, complexities, "complexityTwenty");
    result = result && assertRiskCategory("Moderate", complexities, "complexityTwenty");

    result = result && assertComplexity(21, complexities, "complexityTwentyOne");
    result = result && assertRiskCategory("Complex", complexities, "complexityTwentyOne");

    result = result && assertComplexity(51, complexities, "complexityFiftyOne");
    result = result && assertRiskCategory("Untestable", complexities, "complexityFiftyOne");

    return result;
}

private bool assertComplexity(int expected, RelComplexities complexities, str unitName) {
    int actual = head([cc.complexity | cc <- complexities, cc.unitName == unitName]);
    return assertEqual(expected, actual, "Method <unitName> returned unexpected complexity value.");
}

private bool assertRiskCategory(str expected, RelComplexities complexities, str unitName) {
    str actual = head([cc.riskCategory | cc <- complexities, cc.unitName == unitName]);
    return assertEqual(expected, actual, "Method <unitName> returned unexpected riskCategory value.");
}

