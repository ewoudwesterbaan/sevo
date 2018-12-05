module Main

import Volume;
import Unitsize;
import Utils;

public void main() {
	loc project = |project://smallsql/|;
	LocationMetrics volume = volumeMetrics(project);
	LocationMetrics unitSize = unitSizeMetrics(project);
}