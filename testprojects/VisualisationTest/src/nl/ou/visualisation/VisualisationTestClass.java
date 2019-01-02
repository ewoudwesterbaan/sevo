package nl.ou.visualisation;

import nl.ou.visualisation.complexity.ComplexityTestClass;

public class VisualisationTestClass {
	
	private ComplexityTestClass complexity = new ComplexityTestClass();
	
	public void complexity(int level) {
		switch (level) {
			case 1 : complexity.complexityOne();
			case 2 : complexity.complexityTwo(true);
			case 3 : complexity.complexityThree(1);
			case 4 : complexity.complexityFour();
			case 6 : complexity.complexitySix(true, 53);
			case 20 : complexity.complexityTwenty(1);
			case 21 : complexity.complexityTwentyOne(2);
			default : complexity.complexityFiftyOne(3);
		}
	}

}
