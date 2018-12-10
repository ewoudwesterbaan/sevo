module metrics::Complexity

import utils::Utils;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import Boolean;
import IO;
import List;
import Set;

// Geeft van alle methdodes en constructoren van alle klassen in een project de complexiteismaten
//    project - het (Java-)project dat moet worden geanalysseerd
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
    // TODO CC risk evaluation
    return <stat.src, unitName, complexity>; 
}

