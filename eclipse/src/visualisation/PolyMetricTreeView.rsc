module visualisation::PolyMetricTreeView

import vis::Figure;
import vis::Render;
import vis::KeySym;

import List;
import Set;
import Map;
import util::Math;

import metrics::Complexity;
import metrics::Aggregate;
import metrics::Rate;

import View;
import visualisation::widgets::Widgets;
import visualisation::utils::VisUtils;
import visualisation::visData::DataTypes;

import IO;

private ProjectInfoTuple projectInfo;

// Overloaded versie van showProjectView(ProjectInfoTuple projInfo, str colorPalletteName). Deze
// versie toont de project view met een "default" kleurenpallet (de kleurenversie van de visualisatie).
public void showProjectView(ProjectInfoTuple projInfo) {
	showProjectView(projInfo, "default");
}

// Toont alle packages in het project (zonder de bijbehorende klassen). Deze methode (of de overloaded 
// versie hierboven) is de eerste methode in deze module wordt aangeroepen (en ook de enige public 
// methode). Hier vindt daarom de initialisatie plaats van het private attribuut projectInfo, die in andere 
// private methoden wordt gebruikt. Verder worden twee boxplots en twee stacked diagrams getoond met 
// informatie over de grootte van de units en de complexiteit van de units in het project.
// Deze project view van de visualisatie biedt de gebruiker de mogelijkheid om in te zoomen naar de package
// view, en daarbinnen weer naar de class view.
public void showProjectView(ProjectInfoTuple projInfo, str colorPalletteName) {
	// Eenmalig vullen van de private attributen
	projectInfo = projInfo;

	// De root van de tree representeert het project.
	root = createProjectFigure(colorPalletteName);
	
	// De leaves van de tree representeren de packages. We stellen de leaves hier samen.
	leaves = [];
	PkgInfoMap pkgInfos = projectInfo.pkgInfos;
	for (pkgInfo <- range(pkgInfos)) leaves += createPkgFigure(pkgInfo, true, colorPalletteName);
	
	// Stel een kruimelpad voor de pagina samen
	Figure bc1 = breadcrumElement(projectInfo.projName);
	
	// Stel een boxplot samen voor codeLines per unit
	Figure codeLinesBoxplot = boxPlot("Coderegels per unit", [unit.codeLines | unit <- getUnitsFromProjectInfo(projectInfo)]);
	// Stel een boxplot samen voor complexity per unit
	Figure complexityBoxplot = boxPlot("Complexity per unit", [unit.complexity | unit <- getUnitsFromProjectInfo(projectInfo)]);

	// Stel een stackedDiagram samen met de unit size informatie voor dit project
	Figure unitSizeStackedDiagram = createUnitSizeStackedDiagram("Unit size distributie", projInfo.unitSizeCats, colorPalletteName);
	// Stel een stackedDiagram samen met de complexity rank distributie voor dit project
	Figure complexityRankStackedDiagram = createComplexityRankStackedDiagram("Complexity rank dist.", projInfo.complexityRanks, colorPalletteName);
	
	// Render een pagina met de bovenstaande elementen
	renderPage(
		breadcrumPath([bc1]), 
		createTree(root, leaves), 
		codeLinesBoxplot, 
		unitSizeStackedDiagram, 
		complexityBoxplot, 
		complexityRankStackedDiagram
	);
}

// Toont een boom van een package met de bijbehorende klassen, plus twee boxplots en twee stacked diagrams. 
// De view is vergelijkbaar met de project view, maar dan ingezoomed op een van de packages in de project view.
private void showPackageView(str pkgName, str colorPalletteName) {
	PkgInfoTuple pkgInfo = projectInfo.pkgInfos[pkgName];

	// De root van de tree representeert de package. We stellen de root hier samen.
	root = createPkgFigure(pkgInfo, false, colorPalletteName);
		
	// De leaves van de tree representeren de klassen. We stellen de leaves hier samen.
	leaves = [];
	ClassInfoMap classInfos = pkgInfo.classInfos;
	for (classInfo <- range(classInfos)) leaves += createClassFigure(classInfo, true, colorPalletteName);
	
	// Stel een kruimelpad voor de pagina samen om te kunnen navigeren
	Figure bc1 = breadcrumElement(void(){showProjectView(projectInfo, colorPalletteName);}, projectInfo.projName);
	Figure bc2 = breadcrumElement(pkgName);

	// Stel een boxplot samen voor codeLines
	Figure codeLinesBoxplot = boxPlot("Coderegels per unit", [unit.codeLines | unit <- getUnitsFromPkgInfo(pkgInfo)]);
	// Stel een boxplot samen voor complexity
	Figure complexityBoxplot = boxPlot("Complexity per unit", [unit.complexity | unit <- getUnitsFromPkgInfo(pkgInfo)]);
	
	// Stel een stackedDiagram samen met de unit size informatie voor deze package
	Figure unitSizeStackedDiagram = createUnitSizeStackedDiagram("Unit size distributie", pkgInfo.unitSizeCats, colorPalletteName);
	// Stel een stackedDiagram samen met de complexity rank distributie voor deze package
	Figure complexityRankStackedDiagram = createComplexityRankStackedDiagram("Complexity rank dist.", pkgInfo.complexityRanks, colorPalletteName);

	// Render een pagina met de bovenstaande elementen
	renderPage(
		breadcrumPath([bc1, bc2]), 
		createTree(root, leaves), 
		codeLinesBoxplot, 
		unitSizeStackedDiagram, 
		complexityBoxplot, 
		complexityRankStackedDiagram
	);
}

// Toont een boom van een klasse met de bijbehorende methoden, plus twee boxplots en twee stacked diagrams. 
// De view is vergelijkbaar met de project en de package view, maar dan ingezoomed op een van de classes in de 
// package view.
private void showClassView(str pkgName, str classId, str colorPalletteName) {
	ClassInfoTuple classInfo = projectInfo.pkgInfos[pkgName].classInfos[classId];
	
	// De root van de tree representeert de klasse. We stellen de root hier samen.
	root = createClassFigure(classInfo, false, colorPalletteName);
	
	// De leaves van de tree representeren de units (methoden en constructoren). We stellen de leaves hier samen.
	leaves = [];
	for (unit <- classInfo.units) leaves += createUnitFigure(unit, colorPalletteName);

	// Stel een kruimelpad voor de pagina samen om te kunnen navigeren
	Figure bc1 = breadcrumElement(void(){showProjectView(projectInfo, colorPalletteName);}, projectInfo.projName);
	Figure bc2 = breadcrumElement(void(){showPackageView(pkgName, colorPalletteName);}, pkgName);
	Figure bc3 = breadcrumElement(classInfo.className);
	
	// Stel een boxplot samen voor codeLines
	Figure codeLinesBoxplot = boxPlot("Coderegels per unit", [unit.codeLines | unit <- classInfo.units]);
	// Stel een boxplot samen voor complexity
	Figure complexityBoxplot = boxPlot("Complexity per unit", [unit.complexity | unit <- classInfo.units]);
	
	// Stel een stackedDiagram samen met de unit size informatie voor deze klasse
	Figure unitSizeStackedDiagram = createUnitSizeStackedDiagram("Unit size distributie", classInfo.unitSizeCats, colorPalletteName);
	// Stel een stackedDiagram samen met de risk category informatie voor deze klasse
	Figure riskCatStackedDiagram = createRiskCatStackedDiagram("Risico distributie", classInfo, colorPalletteName);
	
	// Render een pagina met de bovenstaande elementen
	renderPage(
		breadcrumPath([bc1, bc2, bc3]), 
		createTree(root, leaves), 
		codeLinesBoxplot, 
		unitSizeStackedDiagram, 
		complexityBoxplot, 
		riskCatStackedDiagram
	);
}

// Rendert een pagina.
private void renderPage(Figure breadcrumPath, Figure tree, Figure topLeftFigure, Figure bottomLeftFigure, Figure topRightFigure, Figure bottomRightFigure) {
	Figure title = pageTitle(projectInfo.projName);
	Figure dashBoard = dashBoard(tree, topLeftFigure, bottomLeftFigure, topRightFigure, bottomRightFigure);
	render(page(title, breadcrumPath, dashBoard));
}

// Maakt een stacked diagram met informatie over de verdeling van de coderegels in de classes van 
// een package over de verschillende complexity ranks (++, +, 0, -, --).
private Figure createComplexityRankStackedDiagram(str title, ComplexityRankDistributionMap complexityRanks, str colorPalletteName) {
	// Sorteer de risicocategorieen, zodat ze in de juiste volgorde in het diagram verschijnen
	list[TupComplexityRankCategory] sortedComplexityRanks = sort(toList(domain(complexityRanks)), 
		bool(TupComplexityRankCategory a, TupComplexityRankCategory b) { 
			return a.maxRelativeLOCModerate > b.maxRelativeLOCModerate; 
		}
	);
	
	// Verzamel de gegevens
	list[int] values = [];
	list[str] infoTexts = [];
	list[Color] colors = [];
	for (cat <- sortedComplexityRanks) {
		real perc = round(complexityRanks[cat], 0.01); 
		infoTexts += "Rank <cat.rank>: <perc>%";
		values += round(perc);
		colors += getComplexityRatingIndicationColor(cat.rank, colorPalletteName);
	}
	
	// Maak het stack diagram
	return stackedDiagram(title, values, colors, infoTexts);
}

// Maakt een stacked diagram met de informatie over de verdeling van coderegels in de units over de
// verschillende risk categories (complexiteit).
private Figure createRiskCatStackedDiagram(str title, ClassInfoTuple classInfo, str colorPalletteName) {
	// Sorteer de risicocategorieen, zodat ze in de juiste volgorde in het diagram verschijnen
	list[TupComplexityRiskCategory] sortedRiskCats = sort(toList(domain(classInfo.riskCats)), 
		bool(TupComplexityRiskCategory a, TupComplexityRiskCategory b) { 
			return a.minComplexity > b.minComplexity; 
		}
	);
	
	// Verzamel de gegevens
	list[int] values = [];
	list[str] infoTexts = [];
	list[Color] colors = [];
	for (cat <- sortedRiskCats) {
		real perc = round(classInfo.riskCats[cat], 0.01); 
		infoTexts += "<cat.categoryName>: <perc>%";
		values += round(perc);
		colors += getUnitRiskIndicationColor(cat, colorPalletteName);
	}
	
	// Maak het stack diagram
	return stackedDiagram(title, values, colors, infoTexts);
}

// Maakt een stacked diagram met de informatie over de verdeling van unit size over de units.
private Figure createUnitSizeStackedDiagram(str title, UnitSizeDistributionMap unitSizeCats, str colorPalletteName) {
	// Sorteer de categorieen, zodat ze in de juiste volgorde in het diagram verschijnen
	list[TupUnitSizeCategory] sortedUnitSizeCats = sort(toList(domain(unitSizeCats)), 
		bool(TupUnitSizeCategory a, TupUnitSizeCategory b) { 
			return a.minLines > b.minLines; 
		}
	);
	
	// Verzamel de gegevens
	list[int] values = [];
	list[str] infoTexts = [];
	list[Color] colors = [];
	for (cat <- sortedUnitSizeCats) {
		real perc = round(unitSizeCats[cat], 0.01); 
		infoTexts += "<cat.categoryName>: <perc>%";
		values += round(perc);
		colors += getUnitSizeIndicationColor(cat.categoryName, colorPalletteName);
	}
	
	// Maak het stack diagram
	return stackedDiagram(title, values, colors, infoTexts);
}

// Maakt een boom met de opgegeven root en leaves.
// Er wordt een aantal standaard properties aan de tree toegevoegd (grootte, tussenruimte, orientatie, ...)
// De orientatie is leftRight, en de bomen worden links uitgelijnd.
private Figure createTree(Figure root, list[Figure] leaves) {
	return tree(root, leaves, std(size(30)), std(hgap(30)), std(vgap(2)), orientation(leftRight()), left());
}

// Maakt een Figure representatie voor een project node in een boom.
private Figure createProjectFigure(str colorPalletteName) {
	int width = getProjectSize(projectInfo.codeLines);
	str popupText = "Project: <projectInfo.projName>, " + 
	                "\ntotaal aantal regels (incl lege regels binnen de units): <projectInfo.totalLines>," + 
	                "\ncommentaarregels: <projectInfo.commentLines>, " + 
	                "\ncoderegels: <projectInfo.codeLines>, " + 
	                "\ncomplexity rating: <projectInfo.complexityRating>. ";
	Color clr = getComplexityRatingIndicationColor(projectInfo.complexityRating, colorPalletteName); 
	Figure b = box(size(width, 10), fillColor(clr), popup(popupText));
	Figure t = text(projectInfo.projName);
	return hcat([t, b], id(projectInfo.projName), hgap(5));
}

// Maakt een Figure representatie voor een package node in een boom.
//   - de packagenaam fungeert als id
//   - de breedte is afhankelijk van het aantal codeLines
//   - de kleur is afhankelijk van de complexity rating 
private Figure createPkgFigure(PkgInfoTuple pkgInfo, bool isLeaf, str colorPalletteName) {
	int width = getPackageSize(pkgInfo.codeLines);
	str popupText = "Package: <pkgInfo.pkgName>, " + 
	                "\ntotaal aantal regels (incl lege regels binnen de units): <pkgInfo.totalLines>," + 
	                "\ncommentaarregels: <pkgInfo.commentLines>, " + 
	                "\ncoderegels: <pkgInfo.codeLines>, " + 
	                "\ncomplexity rating: <pkgInfo.complexityRating>. ";
	Color clr = getComplexityRatingIndicationColor(pkgInfo.complexityRating, colorPalletteName);
	Figure leafbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Klik om in de zoomen.)"), handlePackageClick(pkgInfo.pkgName, colorPalletteName));
	Figure rootbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Shift-klik om uit te zoomen.)"), handlePackageShiftClick(colorPalletteName));
	Figure t = text(pkgInfo.pkgName);
	if (isLeaf) return hcat([leafbox, t], id(pkgInfo.pkgName), hgap(5));
	return hcat([t, rootbox], id(pkgInfo.pkgName), hgap(5));
}

// Maakt een Figure representatie voor een klasse node in een boom.
//   - de location van de klasse fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de complexity rating 
private Figure createClassFigure(ClassInfoTuple classInfo, bool isLeaf, str colorPalletteName) {
	str classId = "<classInfo.location>";
	str className = classInfo.className;
	str pkgName = classInfo.pkgName == "" ? "\<root\>" : classInfo.pkgName;
	int width = getClassSize(classInfo.codeLines);
	str popupText = "Class: <className>, " + 
	                "\ntotaal aantal regels (incl lege regels binnen de units): <classInfo.totalLines>," + 
	                "\ncommentaarregels: <classInfo.commentLines>, " + 
	                "\ncoderegels: <classInfo.codeLines>, " + 
	                "\ncomplexity rating: <classInfo.complexityRating>. ";
	Color clr = getComplexityRatingIndicationColor(classInfo.complexityRating, colorPalletteName);
	Figure leafbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Klik om in de zoomen.)"), handleClassClick(pkgName, classId, colorPalletteName));
	Figure rootbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Shift-klik om uit te zoomen.)"), handleClassShiftClick(pkgName, colorPalletteName));
	Figure t = text(className);
	if (isLeaf) return hcat([leafbox, t], id(classId), hgap(5));
	return hcat([t, rootbox], id(classId), hgap(5)); 
}

// Maak een Figure representatie voor een unit node in een boom.
//   - de location van de unit fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de complexiteitsmaat van de unit.
private Figure createUnitFigure(UnitInfoTuple unitInfo, str colorPalletteName) {
	str unitId = "<unitInfo.location>";
	str unitName = unitInfo.unitName;
	int width = getUnitSize(unitInfo.codeLines);
	str risk = unitInfo.risk;
	str popupText = "Unit: <unitName>, LOC: <unitInfo.codeLines>, cyclomatische complexiteit: <unitInfo.complexity>, risico-inschatting: \"<risk>\"";
	Color clr = getUnitRiskIndicationColor(unitInfo.complexity, colorPalletteName);
	Figure b = box(size(width, 10), fillColor(clr), popup(popupText));
	Figure t = text(unitName);
	return hcat([b, t], id(unitId), hgap(5));
}

// Handelt een click event af op een package 
private FProperty handlePackageClick(str pkgName, str colorPalletteName) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) return false;
		if (modifiers[modCtrl()]) return false;
		if (modifiers[modAlt()]) return false;
		showPackageView(pkgName, colorPalletteName);
		return true;
	});
}

// Handelt een shift-click event af op een package 
private FProperty handlePackageShiftClick(str colorPalletteName) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) {
			showProjectView(projectInfo, colorPalletteName);
			return true;
		}
		return false;
	});
}

// Handelt een click event af op een klasse 
private FProperty handleClassClick(str pkgName, str classId, str colorPalletteName) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) return false;
		if (modifiers[modCtrl()]) return false;
		if (modifiers[modAlt()]) return false;
		showClassView(pkgName, classId, colorPalletteName);
		return true;
	});
}

// Handelt een shift-click event af op een klasse 
private FProperty handleClassShiftClick(str pkgName, str colorPalletteName) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) {
			showPackageView(pkgName, colorPalletteName);
			return true;
		}
		return false;
	});
}

// Haalt een lijst van units per package op
private UnitInfoList getUnitsFromPkgInfo(PkgInfoTuple pkgInfo) {
	UnitInfoList units = [];
	for (classInfo <- range(pkgInfo.classInfos)) units += classInfo.units;
	return units;
}

// Haalt een lijst van units per project op
private UnitInfoList getUnitsFromProjectInfo(ProjectInfoTuple projectInfo) {
	UnitInfoList units = [];
	for (pkgInfo <- range(projectInfo.pkgInfos)) units += getUnitsFromPkgInfo(pkgInfo);
	return units;
}

// Bepaalt de grootte van een unit op basis van de lines of code
private int getUnitSize(int codeLines) {
	return min([250, 10 + codeLines]);
}

// Bepaalt de grootte van een class op basis van de lines of code
private int getClassSize(int codeLines) {
	return min([250, 10 + codeLines / 4]);
}

// Bepaalt de grootte van een package op basis van de lines of code
private int getPackageSize(int codeLines) {
	return min([250, 10 + codeLines / 8]);
}

// Bepaalt de grootte van een project op basis van de lines of code
private int getProjectSize(int codeLines) {
	return min([250, 10 + codeLines / 16]);
}
