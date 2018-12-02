module Volume

import Generic;
import util::Resources;
import Set;
import List;
import IO;
import Map;
import String;

public bool aflopend(tuple[&a, num] x, tuple[&a, num] y) {
	return x[1] > y[1];
}

public void main() {
	Resource r = getProject(|project://smallsql/|);
	set[loc] javaFiles = { a | /file(a) <- r, a.extension == "java" };
	for (file <- javaFiles) processFile(file);

}

// Haal metrieken uit een file
//     totalLines: totaal van regels in een bestand
//     
public void processFile(loc file) {
	println("Processing: <file>");
	int totalLines = size(readFileLines(file));
	println("Totaal regels: <totalLines>");
	// een lijst van niet lege regels waarvan de voor en eind lege string verwijderd is.
	list[str] noWhiteSpace = [ trim(b) | b <- readFileLines(file), trim(b) != ""];
	int nonEmptyLines = size(noWhiteSpace);
	println("Totaal niet lege regels: <nonEmptyLines>");
	
	list[str] comments = [ c | c <- noWhiteSpace,  startsWith(c, "//") 
													   || startsWith(c, "/*")
													   || startsWith(c, "*")
													   || startsWith(c, "/*")];
	int commentLines = size(comments);
	println("Totaal commentaar: <commentLines>");

	int codeLines = nonEmptyLines = commentLines;
	
	
	// [print(l) | l <- noWhiteSpace];
}

// public void test() {
// 	project = getProject(|project://smallsql/|);
// }

