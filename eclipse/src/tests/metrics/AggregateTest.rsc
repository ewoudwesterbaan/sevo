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
    
    real simplePerc = (34 * 100) / 161.0;
    real moderatePerc =  (22 * 100) / 161.0;
    real complexPerc =  (52 * 100) / 161.0;
    real untestablePerc =  (53 * 100) / 161.0;
    
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
	int sysLinesOfCode = 400;
	RelLinesOfCode unitSizes = {
		// small
		<|project://unit1|, 11, 10, 1>,
		<|project://unit2|, 22, 7, 15>,
		// medium
		<|project://unit3|, 26, 10, 16>,
		<|project://unit4|, 60, 10, 50>,
		// large
		<|project://unit5|, 60, 9, 51>,
		<|project://unit6|, 107, 7, 100>,
		// very large
		<|project://unit7|, 106, 5, 101>,
		<|project://unit8|, 255, 5, 250>,
		// insane
		<|project://unit9|, 256, 5, 251>
	};

	// Roep de te testen methode aan
	UnitSizeDistributionMap usdMap = getUnitSizeDistribution(sysLinesOfCode, unitSizes);
	
	// Verwachte resultaten
    real smallPerc = ((1 + 15) * 100.0) / sysLinesOfCode;
    real mediumPerc = ((16 + 50) * 100.0) / sysLinesOfCode;
    real largePerc = ((51 + 100) * 100.0) / sysLinesOfCode;
    real veryLargePerc = ((101 + 250) * 100.0) / sysLinesOfCode;
    real insanePerc = (251 * 100.0) / sysLinesOfCode;

	// Controleer resultaat
    bool result = true;
    result = result && assertUnitSizeDist(usdMap, smallPerc, "Small", "Unexpected % for Small category.");
    result = result && assertUnitSizeDist(usdMap, mediumPerc, "Medium", "Unexpected % for Medium category.");
    result = result && assertUnitSizeDist(usdMap, largePerc, "Large", "Unexpected % for Large category.");
    result = result && assertUnitSizeDist(usdMap, veryLargePerc, "Very large", "Unexpected % for Very large category.");
    result = result && assertUnitSizeDist(usdMap, insanePerc, "Insane", "Unexpected % for Insane category.");
    return result;
} 

// Test de methode metrics::Aggregate::getTupUnitSizeCategory
test bool testGetTupUnitSizeCategory() {
	bool result = true;
	TupUnitSizeCategory cat;
	for (lines <- [1..15]) {
		cat = getTupUnitSizeCategory(lines);
		result = result && assertEqual(cat.categoryName, "Small", "Unexpected unit size category.");
	}
	for (lines <- [16..50]) {
		cat = getTupUnitSizeCategory(lines);
		result = result && assertEqual(cat.categoryName, "Medium", "Unexpected unit size category.");
	}
	for (lines <- [51..100]) {
		cat = getTupUnitSizeCategory(lines);
		result = result && assertEqual(cat.categoryName, "Large", "Unexpected unit size category.");
	}
	for (lines <- [101..250]) {
		cat = getTupUnitSizeCategory(lines);
		result = result && assertEqual(cat.categoryName, "Very large", "Unexpected unit size category.");
	}
	for (lines <- [251..260]) {
		cat = getTupUnitSizeCategory(lines);
		result = result && assertEqual(cat.categoryName, "Insane", "Unexpected unit size category.");
	}
	return result;
}

// Test de methode metrics::Aggregate::getTupUnitSizeCategoryByCategoryName
test bool testGetTupUnitSizeCategoryByCategoryName() {
	bool result = true;

	TupUnitSizeCategory cat = getTupUnitSizeCategoryByCategoryName("Small");
	result = result && assertEqual(0, cat.minLines, "Unexpected unit size category.minLines.");
	result = result && assertEqual(15, cat.maxLines, "Unexpected unit size category.maxLines.");

	cat = getTupUnitSizeCategoryByCategoryName("Medium");
	result = result && assertEqual(16, cat.minLines, "Unexpected unit size category.minLines.");
	result = result && assertEqual(50, cat.maxLines, "Unexpected unit size category.maxLines.");

	cat = getTupUnitSizeCategoryByCategoryName("Large");
	result = result && assertEqual(51, cat.minLines, "Unexpected unit size category.minLines.");
	result = result && assertEqual(100, cat.maxLines, "Unexpected unit size category.maxLines.");

	cat = getTupUnitSizeCategoryByCategoryName("Very large");
	result = result && assertEqual(101, cat.minLines, "Unexpected unit size category.minLines.");
	result = result && assertEqual(250, cat.maxLines, "Unexpected unit size category.maxLines.");

	cat = getTupUnitSizeCategoryByCategoryName("Insane");
	result = result && assertEqual(251, cat.minLines, "Unexpected unit size category.minLines.");
	result = result && assertEqual(-1, cat.maxLines, "Unexpected unit size category.maxLines.");

	return result;
}

private bool assertComplexityDist(ComplexityDistributionMap cdMap, real perc, str categoryName, str msg) {
	TupComplexityRiskCategory cat = getTupRiskCategoryByCategoryName(categoryName);
	return assertEqual(perc, cdMap[cat], msg);
}

private bool assertUnitSizeDist(UnitSizeDistributionMap usdMap, real perc, str categoryName, str msg) {
	TupUnitSizeCategory cat = getTupUnitSizeCategoryByCategoryName(categoryName);
	return assertEqual(perc, usdMap[cat], msg);
}


