module Main

import utils::Utils;
import metrics::Volume;
import metrics::UnitSize;
import metrics::Complexity;
import metrics::Aggregate;
import metrics::Duplication;
import IO;
import Set;
import util::Math;

public void main() {
	// loc project = |project://smallsql/|;
	loc project = |project://DuplicationTest/|;
	
	println("\nVolume berekenen ...");
	RelLinesOfCode volume = volumeMetrics(project);
	println("Berekend volume: ");
	println("- totaal aantal regels (incl. lege regels): <sum(volume.totalLines)>");
	println("- commentaarregels: <sum(volume.commentLines)>");
	println("- coderegels: <sum(volume.codeLines)>");
	
	println("\nUnit size berekenen ...");
	RelLinesOfCode unitSize = unitSizeMetrics(project);
	TupLinesOfCode sumOfUnitSizes = sumOfUnitSizeMetrics(project);
	println("Aantal gevonden units (methodes en constructoren): <size(unitSize)>");
	println("Som van de aantallen regels per methode/constructor: ");
	println("- totaal aantal regels (incl lege regels binnen de units): <sumOfUnitSizes.totalLines>");
	println("- commentaarregels: <sumOfUnitSizes.commentLines>");
	println("- coderegels: <sumOfUnitSizes.codeLines>");

	println("\nBerekenen cyclomatische complexiteit ...");
	RelComplexities complexities = cyclomaticComplexity(project);
	// for (TupComplexity c <- complexities) println("Complexity: location = <c.location>, method = <c.unitName>, complexity = <c.complexity>.");
	
	println("\nAggregeren gegevens (unit size and complexity) ...");
	ComplexityRatingMap ratingMap = getComplexityRating(project);
	for (entry <- ratingMap) {
		println("- Categorie <entry.categoryName> (<entry.description>): <ratingMap[entry]>%");
	}

	println("\nBerekenen duplicatie");
	methodsForDuplication = { <m, cod> | <m, tot, com, cod> <- unitSize, cod >= 6 }; 
	RelDuplications duplicationResult = duplication(methodsForDuplication);
	// duplicatie wordt alleen bekeken in de methodes en constructors. De verhouding duplicates is dan ook ten opzichte van de som an de unitsize
	num sumUnitSize = sumOfUnitSizeMetrics(project).codeLines;
	println("sumUnitSize: <sumUnitSize>");
	
	num sumDuplicatedCode = sum({0}+{ x.duplicateLines | x <- duplicationResult});
	println("sumDuplicatedCode: <sumDuplicatedCode>");
	
	num duplicationPercentage = sumDuplicatedCode / sumUnitSize;
	
	println("Result duplication: <duplicationPercentage>");

	// We moeten de resultaten van unit size met cyclomatic complexity joinen op locatie
	// a = {<unitSize.location, unitSize.codeLines, complexities.riskCategory> | <unitSize.location, unitSize.codeLines, complexities.riskCategory> <- unitSize join complexities, unitSize.location == complexities.location}
	
	// join is echt betreurenswaardig traag
	// andere probeersel:
	//g = {<c.location, c.unitSize, d.riskCategory> | c <- unitSize, d <- complexities, c.location == d.location};
	
	println("Program ended succesfully");
}

//public rel[loc location, int unitSize, str riskCategory] joinUnitSizeComplexity(RelComplexities complexities, RelLinesOfCode unitSize) {
//	rel[loc location, int unitSize, str riskCategory] newResult = {};
//	for ( c <- unitSize)
//	{
//		for ( d <- complexities) {
//			if (c.location == d.location) {
//				println("Same!!!");
//				newResult += <c.location, c.unitSize, d.riskCategory>;
//				break;
//			};
//		};
//	};
//	return newResult;
//}