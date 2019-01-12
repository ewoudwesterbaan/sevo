public class Main {

	public void main(String[] args) {
		new InnerRankZero().complexity1();
		new InnerRankZero().complexity11(1);
		new InnerRankZero().complexity19(2);
		new InnerRankZero().complexity2(3);
		new InnerRankZero().complexity3(4);
	}
	
	// Inner class
	class InnerRankZero {
		
		public void complexity1() {
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
			System.out.println("1");
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

		public void complexity4(int level) {
			switch (level) {
				case 1 : System.out.println("1"); break;
				case 2 : System.out.println("2"); break;
				case 3 : System.out.println("3"); break;
				default : System.out.println("default"); break;
			}
		}

		public void complexity11(int level) {
			if (level == 1 || level == 2 || level == 3 || level == 4) {
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
		
		public void complexity19(int level) {
			if (level > 1) {
				if (level < 10) {
					for (int i = level; i < 100; i++) {
						if (i > 1 || i < 10) {
							switch (i) {
								case 1 : System.out.println("1"); break;
								case 2 : System.out.println("2"); break;
								case 3 : System.out.println("3"); break;
								case 4 : System.out.println("4"); break;
								case 5 : System.out.println("5"); break;
								case 6 : System.out.println("6"); break;
								case 7 : System.out.println("7"); break;
								case 8 : System.out.println("8"); break;
								case 9 : System.out.println("9"); break;
								case 10 : System.out.println("10"); break;
								case 11 : System.out.println("11"); break;
								case 12 : System.out.println("12"); break;
								case 13 : System.out.println("13"); break;
								default : System.out.println("default"); break;
							}
						}
					}
				}
			}
		}	
	}	
	
}
