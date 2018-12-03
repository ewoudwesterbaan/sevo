module Volume

//import Generic;
import util::Resources;
import Set;
import List;
import IO;
import Map;
import String;
import Relation;

public void main() {
	Resource r = getProject(|project://smallsql/|);
	set[loc] javaFiles = { a | /file(a) <- r, a.extension == "java" };
	//for (file <- javaFiles) processFile(file);
	rel[loc file,int nonEmptyLines, int totalLines, int commentLines,int codeLines] relLineCounts = { processFile(file) | file <- javaFiles };
	println(relLineCounts);
}

// Haal metrieken uit een file
//     totalLines: Totaal van regels in een bestand
//     nonEmptyLines: Niet lege regels
//     commentLines: Aantal regels commentaar
//     codeLines: Aantal regels code
//
public tuple[loc file, int totalLines, int nonEmptyLines, int commentLines, int codeLines] processFile(loc file) {
	int totalLines = size(readFileLines(file));
	// een lijst van niet lege regels waarvan de voor en eind lege string verwijderd is.
	list[str] noWhiteSpace = [ trim(b) | b <- readFileLines(file), trim(b) != ""];
	int nonEmptyLines = size(noWhiteSpace);

	// als een regels start met '//', '/*' of '*' dan beschouwen we dat als commentaar
	list[str] comments = [ c | c <- noWhiteSpace,  startsWith(c, "//") 
													   || startsWith(c, "/*")
													   || startsWith(c, "*")];
	int commentLines = size(comments);
	int codeLines = nonEmptyLines - commentLines;
	return <file, totalLines, nonEmptyLines, commentLines, codeLines>;
}
