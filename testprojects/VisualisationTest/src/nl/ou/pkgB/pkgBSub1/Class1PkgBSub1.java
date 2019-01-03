package nl.ou.pkgB.pkgBSub1;

public class Class1PkgBSub1 {
	
	public void complexity1(int level) {
		System.out.println("1");
	}

	public void complexity2(int level) {
		switch (level) {
			case 1 : System.out.println("1"); break;
			default : System.out.println("default"); break;
		}
	}

	public void complexity3(int level) {
		switch (level) {
			case 1 : System.out.println("1"); break;
			case 2 : System.out.println("2"); break;
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
