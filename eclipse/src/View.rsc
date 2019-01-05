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

import visualisation::utils::VisUtils;

import IO;

private loc project = |project://VisualisationTest/|;
//private loc project = |project://ComplexityTest/|;
//private loc project = |project://smallsql/|;
//private loc project = |project://DuplicationTest/|;
//private loc project = |project://JabberPoint/|;

// Start de visualisatie van metrics.
// Laadt eerst het project.
// Toont dan een scherm met twee buttons, eentje voor elke view die we kennen.
public void visualizeMetrics() {
	// Data inladen...
	Figure loading = pageTitle("Project Laden ...");
	render(grid([[loading]], gap(20), vsize(300), hsize(400), resizable(false)));
	ProjectInfoTuple projectInfo = getProjectInfoTupleFromPkgInfoMap(project, getPkgInfoMapFromClassInfoMap(getClassInfo(project)));

	// Twee buttons voor de verschillende views: Tree view resp. TreeMap view.
	Figure title = pageTitle("Polymetrische visualisatie van <projectInfo.projName>");
	Figure descr = text(
		"Deze toepassing ondersteunt twee verschillende polymetrische views. Maak een keuze door\n" + 
		"op een van de onderstaande knoppen te klikken. Tijdens het gebruik kan op elk gewenst \n" + 
		"moment van view worden gewisseld."
	); 
	Figure treeViewButton = button(void(){showProjectTree(projectInfo);}, "Polymetric Tree");
	Figure treeMapViewButton = button(void(){showProjectTreeMap(projectInfo);}, "Polymetric TreeMap");
	Figure buttonGrid = grid([[treeViewButton, treeMapViewButton]], gap(20)); 
	render(grid([[title], [descr], [buttonGrid]], gap(20), vsize(300), hsize(400), resizable(false)));
}
