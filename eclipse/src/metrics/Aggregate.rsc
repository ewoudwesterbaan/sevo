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
public alias ComplexityRatingMap = map[TupComplexityRiskCategory category, int lines];

// Produceert een complexity rating. Per complexiteitscategorie (simple, moderate, high, ...)
// wordt op basis van de regels code in het hele systeem, afgezet tegen de regels code per unit 
// (methode/constructor) een overzicht gegenereerd.
// Geeft een ComplexityRatingMap terug met per risicocategorie een percentage. Dit percentage is
// het aantal coderegels in verhouding tot het totaal aantal coderegels per categorie.
public ComplexityRatingMap getComplexityRating(loc project) {

	// Een map waarin we het totaal aantal LOC van alle units per complexiteitscategorie bijhouden
	ComplexityRatingMap ratingMap = (rc : 0 | rc <- riskCategories);

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
		ratingMap[riskCategory] += unitLinesOfCode;
	}
	
	// We hebben nu een ratingMap met per risicocategorie het aantal unitcoderegels.
	// Bepaal nu de ratio van de regels per complexiteitscategorie
	for (key <- ratingMap.category) {
		ratingMap[key] = (ratingMap[key] * 100) / sysLinesOfCode;
	}
	
	return ratingMap;
}

