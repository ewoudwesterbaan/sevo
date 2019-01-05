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

// Toont alle packages in het project (zonder de bijbhorende klassen). 
// De grootte van de nodes is afhankelijk van het aantal lines of code.
// De kleur van de nodes is afhankelijk van de (gewogen) complexiteit.
public void showProjectTree(loc project) {
	// Eenmalig vullen van de private attributen
	projectInfo = getProjectInfoTupleFromPkgInfoMap(project, getPkgInfoMapFromClassInfoMap(getClassInfo(project)));
	PkgInfoMap pkgInfo = projectInfo.pkgInfo;

	// De root van de tree representeert het project.
	root = createProjectFigure();
	// De leaves van de tree representeren de packages. We stellen de leaves hier samen.
	leaves = [];
	for (pkgName <- pkgInfo) leaves += createPkgFigure(pkgName, true);
	
	// Render een pagina met de boom
	renderPage(createTree(root, leaves));
}

// Toont een boom van een package met de bijbehorende klassen.
// De grootte van de nodes is afhankelijk van het aantal lines of code.
// De kleur van de nodes is afhankelijk van de (gewogen) complexiteit.
private void showPackageTree(str packageName) {
	PkgInfoMap pkgInfo = projectInfo.pkgInfo;
	for (pkgName <- pkgInfo) {
		// Filter op packagenaam
		if (pkgName != packageName) continue;
		
		// De root van de tree representeert de package. We stellen de root hier samen.
		root = createPkgFigure(pkgName, false);
		
		// De leaves van de tree representeren de klassen. We stellen de leaves hier samen.
		leaves = [];
		for (classInfoTuple <- pkgInfo[pkgName]) {
			leaves += createClassFigure(classInfoTuple, true);
		}
		
		// Render een pagina met de boom
		renderPage(createTree(root, leaves));
		return;
	}	
}

// Toont een boom van een klasse met de bijbehorende methoden.
// De grootte van de nodes is afhankelijk van het aantal lines of code.
// De kleur van de nodes is afhankelijk van de (gewogen) complexiteit.
private void showClassTree(str pkgName, str classId) {
	ClassInfoMap classInfo = projectInfo.pkgInfo[pkgName];
	for (clazz <- classInfo) {
		// Filter op classId (location)
		if (classId != "<clazz.location>") continue;
	
		// De root van de tree representeert de klasse. We stellen de root hier samen.
		root = createClassFigure(clazz, false);
		
		// De leaves van de tree representeren de units (methoden en constructoren). We stellen de leaves hier samen.
		leaves = [];
		for (unit <- classInfo[clazz]) leaves += createUnitFigure(unit);

		// Render een pagina met de boom
		renderPage(createTree(root, leaves));
		return;
	}	

}

// Rendert een pagina.
private void renderPage(Figure tree) {
	Figure title = pageTitle("<projectInfo.projName> - Polymetric Tree");
	Figure homeButton = button(void(){visualizeMetrics();}, "Home");
	Figure treeMapViewButton = button(void(){showProjectTreeMap(projectInfo.project);}, "Switch naar TreeMap"); 
	Figure buttonGrid = grid([[homeButton, treeMapViewButton]], gap(20));
	render(grid([[title], [tree], [buttonGrid]], gap(20), vsize(300), hsize(400), resizable(false)));
}

// Maakt een boom met de opgegeven root en leaves.
// Er wordt een aantal standaard properties aan de tree toegevoegd (grootte, tussenruimte, orientatie, ...)
// De orientatie is leftRight, en de bomen worden links uitgelijnd.
private Figure createTree(Figure root, list[Figure] leaves) {
	return tree(root, leaves, std(size(30)), std(hgap(30)), std(vgap(2)), orientation(leftRight()), left());
}

// Maakt een Figure representatie voor een project.
private Figure createProjectFigure() {
	int width = 40; // TODO
	str popupText = "Project: <projectInfo.projName>. "; // TODO: volume en complexiteit rank in de popup opnemen.
	Color clr = getProjectRankIndicationColor(projectInfo.riskRank); 
	Figure b = box(size(width, 10), fillColor(clr), popup(popupText));
	Figure t = text(projectInfo.projName);
	return hcat([t, b], id(projectInfo.projName), hgap(5));
}

// Maakt een Figure representatie voor een package.
private Figure createPkgFigure(str pkgName, bool isLeaf) {
	int width = 40; // TODO
	str popupText = "Package: <pkgName>. "; // TODO: volume en gewogen complexiteit in de popup opnemen.
	Color clr = getPkgFillColor(1); // TODO
	Figure leafbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Click to zoom in.)"), handlePackageClick(pkgName));
	Figure rootbox = box(size(width, 10), fillColor(clr), popup("<popupText>\n(Shift-click to zoom out.)"), handlePackageShiftClick());
	Figure t = text(pkgName);
	if (isLeaf) return hcat([leafbox, t], id(pkgName), hgap(5));
	return hcat([t, rootbox], id(pkgName), hgap(5));
}

// Maakt een Figure representatie voor een klasse.
//   - de location van de klasse fungeert als id, 
//   - de breedte is afhankelijk van het aantal codeLines,
//   - de kleur is afhankelijk van de (gewogen) complexiteit van de klasse.
private Figure createClassFigure(ClassInfoTuple clazz, bool isLeaf) {
	str classId = "<clazz.location>";
	str className = clazz.className;
	str pkgName = clazz.pkgName == "" ? "\<root\>" : clazz.pkgName;
	int width = getClassSize(clazz.codeLines);
	str popupText = "Class: <className>, LOC: <clazz.codeLines>, weighed complexity: <clazz.avgComplexity>. ";
	Color clr = getClassFillColor(clazz.avgComplexity);
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
private Figure createUnitFigure(UnitInfoTuple unit) {
	str unitId = "<unit.location>";
	str unitName = unit.unitName;
	int width = getUnitSize(unit.codeLines);
	str risk = unit.risk;
	str popupText = "Unit: <unitName>, LOC: <unit.codeLines>, cyclomatische complexiteit: <unit.complexity>, risico-inschatting: \"<risk>\"";
	Color clr = getUnitRiskIndicationColor(unit.complexity);
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
			showProjectTree(projectInfo.project);
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

// Bepaalt de kleur van een package figure op basis van de gewogen complexity
private Color getPkgFillColor(int avgComplexity) {
	return getFillColor(avgComplexity, "gray");
}

// Bepaalt de kleur van een klasse figure op basis van de gewogen complexity
private Color getClassFillColor(int avgComplexity) {
	return getFillColor(avgComplexity, "gray");
}

// Bepaalt de kleur van een figuur op basis van de complexity en een basiskleur
private Color getFillColor(int complexity, str baseColor) {
	real gradient = 0.65 / (complexity < 1 ? 1 : complexity);
	return color(baseColor, 1 - gradient);
}

// Bepaalt de grootte van een unit op basis van de lines of code
private int getUnitSize(int codeLines) {
	return 25 + codeLines / 2;
}

// Bepaalt de grootte van een class op basis van de lines of code
private int getClassSize(int codeLines) {
	return 25 + codeLines / 6;
}


