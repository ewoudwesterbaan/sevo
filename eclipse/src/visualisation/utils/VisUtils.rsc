module visualisation::utils::VisUtils

import vis::Figure;
import vis::Render;

import metrics::Complexity;
import metrics::Rank;

private Color simpleColor = color("yellowgreen");
private Color moderateColor = color("gold");
private Color complexColor = color("orange");
private Color untestableColor = color("crimson");

private Color rankPluPlusColor = simpleColor;
private Color rankPlusColor = moderateColor;
private Color rankZeroColor = complexColor;
private Color rankMinusColor = untestableColor;
private Color rankMinusMinusColor = color("darkred");

public Color getUnitComplexityIndicationColor(int complexity) {
	int simpleMax = getTupRiskCategoryByCategoryName("Simple").maxComplexity;
	int moderateMax = getTupRiskCategoryByCategoryName("Moderate").maxComplexity;
	int complexMax = getTupRiskCategoryByCategoryName("Complex").maxComplexity;
	if (complexity <= simpleMax) return simpleColor;
	if (complexity <= simpleMax) return moderateColor;
	if (complexity <= simpleMax) return complexColor;
	return untestableColor;
}

