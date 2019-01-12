package nl.ou.packagePlus.subpackageZero;

public class RankZero {
	
	public void complexity1(int level) {
		complexity11(1);
		complexity11(2);
		complexity11(3);
		complexity11(4);
		complexity11(5);
		complexity11(6);
		complexity11(7);
		complexity11(8);
		complexity11(9);
		complexity11(10);
		complexity11(11);
		complexity11(12);
		complexity11(13);
		complexity11(14);
		complexity11(15);
		complexity11(16);
	}
	
	public void complexity11(int level) {
		while (level < 99) {
			switch (level) {
				case 1 : System.out.println("1"); break;
				case 2 : System.out.println("2"); break;
				case 3 : System.out.println("3"); break;
				case 4 : System.out.println("4"); break;
				case 5 : System.out.println("5"); break;
				case 6 : System.out.println("6"); break;
				case 7 : System.out.println("7"); break;
				case 8 : System.out.println("8"); break;
				case 9 : System.out.println("9"); break;
				default : System.out.println("default"); break;
			}
		}
	}

}
