module tests::utils::UtilsTest

import utils::Utils;
import Boolean;
import IO;
import tests::utils::TestUtils;

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
