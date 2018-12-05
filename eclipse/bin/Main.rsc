module Main

import utils::Utils;
import metrics::Volume;
import metrics::UnitSize;
import metrics::Duplication;
import IO;

public void main() {
	loc project = |project://smallsql/|;
	println("Calculating volume");
	RelLinesOfCode volume = volumeMetrics(project);
	println("Calculating unitsize");
	RelLinesOfCode unitSize = unitSizeMetrics(project);
	
	methodsForDuplication = { <m, cod> | <m, tot, com, cod> <- unitSize, code >= 6 }; 
	duplication(methodsForDuplication);
	
	println("Program ended succesfully");
}