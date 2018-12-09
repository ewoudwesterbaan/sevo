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
    	    	// Default 0
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
    
    void complexityTwentyOne(int c) {
    	switch(c) {
    	case 1:
    		do {
    			System.out.print("Case 1");
    		} while (false);
    		break;
    	case 2:
    		if (true) System.out.print("Case 2");
    		break;
    	case 3:
    		while (true) {
    			System.out.println("Case 3");
    			break;
    		}
    		break;
    	case 4:
    		try {
    			System.out.println("Case 4a");
    		} catch (Exception e) {
    			System.out.println("Case 4b");
    		}
    		break;
    	case 5:
    		if (c == 5) System.out.print("Case 5a");
    		else System.out.print("Case 5b");
    		break;
    	case 6:
    		for (;true;) {
    			System.out.println("Case 6");
    			break;
    		}
    		break;
    	case 7:
    		boolean b7 = (c == 7 && c != 8);
    		System.out.println("Case 7 = " + b7);
    		break;
    	case 8:
    		boolean b8 = (c != 7 || c == 8);
    		System.out.println("Case 8 = " + b8);
    		break;
    	case 9:
    		String[] arr = {"9"};
    		for (String s : arr) {
				System.out.println("Case " + s);
			}
    		break;
    	case 10:
    		System.out.println("Case " + (c == 10 ? c : 0));
    		break;
    	default:
    		break;
    	}
    }
}
