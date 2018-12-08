class ComplexityTestClass {

	private String aString;
	
    void complexityOne() {
        this.aString = "hello";
    }
    
    void complexityTwo(boolean hello) {
    	if (hello) {
            this.aString = "hello";
    	}
    }
    
    void complexityThree(int n) {
    	switch (n) {
    	    case 1 : 
    	        this.aString = "1";
                break;
    	    case 2 : 
    	        this.aString = "2";
    	        break;
    	    default : 
    		    this.aString = "0";
    		    break;
        }
    }

    void complexityFour() {
    	while (true) {
    		if (true) {
    			for (;true;) {
    				return;
    			}
    		}
    	}
    }
    
    void complexityFive(boolean male, int age) {
    	if (male && (age < 18 || age >= 50)) {
    		return;
    	} else if (!male) {
    		return;
    	}
    	aString = "Male between 18 and 50";
    }

    void complexitySix(boolean male, int age) {
    	if ((male && age < 18) || (male && age >= 50)) {
    		return;
    	} else if (!male) {
    		return;
    	}
    	aString = "Male between 18 and 50";
    }
}
