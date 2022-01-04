import java.util.ArrayList;

class ArrayBenchmark{
	private static Integer[] testArray;
	private static ArrayList<Integer> testList;

	private static void testArray(){
		testArray = new Integer[1000000];
		long then = System.currentTimeMillis();
		for(int i = 0; i < 100000; i++){
			testArray[i] = i;
		}
		long now = System.currentTimeMillis();
		System.out.println("array add time cost : " + (now - then));
	}

	private static void testList(){
		testList = new ArrayList<>(1000000);
		long then = System.currentTimeMillis();
		for(int i = 0; i < 1000000; i++){
			testList.add(i);
		}
		long now = System.currentTimeMillis();
		System.out.println("list add time cost : " + (now - then));
	}

	public static void main(String[] args){
		testArray();
		testList();

		System.out.println("Press Enter key to continue...");
		try
		{
			System.in.read();
		}
		catch(Exception e)
		{}
	}
}