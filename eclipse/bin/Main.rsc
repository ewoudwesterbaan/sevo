module Main

import utils::Utils;
import metrics::Volume;
import metrics::UnitSize;
import metrics::Complexity;
import metrics::Duplication;
import IO;
import Set;
import util::Math;

public void main() {
	loc project = |project://smallsql/|;
	
	println("Calculating volume");
	RelLinesOfCode volume = volumeMetrics(project);
	
	println("Calculating unitsize");
	RelLinesOfCode unitSize = unitSizeMetrics(project);

	println("Calculating duplication");
	methodsForDuplication = { <m, cod> | <m, tot, com, cod> <- unitSize, cod >= 6 }; 
	RelDuplications duplicationResult = duplication(methodsForDuplication);
	// duplicatie wordt alleen bekeken in de methodes en constructors. De verhouding duplicates is dan ook ten opzichte van de som an de unitsize
	num sumUnitSize = sum({x.codeLines | x <- unitSize});
	println("sumUnitSize: <sumUnitSize>");
	
	num sumDuplicatedCode = sum({ x.duplicateLines | x <- duplicationResult});
	println("sumDuplicatedCode: <sumDuplicatedCode>");
	
	num duplicationPercentage = sumDuplicatedCode / sumUnitSize;
	
	println("Result duplication: <duplicationPercentage>");

	println("Calculating cyclomatic complexity");
	RelComplexities complexities = cyclomaticComplexity(project);
	for (TupComplexity c <- complexities) println("Complexity: location = <c.location>, method = <c.unitName>, complexity = <c.complexity>.");
	
	// We moeten de resultaten van unit size met cyclomatic complexity joinen op locatie
	//a = {<unitSize.location, unitSize.codeLines, complexities.riskCategory> | <unitSize.location, unitSize.codeLines, complexities.riskCategory> <- unitSize join complexities, unitSize.location == complexities.location}
	
	// join is echt betreurenswaardig traag
	// andere probeersel:
	//g = {<c.location, c.unitSize, d.riskCategory> | c <- unitSize, d <- complexities, c.location == d.location};
	
	
	//TODO Relaties aggregeren
	
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