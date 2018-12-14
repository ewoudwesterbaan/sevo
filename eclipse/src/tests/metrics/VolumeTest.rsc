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
test bool testVolumeMetrics() {
	int expectedLOC = 187;
	int actualLOC = sum(volumeMetrics(project).codeLines);
	return assertEqual(expectedLOC, actualLOC, "Onverwacht aantal LOC in project.");
}