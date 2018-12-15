module tests::utils::UtilsTest

import utils::Utils;
import Boolean;
import IO;
import tests::utils::TestUtils;

test bool testCompareLocations_GreaterThanByPosition() {
	loc a = |project://example-project/src/HelloWorld.java|(0,1,<22,3>,<24,5>);
	loc b = |project://example-project/src/HelloWorld.java|(0,1,<12,3>,<14,5>);
	return compareLocations(a, b) > 0;
}

test bool testCompareLocations_GreaterThanByClassName() {
	loc a = |project://example-project/src/HelloWorld.java|(0,1,<22,3>,<24,5>);
	loc b = |project://example-project/src/HalloWereld.java|(0,1,<22,3>,<24,5>);
	return compareLocations(a, b) > 0;
}

test bool testCompareLocations_GreaterThanLogicalFormat() {
	loc a = |java+method:///MyClass/method_b()|;
	loc b = |java+method:///MyClass/method_a()|;
	return compareLocations(a, b) > 0;
}

test bool testCompareLocations_LessThanByPosition() {
	loc a = |project://example-project/src/HelloWorld.java|(0,1,<12,3>,<14,5>);
	loc b = |project://example-project/src/HelloWorld.java|(0,1,<22,3>,<24,5>);
	return compareLocations(a, b) < 0;
}

test bool testCompareLocations_LessThanByClassName() {
	loc a = |project://example-project/src/HalloWorld.java|(0,1,<22,3>,<24,5>);
	loc b = |project://example-project/src/HelloWereld.java|(0,1,<22,3>,<24,5>);
	return compareLocations(a, b) < 0;
}

test bool testCompareLocations_LessThanLogicalFormat() {
	loc a = |java+method:///MyClass/method_a()|;
	loc b = |java+method:///MyClass/method_b()|;
	return compareLocations(a, b) < 0;
}

test bool testCompareLocations_Equal() {
	loc a = |project://example-project/src/HelloWorld.java|(0,1,<22,3>,<24,5>);
	loc b = |project://example-project/src/HelloWorld.java|(0,1,<22,3>,<24,5>);
	return compareLocations(a, b) == 0;
}

test bool testCompareLocations_EqualLogicalFormat() {
	loc a = |java+method:///MyClass/method_a()|;
	loc b = |java+method:///MyClass/method_a()|;
	return compareLocations(a, b) == 0;
}

test bool testCleanLineComment_NoComment() {
	str input = "Text with no comment";
	str expect = "Text with no comment";
	str actual = cleanLineComment(input);
	return assertEqual(expect, actual, "Assert failed");
}

test bool testCleanLineComment_CommentAtTheEnd() {
	str input = "Text with comment // at the end";
	str expect = "Text with comment";
	str actual = cleanLineComment(input);
	return assertEqual(expect, actual, "Assert failed");
}

test bool testCleanLineComment_SlashInString() {
	str input = "Text with \"//\" in a string";
	str expect = "Text with \"//\" in a string";
	str actual = cleanLineComment(input);
	return assertEqual(expect, actual, "Assert failed");
}

test bool testCleanLineComment_SlashInString() {
	str input = "\"Text with \\\"just a string\"//\" in a string";
	str expect = "\"Text with \\\"just a string\"";
	str actual = cleanLineComment(input);
	return assertEqual(expect, actual, "Assert failed");
}

test bool testCleanLineComment_SlashInString() {
	str input = "\"Text with \"just a string\"//\" in a string\"";
	str expect =  "\"Text with \"just a string\"//\" in a string\"";
	str actual = cleanLineComment(input);
	return assertEqual(expect, actual, "Assert failed");
}

test bool testCleanLineComment_SlashInString() {
	str input = "\"Text with \"just a string\"//\" in a string // commentaar";
	str expect =  "\"Text with \"just a string\"//\" in a string";
	str actual = cleanLineComment(input);
	return assertEqual(expect, actual, "Assert failed");
}

test bool testCleanLineComment_SlashInString() {
	str input = "\"//\"\"\"//\"\"\"\"";
	str expect =  "\"//\"\"\"";
	str actual = cleanLineComment(input);
	return assertEqual(expect, actual, "Assert failed");
}

test bool testCleanLineComment_SlashInString() {
	str input = "a //\"\"\"\"";
	str expect =  "a";
	str actual = cleanLineComment(input);
	return assertEqual(expect, actual, "Assert failed");
}

test bool testCleanLineComment_SlashInString() {
	str input = "a \"//\"";
	str expect =  "a \"//\"";
	str actual = cleanLineComment(input);
	return assertEqual(expect, actual, "Assert failed");
}

test bool testCleanLineComment_SlashInString() {
	str input = "a \"\"//\"";
	str expect =  "a \"\"";
	str actual = cleanLineComment(input);
	return assertEqual(expect, actual, "Assert failed");
}
