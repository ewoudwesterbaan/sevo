package nl.ou.packageMinus.subpackagePlusPlus;

public class RankPlusPlus2 {
	
	public void complexity3(int level) {
		switch (level) {
			case 1 : System.out.println("1"); break;
			case 2 : System.out.println("2"); break;
			default : System.out.println("default"); break;
		}
	}

	public void complexity6(int level) {
		switch (level) {
			case 1 : System.out.println("1"); break;
			case 2 : System.out.println("2"); break;
			case 4 : System.out.println("4"); break;
			case 3 : System.out.println("3"); break;
			default : System.out.println(level > 9 ? "default" : "DEFAULT"); break;
		}
	}

	public void complexity7(int level) {
		if (level == 1 || level == 2 || level == 3) {
			switch (level) {
				case 1 : System.out.println("1"); break;
				case 2 : System.out.println("2"); break;
				case 3 : System.out.println("3"); break;
				default : System.out.println("default"); break;
			}
		}
	}
	
}
