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

// Test de methode metrics::Rate::getTupRankCategoryByRank
test bool testGetTupRankCategoryByRank() {
	bool result = assertEqual("++", getTupRankCategoryByRank("++").rank, "Unexpected rank");
	result = result && assertEqual("+", getTupRankCategoryByRank("+").rank, "Unexpected rank");
	result = result && assertEqual("0", getTupRankCategoryByRank("0").rank, "Unexpected rank");
	result = result && assertEqual("-", getTupRankCategoryByRank("-").rank, "Unexpected rank");
	result = result && assertEqual("--", getTupRankCategoryByRank("--").rank, "Unexpected rank");
	return result;
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_PlusPlus() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75.0,
		getTupRiskCategoryByCategoryName("Moderate") : 25.0,
		getTupRiskCategoryByCategoryName("Complex") : 0.0,
		getTupRiskCategoryByCategoryName("Untestable") : 0.0
	);
	return assertEqual("++", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Plus1() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75.0,
		getTupRiskCategoryByCategoryName("Moderate") : 26.0,
		getTupRiskCategoryByCategoryName("Complex") : 0.0,
		getTupRiskCategoryByCategoryName("Untestable") : 0.0
	);
	return assertEqual("+", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Plus2() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75.0,
		getTupRiskCategoryByCategoryName("Moderate") : 24.0,
		getTupRiskCategoryByCategoryName("Complex") : 5.0,
		getTupRiskCategoryByCategoryName("Untestable") : 0.0
	);
	return assertEqual("+", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Zero1() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75.0,
		getTupRiskCategoryByCategoryName("Moderate") : 31.0,
		getTupRiskCategoryByCategoryName("Complex") : 0.0,
		getTupRiskCategoryByCategoryName("Untestable") : 0.0
	);
	return assertEqual("0", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Zero2() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75.0,
		getTupRiskCategoryByCategoryName("Moderate") : 26.0,
		getTupRiskCategoryByCategoryName("Complex") : 6.0,
		getTupRiskCategoryByCategoryName("Untestable") : 0.0
	);
	return assertEqual("0", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Minus1() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75.0,
		getTupRiskCategoryByCategoryName("Moderate") : 41.0,
		getTupRiskCategoryByCategoryName("Complex") : 0.0,
		getTupRiskCategoryByCategoryName("Untestable") : 0.0
	);
	return assertEqual("-", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Minus2() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75.0,
		getTupRiskCategoryByCategoryName("Moderate") : 31.0,
		getTupRiskCategoryByCategoryName("Complex") : 11.0,
		getTupRiskCategoryByCategoryName("Untestable") : 0.0
	);
	return assertEqual("-", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_Minus3() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 75.0,
		getTupRiskCategoryByCategoryName("Moderate") : 31.0,
		getTupRiskCategoryByCategoryName("Complex") : 9.0,
		getTupRiskCategoryByCategoryName("Untestable") : 5.0
	);
	return assertEqual("-", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_MinusMinus1() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 23.0,
		getTupRiskCategoryByCategoryName("Moderate") : 51.0,
		getTupRiskCategoryByCategoryName("Complex") : 0.0,
		getTupRiskCategoryByCategoryName("Untestable") : 0.0
	);
	return assertEqual("--", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_MinusMinus2() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 23.0,
		getTupRiskCategoryByCategoryName("Moderate") : 31.0,
		getTupRiskCategoryByCategoryName("Complex") : 16.0,
		getTupRiskCategoryByCategoryName("Untestable") : 0.0
	);
	return assertEqual("--", getComplexityRank(cdMap), "Unexpected rank.");
}

// Test de methode metrics::Rate::getComplexityRank
test bool testGetComplexityRank_MinusMinus2() {
	RiskCatDistributionMap cdMap = (
		getTupRiskCategoryByCategoryName("Simple") : 23.0,
		getTupRiskCategoryByCategoryName("Moderate") : 5.0,
		getTupRiskCategoryByCategoryName("Complex") : 5.0,
		getTupRiskCategoryByCategoryName("Untestable") : 6.0
	);
	return assertEqual("--", getComplexityRank(cdMap), "Unexpected rank.");
}