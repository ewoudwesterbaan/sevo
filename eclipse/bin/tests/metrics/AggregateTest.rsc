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

// Test de methode metrics::Aggregate::getComplexityDistribution
test bool testGetComplexityRating() {
    ComplexityDistributionMap cdMap = getComplexityDistribution(project);
    
    int simplePerc = (46 * 100) / 179;
    int moderatePerc =  (24 * 100) / 179;
    int complexPerc =  (54 * 100) / 179;
    int untestablePerc =  (55 * 100) / 179;
    
    bool result = true;
    result = result && assertDistribution(cdMap, simplePerc, "Simple", "Unexpected % for Simple category.");
    result = result && assertDistribution(cdMap, moderatePerc, "Moderate", "Unexpected % for Moderate category.");
    result = result && assertDistribution(cdMap, complexPerc, "Complex", "Unexpected % for Complex category.");
    result = result && assertDistribution(cdMap, untestablePerc, "Untestable", "Unexpected % for Untestable category.");
    return result;
}

private bool assertDistribution(ComplexityDistributionMap cdMap, int perc, str categoryName, str msg) {
	TupComplexityRiskCategory riskCategory = getTupRiskCategoryByCategoryName(categoryName);
	return assertEqual(perc, cdMap[riskCategory], msg);
}


