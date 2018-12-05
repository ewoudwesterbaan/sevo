module Main

import utils::Utils;
import metrics::Volume;
import metrics::UnitSize;
import IO;

public void main() {
	loc project = |project://smallsql/|;
	println("Calculating volume");
	RelLinesOfCode volume = volumeMetrics(project);
	println("Calculating unitsize");
	RelLinesOfCode unitSize = unitSizeMetrics(project);
	
	println("Program ended succesfully");
}