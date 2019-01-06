module visualisation::PolyMetricTreeView

import vis::Figure;
import vis::Render;
import vis::KeySym;

import List;
import Set;
import Map;

import View;
import visualisation::PolyMetricTreeMapView;
import visualisation::widgets::Widgets;
import visualisation::utils::VisUtils;

import IO;

private ProjectInfoTuple projectInfo;

// Toont alle packages in het project (zonder de bijbehorende klassen). 
public void showProjectTree(ProjectInfoTuple projInfo) {
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
	renderPage(breadcrumPath([bc1]), createTree(root, leaves));
}

// Toont een boom van een package met de bijbehorende klassen.
private void showPackageTree(str pkgName) {
	PkgInfoTuple pkgInfo = projectInfo.pkgInfos[pkgName];

	// De root van de tree representeert de package. We stellen de root hier samen.
	root = createPkgFigure(pkgInfo, false);
		
	// De leaves van de tree representeren de klassen. We stellen de leaves hier samen.
	leaves = [];
	ClassInfoMap classInfos = pkgInfo.classInfos;
	for (classInfo <- range(classInfos)) leaves += createClassFigure(classInfo, true);
	
	// Render een pagina met de boom
	Figure bc1 = breadcrumElement(void(){showProjectTree(projectInfo);}, projectInfo.projName);
	Figure bc2 = breadcrumElement(pkgName);
	renderPage(breadcrumPath([bc1, bc2]), createTree(root, leaves));
}

// Toont een boom van een klasse met de bijbehorende methoden.
private void showClassTree(str pkgName, str classId) {
	ClassInfoTuple classInfo = projectInfo.pkgInfos[pkgName].classInfos[classId];
	
	// De root van de tree representeert de klasse. We stellen de root hier samen.
	root = createClassFigure(classInfo, false);
	
	// De leaves van de tree representeren de units (methoden en constructoren). We stellen de leaves hier samen.
	leaves = [];
	for (unit <- classInfo.units) leaves += createUnitFigure(unit);

	// Render een pagina met de boom
	Figure bc1 = breadcrumElement(void(){showProjectTree(projectInfo);}, projectInfo.projName);
	Figure bc2 = breadcrumElement(void(){showPackageTree(pkgName);}, pkgName);
	Figure bc3 = breadcrumElement(classInfo.className);
	renderPage(breadcrumPath([bc1, bc2, bc3]), createTree(root, leaves));
}

// Rendert een pagina.
private void renderPage(Figure breadcrumPath, Figure tree) {
	Figure title = pageTitle("<projectInfo.projName> - Polymetric Tree");
	
	Figure homeButton = button(void(){visualizeMetrics();}, "Home");
	Figure treeMapViewButton = button(void(){showProjectTreeMap(projectInfo);}, "Switch naar TreeMap"); 
	Figure buttonGrid = grid([[homeButton, treeMapViewButton]], gap(20));
	
	render(grid([[title], [breadcrumPath], [tree], [buttonGrid]], gap(20), vsize(300), hsize(400), resizable(false)));
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
private Figure createPkgFigure(PkgInfoTuple pkgInfo, bool isLeaf) {
	int width = getPackageSize(pkgInfo.codeLines);
	str popupText = "Package: <pkgInfo.pkgName>, " + 
	                "\ntotaal aantal regels (incl lege regels binnen de units): <pkgInfo.totalLines>," + 
	                "\ncommentaarregels: <pkgInfo.commentLines>, " + 
	                "\ncoderegels: <pkgInfo.codeLines>, " + 
	                "\ncomplexity rating: <pkgInfo.complexityRating>. ";
	Color clr = getComplexityRatingIndicationColor(pkgInfo.complexityRating);
	Figure leafbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Click to zoom in.)"), handlePackageClick(pkgInfo.pkgName));
	Figure rootbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Shift-click to zoom out.)"), handlePackageShiftClick());
	Figure t = text(pkgInfo.pkgName);
	if (isLeaf) return hcat([leafbox, t], id(pkgInfo.pkgName), hgap(5));
	return hcat([t, rootbox], id(pkgInfo.pkgName), hgap(5));
}

// Maakt een Figure representatie voor een klasse.
//   - de location van de klasse fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de (gewogen) complexiteit van de klasse.
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
	Figure leafbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Click to zoom in.)"), handleClassClick(pkgName, classId));
	Figure rootbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Shift-click to zoom out.)"), handleClassShiftClick(pkgName));
	Figure t = text(className);
	if (isLeaf) return hcat([leafbox, t], id(classId), hgap(5));
	return hcat([t, rootbox], id(classId), hgap(5)); 
}

// Maak een Figure representatie voor een unit.
//   - de location van de unit fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de complexiteit van de unit.
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
		showPackageTree(pkgName);
		return true;
	});
}

// Handelt een shift-click event af op een package 
private FProperty handlePackageShiftClick() {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) {
			showProjectTree(projectInfo);
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
		showClassTree(pkgName, classId);
		return true;
	});
}

// Handelt een shift-click event af op een klasse 
private FProperty handleClassShiftClick(str pkgName) {
	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
		if (modifiers[modShift()]) {
			showPackageTree(pkgName);
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


