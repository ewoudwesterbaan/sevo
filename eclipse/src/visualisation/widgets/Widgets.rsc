module visualisation::widgets::Widgets

import vis::Figure;
import vis::Render;
import vis::KeySym;

import util::Math;
import List;
import analysis::statistics::Descriptive;

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

private Color boxPlotFillColor = color("lightsteelblue");
private int boxplotFontSize = 12;

// Geeft een pagina terug met een titel, een kruimelpad, en inhoud (dashboard met een tree en een aantal subgrids).
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

// Een button met een label en een buttontekst.
//  - btnText: de tekst op de button,
//  - vcallback: de methode die moet worden aangeroepen wanneer er op de button wordt geklikt.
public Figure button(void () vcallback, str btnText){
	return button(
		btnText, 
		vcallback, 
		fillColor(buttonFillColor), 
		lineColor(buttonLineColor), 
		fontColor(buttonFontColor),
		fontBold(true),
		resizable(false),
		vsize(35),
		hsize(150)
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

// Een breadcrum figure.
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

// Toont een dasboard met meerdere panels/grids
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
						, size(200)
						, resizable(false)
						), 
						box(grid([[bottomLeftContent]], std(lineColor(defaultLineColor)), std(fontSize(subGridFontSize)))
						, size(200)
						, resizable(false)
						),
						box(grid([[]]), resizable(true)) // Filler
					]
					, std(fillColor(subGridFillColor))
					, lineColor(subGridLineColor)
				)
				, width(200)
				, hresizable(false)
			),	
			box(
				vcat (
					[
						box(grid([[topRightContent]], std(lineColor(defaultLineColor)), std(fontSize(subGridFontSize)))
						, size(200)
						, resizable(false)
						), 
						box(grid([[bottomRightContent]], std(lineColor(defaultLineColor)), std(fontSize(subGridFontSize)))
						, size(200)
						, resizable(false)
						),
						box(grid([[]]), resizable(true)) // Filler
					]
					, std(fillColor(subGridFillColor))
					, lineColor(subGridLineColor)
				)
				, width(200)
				, hresizable(false)
			)	
		]),
		std(lineColor(defaultFillColor)),
		std(fontColor(defaultFontColor)),
		resizable(true)
	);
}

// Een stacked diagram voor complexity rates
public Figure stackedDiagram(str title, list[int] values, list[Color] colors, list[str] infoTexts) {
	// Afmetingen
	int diagramWidth = 30;
	int textWidth = 70;
	num numHeight = 120.0;
	int intHeight = round(numHeight);
	num heightRatio = numHeight / sum(values);
	
	list[int] heights = [round(heightRatio * v) | v <- values];
	list[Figure] boxes = [];
	for (i <- [0..size(heights)]) {
		boxes += box(space(), fillColor(colors[i]), size(diagramWidth, heights[i]), resizable(false));
	}

	str details = "";	
	for (t <- infoTexts) {
		details += "<t>\n\n";
	}
	
	return vcat([
		subTitle(title), 
		hcat([
			vcat([text(details, ialign(1.0))], size(diagramWidth, intHeight)), 
			box(vcat(boxes), size(diagramWidth, intHeight), resizable(false))
		])
	]);
}

// Een boxplot
public Figure boxPlot(str title, list[int] values, FProperty props...) {
	num median = median(values);
	num q1 = percentile(values, 25);
	num q3 = percentile(values, 75);
	num qr = q3 - q1;
	num minimum = q1 - (1.5 * qr);
	num maximum = q3 + (1.5 * qr);
	num startRange = analysis::statistics::Descriptive::min(values);
	num endRange = analysis::statistics::Descriptive::max(values);
	num mean = mean(values);
	return boxPlot(title, startRange, minimum, q1, median, q3, maximum, endRange, mean, props);
}

public Figure boxPlot(str title, num startRange, num minimum, num q1, num median, num q3, num maximum, num endRange, num mean, FProperty props...) {	
 	// Ratio's berekenen
	num ratio = (endRange - startRange);
 	num ratio_endRange_maximum = percent((endRange - maximum), ratio);
 	num ratio_maximum_q3 = percent((maximum - q3), ratio);
 	num ratio_q3_median = percent((q3 - median), ratio);
 	num ratio_median_q1 = percent((median - q1), ratio);
 	num ratio_q1_minimum = percent((q1- minimum), ratio);
 	num ratio_minimum_startRange = percent((minimum - startRange), ratio);

	// Afmetingen
	int width = 50;
	int height = 120;
	int axisWidth = 25;
	int axisHeight = height + 40;
	
	int h1 = round(height * ratio_endRange_maximum / 100);
	int h2 = round(height * ratio_maximum_q3 / 100);
	int h3 = round(height * ratio_q3_median / 100);
	int h4 = round(height * ratio_median_q1 / 100);
	int h5 = round(height * ratio_q1_minimum / 100);
	int h6 = round(height * ratio_minimum_startRange / 100);

	// Boxplot zelf
	Figure bPlot = vcat(
		[
			// Filler
			space(size(width, (axisHeight - height) / 2), resizable(false)), 
			// Echte boxplot onderdelen
			space(size(width, h1), resizable(false)),
			box(size(width, 1), resizable(false)), 
			box(size(1, h2), resizable(false), lineStyle("dash")), 
			box(size(width, h3), resizable(false), fillColor(boxPlotFillColor)), 
			box(size(width, h4), resizable(false), fillColor(boxPlotFillColor)), 
			box(size(1, h5), resizable(false), lineStyle("dash")), 
			box(size(width, 1), resizable(false)),
			space(size(width, h6), resizable(false))
		], 
		size(width, height),
		resizable(false)
	);
	
	// Lineaal
	Figure axisGrid = box(
		text(
			"<endRange> .\n.\n.\n.\n.\n.\n.\n.\n.\n<startRange> .", 
			ialign(1.0),
			fontSize(boxplotFontSize)
		), 
		size(axisWidth, height), 
		resizable(false),
		lineColor(subGridFillColor)
	);
	
	return vcat([
		subTitle(title), 
		hcat([
			axisGrid, 
			bPlot
		], 
		hgap(10), 
		size(1), 
		resizable(false))
	]);
}




