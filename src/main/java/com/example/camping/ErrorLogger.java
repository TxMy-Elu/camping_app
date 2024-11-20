package com.example.camping;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public class ErrorLogger {
    private static final String LOG_FILE = "errors.log";

    /** Exception Personnalisee de Journalisation dans LOG_FILE
     *
     * @param e
     */
    public static void logError(CustomException e) {
        try (PrintWriter out = new PrintWriter(new FileWriter(LOG_FILE, true))) {
            out.println("Timestamp: " + e.getTimestamp());
            out.println("Message: " + e.getMessage());
            out.println("Description: " + e.getErrorDescription());
            out.println("StackTrace: " + e.getStackTraceString());
            out.println("--------------------------------------------------");
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }

    /** Erreur de Connexion Journalisation dans LOG_FILE
     *
     * @param e
     */
    public static void logErrorConnex(CustomException e) {
        try (PrintWriter out = new PrintWriter(new FileWriter(LOG_FILE, true))) {
            out.println("Timestamp: " + java.time.LocalDateTime.now());
            out.println("Message: " + "Connexion impossible");
            out.println("Description: " + "Connexion impossible / mauvais login ou mot de passe");
            out.println("--------------------------------------------------");
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
    }
}
