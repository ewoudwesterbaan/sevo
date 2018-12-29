module visualisation::PolyMetricViewExercise

import vis::Figure;
import vis::Render;

private alias UnitInfoTuple = tuple[loc location, str unitName, int complexity, int codeLines];
private alias UnitInfoRel = rel[loc location, str unitName, int complexity, int codeLines];
private alias ClassInfoTuple = tuple[loc location, str className];
private alias ClassInfoMap = map[ClassInfoTuple clazz, UnitInfoRel units];

// Toont een graaf van alle klassen met hun methoden
public void showGraph() {
	nodes = [];
	edges = [];

	// Verzamel info van alle klassen
	ClassInfoMap classInfo = createTestClassInfoMap();
	
	for (clazz <- classInfo) {
		// Voeg klasse toe aan de graaf
		str classId = "<clazz.location>";
		str className = clazz.className;
		UnitInfoRel units = classInfo[clazz];
		nodes += vcat([text(className), box(size(30), fillColor(getClassFillColor()))], id(classId));

		// Voeg de units in de klasse (en hun onderlinge relaties) toe aan de graaf
		for (unit <- units) {
			str unitId = "<unit.location>";
			str unitName = unit.unitName;
			int height = getUnitHeight(unit.codeLines);
			Color clr = getUnitFillColor(unit.complexity);
	        nodes += vcat([box(size(10, height), fillColor(clr)), text(unitName, textAngle(90))], id(unitId));
			edges += edge(classId, unitId);
		}
	}	

	// Render de gegereerde graaf	
	render(graph(nodes, edges, hint("layered"), gap(50)));
}

// Bepaalt de kleur van een unit op basis van de complexity
private Color getUnitFillColor(int complexity) {
	real gradient = 0.2 + (0.8 / complexity);
	return gray(gradient);
}

// Bepaalt de hoogte van een unit op basis van de lines of code
private Color getUnitHeight(int codeLines) {
	return 30 + codeLines / 2;
}

// Bepaalt de kleur van een klasse
private Color getClassFillColor() {
	return color("lightgreen");
}

// Vult een ClassInfoMap met testdata
private ClassInfoMap createTestClassInfoMap() {
	loc dummyLoc1 = |project://Dummy/src/Dummy.java|(2967,604,<107,46>,<126,1>);
	loc dummyLoc2 = |project://Dummy/src/Dummy.java|(2967,604,<107,46>,<126,2>);
	loc dummyLoc3 = |project://Dummy/src/Dummy.java|(2967,604,<107,46>,<126,3>);
	loc dummyLoc4 = |project://Dummy/src/Dummy.java|(2967,604,<107,46>,<126,4>);
	loc dummyLoc5 = |project://Dummy/src/Dummy.java|(2967,604,<107,46>,<126,5>);
	loc dummyLoc6 = |project://Dummy/src/Dummy.java|(2967,604,<107,46>,<126,6>);

	UnitInfoTuple unit1 = <dummyLoc1, "methodA1", 1, 1>;
	UnitInfoTuple unit2 = <dummyLoc2, "methodA2", 2, 5>;
	UnitInfoRel unitsA = {unit1, unit2};
	ClassInfoTuple clazzA = <dummyLoc5, "MyTestClassA">;

	UnitInfoTuple unit3 = <dummyLoc3, "methodB1", 1, 10>;
	UnitInfoTuple unit4 = <dummyLoc4, "methodB2", 8, 45>;
	UnitInfoRel unitsB = {unit3, unit4};
	ClassInfoTuple clazzB = <dummyLoc6, "MyTestClassB">;

	return (clazzA : unitsA, clazzB : unitsB);
}
