module metrics::Duplication

import Set;
import Relation;
import IO;
import utils::Utils;
import List;

// Input moet een set van locaties van methodes zijn 
// waarvan het aantal regel gelijk of groter is dan 6.
public void duplication(rel[loc location, int codeSize] methods) {
	rel[loc methodA, loc methodB] createComparePairs(domain(methods));
}

// Maakt een relatie met methodes om met elkaar te verglijken.
// Geeft een relatie terug van twee methodes.
public rel[loc methodA, loc methodB] createComparePairs(set[loc] methods) {
	println("size of methods: <size(methods)>");
	rel[loc methodA, loc methodB] cartesianProduct = methods*methods;
	println("size of cartesianProduct: <size(cartesianProduct)>");
	rel[loc, loc] pairs = { <methodA, methodB> | <methodA, methodB> <- cartesianProduct, methodA < methodB };
	println("size of pairs: <size(pairs)>");
	return pairs;
}

// Vergelijk de methodes met elkaar.
// Als 6 aan elkaar gesloten regels overeenkomen, geeft dan True terug, anders False
public bool compare(loc methodA, loc methodB) {
	// We vergelijken 'schoongemaate' content
	list[str] contentA = cleanContent(methodA);
	list[str] contentB = cleanContent(methodB);
	for (indA <- index(contentA)) { // [0, 1, 2 ..]
		if (size(contentA[indA ..]) < 6) return false;
		for (indB <- index(contentB)) {
			if (compareListOfStrings(contentA[indA ..], contentB[indB ..], 6)) {
				return true;
			};
		};
	};
	return false;
}

// Vergelijks twee lijsten van strings met elkaar
// Geeft het aantal gelijke rgeles terug als het minimaal aantal van numLinesMustBeEqual opeenvolgende regels gelijk zijn
public bool compareListOfStrings(list[str] lstStringA, list[str] lstStringB, int numLinesMustBeEqual) {
	if (size(lstStringA) >= numLinesMustBeEqual && size(lstStringB) >= numLinesMustBeEqual) {
		return head(lstStringA, numLinesMustBeEqual) == head(lstStringB, numLinesMustBeEqual);
	} else {
		return false;
	};
}

