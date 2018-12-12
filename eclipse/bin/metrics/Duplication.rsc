module metrics::Duplication

import Set;
import Relation;
import IO;
import utils::Utils;
import List;

// Input moet een set van locaties van methodes zijn 
// waarvan het aantal regel gelijk of groter is dan 6.
public rel[loc methodA, loc methodB, int methodA_start, int locDuplicate] duplication(rel[loc location, int codeSize] methods) {
	rel[loc methodA, loc methodB, int methodA_start, int locDuplicate] result = {};
	int counter = 0; // Teller om de voortgang van het proces te tonen
	for (<methodA, methodB> <- createComparePairs(domain(methods))) {
		counter += 1;
		counter % 1000 == 0 ? println("Processing number <counter>");
		compareTwoMethods(methodA, methodB);
	};
	println("Number duplication found: <size(result)>");
	return result;
}

// Vergelijkt twee methods met elkaar
// Geeft een relatie terug van gelijkenissen
//    methodA: methode om te vergelijken
//    methodB: methode om te vergelijken
//    methodA_start: regel in methodeA waar de gelijkenis start
//    duplicateLines: aantal regels die gelijk zijn
public rel[loc methodA, loc methodB, int methodA_start, int duplicateLines] compareTwoMethods(loc methodA, loc methodB) {
	rel[loc methodA, loc methodB, int methodA_start, int duplicateLines] result = {};
	int methodAStart = 0;
	bool foundDup = true;
	while (foundDup) {
		CompareResult compareResult = compare(methodA, methodB, methodAStart);
		// println("compareResult: <compareResult>");
		if (compareResult.duplicateLines == -1) { 
			break;
		} else {
			methodAStart = compareResult.fromLine + compareResult.duplicateLines;
			// println("Next methodAStart: <methodAStart>"); // debug
			result += <methodA, methodB, compareResult.fromLine, compareResult.duplicateLines>;
		};
	};
	return result;
}

// Maakt een relatie met methodes om met elkaar te verglijken.
// Geeft een relatie terug van twee methodes.
public rel[loc methodA, loc methodB] createComparePairs(set[loc] methods) {
	rel[loc methodA, loc methodB] cartesianProduct = methods*methods;
	rel[loc, loc] pairs = { <methodA, methodB> | <methodA, methodB> <- cartesianProduct, methodA < methodB };
	println("size of pairs to check: <size(pairs)>");
	return pairs;
}

// fromLine: 0-based regel waar de gelijkenis start
// toLine: 0-based regel met de laatste aaneengesloten gelijkenis
// duplicateLines: Aantal gelijke regels (ja, inderdaad, dit is toLine - fromLine :) )
public alias CompareResult = tuple[int fromLine, int toLine, int duplicateLines];

// Vergelijk de methodes met elkaar.
// Als 6 aan elkaar gesloten regels overeenkomen
// Geeft een tuple CompareResult terug
public CompareResult compare(loc methodA, loc methodB, int methodAStartIndex) {
	// We vergelijken 'schoongemaate' content
	list[str] contentA = cleanContent(methodA);
	list[str] contentB = cleanContent(methodB);
	
	for (indA <- index(contentA), indA >= methodAStartIndex) { // [0, 1, 2 ..]	
		if (size(contentA[indA ..]) < 6) return <-1, -1, -1>;
		for (indB <- index(contentB)) {
			if (size(contentB[indB ..]) < 6) break;		
			int compareRes = compareListOfStrings(contentA[indA ..], contentB[indB ..], 6);			
			if (compareRes != -1) {
				return <indA, indA + compareRes, compareRes>;
			};
		};
	};
	return <-1, -1, -1>;
}

// Vergelijk twee lijsten van strings met elkaar
// Geeft het aantal terug van opeenvolgende regels indien deze groter zijn dan numLinesMustBeEqual, 
// anders -1 
public int compareListOfStrings(list[str] lstStringA, list[str] lstStringB, int numLinesMustBeEqual) {
	if (size(lstStringA) >= numLinesMustBeEqual && size(lstStringB) >= numLinesMustBeEqual) {
		if(head(lstStringA, numLinesMustBeEqual) == head(lstStringB, numLinesMustBeEqual)) {
			int sizeLstStringA = size(lstStringA);
			for (rowNum <- [numLinesMustBeEqual .. sizeLstStringA]) {
				if (lstStringA[rowNum] == lstStringB[rowNum]) {
					numLinesMustBeEqual += 1;
				} else {
					break;
				};
			};
			return numLinesMustBeEqual;
		};
	}
	return -1;
}

