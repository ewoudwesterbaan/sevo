module metrics::Duplication

import Set;
import Relation;
import IO;
import utils::Utils;
import List;

// Input moet een set van locaties van methodes zijn 
// waarvan het aantal regel gelijk of groter is dan 6.
public rel[loc methodA, loc methodB, int locEqual] duplication(rel[loc location, int codeSize] methods) {
	rel[loc methodA, loc methodB, int locEqual] compareResult = {<a, b, compare(a, b)> | <a, b> <- createComparePairs(domain(methods)), compare(a, b) != -1};
	println("Number of pairs with code duplication: <size(compareResult)>");
	return compareResult;
}

// Maakt een relatie met methodes om met elkaar te verglijken.
// Geeft een relatie terug van twee methodes.
public rel[loc methodA, loc methodB] createComparePairs(set[loc] methods) {
	rel[loc methodA, loc methodB] cartesianProduct = methods*methods;
	rel[loc, loc] pairs = { <methodA, methodB> | <methodA, methodB> <- cartesianProduct, methodA < methodB };
	println("size of pairs to check: <size(pairs)>");
	return pairs;
}

// Vergelijk de methodes met elkaar.
// Als 6 aan elkaar gesloten regels overeenkomen, geeft dan True terug, anders False
public int compare(loc methodA, loc methodB) {
	// We vergelijken 'schoongemaate' content
	list[str] contentA = cleanContent(methodA);
	list[str] contentB = cleanContent(methodB);
	for (indA <- index(contentA)) { // [0, 1, 2 ..]	
		if (size(contentA[indA ..]) < 6) return -1;
		for (indB <- index(contentB)) {
			if (size(contentB[indB ..]) < 6) break;		
			int compareRes = compareListOfStrings(contentA[indA ..], contentB[indB ..], 6);
			if (compareRes != -1) {
				return compareRes;
			};
		};
	};
	return -1;
}

// Vergelijk twee lijsten van strings met elkaar
// Geeft het aantal terug van opeenvolgende regels indien deze groter zijn dan numLinesMustBeEqual, anders -1 
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

