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
import visualisation::DataTypes;

import IO;

private ProjectInfoTuple projectInfo;

public void showProjectTreeMap(ProjectInfoTuple projInfo) {
	// Eenmalig vullen van de private attributen
	projectInfo = projInfo;
	PkgInfoMap pkgInfos = projectInfo.pkgInfos;
	
	// Tijdelijk. Hier moet de visualisatie mbv TreeMaps komen.
	Figure descr = text(
		"Deze toepassing ondersteunt momenteen nog geen TreeMaps. Deze worden binnenkort gerealiseerd."
	); 
	
	renderPage(descr);
}

// Rendert een pagina.
private void renderPage(Figure tree) {
	Figure title = pageTitle("<projectInfo.projName> - Polymetric TreeMap");
	Figure homeButton = button(void(){visualizeMetrics();}, "Home");
	Figure treeMapViewButton = button(void(){showProjectTree(projectInfo);}, "Switch naar Tree"); 
	Figure buttonGrid = buttonGrid([homeButton, treeMapViewButton]);
	render(page(title, tree, buttonGrid));
}