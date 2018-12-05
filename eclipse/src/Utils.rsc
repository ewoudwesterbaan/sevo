module Utils

import IO;
import String;
import List;

// Tuple van locatie met metrieken
alias LocationData = tuple[loc location, int totalLines, int nonEmptyLines, int commentLines, int codeLines];
// Set van bovenstaance tuples (relatie)
alias LocationMetrics = rel[loc unit, int totalLines, int nonEmptyLines, int commentLines, int codeLines];

// Haal metrieken uit een locatie
// Geeft een tuple terug met de volgende attributen:
//     location: Locatie waarover de metrieken berekent zijn
//     totalLines: Totaal van regels in een locatie
//     nonEmptyLines: Niet lege regels
//     commentLines: Aantal regels commentaar
//     codeLines: Aantal regels code
//
public LocationData processLocation(loc location) {
	int totalLines = size(readFileLines(location));
	// een lijst van niet lege regels waarvan de voor en eind lege string verwijderd is.
	list[str] noWhiteSpace = [ trim(b) | b <- readFileLines(location), trim(b) != ""];
	int nonEmptyLines = size(noWhiteSpace);

	// als een regels start met '//', '/*' of '*' dan beschouwen we dat als commentaar
	list[str] comments = [ c | c <- noWhiteSpace,  startsWith(c, "//") 
													   || startsWith(c, "/*")
													   || startsWith(c, "*")];
	int commentLines = size(comments);
	int codeLines = nonEmptyLines - commentLines;
	return <location, totalLines, nonEmptyLines, commentLines, codeLines>;
}