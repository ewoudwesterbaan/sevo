module metrics::Duplication

import Set;
import Relation;
import IO;
import utils::Utils;
import List;

// Set van duplicaties
public alias RelDuplications = rel[loc methodA, int methodA_start, loc methodB, int methodB_start, int duplicateLines];

// Input moet een set van locaties van methodes zijn 
// waarvan het aantal regel gelijk of groter is dan 6.
public RelDuplications duplication(rel[loc location, int codeSize] methods) {
	RelDuplications result = {};
	int counter = 0; // Teller om de voortgang van het proces te tonen
	for (<methodA, methodB> <- createComparePairs(domain(methods))) {
		counter += 1;
		// if (counter % 1000 == 0) println("Processing number <counter>");
		result += compareTwoMethods(methodA, methodB);
	};
	return result;
}

// Vergelijkt twee methods met elkaar
// Geeft een relatie terug van gelijkenissen
//    methodA: methode om te vergelijken
//    methodB: methode om te vergelijken
//    methodA_start: regel in methodeA waar de gelijkenis start
//    duplicateLines: aantal regels die gelijk zijn
public RelDuplications compareTwoMethods(loc methodA, loc methodB) {
	RelDuplications result = {};
	int methodAStart = 0;
	bool foundDup = true;
	// We vergelijken 'schoongemaakte' content
	list[str] contentA = cleanContent(methodA);
	list[str] contentB = cleanContent(methodB);
	while (foundDup) {
		CompareResult compareResult = compare(contentA, contentB, methodAStart);
		// println("compareResult: <compareResult>");
		if (compareResult.duplicateLines == -1) { 
			break;
		} else {
			methodAStart = compareResult.fromLineA + compareResult.duplicateLines;
			// println("Next methodAStart: <methodAStart>"); // debug
			result += <methodA, compareResult.fromLineA, methodB, compareResult.fromLineB, compareResult.duplicateLines>;
		};
	};
	return result;
}

// Maakt een relatie met methodes om met elkaar te verglijken.
// Geeft een relatie terug van twee methodes.
public rel[loc methodA, loc methodB] createComparePairs(set[loc] methods) {
	rel[loc methodA, loc methodB] cartesianProduct = methods*methods;
	rel[loc, loc] pairs = { <methodA, methodB> | <methodA, methodB> <- cartesianProduct, compareLocations(methodA, methodB) < 0 };
	println("size of pairs to check: <size(pairs)>");
	return pairs;
}

// fromLine: 0-based regel waar de gelijkenis start
// toLine: 0-based regel met de laatste aaneengesloten gelijkenis
// duplicateLines: Aantal gelijke regels (ja, inderdaad, dit is toLine - fromLine :) )
public alias CompareResult = tuple[int fromLineA, int toLine, int fromLineB, int duplicateLines];

// Vergelijk de methodes met elkaar.
// Als 6 aan elkaar gesloten regels overeenkomen
// Geeft een tuple CompareResult terug
public CompareResult compare(list[str] contentA, list[str] contentB, int methodAStartIndex) {	
	for (indA <- index(contentA), indA >= methodAStartIndex) { // [0, 1, 2 ..]	
		if (size(contentA[indA ..]) < 6) return <-1, -1, -1, -1>;
		for (indB <- index(contentB)) {
			if (size(contentB[indB ..]) < 6) break;		
			int compareRes = compareListOfStrings(contentA[indA ..], contentB[indB ..], 6);			
			if (compareRes != -1) {
				return <indA, indA + compareRes, indB, compareRes>;
			};
		};
	};
	return <-1, -1, -1, -1>;
}

// Vergelijk twee lijsten van strings met elkaar
// Geeft het aantal terug van opeenvolgende regels indien deze groter zijn dan numLinesMustBeEqual, 
// anders -1 
public int compareListOfStrings(list[str] lstStringA, list[str] lstStringB, int numLinesMustBeEqual) {
	int sizeLstStringA = size(lstStringA);
	int sizeLstStringB = size(lstStringB);
	if (sizeLstStringA >= numLinesMustBeEqual && sizeLstStringB >= numLinesMustBeEqual) {
		if(head(lstStringA, numLinesMustBeEqual) == head(lstStringB, numLinesMustBeEqual)) {			
			for (rowNum <- [numLinesMustBeEqual .. sizeLstStringA]) {
				if (rowNum > sizeLstStringB-1) break;
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

