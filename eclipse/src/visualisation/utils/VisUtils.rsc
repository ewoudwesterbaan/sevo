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

private alias ColorPallette = tuple[
	Color simpleColor,
	Color moderateColor,
	Color complexColor,
	Color untestableColor,

	Color rankPlusPlusColor,
	Color rankPlusColor,
	Color rankZeroColor,
	Color rankMinusColor,
	Color rankMinusMinusColor,
	
	Color smallSizeColor,
	Color mediumSizeColor,
	Color largeSizeColor,
	Color veryLargeSizeColor,
	Color insaneSizeColor
];
private alias ColorMap = map[str palletteName, ColorPallette palette];

private ColorMap colorMap = (
	"default" : <
		color("limegreen"),
		color("gold"),
		color("darkorange"),
		color("red"),
		
		color("limegreen"),
		color("yellowgreen"),
		color("gold"),
		color("orange"),
		color("red"),
		
		color("white"),
		color("aliceblue"),
		color("lightsteelblue"),
		color("steelblue"),
		color("midnightblue")
	>,
	"BW" : <
		rgb(255, 255, 255),
		rgb(200, 200, 200),
		rgb(120, 120, 120),
		rgb(0,0,0),
		
		rgb(255, 255, 255),
		rgb(220, 220, 220),
		rgb(170, 170, 170),
		rgb(120, 120, 120),
		rgb(0, 0, 0),
		
		rgb(255, 255, 255),
		rgb(210, 210, 210),
		rgb(160, 160, 160),
		rgb(100, 100, 100),
		rgb(0, 0, 0)
	>
); 

// Geeft de kleur van een figure terug, op basis van de complexity rating waarin het project valt.
//   - rank: de risico rank (++, +, 0, -, --)
public Color getComplexityRatingIndicationColor(str rank) {
	return getComplexityRatingIndicationColor(rank, "default");
}

public Color getComplexityRatingIndicationColor(str rank, str palletteName) {
	if (rank == "++") return colorMap[palletteName].rankPlusPlusColor;
	if (rank == "+") return colorMap[palletteName].rankPlusColor;
	if (rank == "0") return colorMap[palletteName].rankZeroColor;
	if (rank == "-") return colorMap[palletteName].rankMinusColor;
	if (rank == "--") return colorMap[palletteName].rankMinusMinusColor;
	throw "Unexpected rank: <rank>";
}

// Geeft de kleur van een unit figure terug, op basis van de cyclomatic complexity van een unit.
public Color getUnitRiskIndicationColor(int complexity) {
	return getUnitRiskIndicationColor(complexity, "default");
}

public Color getUnitRiskIndicationColor(int complexity, str palletteName) {
	int simpleMax = getTupRiskCategoryByCategoryName("Simple").maxComplexity;
	int moderateMax = getTupRiskCategoryByCategoryName("Moderate").maxComplexity;
	int complexMax = getTupRiskCategoryByCategoryName("Complex").maxComplexity;
	if (complexity <= simpleMax) return colorMap[palletteName].simpleColor;
	if (complexity <= moderateMax) return colorMap[palletteName].moderateColor;
	if (complexity <= complexMax) return colorMap[palletteName].complexColor;
	return colorMap[palletteName].untestableColor;
}

// Geeft de kleur terug op basis van het complexity risico (categorie) van een unit.
public Color getUnitRiskIndicationColor(TupComplexityRiskCategory cat) {
	return getUnitRiskIndicationColor(cat, "default");
}

public Color getUnitRiskIndicationColor(TupComplexityRiskCategory cat, str palletteName) {
	return getUnitRiskIndicationColor(cat.categoryName, palletteName);
}

// Geeft de kleur terug op basis van het complexity risico (categorienaam) van een unit.
public Color getUnitRiskIndicationColor(str categoryName) {
	return getUnitRiskIndicationColor(categoryName, "default");
}

public Color getUnitRiskIndicationColor(str categoryName, str palletteName) {
	if (categoryName == "Simple") return colorMap[palletteName].simpleColor;
	if (categoryName == "Moderate") return colorMap[palletteName].moderateColor;
	if (categoryName == "Complex") return colorMap[palletteName].complexColor;
	return colorMap[palletteName].untestableColor;
}

// Geeft de kleur terug op basis van de grootte-categorienaam van een unit.
public Color getUnitSizeIndicationColor(str categoryName) {
	return getUnitSizeIndicationColor(categoryName, "default");
}

public Color getUnitSizeIndicationColor(str categoryName, str palletteName) {
	if (categoryName == "Small") return colorMap[palletteName].smallSizeColor;
	if (categoryName == "Medium") return colorMap[palletteName].mediumSizeColor;
	if (categoryName == "Large") return colorMap[palletteName].largeSizeColor;
	if (categoryName == "Very large") return colorMap[palletteName].veryLargeSizeColor;
	return colorMap[palletteName].insaneSizeColor;
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

