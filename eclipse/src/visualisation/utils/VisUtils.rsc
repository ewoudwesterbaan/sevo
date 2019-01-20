module visualisation::utils::VisUtils

import vis::Figure;
import vis::Render;

import util::Math;
import analysis::statistics::Descriptive;

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
private Color untestableColor = color("red");

private Color rankPlusPlusColor = simpleColor;
private Color rankPlusColor = color("yellowgreen");
private Color rankZeroColor = moderateColor;
private Color rankMinusColor = color("orange");
private Color rankMinusMinusColor = untestableColor;

private Color smallSizeColor = color("white");
private Color mediumSizeColor = color("aliceblue");
private Color largeSizeColor = color("lightsteelblue");
private Color veryLargeSizeColor = color("steelblue");
private Color insaneSizeColor = color("midnightblue");

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

// Geeft de kleur van een unit figure terug, op basis van de cyclomatic complexity van een unit.
public Color getUnitRiskIndicationColor(int complexity) {
	int simpleMax = getTupRiskCategoryByCategoryName("Simple").maxComplexity;
	int moderateMax = getTupRiskCategoryByCategoryName("Moderate").maxComplexity;
	int complexMax = getTupRiskCategoryByCategoryName("Complex").maxComplexity;
	if (complexity <= simpleMax) return simpleColor;
	if (complexity <= moderateMax) return moderateColor;
	if (complexity <= complexMax) return complexColor;
	return untestableColor;
}

// Geeft de kleur terug op basis van het complexity risico (categorie) van een unit.
public Color getUnitRiskIndicationColor(TupComplexityRiskCategory cat) {
	return getUnitRiskIndicationColor(cat.categoryName);
}

// Geeft de kleur terug op basis van het complexity risico (categorienaam) van een unit.
public Color getUnitRiskIndicationColor(str categoryName) {
	if (categoryName == "Simple") return simpleColor;
	if (categoryName == "Moderate") return moderateColor;
	if (categoryName == "Complex") return complexColor;
	return untestableColor;
}

// Geeft de kleur terug op basis van de grootte-categorienaam van een unit.
public Color getUnitSizeIndicationColor(str categoryName) {
	if (categoryName == "Small") return smallSizeColor;
	if (categoryName == "Medium") return mediumSizeColor;
	if (categoryName == "Large") return largeSizeColor;
	if (categoryName == "Very large") return veryLargeSizeColor;
	return insaneSizeColor;
}

// Bepaalt de parameters voor een pboxplot, op basis van een lijst van waarden
//   - values: een lijst van waarden waarvan een boxplot moet worden gemaakt
public tuple[num startRange, num q1, num median, num q3, num endRange] getBoxplotParams(list[int] values) {
	// De uitzonderingen
	if (size(values) == 0) {
		return <0.0, 0.0, 0.0, 0.0, 0.0>;
	}
	if (size(values) == 1) {
		num v = head(values);
		return <v, v, v, v, v>;
	}

	// Sorteer de values
	values = sort(values);
	
	// Bepaal de mediaan
	num median_ = median(values);
	
	// Deel de waarden op in twee helften: v1 en v2
	tuple[list[int] first, list[int] last] splitted = split(values);
	list[int] v1 = splitted.first;
	list[int] v2 = splitted.last;
	if (size(v2) > size(v1)) v2 = tail(v2);
	
	// Bepaal de kwartielen q1 en q3 (beide de mediaan van resp. de eerste helft en de tweede helft van de waardenlijst).
	num q1 = median(v1);
	num q3 = median(v2);

	// Geef het resultaat terug
	return <head(v1), q1, median_, q3, last(v2)>;
}

