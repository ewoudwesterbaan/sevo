module metrics::Complexity

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

public int cyclomaticComplexity(loc project) {
	M3 model = createM3FromEclipseProject(project);
	// TODO
	return 1; 
}