package nl.ou.pkgA.pkgASub1;

public class Class2PkgASub1 {
	
	public void complexity7(int level) {
		switch (level) {
			case 1 : System.out.println("1"); break;
			case 2 : System.out.println("2"); break;
			case 3 : System.out.println("3"); break;
			case 4 : System.out.println("4"); break;
			case 5 : System.out.println("5"); break;
			case 6 : System.out.println("6"); break;
			default : System.out.println("default"); break;
		}
	}

	public void complexity4(int level) {
		switch (level) {
			case 1 : System.out.println("1"); break;
			case 2 : System.out.println("2"); break;
			case 3 : System.out.println("3"); break;
			default : System.out.println("default"); break;
		}
	}

	public void complexity8(int level) {
		if (level == 1 || level == 2 || level == 3 || level == 4) {
			switch (level) {
				case 1 : System.out.println("1"); break;
				case 2 : System.out.println("2"); break;
				case 3 : System.out.println("3"); break;
				default : System.out.println("default"); break;
			}
		}
	}
	
}
