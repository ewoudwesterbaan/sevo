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
    
    void complexityTwenty(int c) {
    	switch(c) {
    	case 1: break;
    	case 2: break;
    	case 3: break;
    	case 4: break;
    	case 5: break;
    	case 6: break;
    	case 7: break;
    	case 8: break;
    	case 9: break;
    	case 10: break;
    	case 11: break;
    	case 12: break;
    	case 13: break;
    	case 14: break;
    	case 15: break;
    	case 16: break;
    	case 17: break;
    	case 18: break;
    	case 19: break;
    	default: break;
    	}
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

    void complexityFiftyOne(int c) {
    	switch(c) {
    	case 1: break;
    	case 2: break;
    	case 3: break;
    	case 4: break;
    	case 5: break;
    	case 6: break;
    	case 7: break;
    	case 8: break;
    	case 9: break;
    	case 10: break;
    	case 11: break;
    	case 12: break;
    	case 13: break;
    	case 14: break;
    	case 15: break;
    	case 16: break;
    	case 17: break;
    	case 18: break;
    	case 19: break;
    	case 20: break;
    	case 21: break;
    	case 22: break;
    	case 23: break;
    	case 24: break;
    	case 25: break;
    	case 26: break;
    	case 27: break;
    	case 28: break;
    	case 29: break;
    	case 30: break;
    	case 31: break;
    	case 32: break;
    	case 33: break;
    	case 34: break;
    	case 35: break;
    	case 36: break;
    	case 37: break;
    	case 38: break;
    	case 39: break;
    	case 40: break;
    	case 41: break;
    	case 42: break;
    	case 43: break;
    	case 44: break;
    	case 45: break;
    	case 46: break;
    	case 47: break;
    	case 48: break;
    	case 49: break;
    	case 50: break;
    	default: break;
    	}
    }

}
