module metrics::Complexity

import utils::Utils;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import Boolean;
import IO;
import List;
import Set;

// Tuple van unit met cyclomatische complexiteit
public alias TupComplexity = tuple[loc location, str unitName, int complexity, str riskCategory];
// Set van bovenstaande complexity tuples (relatie)
public alias RelComplexities = rel[loc location, str unitName, int complexity, str riskCategory];

// Tuple voor risicocategorie voor de complexiteit
public alias TupComplexityRiskCategory = tuple[str categoryName, str description, int minComplexity, int maxComplexity];
// Relatie van risicocategorieen voor de complexiteit
public alias RelComplexityRiskCategories = rel[str categoryName, str description, int minComplexity, int maxComplexity];

// Risicocategorieen
public RelComplexityRiskCategories riskCategories = {
	<"Simple", "Without much risk", 1, 10>,
	<"Moderate", "With moderate risk", 11, 20>,
	<"Complex", "Complex, with high risk", 21, 50>,
	<"Untestable", "Untestable, very high risk", 50, -1>
};

// Geeft van alle methodes en constructoren van alle klassen in een project de complexity en risk category
//    project - het (Java-)project dat moet worden geanalyseerd
public RelComplexities cyclomaticComplexity(loc project) {
    RelComplexities result = {};
    for (Declaration ast <- createAstsFromEclipseProject(project, true)) { 
        // Voor constructoren en methodes gaan we de complexity bepalen.
        visit(ast) {
            case \constructor(name, _, _, impl) : result += getUnitComplexity(name, impl);
            case \method(_, name, _, _, impl) : result += getUnitComplexity(name, impl);
        }
    }
    return result;
}

// Geeft de complexiteitsmaat van een unit
//   unitName -  de naam van de unit (methode of constructor)
//   stat - de implementatie van de unit (een Statement)
private TupComplexity getUnitComplexity(str unitName, Statement stat) {
    int complexity = 1;
    visit(stat) {
        case \case(_) : complexity += 1;
        case \do(_, _) : complexity += 1;
        case \if(_, _) : complexity += 1;
        case \catch(_,_): complexity += 1;
        case \while(_, _) : complexity += 1;
        case \if(_, _, _) : complexity += 1;
        case \for(_, _, _) : complexity += 1;
        case infix(_,"&&",_) : complexity += 1;
        case infix(_,"||",_) : complexity += 1;    
        case \for(_, _, _, _) : complexity += 1;
        case \foreach(_, _, _) : complexity += 1;
        case \conditional(_,_,_): complexity += 1;
    }
    return <stat.src, unitName, complexity, getCategoryName(complexity)>; 
}

// Geeft de risicocategorienaam terug bij een complexiteitsmaat
public str getCategoryName(int complexityMeasure) {
	return head([riskCategory.categoryName | riskCategory <- riskCategories, 
		complexityMeasure >= riskCategory.minComplexity, 
		complexityMeasure <= riskCategory.maxComplexity || 
		-1 == riskCategory.maxComplexity]
	);
}

// Geeft de risico-omschrijving terug bij een complexiteitsmaat
public str getCategoryDescription(int complexityMeasure) {
	return head([riskCategory.description | riskCategory <- riskCategories, 
		complexityMeasure >= riskCategory.minComplexity, 
		complexityMeasure <= riskCategory.maxComplexity || 
		-1 == riskCategory.maxComplexity]
	);
}

// Geeft een tupel met complexiteitsrisicogegevens terug op basis van de categorienaam
public TupComplexityRiskCategory getTupRiskCategoryByCategoryName(str name) {
	return head([riskCategory | riskCategory <- riskCategories, name == riskCategory.categoryName]);	
}

// Geeft de complexity metric terug voor een bepaalde unit
public int getComplexityMetric(RelComplexities complexities, loc unit) {
	return head([complexity.complexity | complexity <- complexities, complexity.location == unit]);
}

