module utils::Utils

import IO;
import String;
import List;
import Boolean;

// Tuple van locatie met metrieken
public alias TupLinesOfCode = tuple[loc location, int totalLines, int commentLines, int codeLines];
// Set van bovenstaance tuples (relatie)
public alias RelLinesOfCode = rel[loc location, int totalLines, int commentLines, int codeLines];

// Haal metrieken uit een locatie
// Geeft een tuple terug met de volgende attributen:
//     location: Locatie waarover de metrieken berekent zijn
//     totalLines: Totaal van regels in een locatie
//     commentLines: Aantal regels commentaar
//     codeLines: Aantal regels code
//
public TupLinesOfCode getLinesOfCode(loc location) {
	int totalLines = size(readFileLines(location));

	// alle characters tussen (en inclusief) /* en */ is block commentaar
	list[str] blockComments = [ bc | /<bc:(?s)\/\*.*?\*\/>/ := readFile(location)];
	
	// nieuwe content opbouwen waarbij we de blockcommentaar eruit halen
	str totalContent = readFile(location);
	for (bc <- blockComments) {
		totalContent = replaceAll(totalContent, bc, "");
	};
	
	// split the content in aparte regels, nu hebben we de code en de linecomments over
	list[str] contentInStrings = [l | /<l:.*>/ := totalContent, !isEmpty(trim(l))];
	
	// als een regels start met '//' is dat line commentaar
	// inline commentaar wordt hier niet meegenomen
	int lineComments = size([ c | c <- contentInStrings,  startsWith(trim(c), "//")]);

	// De codeLines hier kunnen inline commentaar bevatten. Dit maakt voor de metriek niet uit.
	int codeLines = size(contentInStrings) - lineComments;
	
	// We moeten de blockcomment splitsen in regels om de size te bepalen
	int blockCommentsLines = 0;
	for (bc <- blockComments)
	{
		blockCommentsLines += size([l | /<l:.*>/ := bc, !isEmpty(trim(l))]);
	}
	int commentLines = lineComments + blockCommentsLines;

	return <location, totalLines, commentLines, codeLines>;
}