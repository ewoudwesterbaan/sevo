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
	println("Calculating duplication");
	methodsForDuplication = { <m, cod> | <m, tot, com, cod> <- unitSize, cod >= 6 }; 
	duplication(methodsForDuplication);
	
	println("Program ended succesfully");
}