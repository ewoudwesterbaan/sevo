module tests::metrics::DuplicationTest

import metrics::Duplication;
import metrics::UnitSize;
import utils::Utils;
import Boolean;
import Relation;
import Set;
import IO;

// Testobject
private loc project = |project://DuplicationTest/|;

// Controle op het aantal pairs
test bool testSizeComparePairs() {
	RelLinesOfCode unitSize = unitSizeMetrics(project);
	methodsForDuplication = { <m, cod> | <m, tot, com, cod> <- unitSize, cod >= 6 };
	rel[loc methodA, loc methodB] result = createComparePairs(domain(methodsForDuplication));
	println("Actual: <size(result)>");
	println("Expection: 21");
    return size(result) == 21;
}

test bool testCompareListOfStrings_Equal() {
	list[str] lstA = ["a", "b"];
	list[str] lstB = ["a", "b"];
	return compareListOfStrings(lstA, lstB, 2) == true;
}

test bool testCompareListOfStrings_NotEnoughLines() {
	list[str] lstA = ["a", "b"];
	list[str] lstB = ["a", "b"];
	return compareListOfStrings(lstA, lstB, 3) == false;
}

test bool testCompareListOfStrings_Equal_BMore() {
	list[str] lstA = ["a", "b"];
	list[str] lstB = ["a", "b", "c"];
	return compareListOfStrings(lstA, lstB, 2) == true;
}

test bool testCompareListOfStrings_Equal_PatternLater() {
	list[str] lstA = ["a", "b"];
	list[str] lstB = ["a", "c", "a", "b"];
	return compareListOfStrings(lstA, lstB, 2) == false;
}

// Method to compare other method against
private loc benchMarkMethod = |java+method:///DuplicationTestClass/baseMethod()|;

test bool testCompare_duplicationTestEquals_ExpectTrue() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestEquals_ExpectTrue()|;
	return compare(benchMarkMethod, compareMethod) == true;
}

test bool testCompare_duplicationTestFirstPartEquals_ExpectTrue() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestFirstPartEquals_ExpectTrue()|;
	return compare(benchMarkMethod, compareMethod) == true;
}

test bool testCompare_duplicationTestLastPartEquals_ExpectTrue() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestLastPartEquals_ExpectTrue()|;
	return compare(benchMarkMethod, compareMethod) == true;
}

test bool testCompare_duplicationTestContains_ExpectTrue() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestContains_ExpectTrue()|;
	return compare(benchMarkMethod, compareMethod) == true;
}

test bool testCompare_duplicationTestChangeInMid_ExpectFalse() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestChangeInMid_ExpectFalse()|;
	return compare(benchMarkMethod, compareMethod) == false;
}

test bool testCompare_duplicationTestFirstRowRepeat_ExpectTrue() {
	loc compareMethod = |java+method:///DuplicationTestClass/duplicationTestFirstRowRepeat_ExpectTrue()|;
	return compare(benchMarkMethod, compareMethod) == true;
}




