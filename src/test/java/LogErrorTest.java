import com.example.camping.CustomException;
import com.example.camping.ErrorLogger;
import org.junit.jupiter.api.Test;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class LogErrorTest {
    @Test
    public void testLogError() {
        CustomException e = new CustomException("Test message", "Test description");
        ErrorLogger.logError(e);
        // Check that the log file contains the expected message
        try (BufferedReader br = new BufferedReader(new FileReader("errors.log"))) {
            String line;
            boolean found = false;
            while ((line = br.readLine()) != null) {
                if (line.contains("Test message")) {
                    found = true;
                    break;
                }
            }
            assertTrue(found);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }

    @Test
    public void testLogErrorConnex() {
        CustomException e = new CustomException("Test message", "Test description");
        ErrorLogger.logErrorConnex(e);
        // Check that the log file contains the expected message
        try (BufferedReader br = new BufferedReader(new FileReader("errors.log"))) {
            String line;
            boolean found = false;
            while ((line = br.readLine()) != null) {
                if (line.contains("Connexion impossible")) {
                    found = true;
                    break;
                }
            }
            assertTrue(found);
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }

}
