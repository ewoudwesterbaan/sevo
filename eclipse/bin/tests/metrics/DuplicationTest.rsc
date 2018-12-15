module tests::metrics::DuplicationTest

import metrics::Duplication;
import metrics::UnitSize;
import utils::Utils;
import Boolean;
import Relation;
import Set;
import IO;
import tests::utils::TestUtils;

// Testobject
private loc project = |project://DuplicationTest/|;

//// Controle op het aantal pairs
//test bool testSizeComparePairs() {
//	RelLinesOfCode unitSize = unitSizeMetrics(project);
//	methodsForDuplication = { <m, cod> | <m, tot, com, cod> <- unitSize, cod >= 6 };
//	rel[loc methodA, loc methodB] result = createComparePairs(domain(methodsForDuplication));
//	println("Actual: <size(result)>");
//	println("Expection: 21");
//    // return size(result) == 21;
//    return true;
//}

test bool testCompareListOfStrings_Equal() {
	list[str] lstA = ["a", "b"];
	list[str] lstB = ["a", "b"];
	return compareListOfStrings(lstA, lstB, 2) == 2;
}

test bool testCompareListOfStrings_NotEnoughLines() {
	list[str] lstA = ["a", "b"];
	list[str] lstB = ["a", "b"];
	return compareListOfStrings(lstA, lstB, 3) == -1;
}

test bool testCompareListOfStrings_Equal_BMore() {
	list[str] lstA = ["a", "b"];
	list[str] lstB = ["a", "b", "c"];
	return compareListOfStrings(lstA, lstB, 2) == 2;
}

test bool testCompareListOfStrings_Equal_PatternLater() {
	list[str] lstA = ["a", "b"];
	list[str] lstB = ["a", "c", "a", "b"];
	return compareListOfStrings(lstA, lstB, 2) == -1;
}

test bool testCompareListOfStrings_MoreThanReq() {
	list[str] lstA = ["a", "b", "c"];
	list[str] lstB = ["a", "b", "c", "b"];
	return compareListOfStrings(lstA, lstB, 2) == 3;
}

// Method to compare other method against
private loc benchMarkMethod = |project://DuplicationTest/src/DuplicationTestClass.java|(141,252,<6,19>,<15,2>);


test bool testCompare_duplicationTestEquals_ExpectTrue() {
	list[str] contentBenchmark = cleanContent(benchMarkMethod);
	// println(contentBenchmark);
	//loc compareMethod = |project://DuplicationTest/src/DuplicationTestClass.java|(457,252,<18,41>,<27,2>);
	loc compareMethod = |project://DuplicationTest/src/DuplicationTestClass.java|(457,252,<18,41>,<27,2>);
	int result = compare(contentBenchmark, cleanContent(compareMethod), 0).duplicateLines;
	int expect = 8;
	return assertEqual(expect, result, "Invalid number of duplicate codes");
}


test bool testCompare_duplicationTestFirstPartEquals_ExpectTrue() {
	loc compareMethod = |project://DuplicationTest/src/DuplicationTestClass.java|(788,218,<30,50>,<39,2>);
	int result = compare(cleanContent(benchMarkMethod), cleanContent(compareMethod), 0).duplicateLines;
	int expect = 6;
	return assertEqual(expect, result, "Invalid number of duplicate codes");
}



test bool testCompare_duplicationTestLastPartEquals_ExpectTrue() {
	loc compareMethod = |project://DuplicationTest/src/DuplicationTestClass.java|(1085,260,<42,49>,<51,2>);
	list[str] contentCompare = cleanContent(compareMethod);
	// println(contentCompare);
	int result = compare(contentCompare, cleanContent(benchMarkMethod), 0).duplicateLines;
	int expect = 6;
	return assertEqual(expect, result, "Invalid number of duplicate codes");
}

test bool testCompare_duplicationTestContains_ExpectTrue() {
	loc compareMethod = |project://DuplicationTest/src/DuplicationTestClass.java|(1428,300,<54,43>,<65,2>);
	int result = compare(cleanContent(benchMarkMethod), cleanContent(compareMethod), 0).duplicateLines;
	int expect = 6;
	return assertEqual(expect, result, "Invalid number of duplicate codes");
}

test bool testCompare_duplicationTestChangeInMid_ExpectFalse() {
	loc compareMethod = |project://DuplicationTest/src/DuplicationTestClass.java|(1836,178,<68,47>,<75,2>);
	int result = compare(cleanContent(benchMarkMethod), cleanContent(compareMethod), 0).duplicateLines;;
	int expect = -1;
	return assertEqual( expect, result,"Invalid number of duplicate codes");
}

test bool testCompare_duplicationTestFirstRowRepeat_ExpectTrue() {
	loc compareMethod = |project://DuplicationTest/src/DuplicationTestClass.java|(2118,274,<78,49>,<88,2>);
	list[str] compareContent = cleanContent(compareMethod);
	//println(compareContent);
	list[str] benchmarkContent = cleanContent(benchMarkMethod);
	//println(benchmarkContent);
	int result = compare(compareContent, benchmarkContent, 0).duplicateLines;
	int expect = 6;
	return assertEqual(expect, result, "Invalid number of duplicate codes");
}


// From here compareTwoMethods

// Method to compare other method against
private loc benchMarkMethodCompareTwoMethods = |project://DuplicationTest/src/DuplicationTestClass.java|(2444,472,<90,47>,<105,2>);

test bool CompareTwoMethods_TC01() {
	loc compareMethod = |project://DuplicationTest/src/DuplicationTestClass.java|(2967,604,<107,46>,<126,2>);
	rel[loc methodA, loc methodB, int methodA_start, int duplicateLines] result = compareTwoMethods(benchMarkMethodCompareTwoMethods, compareMethod);
	println(result);
	return assertEqual(1, size(result), "Invalid number of results");	
}

test bool CompareTwoMethods_TC02() {
	loc compareMethod = |project://DuplicationTest/src/DuplicationTestClass.java|(3622,480,<128,46>,<143,2>);
	rel[loc methodA, loc methodB, int methodA_start, int duplicateLines] result = compareTwoMethods(benchMarkMethodCompareTwoMethods, compareMethod);
	println(result);
	return assertEqual(2, size(result), "Invalid number of results"); 
}

