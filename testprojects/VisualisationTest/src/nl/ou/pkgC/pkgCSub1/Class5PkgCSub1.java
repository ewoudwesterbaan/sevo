package nl.ou.pkgC.pkgCSub1;

public class Class5PkgCSub1 {
	
	public void complexity43(int level) {
		switch (level) {
			case 1 : System.out.println("1"); break;
			case 2 : System.out.println("2"); break;
			case 3 : System.out.println("3"); break;
			case 4 : System.out.println("4"); break;
			case 5 : System.out.println("5"); break;
			case 6 : System.out.println("6"); break;
			case 11 : System.out.println("11"); break;
			case 12 : System.out.println("12"); break;
			case 13 : System.out.println("13"); break;
			case 14 : System.out.println("14"); break;
			case 15 : System.out.println("15"); break;
			case 16 : System.out.println("16"); break;
			case 21 : System.out.println("21"); break;
			case 22 : System.out.println("22"); break;
			case 23 : System.out.println("23"); break;
			case 24 : System.out.println("24"); break;
			case 25 : System.out.println("25"); break;
			case 26 : System.out.println("26"); break;
			case 31 : System.out.println("31"); break;
			case 32 : System.out.println("32"); break;
			case 33 : System.out.println("33"); break;
			case 34 : System.out.println("34"); break;
			case 35 : System.out.println("35"); break;
			case 36 : System.out.println("36"); break;
			case 41 : System.out.println("41"); break;
			case 42 : System.out.println("42"); break;
			case 43 : System.out.println("43"); break;
			case 44 : System.out.println("44"); break;
			case 45 : System.out.println("45"); break;
			case 46 : System.out.println("46"); break;
			case 51 : System.out.println("51"); break;
			case 52 : System.out.println("52"); break;
			case 53 : System.out.println("53"); break;
			case 54 : System.out.println("54"); break;
			case 55 : System.out.println("55"); break;
			case 56 : System.out.println("56"); break;
			case 61 : System.out.println("61"); break;
			case 62 : System.out.println("62"); break;
			case 63 : System.out.println("63"); break;
			case 64 : System.out.println("64"); break;
			case 65 : System.out.println("65"); break;
			case 66 : System.out.println("66"); break;
			case 71 : System.out.println("71"); break;
			case 72 : System.out.println("72"); break;
			case 73 : System.out.println("73"); break;
			case 74 : System.out.println("74"); break;
			case 75 : System.out.println("75"); break;
			case 76 : System.out.println("76"); break;
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