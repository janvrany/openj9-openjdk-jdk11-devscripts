import java.util.Set;
import java.util.HashSet;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

abstract class TestHarness {
	
	@Retention(RUNTIME)
	@Target(METHOD)
	public @interface Test {
	}
	
	public void assertTrue(boolean b, String message) {
		if (!b) {
			throw new RuntimeException(message);
		}
	}
	
	public void assertTrue(boolean b) {
		assertTrue(b, "Assertion failed!");
	}
	
	public void run(String[] toRun) {
		run(Set.of(toRun));
	}
	
	public void run(Set<String> toRun) {
		Set<Method> all = new HashSet<>();
		for (Method m : this.getClass().getMethods()) {			
			if (m.getAnnotation(Test.class) != null) {
				if (toRun.isEmpty() || toRun.contains(m.getName())) {
					all.add(m);
				}				
			}
		}		
		for (Method m : all) {
			run(m);
		}
	}
	
	public void run(Method m) {		
		try {
			if (m.getAnnotation(Test.class) != null) {
				run(m, Test.class);
			}
			System.out.println("PASS: " + this.getClass().getName() + "# " + m.getName());
		} catch (InvocationTargetException e) {
			e.getCause().printStackTrace();
			System.out.println("FAIL: " + this.getClass().getName() + "# " + m.getName());
		} catch (IllegalAccessException | IllegalArgumentException e) {			
			e.printStackTrace();
			System.out.println("FAIL: " + this.getClass().getName() + "# " + m.getName());
		}
	}
	
	private void run(Method m, Class<Test> annotation) throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {		
		m.invoke(this);
	}
}


public class MinimalTest extends TestHarness {
	Object a;
	int    i;
	
	public int jitMeaningOfTheWorld() {
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
	
	public static void main(String[] args) {
		(new MinimalTest()).run(args);
	}

}
