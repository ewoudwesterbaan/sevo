package nl.ou.packagePlus.subpackageZero;

public class RankMinusMinus {
	
	public void complexity25(int level1, int level2) {
		if (level1 > level2 || level2 > level1 || (level1 > 9 && level2 < 10) || (level1 > 8 && level2 < 9) || (level1 > 9 && level2 < 7) || (level1 > 9 && level2 < 13) || (level1 > 10 && level2 < 6) || (level1 > 8 && level2 < 8)) {
			switch (level1) {
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
