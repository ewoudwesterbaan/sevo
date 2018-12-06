module metrics::Duplication

import Set;
import Relation;
import IO;
import utils::Utils;
import List;

// Input moet een set van locaties van methodes zijn 
// waarvan het aantal regel gelijk of groter is dan 6.
public void duplication(rel[loc location, int codeSize] methods) {
	createComparePairs(domain(methods));
}

// Tijdelijk op void gezet om foutmelding te voorkomen: Missing return statement
public void createComparePairs(set[loc] methods) {
//public rel[loc, loc] createComparePairs(set[loc] methods) {
	println("size of methods: <size(methods)>");
	rel[loc methodA, loc methodB] cartesianProduct = methods*methods; // 682276
	println("size of cartesianProduct: <size(cartesianProduct)>");
	rel[loc, loc] part1 = { <methodA, methodB> | <methodA, methodB> <- cartesianProduct, methodA < methodB };
	println("size of part1: <size(part1)>");
	rel[loc, loc] part2 = { <methodB, methodA> | <methodA, methodB> <- cartesianProduct, methodA > methodB };
	println("size of part2: <size(part2)>");
	rel[loc methodA, loc methodB] distinct = part1 + part2;
	println("size of distinct: <size(distinct)>");
}

public bool compare(loc methodA, loc methodB) {
	int locMethodA = getLinesOfCode(methodA).codeLines;
	int locMethodB = getLinesOfCode(methodB).codeLines;
	// verdelen, a bevat de minste content (of gelijk)
	loc a = locMethodA < locMethodB ? methodA : methodB;
	loc b = locMethodA < locMethodB ? methodB : methodA;
	list[str] contentA = cleanContent(a);
	list[str] contentB = cleanContent(b);
	int sizeA = size(contentA);
	int sizeB = size(contentB);
	int equalRows = 0;
	// we gaan uit van de methode met het minst aantal regels
	for (lineA <- contentA) {
		for (lineB <- contentB) {
			if (lineB == lineA) {
				equalRows += 1;
			} else {
				equalRows = 0;
				
			};
		};
	};
	return equalRows >= 6;
}