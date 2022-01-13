import org.junit.platform.launcher.Launcher;
import org.junit.platform.launcher.LauncherDiscoveryRequest;
import org.junit.platform.launcher.TestPlan;
import org.junit.platform.launcher.core.LauncherDiscoveryRequestBuilder;
import org.junit.platform.launcher.core.LauncherFactory;
import org.junit.platform.launcher.listeners.SummaryGeneratingListener;
import org.junit.platform.launcher.listeners.TestExecutionSummary;

import java.io.PrintWriter;
import java.util.List;

import java.util.ArrayList;
import org.junit.platform.engine.DiscoverySelector;

import static org.junit.platform.engine.discovery.DiscoverySelectors.selectClass;
import static org.junit.platform.engine.discovery.DiscoverySelectors.selectMethod;

public class Runner {    
    public static void run(Class klass) {
        Runner.run(klass, new String[0]);
    }

    public static void run(Class klass, String[] methods) {
        ArrayList<DiscoverySelector> selectors = new ArrayList<>();
        if (methods.length > 0) {            
            for (String method : methods) {
                selectors.add(selectMethod(klass, method));
            }
        } else {
            selectors.add(selectClass(klass));
        }
        Runner.run(selectors);
    }

    public static void run(List<? extends DiscoverySelector> selectors) {
        LauncherDiscoveryRequest request = LauncherDiscoveryRequestBuilder
          .request()
          .selectors(selectors)
          .build();
        SummaryGeneratingListener listener = new SummaryGeneratingListener();
        Launcher launcher = LauncherFactory.create();
        TestPlan testPlan = launcher.discover(request);

        launcher.registerTestExecutionListeners(listener);
        launcher.execute(request);

        TestExecutionSummary summary = listener.getSummary();
        long nfailed = summary.getTestsFailedCount() + summary.getTestsFailedCount();
        if (nfailed > 0) {
            summary.printFailuresTo(new PrintWriter(System.out));
            System.out.println("\n\nFAILED !");
        } else {
            summary.printTo(new PrintWriter(System.out));
            System.out.println("\n\nPASSED");
        }
        System.exit(nfailed == 0 ? 0 : 1);
    }

    public static void main(String[] args) {
        Runner.run(MinimalTest.class, args);
        
    }
}