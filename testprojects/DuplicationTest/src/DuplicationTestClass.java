 
public class DuplicationTestClass {
	
	// Methode om andere methodes mee te vergelijken.
	// Minimaal 6 regels code
	void baseMethod() {
		System.out.println("Start");
		String s = "HelloWorld";
		for (int x = 0; x <= 1; x++) {
			System.out.println(s + " " + x);
		}
		System.out.println("End method");
	}
	
	// Exact gelijk
	void duplicationTestEquals_ExpectTrue() {
		System.out.println("Start");
		String s = "HelloWorld";
		for (int x = 0; x <= 1; x++) {
			System.out.println(s + " " + x);
		}
		System.out.println("End method");
	}
	
	// Eerste deel gelijk
	void duplicationTestFirstPartEquals_ExpectTrue() {
		System.out.println("Start");
		String s = "HelloWorld";
		for (int x = 0; x <= 1; x++) {
			System.out.println(s + " " + x);
		}
		System.out.println("End method");
		int b = 2;
		System.out.println(b);
	}
	
	// Laatste deel gelijk
	void duplicationTestLastPartEquals_ExpectTrue() {
		String a = "onzin";
		System.out.println("Hier print ik ongelooflijke " + a);
		System.out.println("Start");
		String s = "HelloWorld";
		for (int x = 0; x <= 1; x++) {
			System.out.println(s + " " + x);
		}
		System.out.println("End method");
	}
	
	// In het midden een deel gelijk
	void duplicationTestContains_ExpectTrue() {
		String a = "onzin";
		System.out.println("Hier print ik ongelooflijke " + a);
		System.out.println("Start");
		String s = "HelloWorld";
		for (int x = 0; x <= 1; x++) {
			System.out.println(s + " " + x);
		}
		System.out.println("End method");
		int b = 2;
		System.out.println(b);
	}

	// In het midden een verandering. (x en s omgedraaid).
	void duplicationTestChangeInMid_ExpectFalse() {
		System.out.println("Start");
		String s = "HelloWorld";
		for (int x = 0; x <= 1; x++) {
			System.out.println(x + " " + s);
		}
		System.out.println("End method");
	}
	
	// Begin start met een paar keer dezelfde regel
	void duplicationTestFirstRowRepeat_ExpectTrue() {
		System.out.println("Start");
		System.out.println("Start");
		System.out.println("Start");
		System.out.println("Start");
		String s = "HelloWorld";
		for (int x = 0; x <= 1; x++) {
			System.out.println(s + " " + x);
		}
		System.out.println("End method");
	}

}
