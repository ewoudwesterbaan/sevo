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

private Color footerFillColor = headerFillColor;
private Color footerFontColor = headerFontColor;
private Color footerLineColor = headerLineColor;

private Color buttonFillColor = headerFillColor;
private Color buttonFontColor = headerFontColor;
private Color buttonLineColor = buttonFontColor;

private Color breadcrumLineColor = defaultFillColor;
private Color breadcrumFillColor = color("whitesmoke");
private Color breadcrumSelectableFontColor = headerFontColor;

public Color subGridLineColor = breadcrumLineColor;
public Color subGridFillColor = breadcrumFillColor;

private Color boxPlotLineColor = color("black");

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
			fontSize(25),
			resizable(false),
			vsize(70)
		),
		fillColor(headerFillColor),
		lineColor(headerLineColor),
		vsize(70),
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

// Geeft een buttongrid terug met daarop de meegegeven buttons
public Figure buttonGrid(list[Figure] buttons) {
	return box(
		grid([buttons], gap(20), resizable(false), size(75, 75)), 
		fillColor(footerFillColor),
		lineColor(footerLineColor),
		vresizable(false)
	);
}

public Figure dashBoard(Figure mainContent, Figure topRightContent, Figure bottomRightContent) {
	return box(
		hcat([
			// Twee subpanels aan de linkerkant van het dashboard, gevolgd door een filler 
			box(
				vcat (
					[
						box(grid([[topRightContent]])
						, size(200)
						//, resizable(false)
						), 
						box(grid([[bottomRightContent]]), size(200)
						
						//, resizable(false)
						),
						box(grid([[]]), resizable(true)) // Filler
					],  
					std(fillColor(subGridFillColor))
					,std(lineColor(subGridLineColor))
				),
				width(200)
				,hresizable(false)
			),	

			// Hoofdgedeelte van het dashboard
			box(grid([[mainContent]]
			, std(lineColor(defaultLineColor)))
			, lineColor(defaultFillColor)
			, resizable(true)), 
			
			// Twee subpanels aan de rechterkant van het dashboard, gevolgd door een filler 
			box(
				vcat (
					[
						box(grid([[topRightContent]])
						, size(200)
						//, resizable(false)
						), 
						box(grid([[bottomRightContent]]), size(200)
						//, resizable(false)
						),
						box(grid([[]]), resizable(true)) // Filler
					],  
					std(fillColor(subGridFillColor))
					,std(lineColor(subGridLineColor))
				),
				width(200),
				hresizable(false)
			)	
		]),
		std(lineColor(defaultFillColor)),
		std(fontColor(defaultFontColor)),
		resizable(true)
	);
}

// Geeft een pagina terug met een titel, een kruimelpad, inhoud (tree of treemap), en een buttongrid.
public Figure page(Figure pageTitle, Figure breadcrumPath, Figure content, Figure buttonGrid) {
	return box(
		vcat([
			// Titel en kruimelpad bovenaan de pagina
			box(vcat([pageTitle, breadcrumPath]), vresizable(false)),
			// Content 
			box(grid([[content]], std(lineColor(defaultLineColor))), vresizable(true)),
			// Buttongrid onderaan de pagina
			box(buttonGrid, vresizable(false))
		]),
		std(lineColor(defaultFillColor)),
		std(fontColor(defaultFontColor)),
		resizable(true)
	);
}

// Geeft een pagina terug met een titel, inhoud (text, tree of treemap), en een buttongrid.
public Figure page(Figure pageTitle, Figure content, Figure buttonGrid) {
	return page(pageTitle, breadcrumPath([text("")]), content, buttonGrid);
}



// TODO --------------



public Figure boxPlot(list[int] values, FProperty props...) {
	num median = median(values);
	num q1 = percentile(values, 25);
	num q3 = percentile(values, 75);
	num qr = q3 - q1;
	num minimum = q1 - (1.5 * qr);
	num maximum = q3 + (1.5 * qr);
	num startRange = analysis::statistics::Descriptive::min(values);
	num endRange = analysis::statistics::Descriptive::max(values);
	num mean = mean(values);
	return boxPlot(startRange, minimum, q1, median, q3, maximum, endRange, mean, props);
}

private Figure boxPlot(num startRange, num minimum, num q1, num median, num q3, num maximum, num endRange, num mean, FProperty props...) {	
	num ratio = (endRange - startRange);
 	
 	// Ratio's berekenen
 	num ratio_endRange_maximum = percent((endRange - maximum), ratio) / 100.0;
 	num ratio_maximum_q3 = percent((maximum - q3), ratio) / 100.0;
 	num ratio_q3_median = percent((q3 - median), ratio) / 100.0;
 	num ratio_median_q1 = percent((median - q1), ratio) / 100.0;
 	num ratio_q1_minimum = percent((q1- minimum), ratio) / 100.0;
 	num ratio_minimum_startRange = percent((minimum - startRange), ratio) / 100.0;
 	
 	// Grid opbouwen
 
 	// Eventueel kunnen we hier nog outliers wegschrijven
 	row_endRange_maximum = [ box(vshrink(ratio_endRange_maximum), lineColor(subGridFillColor)) ];
	row_maximum_q3  = [ 
		grid(
			[
				[ box(fillColor(boxPlotLineColor), height(2), vresizable(false))
				, box(fillColor(boxPlotLineColor), height(2), width(2), resizable(false))
				, box(fillColor(boxPlotLineColor), height(2), vresizable(false)) 
				],
				[ box(lineColor(subGridFillColor))
				, box(lineColor(boxPlotLineColor), width(1), lineWidth(1), hresizable(false), lineStyle("dash"))
				, box(lineColor(subGridFillColor)) ]
			]
		, vshrink(ratio_maximum_q3), lineColor(boxPlotLineColor)) 
		];
    row_q3_median = [ 
    	grid (
    	[
    		[ box(lineColor(boxPlotLineColor)) ]
    		,[ box(height(1), vresizable(false), lineWidth(1), lineColor(boxPlotLineColor)) ] // Om de mediaanlijn wat dikker aan te zetten
    	], vshrink(ratio_q3_median), lineColor(boxPlotLineColor))
    ];
    row_median_q1 = [ box(vshrink(ratio_median_q1), lineColor(boxPlotLineColor)) ];

    row_q1_minimum = [ 
    	grid(
			[
				[ 
				  box(lineColor(boxPlotLineColor), height(1), vresizable(false))
				, box(lineColor(boxPlotLineColor), height(1), width(2), resizable(false))
				, box(lineColor(boxPlotLineColor), height(1), vresizable(false)) 
				],
				[ 
				  box(lineColor(subGridFillColor))
				, box(lineColor(boxPlotLineColor), width(1), lineWidth(1), hresizable(false), lineStyle("dash"))
				, box(lineColor(subGridFillColor)) 
				],
				[ 
				  box(fillColor(boxPlotLineColor), height(2), vresizable(false))
				, box(fillColor(boxPlotLineColor), height(2), width(2), resizable(false))
				, box(fillColor(boxPlotLineColor), height(2), vresizable(false)) 
				]
			]
		, vshrink(ratio_q1_minimum)
		)
		];
	// Eventueel kunnen we hier nog outliers wegschrijven
    row_minimum_startRange = [ box(lineColor(subGridFillColor), vshrink(ratio_minimum_startRange)) ];
    
    // Uiteindelijke boxplot opbouwen vanuit de rijen 
	Figure boxPlotContent = box(
		grid(
		[
		  row_endRange_maximum
		, row_maximum_q3
		, row_q3_median
		, row_median_q1
		, row_q1_minimum
		, row_minimum_startRange
		]
		));

	
	// TODO: Dit ongelooflijke lelijke stuk ombouwen. Dit kan echt niet...!!!!
	
	
	
	Figure axisGrid = box (grid(
		[ 
			[ box(text("<endRange>", top()), height(5),lineColor(subGridFillColor)), box(height(1), width(5), top(), resizable(false), lineColor(boxPlotLineColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(height(1), width(5), center(), resizable(false), lineColor(boxPlotLineColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(width(5),lineColor(subGridFillColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(height(1), width(5), center(), resizable(false), lineColor(boxPlotLineColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(width(5),lineColor(subGridFillColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(height(1), width(5), center(), resizable(false), lineColor(boxPlotLineColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(width(5),lineColor(subGridFillColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(height(1), width(5), center(), resizable(false), lineColor(boxPlotLineColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(width(5),lineColor(subGridFillColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(height(1), width(5), center(), resizable(false), lineColor(boxPlotLineColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(width(5),lineColor(subGridFillColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(height(1), width(5), center(), resizable(false), lineColor(boxPlotLineColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(width(5),lineColor(subGridFillColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(height(1), width(5), center(), resizable(false), lineColor(boxPlotLineColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(width(5),lineColor(subGridFillColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(height(1), width(5), center(), resizable(false), lineColor(boxPlotLineColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(width(5),lineColor(subGridFillColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(height(1), width(5), center(), resizable(false), lineColor(boxPlotLineColor)) ]
		  , [ box(top(), resizable(false),lineColor(subGridFillColor)), box(width(5),lineColor(subGridFillColor)) ]
		  , [ box(text("<startRange>"), bottom(), resizable(false),lineColor(subGridFillColor)), box(height(1), width(5), bottom(), resizable(false), lineColor(boxPlotLineColor)) ] 
		], hgap(10)), width(20), hresizable(false),lineColor(subGridFillColor)
		);
	
	Figure boxPlotTotal = box(grid([[axisGrid, boxPlotContent]], hgap(10), shrink(0.9))
	,lineColor(subGridFillColor)
	);
	return boxPlotTotal;
}




