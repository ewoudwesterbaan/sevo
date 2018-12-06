module metrics::Complexity

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import Boolean;

public int cyclomaticComplexity(loc project) {
	M3 model = createM3FromEclipseProject(project);
	// TODO
	return 1; 
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