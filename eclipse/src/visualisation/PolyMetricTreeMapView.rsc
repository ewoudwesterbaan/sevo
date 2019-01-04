module visualisation::PolyMetricTreeMapView

import vis::Figure;
import vis::Render;
import vis::KeySym;

import List;
import Set;
import Map;

import visualisation::widgets::Widgets;

import IO;

// Tijdelijk. Hier moet de visualisatie mbv TreeMaps komen.
public void showProjectTreeMap() {
	Figure title = pageTitle("Under construction...");
	Figure descr = text(
		"Deze toepassing ondersteunt momenteen nog geen TreeMaps. Deze worden binnenkort gerealiseerd."
	); 
	render(grid([[title], [descr]], gap(20), vsize(300), hsize(400), resizable(false)));
}
