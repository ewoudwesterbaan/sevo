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
public LstComplexityRankCategories rankCategories = [
	<"++", 25, 0, 0>,
	<"+", 30, 5, 0>,
	<"0", 40, 10, 0>,
	<"-", 50, 15, 5>,
	<"--", 100, 100, 100>
];

public Rank getComplexityRank(ComplexityDistributionMap cdMap) {
	int percModerate = cdMap[getTupRiskCategoryByCategoryName("Moderate")];
	int percComplex = cdMap[getTupRiskCategoryByCategoryName("Complex")];
	int percUntestable = cdMap[getTupRiskCategoryByCategoryName("Untestable")];
	
	return head([rc.rank | rc <- rankCategories, percModerate <= rc.maxRelativeLOCModerate && percComplex <= rc.maxRelativeLOCComplex && percUntestable <= rc.maxRelativeLOCUntestable]);
}
