module metrics::Aggregate

import utils::Utils;
import metrics::Complexity;
import metrics::UnitSize;
import metrics::Volume;
import IO;
import Set;
import List;
import Map;

// Een map met het aantal regels code per complexiteitscategorie (simple, moderate, high, ...)
public alias ComplexityDistributionMap = map[TupComplexityRiskCategory category, int lines];

// Tuple voor unit size categorie
public alias TupUnitSizeCategory = tuple[str categoryName, str description, int minLines, int maxLines];
// Relatie voor unit size categorieen
public alias LstUnitSizeCategories = list[TupUnitSizeCategory];

// Categorieen voor de grootte van units (methoden en constructoren)
public LstUnitSizeCategories unitSizeCategories = [
	<"Small", "Small units (0-5)", 0, 5>,
	<"Medium", "Medium size units (6-15)", 6, 15>,
	<"Large", "Large units (16-25)", 16, 25>,
	<"Very large", "Untestable, very large units (\>26)", 26, -1>
];

// Een map met de totale hoeveelheid code in het systeem per unit size category
public alias UnitSizeDistributionMap = map[TupUnitSizeCategory category, int lines];

// Produceert een verdeling van de complexity. Per complexiteitscategorie (simple, moderate, high, ...)
// wordt op basis van de regels code in het hele systeem, afgezet tegen de regels code per unit 
// (methode/constructor) een overzicht gegenereerd.
// Geeft een ComplexityDistributionMap terug met per risicocategorie een percentage. Dit percentage is
// het aantal coderegels in verhouding tot het totaal aantal coderegels per categorie.
public ComplexityDistributionMap getComplexityDistribution(loc project) {

	// Een map waarin we het totaal aantal LOC van alle units per complexiteitscategorie bijhouden
	ComplexityDistributionMap distributionMap = (rc : 0 | rc <- riskCategories);

	// Alle coderegels van alle units tezamen	
	int sysLinesOfCode = sumOfUnitSizeMetrics(project).codeLines;
	// Het aantal regels per unit
	RelLinesOfCode unitSizes = unitSizeMetrics(project);
	// Complexiteitscategorie per unit
	RelComplexities complexities = cyclomaticComplexity(project);
	
	// Bepaal het (absolute) aantal regels unitcode per complexiteitscategorie
	for (TupLinesOfCode tloc <- unitSizes) {
	    loc unitLocation = tloc.location;
		int unitLinesOfCode = tloc.codeLines;
		
		// Zoek de categorie(naam) van de unit op basis van de locatie van de unit
		str categoryName = head([complexity.riskCategory | complexity <- complexities, complexity.location == unitLocation]);
		
		// Werk de map met ratings bij: hoog het aantal regels bij de relevante categorie op met het aantal 
		// regels in de huidige unit
		TupComplexityRiskCategory riskCategory = getTupRiskCategoryByCategoryName(categoryName);
		distributionMap[riskCategory] += unitLinesOfCode;
	}
	
	// We hebben nu een distributionMap met per risicocategorie het aantal unitcoderegels.
	// Bepaal nu de ratio/distributie van de regels per complexiteitscategorie
	for (key <- distributionMap.category) {
		distributionMap[key] = (distributionMap[key] * 100) / sysLinesOfCode;
	}
	
	return distributionMap;
}

// Produceert een verdeling van de unit size. Per unit size categorie (small, medium, large, ...)
// wordt op basis van de regels code in het hele systeem, afgezet tegen de hoeveelheid regels code 
// per unit (methode/constructor) een overzicht gegenereerd.
// Geeft een UnitSizeDistributionMap terug met per groottecategorie een percentage. Dit percentage is
// het aantal coderegels in verhouding tot het totaal aantal coderegels per categorie.
public UnitSizeDistributionMap getUnitSizeDistribution(int sysLinesOfCode, RelLinesOfCode unitSizes) {

	// Een map waarin we het totaal aantal LOC van alle units per groottecategorie bijhouden
	UnitSizeDistributionMap distributionMap = (rc : 0 | rc <- unitSizeCategories);

	// Bepaal het (absolute) aantal regels unitcode per categorie
	for (TupLinesOfCode tloc <- unitSizes) {
		// Werk de map bij: hoog het aantal regels bij de relevante categorie op met het aantal 
		// regels in de huidige unit
		int unitLinesOfCode = tloc.codeLines;
		TupUnitSizeCategory unitSizeCategory = getTupUnitSizeCategory(unitLinesOfCode);
		distributionMap[unitSizeCategory] += unitLinesOfCode;
	}
	
	// We hebben nu een distributionMap met per groottecategorie het aantal unitcoderegels.
	// Bepaal nu de ratio/distributie van de regels per groottecategorie
	for (key <- distributionMap.category) {
		distributionMap[key] = (distributionMap[key] * 100) / sysLinesOfCode;
	}
	
	return distributionMap;
}

// Zoekt de categorie bij een aantal regels per unit.
private TupUnitSizeCategory getTupUnitSizeCategory(int linesOfCode) {
	return head([cat | cat <- unitSizeCategories, 
		linesOfCode >= cat.minLines && (cat.maxLines == -1 || linesOfCode <= cat.maxLines)
	]);	
}

// Geeft een tupel met unit size gegevens terug op basis van de categorienaam
public TupUnitSizeCategory getTupUnitSizeCategoryByCategoryName(str name) {
	return head([cat | cat <- unitSizeCategories, name == cat.categoryName]);	
}
