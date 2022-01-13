import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

public class MinimalTest {
	Object a;
	int    i;
	
	
	public int jitMeaningOfTheWorld() {
		return 42;
	}
	
	public int intMeaningOfTheWorld() {
		return 42;
	}
	
	public static int staticOfTheWorld() {
		return 42;
	}
	
	@Test
	public void testMeaningOfTheWorld() {
		assertTrue(jitMeaningOfTheWorld() == 42);
	}
	
	static int jitIadd(int a, int b) {
        return a + b;
	}
	
	@Test
	public void testIadd() {
		assertTrue(jitIadd(40,2) == 42);
	}

	static double jitDadd(double a, double b) {
		return a + b;
	}
	
	@Test
	public void testDadd() {
		assertTrue(jitDadd(40,2) == 42);
	}
	
	Object jitGetA() {
		return a;
	}
	
	@Test
	public void testGetA() {
		a = null;
		assertTrue(jitGetA() == null);
		a = new Object();
		assertTrue(jitGetA() == a);

	}
	
	int jitGetI() {
		return i;
	}
		
	@Test
	public void testGetI() {
		i = 42;
		assertTrue(jitGetI() == 42);
		i = 0;
		assertTrue(jitGetI() == 0);
	}
	
	int jitInvokevirtualI_1() {
		return intMeaningOfTheWorld();
	}
	
	@Test
	public void testInvokevirtualI_1() {
		assertTrue(jitInvokevirtualI_1() == 42);
	}

	int jitInvokestaticI_1() {
		return staticOfTheWorld();
	}
	
	@Test
	public void testInvokestaticI_1() {
		staticOfTheWorld(); // force it to resolve;
		assertTrue(jitInvokestaticI_1() == 42);
	}
	
	
	public int int2jitFactorial(int i) {
		if (i == 0) {
			return 1;
		} else {
			return jit2intFactorial(i - 1) * i;
		}
	}
	
	
	public int jit2intFactorial(int i) {
		if (i == 0) {
			return 1;
		} else {
			return int2jitFactorial(i - 1) * i;
		}
	}
	
	@Test
	public void testFactorial() {
		int2jitFactorial(1); // force it to resolve
		assertTrue(jit2intFactorial(5) == 120);
	}

	public int jit2jitFactorial(int i) {
		if (i == 0) {
			return 1;
		} else {
			return jit2jitFactorial(i - 1) * i;
		}
	}

	@Test
	public void testFactorial2() {
		jit2jitFactorial(1); // force it to resolve
		assertTrue(jit2jitFactorial(5) == 120);
	}

	public static void main(String[] args) {
		Runner.run(MinimalTest.class, args);
	}

}
