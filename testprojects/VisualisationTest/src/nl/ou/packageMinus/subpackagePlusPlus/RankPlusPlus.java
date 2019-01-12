package nl.ou.packageMinus.subpackagePlusPlus;

public class RankPlusPlus {
	
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
	
	public void complexity1() {
		complexity7(1);
		complexity7(2);
		complexity7(3);
		complexity7(4);
		complexity7(5);
		complexity7(6);
		complexity7(7);
	}

}
