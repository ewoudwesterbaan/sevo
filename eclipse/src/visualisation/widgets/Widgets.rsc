module visualisation::widgets::Widgets

import vis::Figure;
import vis::Render;
import vis::KeySym;

import util::Math;
import List;

import visualisation::utils::VisUtils;

import IO;

private Color defaultFontColor = rgb(70, 70, 70);
private Color defaultLineColor = color("dimgray");
private Color defaultFillColor = color("white");

private Color popupShadowColor = color("black", 0.1);
private Color popupLineColor = color("burlywood");
private Color popupFillColor = color("blanchedalmond");
private Color popupFontColor = rgb(30, 30, 30);

private Color headerFillColor = color("aliceblue");
private Color headerFontColor = color("steelblue");
private Color headerLineColor = defaultFillColor;
private int headerFontSize = 25;

private Color subHeaderFillColor = headerFillColor;
private Color subHeaderFontColor = headerFontColor;
private Color subHeaderLineColor = headerLineColor;
private int subHeaderFontSize = 14;

private Color footerFillColor = headerFillColor;
private Color footerFontColor = headerFontColor;
private Color footerLineColor = headerLineColor;

private Color buttonFillColor = headerFillColor;
private Color buttonFontColor = headerFontColor;
private Color buttonLineColor = buttonFontColor;

private Color breadcrumLineColor = defaultFillColor;
private Color breadcrumFillColor = color("whitesmoke");
private Color breadcrumSelectableFontColor = headerFontColor;

private Color subGridLineColor = breadcrumLineColor;
private Color subGridFillColor = breadcrumFillColor;
private int subGridFontSize = 11;
private int subPanelSize = 240;

private Color boxPlotFillColor = color("lightsteelblue");
private int boxplotFontSize = 12;

// Geeft een pagina terug met een titel, een kruimelpad, en inhoud.
public Figure page(Figure pageTitle, Figure breadcrumPath, Figure content) {
	return box(
		vcat([
			// Titel en kruimelpad bovenaan de pagina
			box(vcat([pageTitle, breadcrumPath]), vresizable(false)),
			// Content 
			box(grid([[content]], std(lineColor(defaultLineColor))), vresizable(true))
		]),
		std(lineColor(defaultFillColor)),
		std(fontColor(defaultFontColor)),
		resizable(true)
	);
}

// Toont een popup met een tooltip tekst.
//   - gebruik bijv.: box(size(50),fillColor("red"), popup("Hello"))
public FProperty popup(str msg) {
	return mouseOver(box(text(msg), 
		shadow(true), shadowColor(popupShadowColor), shadowPos(5, 5), 
		lineColor(popupLineColor), fillColor(popupFillColor), fontColor(popupFontColor),
		right(), top(),
		gap(10),
		resizable(false))
	);
}

// Een paginatitel.
public Figure pageTitle(str titleText){
	return box(
		text(
			titleText, 
			fontColor(headerFontColor),
			fontBold(true),
			fontSize(headerFontSize),
			resizable(false),
			vsize(70)
		),
		fillColor(headerFillColor),
		lineColor(headerLineColor),
		vsize(70),
		vresizable(false)
	);
}

// Een subtitel.
public Figure subTitle(str titleText){
	return box(
		text(
			titleText, 
			fontColor(subHeaderFontColor),
			fontBold(true),
			fontSize(subHeaderFontSize),
			resizable(false),
			vsize(20)
		),
		fillColor(subHeaderFillColor),
		lineColor(subHeaderLineColor),
		vsize(20),
		vresizable(false)
	);
}

// Een text met een kleurindicatie in een cirkel ernaast.
public Figure legendText(str theText, Color theColor) {
	return box(
		hcat([
			space(hresizable(true)), // Filler
			text(theText), 
			ellipse(width(10), height(10), resizable(false), fillColor(theColor))
		], gap(10)),
		lineColor(subGridFillColor),
		hsize(round(subPanelSize*0.6)),
		resizable(false)
	);
}

// Een breadcrum path, bestaande uit de opgegeven breadcrum elementen.
public Figure breadcrumPath(list[Figure] breadcrumElements) {
	return box(
		hcat(breadcrumElements, ialign(0.0), resizable(false)), 
		lineColor(breadcrumLineColor),
		fillColor(breadcrumFillColor),
		vsize(30),
		vresizable(false)
	);
}

// Een klikbaar breadcrum element
public Figure breadcrumElement(void () vcallback, str elmText){
	return text(
		" / <elmText>", 
		handleBreadcrumClick(vcallback), 
		fontColor(breadcrumSelectableFontColor),
		fontSize(14),
		resizable(false),
		hsize(1),
		vsize(22)
	);
}

// Een niet klikbaar breadcrum element
public Figure breadcrumElement(str elmText){
	return text(
		" / <elmText>", 
		fontSize(14),
		resizable(false),
		ialign(0.0),
		hsize(1),
		vsize(22)
	);
}

// Handelt een click event af op een breadcrum element 
private FProperty handleBreadcrumClick(void () vcallback) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) return false;
		if (modifiers[modCtrl()]) return false;
		if (modifiers[modAlt()]) return false;
		vcallback();
		return true;
	});
}

// Een dasboard met meerdere panels/grids
//   - hoofdgedeelte voor een tree view o.i.d.
//   - vier subpanels voor stacked diagrams, boxplots, o.i.d.
public Figure dashBoard(Figure mainContent, Figure topLeftContent, Figure bottomLeftContent, Figure topRightContent, Figure bottomRightContent) {
	return box(
		hcat([
			// Hoofdgedeelte van het dashboard
			box(grid([[mainContent]]
			, std(lineColor(defaultLineColor)))
			, lineColor(defaultFillColor)
			, resizable(true)), 
			
			// Vier subpanels aan de rechterkant van het dashboard 
			box(
				vcat (
					[
						box(grid([[topLeftContent]], std(lineColor(defaultLineColor)), std(fontSize(subGridFontSize)))
						, size(subPanelSize)
						, resizable(false)
						), 
						box(grid([[bottomLeftContent]], std(lineColor(defaultLineColor)), std(fontSize(subGridFontSize)))
						, size(subPanelSize)
						, resizable(false)
						),
						box(grid([[]]), resizable(true)) // Filler
					]
					, std(fillColor(subGridFillColor))
					, lineColor(subGridLineColor)
				)
				, width(subPanelSize)
				, hresizable(false)
			),	
			box(
				vcat (
					[
						box(grid([[topRightContent]], std(lineColor(defaultLineColor)), std(fontSize(subGridFontSize)))
						, size(subPanelSize)
						, resizable(false)
						), 
						box(grid([[bottomRightContent]], std(lineColor(defaultLineColor)), std(fontSize(subGridFontSize)))
						, size(subPanelSize)
						, resizable(false)
						),
						box(grid([[]]), resizable(true)) // Filler
					]
					, std(fillColor(subGridFillColor))
					, lineColor(subGridLineColor)
				)
				, width(subPanelSize)
				, hresizable(false)
			)	
		]),
		std(lineColor(defaultFillColor)),
		std(fontColor(defaultFontColor)),
		resizable(true)
	);
}

// Een stacked diagram voor bijv. complexity rates en unit sizes
//   - title: de titel boven het diagram
//   - values: de (relatieve) waarden waarop het diagram is gebaseerd
//   - colors: de verschillende kleuren; deze corresponderen met de waarden en de infoTexts
//   - infoTexts: de legenda-teksten, per waarde een toelichting/duiding wat de waarde inhoudt
// De lijsten met waarden, kleuren en infoTexts moetn even lang zijn, omdat ze met elkaar 
// corresponderen. 
public Figure stackedDiagram(str title, list[int] values, list[Color] colors, list[str] infoTexts) {
	// Afmetingen
	int diagramWidth = 30;
	int textWidth = 70;
	num numHeight = 120.0;
	int intHeight = round(numHeight);
	num heightRatio = numHeight / sum(values);
	
	// Diagram
	list[int] heights = [round(heightRatio * v) | v <- values];
	list[Figure] boxes = [];
	for (i <- [0..size(heights)]) {
		boxes += box(space(), fillColor(colors[i]), size(diagramWidth, heights[i]), resizable(false));
	}

	// Tekst
	list[Figure] details = [space(size(1), hresizable(false))];
	for (i <- [0..size(infoTexts)]) {
		details += legendText(infoTexts[i], colors[i]);
	}
	details += space(size(1), hresizable(false));
	
	// Samenvoegen en resultaat retourneren
	return vcat([
		subTitle(title), 
		hcat([
			vcat(details, size(textWidth, intHeight)), 
			box(vcat(boxes), size(diagramWidth, intHeight), resizable(false))
		])
	]);
}

// Een boxplot voor een serie waarden.
//   - title: een titeltekst die boven het boxplot moet worden getoond 
//   - values: een serie waarden
//   - props: properties voor het figuur (optioneel)
public Figure boxPlot(str title, list[int] values, FProperty props...) {
	params = getBoxplotParams(values);
	if (params.endRange == params.startRange) return flatBox(title, params.endRange, props);
	return boxPlot(title, params.startRange, params.q1, params.median, params.q3, params.endRange, props);
}

// Een "boxplot" van een lijst met maar 1 waarde. Dit levert een lijn op.
private Figure flatBox(str title, num val, FProperty proprs...) {
	// Afmetingen
	int width = 50;
	int height = 120;
	
	Figure bPlot = vcat([
			space(resizable(true)), 
			box(size(width, 1), resizable(false)), 
			space(resizable(true)) 
		], 
		popup("Boxplot <title>.\nStartwaarde = <val>, \n1e kwartiel = <val>, \nMediaan = <val>, \n3e kwartiel = <val>, \nEindwaarde = <val>."),
		size(width, height),
		resizable(false)
	);

	return vcat([
		subTitle(title), 
		space(resizable(true)), // Filler
		hcat([text("<val> .", ialign(1.0), fontSize(boxplotFontSize)), bPlot], 
		hgap(10), 
		size(1), 
		resizable(false)),
		space(resizable(true)) // Filler
	]);
}

// Een boxplot op basis van een aantal parameters.
//   - title: een titeltekst die boven het boxplot moet worden getoond 
//   - startRange: de laagste waarde
//   - q1: het eerste kwartiel
//   - median: de mediaan
//   - q3: het derde kwartiel
//   - endRange: de hoogste waarde
//   - props: properties voor het figuur (optioneel)
private Figure boxPlot(str title, num startRange, num q1, num median, num q3, num endRange, FProperty props...) {	
 	// Ratio's berekenen
	num ratio = (endRange - startRange);
 	num ratio_endRange_q3 = percent((endRange - q3), ratio);
 	num ratio_q3_median = percent((q3 - median), ratio);
 	num ratio_median_q1 = percent((median - q1), ratio);
 	num ratio_q1_startRange = percent((q1 - startRange), ratio);
 	
	// Afmetingen
	int width = 50;
	int height = 120;
	int axisWidth = 25;
	int axisHeight = height + 30;
	
	int h1 = round(height * ratio_endRange_q3 / 100);
	int h2 = round(height * ratio_q3_median / 100);
	int h3 = round(height * ratio_median_q1 / 100);
	int h4 = round(height * ratio_q1_startRange / 100);

	// Boxplot zelf
	Figure bPlot = vcat(
		[
			// Filler
			space(size(width, (axisHeight - height) / 2), resizable(false)), 
			// Echte boxplot onderdelen
			box(size(width, 1), resizable(false)), 
			box(size(1, h1), resizable(false), lineStyle("dash")), 
			box(size(width, h2), resizable(false), fillColor(boxPlotFillColor)), 
			box(size(width, h3), resizable(false), fillColor(boxPlotFillColor)), 
			box(size(1, h4), resizable(false), lineStyle("dash")), 
			box(size(width, 1), resizable(false)),
			// Filler
			space(size(width, (axisHeight - height) / 2), resizable(false)) 
		], 
		popup("Boxplot <title>.\nStartwaarde = <startRange>, \n1e kwartiel = <q1>, \nMediaan = <median>, \n3e kwartiel = <q3>, \nEindwaarde = <endRange>."),
		size(width, height),
		resizable(false)
	);
	
	// Lineaal
	Figure axisGrid = box(
		text("<endRange> .\n.\n.\n.\n.\n.\n.\n.\n.\n<startRange> .", ialign(1.0), fontSize(boxplotFontSize)), 
		size(axisWidth, height), 
		resizable(false),
		lineColor(subGridFillColor)
	);
	
	return vcat([
		subTitle(title), 
		space(resizable(true)), // Filler
		hcat([axisGrid, bPlot], 
		hgap(10), 
		size(1), 
		resizable(false)),
		space(resizable(true)) // Filler
	]);
}
