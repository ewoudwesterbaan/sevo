module tests::visualisation::utils::VisUtilsTest

import tests::utils::TestUtils;
import visualisation::utils::VisUtils;
import Boolean;
import List;
import Set;

// Test de methode visualisation::utils::VisUtils::getBoxplotParams
test bool testgetBoxplotParamsOdd() {
	tuple[num startRange, num q1, num median, num q3, num endRange] expected = <1.0, 2.5, 8.0, 50.0, 51.0>;
	tuple[num startRange, num q1, num median, num q3, num endRange] actual = getBoxplotParams([51, 8, 49, 4, 1]);
	bool result = assertEqual(expected.startRange, actual.startRange, "StartRange niet correct.");
	result = result && assertEqual(expected.q1, actual.q1, "Eerste kwartiel (q1) niet correct.");
	result = result && assertEqual(expected.median, actual.median, "Mediaan niet correct.");
	result = result && assertEqual(expected.q3, actual.q3, "Derde kwartiel (q3) niet correct.");
	result = result && assertEqual(expected.endRange, actual.endRange, "EndRange niet correct.");
	return result;
}

// Test de methode visualisation::utils::VisUtils::getBoxplotParams
test bool testgetBoxplotParamsEven() {
	tuple[num startRange, num q1, num median, num q3, num endRange] expected = <4.0, 8.0, 10.0, 49.0, 51.0>;
	tuple[num startRange, num q1, num median, num q3, num endRange] actual = getBoxplotParams([51, 8, 49, 4, 9, 11]);
	bool result = assertEqual(expected.startRange, actual.startRange, "StartRange niet correct.");
	result = result && assertEqual(expected.q1, actual.q1, "Eerste kwartiel (q1) niet correct.");
	result = result && assertEqual(expected.median, actual.median, "Mediaan niet correct.");
	result = result && assertEqual(expected.q3, actual.q3, "Derde kwartiel (q3) niet correct.");
	result = result && assertEqual(expected.endRange, actual.endRange, "EndRange niet correct.");
	return result;
}

// Test de methode visualisation::utils::VisUtils::getBoxplotParams
test bool testgetBoxplotParamsSingleValue() {
	tuple[num startRange, num q1, num median, num q3, num endRange] expected = <4.0, 4.0, 4.0, 4.0, 4.0>;
	tuple[num startRange, num q1, num median, num q3, num endRange] actual = getBoxplotParams([4]);
	bool result = assertEqual(expected.startRange, actual.startRange, "StartRange niet correct.");
	result = result && assertEqual(expected.q1, actual.q1, "Eerste kwartiel (q1) niet correct.");
	result = result && assertEqual(expected.median, actual.median, "Mediaan niet correct.");
	result = result && assertEqual(expected.q3, actual.q3, "Derde kwartiel (q3) niet correct.");
	result = result && assertEqual(expected.endRange, actual.endRange, "EndRange niet correct.");
	return result;
}

// Test de methode visualisation::utils::VisUtils::getBoxplotParams
test bool testgetBoxplotParamsEmptyList() {
	tuple[num startRange, num q1, num median, num q3, num endRange] expected = <0.0, 0.0, 0.0, 0.0, 0.0>;
	tuple[num startRange, num q1, num median, num q3, num endRange] actual = getBoxplotParams([]);
	bool result = assertEqual(expected.startRange, actual.startRange, "StartRange niet correct.");
	result = result && assertEqual(expected.q1, actual.q1, "Eerste kwartiel (q1) niet correct.");
	result = result && assertEqual(expected.median, actual.median, "Mediaan niet correct.");
	result = result && assertEqual(expected.q3, actual.q3, "Derde kwartiel (q3) niet correct.");
	result = result && assertEqual(expected.endRange, actual.endRange, "EndRange niet correct.");
	return result;
}
