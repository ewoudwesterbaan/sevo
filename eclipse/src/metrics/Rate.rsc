module metrics::Rate

import metrics::Aggregate;
import metrics::Complexity;
import List;
import Set;

public alias Rank = str;

// Tuple voor ranking obv de complexiteit
public alias TupComplexityRankCategory = tuple[Rank rank, int maxRelativeLOCModerate, int maxRelativeLOCComplex, int maxRelativeLOCUntestable];
// Lijst van de bovenstaande tupels
public alias LstComplexityRankCategories = list[TupComplexityRankCategory];

// Ranking categorieen
public LstComplexityRankCategories riskRankCategories = [
	<"++", 25, 0, 0>,
	<"+", 30, 5, 0>,
	<"0", 40, 10, 0>,
	<"-", 50, 15, 5>,
	<"--", 100, 100, 100>
];

// Tuple voor ranking obv de complexiteit
public alias TupUnitSizeRankCategory = tuple[Rank rank, int maxRelativeLOCMedium, int maxRelativeLOCLarge, int maxRelativeLOCVeryLarge];
// Lijst van de bovenstaande tupels
public alias LstUnitSizeRankCategories = list[TupUnitSizeRankCategory];

// Ranking categorieen voor de unit size
public LstUnitSizeRankCategories unitSizeRankCategories = [
	<"++", 25, 0, 0>,
	<"+", 30, 5, 0>,
	<"0", 40, 10, 0>,
	<"-", 50, 15, 5>,
	<"--", 100, 100, 100>
];

// Bepaalt de rank van de software op basis van de complexiteit
public Rank getComplexityRank(ComplexityDistributionMap cdMap) {
	int percModerate = cdMap[getTupRiskCategoryByCategoryName("Moderate")];
	int percComplex = cdMap[getTupRiskCategoryByCategoryName("Complex")];
	int percUntestable = cdMap[getTupRiskCategoryByCategoryName("Untestable")];
	return head([rc.rank | rc <- riskRankCategories, percModerate <= rc.maxRelativeLOCModerate && percComplex <= rc.maxRelativeLOCComplex && percUntestable <= rc.maxRelativeLOCUntestable]);
}

// Bepaalt de rank van de applicatie op basis van de unit sizes
public Rank getUnitSizeRank(UnitSizeDistributionMap usdMap) {
	int percMedium = usdMap[getTupUnitSizeCategoryByCategoryName("Medium")];
	int percLarge = usdMap[getTupUnitSizeCategoryByCategoryName("Large")];
	int percVeryLarge = usdMap[getTupUnitSizeCategoryByCategoryName("Very large")];
	return head([rc.rank | rc <- unitSizeRankCategories, percMedium <= rc.maxRelativeLOCMedium && percLarge <= rc.maxRelativeLOCLarge && percVeryLarge <= rc.maxRelativeLOCVeryLarge]);
}
