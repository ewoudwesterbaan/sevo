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
// Laadt eerst het project, en toont dan het introductiescherm met uitleg.
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

	// Introscherm tonen
	Figure title = pageTitle("Polymetrische visualisatie van <projectInfo.projName>");
	Figure descr = text(
		"Deze toepassing toont een dashboard met een aantal panels. Het hoofdpanel toont een polymetrische\n" + 
		"visualisatie van het project <projectInfo.projName>. Op het hoogste niveau worden alle packages van\n" + 
		"de applicatie getoond. Het project en de packages worden gevisualiseerd als nodes in een boom. De\n" + 
		"kleur van een node is een indicatie van de complexity rating, en de grootte van een node zegt iets\n" + 
		"over het aantal lines of code. Door boven een package te hoveren met de muis, kan een popup worden\n" + 
		"geactiveerd met gedetaileerde informatie over de desbetreffende node. Door op een package te klikken\n" + 
		"kan worden ingezoomd: van het package worden alle klassen getoond, wederom in een boomstructuur, en met\n" + 
		"dezelfde kleur- en groottefuncties. Door op een klasse te klikken kan nog een niveau worden ingezoomd\n" + 
		"naar de methoden bij die klasse. Uitzoomen kan met shift-klik op de nodes, of door in het kruimelpad\n" + 
		"bovensaan het scherm te klikken.\n\n" + 
		"De subpanels tonen aanvullende informatie die is gerelateerd aan het niveau waarop is ingezoomd. TODO...",
		fontSize(14)
	); 
	Figure treeViewButton = button(void(){showProjectTree(projectInfo);}, "Naar dashboard");
	Figure buttonGrid = buttonGrid([treeViewButton]);
	render(page(title, descr, buttonGrid));
}
