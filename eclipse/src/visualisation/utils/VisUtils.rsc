module visualisation::utils::VisUtils

import vis::Figure;
import vis::Render;

import List;
import Set;
import Map;

import IO;

// Voor getTupRiskCategoryByCategoryName.
import metrics::Complexity;

// Voor de data types en aliassen
import visualisation::visData::DataTypes;

private Color simpleColor = color("limegreen");
private Color moderateColor = color("gold");
private Color complexColor = color("darkorange");
private Color untestableColor = color("crimson");

private Color rankPlusPlusColor = simpleColor;
private Color rankPlusColor = color("yellowgreen");
private Color rankZeroColor = moderateColor;
private Color rankMinusColor = color("orange");
private Color rankMinusMinusColor = untestableColor;

// Geeft de kleur van een figure terug, op basis van de complexity rating waarin het project valt.
//   - rank: de risico rank (++, +, 0, -, --)
public Color getComplexityRatingIndicationColor(str rank) {
	if (rank == "++") return rankPlusPlusColor;
	if (rank == "+") return rankPlusColor;
	if (rank == "0") return rankZeroColor;
	if (rank == "-") return rankMinusColor;
	if (rank == "--") return rankMinusMinusColor;
	throw "Unexpected rank: <rank>";
}

// Geeft de kleur van een unit figure terug, op basis van de risicocategorie waarin de unit valt.
public Color getUnitRiskIndicationColor(int complexity) {
	int simpleMax = getTupRiskCategoryByCategoryName("Simple").maxComplexity;
	int moderateMax = getTupRiskCategoryByCategoryName("Moderate").maxComplexity;
	int complexMax = getTupRiskCategoryByCategoryName("Complex").maxComplexity;
	if (complexity <= simpleMax) return simpleColor;
	if (complexity <= moderateMax) return moderateColor;
	if (complexity <= complexMax) return complexColor;
	return untestableColor;
}

