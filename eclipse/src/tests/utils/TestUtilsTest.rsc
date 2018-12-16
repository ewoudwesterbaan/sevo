module tests::utils::TestUtilsTest

import Boolean;
import IO;
import tests::utils::TestUtils;

// Test de methode tests::utils::TestUtils::assertEquals(str, str, str)
test bool testAssertEqual_EmptyStrings() {
	return assertEqual("", "", "Should be successful");
}

// Test de methode tests::utils::TestUtils::assertEquals(str, str, str)
test bool testAssertEqual_NonEmptyStrings() {
	return assertEqual("bla", "bla", "Should be successful");
}

// Test de methode tests::utils::TestUtils::assertEquals(str, str, str)
test bool testAssertEqual_StringFail() {
	return false == assertEqual("blabla", "bla", "** No worries! This test should fail **");
}

// Test de methode tests::utils::TestUtils::assertEquals(int, int, str)
test bool testAssertEqual_Int() {
	return assertEqual(1, 1, "Should be successful");
}

// Test de methode tests::utils::TestUtils::assertEquals(int, int, str)
test bool testAssertEqual_IntFail() {
	return false == assertEqual(1, 2, "** No worries! This test should fail **");
}
