module tests::utils::UtilsTest

import utils::Utils;
import Boolean;
import IO;
import tests::utils::TestUtils;

test bool testCompareLocation_GreaterThanByPosition() {
	loc a = |project://example-project/src/HelloWorld.java|(0,1,<22,3>,<24,5>);
	loc b = |project://example-project/src/HelloWorld.java|(0,1,<12,3>,<14,5>);
	return comparePhysicalLocations(a, b) > 0;
}

test bool testCompareLocation_GreaterThanByClassName() {
	loc a = |project://example-project/src/HelloWorld.java|(0,1,<22,3>,<24,5>);
	loc b = |project://example-project/src/HalloWereld.java|(0,1,<22,3>,<24,5>);
	return comparePhysicalLocations(a, b) > 0;
}

test bool testCompareLocation_LessThanByPosition() {
	loc a = |project://example-project/src/HelloWorld.java|(0,1,<12,3>,<14,5>);
	loc b = |project://example-project/src/HelloWorld.java|(0,1,<22,3>,<24,5>);
	return comparePhysicalLocations(a, b) < 0;
}

test bool testCompareLocation_LessThanByClassName() {
	loc a = |project://example-project/src/HalloWorld.java|(0,1,<22,3>,<24,5>);
	loc b = |project://example-project/src/HelloWereld.java|(0,1,<22,3>,<24,5>);
	return comparePhysicalLocations(a, b) < 0;
}

test bool testCompareLocation_Equal() {
	loc a = |project://example-project/src/HelloWorld.java|(0,1,<22,3>,<24,5>);
	loc b = |project://example-project/src/HelloWorld.java|(0,1,<22,3>,<24,5>);
	return comparePhysicalLocations(a, b) == 0;
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
