module visualisation::PolyMetricTreeMapView

import vis::Figure;
import vis::Render;
import vis::KeySym;

import List;
import Set;
import Map;

import View;
import visualisation::PolyMetricTreeView;
import visualisation::widgets::Widgets;
import visualisation::utils::VisUtils;

import IO;

private loc project;
private str projectName;
private PkgInfoMap pkgInfo;

public void showProjectTreeMap(loc proj) {
	// Eenmalig vullen van de private attributen
	project = proj;
	projectName = "<project>"[11..-1];
	pkgInfo = getPkgInfoMapFromClassInfoMap(getClassInfo(project));
	
	// Tijdelijk. Hier moet de visualisatie mbv TreeMaps komen.
	Figure descr = text(
		"Deze toepassing ondersteunt momenteen nog geen TreeMaps. Deze worden binnenkort gerealiseerd."
	); 
	
	renderPage(descr);
}

// Rendert een pagina.
private void renderPage(Figure tree) {
	Figure title = pageTitle("<projectName> - Polymetric TreeMap");
	Figure homeButton = button(void(){visualizeMetrics();}, "Home");
	Figure treeMapViewButton = button(void(){showProjectTree(project);}, "Switch naar Tree"); 
	Figure buttonGrid = grid([[homeButton, treeMapViewButton]], gap(20));
	render(grid([[title], [tree], [buttonGrid]], gap(20), vsize(300), hsize(400), resizable(false)));
}