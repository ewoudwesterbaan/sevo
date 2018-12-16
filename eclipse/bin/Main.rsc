module Main

import utils::Utils;
import metrics::Volume;
import metrics::UnitSize;
import metrics::Complexity;
import metrics::Aggregate;
import metrics::Rate;
import metrics::Duplication;
import IO;
import Set;
import util::Math;
import List;
import analysis::graphs::Graph;

public void main() {
	loc project = |project://smallsql/|;
	// loc project = |project://DuplicationTest/|;
	
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
	
	println("\nAggregeren gegevens (unit size and complexity) ...");
	ComplexityDistributionMap cdMap = getComplexityDistribution(project);
	for (entry <- cdMap) {
		println("- Categorie <entry.categoryName> (<entry.description>): <cdMap[entry]>%");
	}
	println("- Rank op basis van aggregatie: <getComplexityRank(cdMap)>");


	println("\nBerekenen duplicatie ...");
	methodsForDuplication = { <m, cod> | <m, tot, com, cod> <- unitSize, cod >= 6 }; 
	RelDuplications duplicationResult = duplication(methodsForDuplication);
	// duplicatie wordt alleen bekeken in de methodes en constructors. De verhouding duplicates is dan ook ten opzichte van de som van de unitsize
	println("- Aantal duplicaties: <size(duplicationResult)>");
	
	num totalDupLines = 0;	
	for (int dupLines <- duplicationResult.duplicateLines) {
		rel[loc from, loc to] tmp = { <methodA + "_<methodA_start>", methodB + "_<methodB_start>"> | <loc methodA, int methodA_start, loc methodB, int methodB_start, int duplicateLines> <- duplicationResult, duplicateLines == dupLines};
		totalDupLines += sum([size(d) * dupLines | d <- toList(connectedComponents(tmp))]);
	};

	println("- Aantal regels gedupliceerd: <totalDupLines>");
	
	num duplicationPercentage = (totalDupLines * 100) / sumOfUnitSizes.codeLines;
	println("- Duplicatepercentage: <duplicationPercentage>%");

	println("\nProgramma beëindigd");
}
