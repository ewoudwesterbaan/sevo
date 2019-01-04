module View

import vis::Figure;
import vis::Render;
import vis::KeySym;

import List;
import Set;
import Map;

import visualisation::PolyMetricTreeView;
import visualisation::PolyMetricTreeMapView;
import visualisation::widgets::Widgets;

import IO;

private loc project = |project://VisualisationTest/|;
//private loc project = |project://ComplexityTest/|;
//private loc project = |project://smallsql/|;
//private loc project = |project://DuplicationTest/|;
//private loc project = |project://JabberPoint/|;

private str projectName = "<project>"[11..-1];

// Start de visualisatie van metrics.
// Toont twee buttons, eentje voor elke view die we kennen.
public void visualizeMetrics() {
	// Twee buttons voor de verschillende views: Tree view resp. TreeMap view.
	Figure title = pageTitle("Polymetrische visualisatie van <projectName>");
	Figure descr = text(
		"Deze toepassing ondersteunt twee verschillende polymetrische views. Maak een keuze door\n" + 
		"op een van de onderstaande knoppen te klikken. Tijdens het gebruik kan op elk gewenst \n" + 
		"moment van view worden gewisseld."
	); 
	Figure treeViewButton = button(void(){showProjectTree();}, "Polymetric Tree");
	Figure treeMapViewButton = button(void(){showProjectTreeMap();}, "Polymetric TreeMap"); 
	render(grid([[title], [descr], [grid([[treeViewButton, treeMapViewButton]], gap(20))]], gap(20), vsize(300), hsize(400), resizable(false)));
}
