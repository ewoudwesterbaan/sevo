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

// Bepaalt de rank van de software op basis van de complexiteit
public Rank getComplexityRank(ComplexityDistributionMap cdMap) {
	real percModerate = cdMap[getTupRiskCategoryByCategoryName("Moderate")];
	real percComplex = cdMap[getTupRiskCategoryByCategoryName("Complex")];
	real percUntestable = cdMap[getTupRiskCategoryByCategoryName("Untestable")];
	return head([rc.rank | rc <- riskRankCategories, percModerate <= rc.maxRelativeLOCModerate && percComplex <= rc.maxRelativeLOCComplex && percUntestable <= rc.maxRelativeLOCUntestable]);
}

// Bepaalt de rank van de applicatie, gegeven de duplicatiepercentage
public str getDuplicationRank(num percentage) {
	if (percentage < 3) return "++";
	if (percentage < 5) return  "+";
	if (percentage < 10) return "o";
	if (percentage < 20) return "-";
	else return "--";
}