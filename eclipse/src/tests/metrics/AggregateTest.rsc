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
    
    int simplePerc = (34 * 100) / 161;
    int moderatePerc =  (22 * 100) / 161;
    int complexPerc =  (52 * 100) / 161;
    int untestablePerc =  (53 * 100) / 161;
    
    bool result = true;
    result = result && assertComplexityDist(cdMap, simplePerc, "Simple", "Unexpected % for Simple category.");
    result = result && assertComplexityDist(cdMap, moderatePerc, "Moderate", "Unexpected % for Moderate category.");
    result = result && assertComplexityDist(cdMap, complexPerc, "Complex", "Unexpected % for Complex category.");
    result = result && assertComplexityDist(cdMap, untestablePerc, "Untestable", "Unexpected % for Untestable category.");
    return result;
}

// Test de methode metrics::Aggregate::getUnitSizeDistribution
test bool testGetUnitSizeDistribution() {

	// Statische testdata
	int sysLinesOfCode = 100;
	RelLinesOfCode unitSizes = {
		// not implemented
		<|project://unit0|, 0, 5, 0>,
		// small
		<|project://unit1|, 12, 10, 2>,
		<|project://unit2|, 10, 7, 3>,
		// medium
		<|project://unit3|, 16, 10, 6>,
		<|project://unit4|, 18, 10, 8>,
		// large
		<|project://unit5|, 20, 9, 11>,
		<|project://unit6|, 20, 7, 13>,
		// very large
		<|project://unit7|, 35, 5, 30>
	};

	// Roep de te testen methode aan
	UnitSizeDistributionMap usdMap = getUnitSizeDistribution(sysLinesOfCode, unitSizes);
	
	// Verwachte resultaten
    int smallPerc = ((2 + 3) * 100) / sysLinesOfCode;
    int mediumPerc = ((6 + 8) * 100) / sysLinesOfCode;
    int largePerc = ((11 + 13) * 100) / sysLinesOfCode;
    int veryLargePerc = (30 * 100) / sysLinesOfCode;

	// Controleer resultaat
    bool result = true;
    result = result && assertUnitSizeDist(usdMap, smallPerc, "Small", "Unexpected % for Small category.");
    result = result && assertUnitSizeDist(usdMap, mediumPerc, "Medium", "Unexpected % for Medium category.");
    result = result && assertUnitSizeDist(usdMap, largePerc, "Large", "Unexpected % for Large category.");
    result = result && assertUnitSizeDist(usdMap, veryLargePerc, "Very large", "Unexpected % for Very large category.");
    return result;
} 

// Test de methode metrics::Aggregate::getTupUnitSizeCategory
test bool testGetTupUnitSizeCategory() {
	bool result = true;
	TupUnitSizeCategory cat;
	for (lines <- [1..3]) {
		cat = getTupUnitSizeCategory(lines);
		result = result && assertEqual(cat.categoryName, "Small", "Unexpected unit size category.");
	}
	for (lines <- [4..15]) {
		cat = getTupUnitSizeCategory(lines);
		result = result && assertEqual(cat.categoryName, "Medium", "Unexpected unit size category.");
	}
	for (lines <- [16..25]) {
		cat = getTupUnitSizeCategory(lines);
		result = result && assertEqual(cat.categoryName, "Large", "Unexpected unit size category.");
	}
	for (lines <- [26..30]) {
		cat = getTupUnitSizeCategory(lines);
		result = result && assertEqual(cat.categoryName, "Very large", "Unexpected unit size category.");
	}
	return result;
}

// Test de methode metrics::Aggregate::getTupUnitSizeCategoryByCategoryName
test bool testGetTupUnitSizeCategoryByCategoryName() {
	bool result = true;

	TupUnitSizeCategory cat = getTupUnitSizeCategoryByCategoryName("Small");
	result = result && assertEqual(0, cat.minLines, "Unexpected unit size category.minLines.");
	result = result && assertEqual(3, cat.maxLines, "Unexpected unit size category.maxLines.");

	cat = getTupUnitSizeCategoryByCategoryName("Medium");
	result = result && assertEqual(4, cat.minLines, "Unexpected unit size category.minLines.");
	result = result && assertEqual(15, cat.maxLines, "Unexpected unit size category.maxLines.");

	cat = getTupUnitSizeCategoryByCategoryName("Large");
	result = result && assertEqual(16, cat.minLines, "Unexpected unit size category.minLines.");
	result = result && assertEqual(25, cat.maxLines, "Unexpected unit size category.maxLines.");

	cat = getTupUnitSizeCategoryByCategoryName("Very large");
	result = result && assertEqual(26, cat.minLines, "Unexpected unit size category.minLines.");
	result = result && assertEqual(-1, cat.maxLines, "Unexpected unit size category.maxLines.");

	return result;
}

private bool assertComplexityDist(ComplexityDistributionMap cdMap, int perc, str categoryName, str msg) {
	TupComplexityRiskCategory cat = getTupRiskCategoryByCategoryName(categoryName);
	return assertEqual(perc, cdMap[cat], msg);
}

private bool assertUnitSizeDist(UnitSizeDistributionMap usdMap, int perc, str categoryName, str msg) {
	TupUnitSizeCategory cat = getTupUnitSizeCategoryByCategoryName(categoryName);
	return assertEqual(perc, usdMap[cat], msg);
}


