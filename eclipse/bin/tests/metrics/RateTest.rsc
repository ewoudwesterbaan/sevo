module tests::metrics::RateTest

import tests::utils::TestUtils;
import metrics::Aggregate;
import metrics::Complexity;
import metrics::Rate;
import utils::Utils;
import Boolean;
import IO;
import Set;
import List;

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_PlusPlus() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75,
		getTupRiskCategoryByCategoryName("Moderate") : 25,
		getTupRiskCategoryByCategoryName("Complex") : 0,
		getTupRiskCategoryByCategoryName("Untestable") : 0
	);
	return assertEqual("++", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Plus1() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75,
		getTupRiskCategoryByCategoryName("Moderate") : 26,
		getTupRiskCategoryByCategoryName("Complex") : 0,
		getTupRiskCategoryByCategoryName("Untestable") : 0
	);
	return assertEqual("+", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Plus2() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75,
		getTupRiskCategoryByCategoryName("Moderate") : 24,
		getTupRiskCategoryByCategoryName("Complex") : 5,
		getTupRiskCategoryByCategoryName("Untestable") : 0
	);
	return assertEqual("+", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Zero1() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75,
		getTupRiskCategoryByCategoryName("Moderate") : 31,
		getTupRiskCategoryByCategoryName("Complex") : 0,
		getTupRiskCategoryByCategoryName("Untestable") : 0
	);
	return assertEqual("0", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Zero2() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75,
		getTupRiskCategoryByCategoryName("Moderate") : 26,
		getTupRiskCategoryByCategoryName("Complex") : 6,
		getTupRiskCategoryByCategoryName("Untestable") : 0
	);
	return assertEqual("0", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Minus1() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75,
		getTupRiskCategoryByCategoryName("Moderate") : 41,
		getTupRiskCategoryByCategoryName("Complex") : 0,
		getTupRiskCategoryByCategoryName("Untestable") : 0
	);
	return assertEqual("-", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Minus2() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75,
		getTupRiskCategoryByCategoryName("Moderate") : 31,
		getTupRiskCategoryByCategoryName("Complex") : 11,
		getTupRiskCategoryByCategoryName("Untestable") : 0
	);
	return assertEqual("-", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Minus3() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75,
		getTupRiskCategoryByCategoryName("Moderate") : 31,
		getTupRiskCategoryByCategoryName("Complex") : 9,
		getTupRiskCategoryByCategoryName("Untestable") : 5
	);
	return assertEqual("-", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_MinusMinus1() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 23,
		getTupRiskCategoryByCategoryName("Moderate") : 51,
		getTupRiskCategoryByCategoryName("Complex") : 0,
		getTupRiskCategoryByCategoryName("Untestable") : 0
	);
	return assertEqual("--", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_MinusMinus2() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 23,
		getTupRiskCategoryByCategoryName("Moderate") : 31,
		getTupRiskCategoryByCategoryName("Complex") : 16,
		getTupRiskCategoryByCategoryName("Untestable") : 0
	);
	return assertEqual("--", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_MinusMinus2() {
	ComplexityDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 23,
		getTupRiskCategoryByCategoryName("Moderate") : 5,
		getTupRiskCategoryByCategoryName("Complex") : 5,
		getTupRiskCategoryByCategoryName("Untestable") : 6
	);
	return assertEqual("--", getComplexityRank(cdMap), "Unexpected rank.");
}



