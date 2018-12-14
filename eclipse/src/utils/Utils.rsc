module utils::Utils

import IO;
import String;
import List;
import Boolean;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

// Tuple van locatie met metrieken
public alias TupLinesOfCode = tuple[loc location, int totalLines, int commentLines, int codeLines];
// Set van bovenstaande tuples (relatie)
public alias RelLinesOfCode = rel[loc location, int totalLines, int commentLines, int codeLines];

// Set van duplicaties
public alias RelDuplications = rel[loc methodA, loc methodB, int methodA_start, int duplicateLines];

// Haal alle methoden en constructoren op, per java-klasse, op basis van het project (een location)
//     c = klasse
//     m = methode
public rel[loc, loc] getUnits(loc project) {
	rel[loc, loc] result = {};	
    for (Declaration ast <- createAstsFromEclipseProject(project, true)) {
    	// Class locatie
    	loc c = ast.src; 
        // We halen de locaties van de constructoren en methodes op.
        visit(ast) {
            case \constructor(name, _, _, impl) : result += <c, impl.src>;
            case \method(_, name, _, _, impl) : result += <c, impl.src>;
        }
    }
    return result;
}

// Haal metrieken uit een locatie
// Geeft een tuple terug met de volgende attributen:
//     location: Locatie waarover de metrieken berekend zijn
//     totalLines: Totaal van regels in een locatie
//     commentLines: Aantal regels commentaar
//     codeLines: Aantal regels code
//
public TupLinesOfCode getLinesOfCode(loc location) {
	// bepalen van het totaal aantal regels
	list[str] rawContent = readFileLines(location);
	int totalLines = size(rawContent);
	
	// als een regels start met '//' is dat line commentaar
	// inline commentaar wordt hier niet meegenomen
	int lineComments = size([ c | c <- rawContent,  startsWith(trim(c), "//")]);

	// De codeLines hier kunnen inline commentaar bevatten. Dit maakt voor de metriek niet uit.
	int codeLines = size(cleanContent(location));
	
	// We moeten de blockcomment splitsen in regels om de size te bepalen
	int blockCommentsLines = 0;
	for (bc <- getBlockComments(location))
	{
		blockCommentsLines += size([l | /<l:.*>/ := bc, !isEmpty(trim(l))]);
	}
	int commentLines = lineComments + blockCommentsLines;

	return <location, totalLines, commentLines, codeLines>;
}

private list[str] getBlockComments(loc location) {
	// alle characters tussen (en inclusief) /* en */ is block commentaar
	list[str] blockComments = [ bc | /<bc:(?s)\/\*.*?\*\/>/ := readFile(location)];
	return blockComments;	
}

public list[str] cleanContent(loc location) {
	// nieuwe content opbouwen waarbij we de blockcommentaar eruit halen
	str totalContent = readFile(location);
	for (bc <- getBlockComments(location)) {
		totalContent = replaceAll(totalContent, bc, "");
	};
	// split the content in aparte regels, nu hebben we de code en de linecomments over
	// en haal de lege ruimte voor en na de string weg
	list[str] contentInStringsBeforeLineComments = [trim(l) | /<l:.*>/ := totalContent, !isEmpty(trim(l))];
	// verwijder de linecomments
	list[str] cleanedContent = [cleanLineComment(x) | x <- contentInStringsBeforeLineComments, !startsWith(x, "//")];
	return cleanedContent;
}

// Haalt het commentaar uit de regel
// Geeft zo snel mogelijk een resultaat terug
// Let op! commentaar regels die beginnen met // zullen niet goed gaan!
public str cleanLineComment(str input) {
	if (contains(input, "//")) {
		list[str] strParts = split("//", input);
		// Deel heeft ook contain deel, zodat sneller resultaat terug gegeven wordt
		if (size(strParts) == 2 
			&& (
				!contains(strParts[0], "\"") 
				|| 
				size(findAll(replaceAll(strParts[0], "\\\"", ""), "\"")) % 2 == 0)
				) {
			return trim(strParts[0]);
		};
		str returnValue = "";
		int totaalAantalQuotes = 0;
		for (int i <- index(strParts)) {
			str s = strParts[i];
			// vervangen van de geescapde quotes door niets
			t = replaceAll(s, "\\\"", "");
			int aantalQuotesDeel = size(findAll(t, "\""));
			totaalAantalQuotes += aantalQuotesDeel;
			returnValue = returnValue + s + "//";
			// Als het totaal aantal quotes even is, is alles wat na de // komt commentaar
			if (totaalAantalQuotes % 2 == 0) {
				break;
			};
		};
		return trim(substring(returnValue, 0, size(returnValue) - 2));
	};
	return input;
}

