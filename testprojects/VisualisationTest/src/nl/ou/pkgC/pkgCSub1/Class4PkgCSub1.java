package nl.ou.pkgC.pkgCSub1;

public class Class4PkgCSub1 {
	
	public void complexity2(int level) {
		switch (level) {
			case 1 : 
				System.out.println("1");
				break;
			default : 
				System.out.println("default");
				break;
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
	
	public void complexity9(int level) {
		if (level > 1) {
			if (level < 10) {
				for (int i = level; i < 100; i++) {
					if (i > 1 || i < 10) {
						switch (i) {
							case 1 : System.out.println("1"); break;
							case 2 : System.out.println("2"); break;
							case 3 : System.out.println("3"); break;
							default : System.out.println("default"); break;
						}
					}
				}
			}
		}
	}
}
