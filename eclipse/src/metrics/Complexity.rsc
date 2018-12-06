module metrics::Complexity

import utils::Utils;
import lang::java::jdt::m3::Core;
import Boolean;

public RelComplexities cyclomaticComplexity(loc project) {
	M3 model = createM3FromEclipseProject(project);
	return {getUnitComplexity(m) | <c, m> <- getUnits(model)};
}

private TupComplexity getUnitComplexity(loc unit) {
	// TODO
	return <unit, 1>;
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