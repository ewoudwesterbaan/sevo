module tests::metrics::ComplexityTest

import metrics::Complexity;
import Boolean;

// TODO: Voeg hier unittesten toe om de Complexity module te testen
test bool testDummy() {
    return true;
}

private int dummy() {
    return 0;
}

test bool testDummySuccess() {
    return dummy() == 0;
}

test bool testDummyFail() {
    return dummy() == 1;
}