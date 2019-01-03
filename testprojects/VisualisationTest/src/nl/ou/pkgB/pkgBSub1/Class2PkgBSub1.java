package nl.ou.pkgB.pkgBSub1;

public class Class2PkgBSub1 {
	
	public void complexity1(int level) {
		complexity8(1);
	}
	
	public void complexity8(int level) {
		while (level < 99) {
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
	}

}
