module tests::metrics::AggregateTest

import tests::utils::TestUtils;
import metrics::Aggregate;
import metrics::Complexity;
import utils::Utils;
import Boolean;
import IO;
import Set;
import List;

// De testdata voor deze testmodule bevindt zich in het complexity project
private loc project = |project://ComplexityTest/|;

// Test de methode metrics::Aggregate::getComplexityRating
test bool testGetComplexityRating() {
    ComplexityDistributionMap cdMap = getComplexityRating(project);
    
    int simplePerc = (46 * 100) / 179;
    int moderatePerc =  (24 * 100) / 179;
    int complexPerc =  (54 * 100) / 179;
    int untestablePerc =  (55 * 100) / 179;
    
    bool result = true;
    result = result && assertRating(cdMap, simplePerc, "Simple", "Unexpected % for Simple category.");
    result = result && assertRating(cdMap, moderatePerc, "Moderate", "Unexpected % for Moderate category.");
    result = result && assertRating(cdMap, complexPerc, "Complex", "Unexpected % for Complex category.");
    result = result && assertRating(cdMap, untestablePerc, "Untestable", "Unexpected % for Untestable category.");
    return result;
}

private bool assertRating(ComplexityDistributionMap cdMap, int perc, str categoryName, str msg) {
	TupComplexityRiskCategory riskCategory = getTupRiskCategoryByCategoryName(categoryName);
	return assertEqual(perc, cdMap[riskCategory], msg);
}


