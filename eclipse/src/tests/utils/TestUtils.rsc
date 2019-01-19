module tests::utils::TestUtils

import Boolean;
import List;
import Set;
import IO;

// Bevat een aantal utility methoden ten behoeve van de testmodules.

// Controleert of twee integers gelijk zijn, en drukt een foutmelding af wanneer dit niet het geval is.
//   expected - de verwachte waarde
//   actual - de feitelijke waarde
//   msg - de foutmelding die moet worden afgedrukt wanneer de controle faalt
public bool assertEqual(int expected, int actual, str msg) {
	msg = /.*\./ := msg ? msg : msg + ".";
    if (expected != actual) {
        println("Test failed. Msg: <msg> Expected = <expected>, actual = <actual>");
    }
    return expected == actual;
}

// Controleert of twee reals gelijk zijn, en drukt een foutmelding af wanneer dit niet het geval is.
//   expected - de verwachte waarde
//   actual - de feitelijke waarde
//   msg - de foutmelding die moet worden afgedrukt wanneer de controle faalt
public bool assertEqual(real expected, real actual, str msg) {
	msg = /.*\./ := msg ? msg : msg + ".";
    if (expected != actual) {
        println("Test failed. Msg: <msg> Expected = <expected>, actual = <actual>");
    }
    return expected == actual;
}

// Controleert of twee nums gelijk zijn, en drukt een foutmelding af wanneer dit niet het geval is.
//   expected - de verwachte waarde
//   actual - de feitelijke waarde
//   msg - de foutmelding die moet worden afgedrukt wanneer de controle faalt
public bool assertEqual(num expected, num actual, str msg) {
	msg = /.*\./ := msg ? msg : msg + ".";
    if (expected != actual) {
        println("Test failed. Msg: <msg> Expected = <expected>, actual = <actual>");
    }
    return expected == actual;
}

// Controleert of twee strings gelijk zijn, en drukt een foutmelding af wanneer dit niet het geval is.
//   expected - de verwachte waarde
//   actual - de feitelijke waarde
//   msg - de foutmelding die moet worden afgedrukt wanneer de controle faalt
public bool assertEqual(str expected, str actual, str msg) {
	msg = /.*\./ := msg ? msg : msg + ".";
    if (expected != actual) {
        println("Test failed. Msg: <msg> Expected = <expected>, actual = <actual>");
    }
    return expected == actual;
}