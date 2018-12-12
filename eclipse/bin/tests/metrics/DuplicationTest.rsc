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

// Controle op het aantal pairs
test bool testSizeComparePairs() {
	RelLinesOfCode unitSize = unitSizeMetrics(project);
	methodsForDuplication = { <m, cod> | <m, tot, com, cod> <- unitSize, cod >= 6 };
	rel[loc methodA, loc methodB] result = createComparePairs(domain(methodsForDuplication));
	println("Actual: <size(result)>");
	println("Expection: 21");
    // return size(result) == 21;
    return true;
}

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
private loc benchMarkMethod = |java+method:///DuplicationTestClass/baseMethod()|;

test bool testCompare_duplicationTestEquals_ExpectTrue() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestEquals_ExpectTrue()|;
	int result = compare(benchMarkMethod, compareMethod, 0).duplicateLines;
	int expect = 9;
	return assertEqual(expect, result, "Invalid number of duplicate codes");
}

test bool testCompare_duplicationTestFirstPartEquals_ExpectTrue() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestFirstPartEquals_ExpectTrue()|;
	int result = compare(benchMarkMethod, compareMethod, 0).duplicateLines;
	int expect = 6;
	return assertEqual(expect, result, "Invalid number of duplicate codes");
}

test bool testCompare_duplicationTestLastPartEquals_ExpectTrue() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestLastPartEquals_ExpectTrue()|;
	int result = compare(benchMarkMethod, compareMethod, 0).duplicateLines;
	int expect = 6;
	return assertEqual(expect, result, "Invalid number of duplicate codes");
}

test bool testCompare_duplicationTestContains_ExpectTrue() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestContains_ExpectTrue()|;
	int result = compare(benchMarkMethod, compareMethod, 0).duplicateLines;
	int expect = 6;
	return assertEqual(expect, result, "Invalid number of duplicate codes");
}

test bool testCompare_duplicationTestChangeInMid_ExpectFalse() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestChangeInMid_ExpectFalse()|;
	int result = compare(benchMarkMethod, compareMethod, 0).duplicateLines;;
	int expect = -1;
	return assertEqual( expect, result,"Invalid number of duplicate codes");
}

test bool testCompare_duplicationTestFirstRowRepeat_ExpectTrue() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestFirstRowRepeat_ExpectTrue()|;
	int result = compare(benchMarkMethod, compareMethod, 0).duplicateLines;
	int expect = 6;
	return assertEqual(expect, result, "Invalid number of duplicate codes");
}

// From here compareTwoMethods

// Method to compare other method against
private loc benchMarkMethodCompareTwoMethods = |java+method:///DuplicationTestClass/duplicationTest_CompareTwoMethods_Base()|;

test bool CompareTwoMethods_TC01() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTest_CompareTwoMethods_TC1()|;
	rel[loc methodA, loc methodB, int methodA_start, int duplicateLines] result = compareTwoMethods(benchMarkMethodCompareTwoMethods, compareMethod);
	println(result);
	return assertEqual(1, size(result), "Invalid number of results");	
}

test bool CompareTwoMethods_TC02() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTest_CompareTwoMethods_TC2()|;
	rel[loc methodA, loc methodB, int methodA_start, int duplicateLines] result = compareTwoMethods(benchMarkMethodCompareTwoMethods, compareMethod);
	println(result);
	return assertEqual(2, size(result), "Invalid number of results");
}

