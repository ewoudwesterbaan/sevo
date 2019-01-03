package nl.ou.pkgC.pkgCSub1;

public class Class2PkgASub1 {
	
	public void complexity10(int level) {
		switch (level) {
			case 1 : 
				System.out.println("1");
				break;
			case 2 : 
				System.out.println("2");
				break;
			case 3 : 
				System.out.println("3");
				break;
			case 4 : 
				if (level > 1) System.out.println("Duh");
				else System.out.println("Impossible");
				break;
			case 5 : 
				if (level > 1) System.out.println("Duh");
				else System.out.println("Impossible");
				break;
			case 6 : 
				if (level > 1) System.out.println("Duh");
				else System.out.println("Impossible");
				break;
			default : System.out.println("default");
		}
	}

}
