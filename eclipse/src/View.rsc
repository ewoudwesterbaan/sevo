module View

import vis::Figure;
import vis::Render;
import vis::KeySym;

import List;
import Set;
import Map;

import visualisation::PolyMetricTreeView;
import visualisation::widgets::Widgets;
import visualisation::visData::DataTypes;
import visualisation::visData::Cache;
import visualisation::utils::VisUtils;

import IO;

private loc project = |project://VisualisationTest/|;
//private loc project = |project://ComplexityTest/|;
//private loc project = |project://smallsql/|;
//private loc project = |project://DuplicationTest/|;
//private loc project = |project://JabberPoint/|;

// Start de visualisatie van metrics.
// Laadt eerst het project, en toont dan het dashboard.
public void visualizeMetrics() {
	// Data inladen...
	Figure loading = text (
		"Project Laden ...",
		fontColor(color("steelblue")),
		fontBold(true),
		fontSize(25),
		resizable(false),
		vsize(70)
	);
	render(grid([[loading]], gap(20), vsize(300), hsize(400), resizable(false)));
	ProjectInfoTuple projectInfo = readProject(project);

	// Dashboard tonen (polymetric tree view)
	showProjectTree(projectInfo);
}
