module visualisation::BoxplotExercise

import vis::Figure;
import vis::Render;

import util::Math;
import List;
import analysis::statistics::Descriptive;

import IO;

void Test() {
	int maximum = 10;
	int q3 = 7;
	int mediaan = 4;
	int q1 = 3;
	int minimum = 1;
	int startRange= 0;
	int endRange = 12;
	
	int plotHeight = 200;
	int plotWidth = 50;
	
	Figure boxPlot = getBoxPlot(startRange, minimum, q1, mediaan, q3, maximum, endRange, 0);
	
	//Figure testCage = box(boxPlot, center(), shrink(0.8), lineWidth(1));
	
	render(box(boxPlot, fillColor("lightGray"), shrink(0.8)));
}

void Test2() {
	list[int] values = [5, 19, 20, 20, 20, 20, 21, 18, 18, 22, 25, 18];
	Figure boxPlot = getBoxPlot(values);
	
	Figure testCage = box(boxPlot, center(), shrink(0.5));
	
	render(box(testCage));
}

Figure getBoxPlot(list[int] values, FProperty props...) {
	num median = median(values);
	num q1 = percentile(values, 25);
	num q3 = percentile(values, 75);
	num qr = q3 - q1;
	num minimum = q1 - (1.5 * qr);
	num maximum = q3 + (1.5 * qr);
	num startRange = analysis::statistics::Descriptive::min(values);
	num endRange = analysis::statistics::Descriptive::max(values);
	num mean = mean(values);
	return getBoxPlot(startRange, minimum, q1, median, q3, maximum, endRange, mean, props);
}

Figure getBoxPlot(num startRange, num minimum, num q1, num median, num q3, num maximum, num endRange, num mean, FProperty props...) {	
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
 	row_endRange_maximum = [ box(vshrink(ratio_endRange_maximum), lineColor("White")) ];
	row_maximum_q3  = [ 
		grid(
			[
				[ box(fillColor("Black"), height(2), vresizable(false))
				, box(fillColor("Black"), height(2), width(2), resizable(false))
				, box(fillColor("Black"), height(2), vresizable(false)) 
				],
				[ box(lineColor("White"))
				, box(lineColor("Black"), width(1), lineWidth(1), hresizable(false), lineStyle("dash"))
				, box(lineColor("White")) ]
			]
		, vshrink(ratio_maximum_q3)) 
		];
    row_q3_median = [ 
    	grid (
    	[
    		[ box() ]
    		,[ box(height(1), vresizable(false), lineWidth(1)) ] // Om de mediaanlijn wat dikker aan te zetten
    	], vshrink(ratio_q3_median))
    ];
    row_median_q1 = [ box(vshrink(ratio_median_q1)) ];

    row_q1_minimum = [ 
    	grid(
			[
				[ 
				  box(fillColor("Black"), height(1), vresizable(false))
				, box(fillColor("Black"), height(1), width(2), resizable(false))
				, box(fillColor("Black"), height(1), vresizable(false)) 
				],
				[ 
				  box(lineColor("White"))
				, box(lineColor("Black"), width(1), lineWidth(1), hresizable(false), lineStyle("dash"))
				, box(lineColor("White")) ],
				[ 
				  box(fillColor("Black"), height(2), vresizable(false))
				, box(fillColor("Black"), height(2), width(2), resizable(false))
				, box(fillColor("Black"), height(2), vresizable(false)) 
				]
			]
		, vshrink(ratio_q1_minimum)
		)
		];
	// Eventueel kunnen we hier nog outliers wegschrijven
    row_minimum_startRange = [ box(lineColor("White"), vshrink(ratio_minimum_startRange)) ];
    
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
			[ box(text("<endRange>", top()), height(5),lineColor("White")), box(height(1), width(5), top(), resizable(false)) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(height(1), width(5), center(), resizable(false)) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(width(5),lineColor("White")) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(height(1), width(5), center(), resizable(false)) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(width(5),lineColor("White")) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(height(1), width(5), center(), resizable(false)) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(width(5),lineColor("White")) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(height(1), width(5), center(), resizable(false)) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(width(5),lineColor("White")) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(height(1), width(5), center(), resizable(false)) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(width(5),lineColor("White")) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(height(1), width(5), center(), resizable(false)) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(width(5),lineColor("White")) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(height(1), width(5), center(), resizable(false)) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(width(5),lineColor("White")) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(height(1), width(5), center(), resizable(false)) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(width(5),lineColor("White")) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(height(1), width(5), center(), resizable(false)) ]
		  , [ box(top(), resizable(false),lineColor("White")), box(width(5),lineColor("White")) ]
		  , [ box(text("<startRange>"), bottom(), resizable(false),lineColor("White")), box(height(1), width(5), bottom(), resizable(false)) ] 
		], hgap(10)), width(20), hresizable(false),lineColor("White")
		);
	
	Figure boxPlotTotal = box(grid([[axisGrid, boxPlotContent]], hgap(10)),lineColor("White"));
	
	return boxPlotTotal;
}

