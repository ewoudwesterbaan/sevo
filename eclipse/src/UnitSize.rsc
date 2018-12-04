module UnitSize

import IO;
import Relation;
import Map;
import Set;
import List;
import String;
import util::Resources;
import lang::java::jdt::m3::Core;

public void unitSizeMetrics() {
	M3 model = createM3FromEclipseProject(|project://smallsql/|);
	rel[loc c, loc m] units = getUnits(model);
	rel[loc unit, int totalLines, int nonEmptyLines, int commentLines, int codeLines] unitSizeMetrics = {processUnit(m) | <c, m> <- units};
	println(unitSizeMetrics);
}

// Haal metrieken uit een unit (methode)
//     unit: de location van de unit
//     totalLines: Totaal van regels in de unit
//     nonEmptyLines: Niet lege regels
//     commentLines: Aantal regels commentaar
//     codeLines: Aantal regels code
//
private tuple[loc unit, int totalLines, int nonEmptyLines, int commentLines, int codeLines] processUnit(loc unit) {
	int totalLines = size(readFileLines(unit));
	// een lijst van niet lege regels waarvan de voor en eind lege string verwijderd is.
	list[str] noWhiteSpace = [ trim(b) | b <- readFileLines(unit), trim(b) != ""];
	int nonEmptyLines = size(noWhiteSpace);

	// als een regels start met '//', '/*' of '*' dan beschouwen we dat als commentaar
	list[str] comments = [ c | c <- noWhiteSpace,  startsWith(c, "//") 
													   || startsWith(c, "/*")
													   || startsWith(c, "*")];
	int commentLines = size(comments);
	int codeLines = nonEmptyLines - commentLines;
	return <unit, totalLines, nonEmptyLines, commentLines, codeLines>;
}

// Haal alle methoden en constructoren op, per java-klasse
//     c = klasse
//     m = methode
private rel[loc, loc] getUnits(M3 model) {
	return { <c,m> | <c,m> <- model.containment,
	                 c.scheme  == "java+class", 
	                 m.scheme == "java+method" || 
	                 m.scheme == "java+constructor" };
}


