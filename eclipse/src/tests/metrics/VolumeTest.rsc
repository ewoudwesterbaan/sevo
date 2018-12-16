module tests::metrics::VolumeTest

import tests::utils::TestUtils;
import utils::Utils;
import metrics::Volume;
import Boolean;
import List;
import Set;

// De testdata voor deze testmodule bevindt zich in het complexity project
private loc project = |project://ComplexityTest/|;

// Test de methode metrics::Volume::volumeMetrics
// Totaal aantal regels (inclusief lege regels tussen en binnen de methodes
test bool testVolumeTotalLinesMetrics() {
	int expected = 208;
	int actual = sum(volumeMetrics(project).totalLines);
	return assertEqual(expected, actual, "Onverwacht aantal total lines in project.");
}

// Test de methode metrics::Volume::volumeMetrics
// Totaal commentaarregels
test bool testVolumeCommentLinesMetrics() {
	int expected = 6;
	int actual = sum(volumeMetrics(project).commentLines);
	return assertEqual(expected, actual, "Onverwacht aantal comment lines in project.");
}

// Test de methode metrics::Volume::volumeMetrics
// Totaal aantal echte coderegels
test bool testVolumeCodeLinesMetrics() {
	int expected = 185;
	int actual = sum(volumeMetrics(project).codeLines);
	return assertEqual(expected, actual, "Onverwacht aantal code lines in project.");
}