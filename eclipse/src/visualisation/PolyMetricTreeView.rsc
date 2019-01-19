module visualisation::PolyMetricTreeView

import vis::Figure;
import vis::Render;
import vis::KeySym;

import List;
import Set;
import Map;
import util::Math;

import metrics::Complexity;

import View;
import visualisation::widgets::Widgets;
import visualisation::utils::VisUtils;
import visualisation::visData::DataTypes;

import IO;

private ProjectInfoTuple projectInfo;

// Toont alle packages in het project (zonder de bijbehorende klassen). Deze methode is de eerste 
// methode in deze module wordt aangeroepen (en ook de enige public methode). Hier vindt daarom de
// initialisatie plaats van het private aatribuut projectInfo, die in andere private methoden wordt
// gebruikt.
public void showProjectView(ProjectInfoTuple projInfo) {
	// Eenmalig vullen van de private attributen
	projectInfo = projInfo;

	// De root van de tree representeert het project.
	root = createProjectFigure();
	
	// De leaves van de tree representeren de packages. We stellen de leaves hier samen.
	leaves = [];
	PkgInfoMap pkgInfos = projectInfo.pkgInfos;
	for (pkgInfo <- range(pkgInfos)) leaves += createPkgFigure(pkgInfo, true);
	
	// Render een pagina met de boom
	Figure bc1 = breadcrumElement(projectInfo.projName);
	Figure boxPlot = boxPlot("bPlot", [6, 7, 4, 9, 6, 2, 8, 6, 9, 6, 8, 9, 7, 3, 10, 5, 6, 7]);
	Figure stackedDiagram = stackedDiagram(
		"sDiagram",
		[5, 19, 10, 30, 7], 
		[getComplexityRatingIndicationColor("--"), getComplexityRatingIndicationColor("-"), getComplexityRatingIndicationColor("0"), getComplexityRatingIndicationColor("+"), getComplexityRatingIndicationColor("++")],
		["Bla x%", "Blie y%", "Hup z%", "Zus a%", "Zo b%"]
	);
	
	renderPage(breadcrumPath([bc1]), createTree(root, leaves), stackedDiagram, boxPlot, stackedDiagram, boxPlot);
}

// Toont een boom van een package met de bijbehorende klassen.
private void showPackageView(str pkgName) {
	PkgInfoTuple pkgInfo = projectInfo.pkgInfos[pkgName];

	// De root van de tree representeert de package. We stellen de root hier samen.
	root = createPkgFigure(pkgInfo, false);
		
	// De leaves van de tree representeren de klassen. We stellen de leaves hier samen.
	leaves = [];
	ClassInfoMap classInfos = pkgInfo.classInfos;
	for (classInfo <- range(classInfos)) leaves += createClassFigure(classInfo, true);
	
	// Render een pagina met de boom
	Figure bc1 = breadcrumElement(void(){showProjectView(projectInfo);}, projectInfo.projName);
	Figure bc2 = breadcrumElement(pkgName);

	Figure boxPlot = boxPlot("bPlot2", [6, 7, 4, 9, 6, 2, 8, 6, 9, 6, 8, 9, 7, 3, 10, 5, 6, 7]);
	Figure stackedDiagram = stackedDiagram(
		"sDiagram2",
		[5, 19, 10, 30, 7], 
		[getComplexityRatingIndicationColor("--"), getComplexityRatingIndicationColor("-"), getComplexityRatingIndicationColor("0"), getComplexityRatingIndicationColor("+"), getComplexityRatingIndicationColor("++")],
		["Bla x%", "Blie y%", "Hup z%", "Zus a%", "Zo b%"]
	);

	renderPage(breadcrumPath([bc1, bc2]), createTree(root, leaves), stackedDiagram, boxPlot, stackedDiagram, boxPlot);
}

// Toont een boom van een klasse met de bijbehorende methoden.
private void showClassView(str pkgName, str classId) {
	ClassInfoTuple classInfo = projectInfo.pkgInfos[pkgName].classInfos[classId];
	
	// De root van de tree representeert de klasse. We stellen de root hier samen.
	root = createClassFigure(classInfo, false);
	
	// De leaves van de tree representeren de units (methoden en constructoren). We stellen de leaves hier samen.
	leaves = [];
	for (unit <- classInfo.units) leaves += createUnitFigure(unit);

	// Stel een kruimelpad voor de pagina samen om te kunnen navigeren
	Figure bc1 = breadcrumElement(void(){showProjectView(projectInfo);}, projectInfo.projName);
	Figure bc2 = breadcrumElement(void(){showPackageView(pkgName);}, pkgName);
	Figure bc3 = breadcrumElement(classInfo.className);
	
	// Stel een boxplot samen met ... TODO
	Figure boxPlot = boxPlot("bPlot3", [6, 7, 4, 9, 6, 2, 8, 6, 9, 6, 8, 9, 7, 3, 10, 5, 6, 7]); // TODO
	
	// Stel een stackedDiagram samen met de risk category informatie voor deze klasse
	Figure stackedDiagram = createRiskCatStackedDiagram("sDgr3", classInfo);
	
	// Render een pagina 
	renderPage(breadcrumPath([bc1, bc2, bc3]), createTree(root, leaves), stackedDiagram, boxPlot, stackedDiagram, boxPlot);
}

// Rendert een pagina.
private void renderPage(Figure breadcrumPath, Figure tree, Figure topLeftFigure, Figure bottomLeftFigure, Figure topRightFigure, Figure bottomRightFigure) {
	Figure title = pageTitle("<projectInfo.projName> - Polymetric Tree");
	Figure homeButton = button(void(){visualizeMetrics();}, "Home");
	Figure dashBoard = dashBoard(tree, topLeftFigure, bottomLeftFigure, topRightFigure, bottomRightFigure);
	render(page(title, breadcrumPath, dashBoard));
}

// Maakt een stacked diagram met de informatie over de verdeling van coderegels in de units over de
// verschillende risk categories (complexiteit).
private Figure createRiskCatStackedDiagram(str title, ClassInfoTuple classInfo) {
	list[int] values = [];
	list[str] infoTexts = [];
	list[Color] colors = [];
	
	// Sorteer de risicocategorieen, zodat ze in de juiste volgorde in het diagram verschijnen
	list[TupComplexityRiskCategory] riskCats = sort(toList(domain(classInfo.riskCats)), 
		bool(TupComplexityRiskCategory a, TupComplexityRiskCategory b) { 
			return a.minComplexity > b.minComplexity; 
		}
	);
	
	// Verzamel de gegevens
	real uncategorized = 100.0;
	for (cat <- riskCats) {
		real perc = round(classInfo.riskCats[cat], 0.01); 
		uncategorized -= perc;
		infoTexts += "<cat.categoryName>: <perc>%";
		values += round(perc);
		colors += getUnitRiskIndicationColor(cat);
	}
	// Uncategorized zijn de regels die wel in een klasse zitten, maar niet in units. 
	// Deze regels zijn dus niet onderdeel van een risico categorie, omdat zo'n categorie
	// betrekking heeft op de codeLines in de units zelf.
	infoTexts += "Uncategorized: <uncategorized>%";
	values += round(uncategorized);
	colors += color("gray");
	
	// Maak het stack diagram
	return stackedDiagram(title, values, colors, infoTexts);
}

// Maakt een boom met de opgegeven root en leaves.
// Er wordt een aantal standaard properties aan de tree toegevoegd (grootte, tussenruimte, orientatie, ...)
// De orientatie is leftRight, en de bomen worden links uitgelijnd.
private Figure createTree(Figure root, list[Figure] leaves) {
	return tree(root, leaves, std(size(30)), std(hgap(30)), std(vgap(2)), orientation(leftRight()), left());
}

// Maakt een Figure representatie voor een project.
private Figure createProjectFigure() {
	int width = getProjectSize(projectInfo.codeLines);
	str popupText = "Project: <projectInfo.projName>, " + 
	                "\ntotaal aantal regels (incl lege regels binnen de units): <projectInfo.totalLines>," + 
	                "\ncommentaarregels: <projectInfo.commentLines>, " + 
	                "\ncoderegels: <projectInfo.codeLines>, " + 
	                "\ncomplexity rating: <projectInfo.complexityRating>. ";
	Color clr = getComplexityRatingIndicationColor(projectInfo.complexityRating); 
	Figure b = box(size(width, 10), fillColor(clr), popup(popupText));
	Figure t = text(projectInfo.projName);
	return hcat([t, b], id(projectInfo.projName), hgap(5));
}

// Maakt een Figure representatie voor een package.
//   - de packagenaam fungeert als id
//   - de breedte is afhankelijk van het aantal codeLines
//   - de kleur is afhankelijk van de complexity rating 
private Figure createPkgFigure(PkgInfoTuple pkgInfo, bool isLeaf) {
	int width = getPackageSize(pkgInfo.codeLines);
	str popupText = "Package: <pkgInfo.pkgName>, " + 
	                "\ntotaal aantal regels (incl lege regels binnen de units): <pkgInfo.totalLines>," + 
	                "\ncommentaarregels: <pkgInfo.commentLines>, " + 
	                "\ncoderegels: <pkgInfo.codeLines>, " + 
	                "\ncomplexity rating: <pkgInfo.complexityRating>. ";
	Color clr = getComplexityRatingIndicationColor(pkgInfo.complexityRating);
	Figure leafbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Klik om in de zoomen.)"), handlePackageClick(pkgInfo.pkgName));
	Figure rootbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Shift-klik om uit te zoomen.)"), handlePackageShiftClick());
	Figure t = text(pkgInfo.pkgName);
	if (isLeaf) return hcat([leafbox, t], id(pkgInfo.pkgName), hgap(5));
	return hcat([t, rootbox], id(pkgInfo.pkgName), hgap(5));
}

// Maakt een Figure representatie voor een klasse.
//   - de location van de klasse fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de complexity rating 
private Figure createClassFigure(ClassInfoTuple classInfo, bool isLeaf) {
	str classId = "<classInfo.location>";
	str className = classInfo.className;
	str pkgName = classInfo.pkgName == "" ? "\<root\>" : classInfo.pkgName;
	int width = getClassSize(classInfo.codeLines);
	str popupText = "Class: <className>, " + 
	                "\ntotaal aantal regels (incl lege regels binnen de units): <classInfo.totalLines>," + 
	                "\ncommentaarregels: <classInfo.commentLines>, " + 
	                "\ncoderegels: <classInfo.codeLines>, " + 
	                "\ncomplexity rating: <classInfo.complexityRating>. ";
	Color clr = getComplexityRatingIndicationColor(classInfo.complexityRating);
	Figure leafbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Klik om in de zoomen.)"), handleClassClick(pkgName, classId));
	Figure rootbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Shift-klik om uit te zoomen.)"), handleClassShiftClick(pkgName));
	Figure t = text(className);
	if (isLeaf) return hcat([leafbox, t], id(classId), hgap(5));
	return hcat([t, rootbox], id(classId), hgap(5)); 
}

// Maak een Figure representatie voor een unit.
//   - de location van de unit fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de complexiteitsmaat van de unit.
private Figure createUnitFigure(UnitInfoTuple unitInfo) {
	str unitId = "<unitInfo.location>";
	str unitName = unitInfo.unitName;
	int width = getUnitSize(unitInfo.codeLines);
	str risk = unitInfo.risk;
	str popupText = "Unit: <unitName>, LOC: <unitInfo.codeLines>, cyclomatische complexiteit: <unitInfo.complexity>, risico-inschatting: \"<risk>\"";
	Color clr = getUnitRiskIndicationColor(unitInfo.complexity);
	Figure b = box(size(width, 10), fillColor(clr), popup(popupText));
	Figure t = text(unitName);
	return hcat([b, t], id(unitId), hgap(5));
}

// Handelt een click event af op een package 
private FProperty handlePackageClick(str pkgName) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) return false;
		if (modifiers[modCtrl()]) return false;
		if (modifiers[modAlt()]) return false;
		showPackageView(pkgName);
		return true;
	});
}

// Handelt een shift-click event af op een package 
private FProperty handlePackageShiftClick() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) {
			showProjectView(projectInfo);
			return true;
		}
		return false;
	});
}

// Handelt een click event af op een klasse 
private FProperty handleClassClick(str pkgName, str classId) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) return false;
		if (modifiers[modCtrl()]) return false;
		if (modifiers[modAlt()]) return false;
		showClassView(pkgName, classId);
		return true;
	});
}

// Handelt een shift-click event af op een klasse 
private FProperty handleClassShiftClick(str pkgName) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) {
			showPackageView(pkgName);
			return true;
		}
		return false;
	});
}

// Bepaalt de grootte van een unit op basis van de lines of code
private int getUnitSize(int codeLines) {
	return min([200, 25 + codeLines / 2]);
}

// Bepaalt de grootte van een class op basis van de lines of code
private int getClassSize(int codeLines) {
	return min([200, 25 + codeLines / 6]);
}

// Bepaalt de grootte van een package op basis van de lines of code
private int getPackageSize(int codeLines) {
	return min([200, 25 + codeLines / 18]);
}

// Bepaalt de grootte van een project op basis van de lines of code
private int getProjectSize(int codeLines) {
	return min([200, 25 + codeLines / 100]);
}



