package com.example.camping;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class ErrorViewer {
    private static final String LOG_FILE = "errors.log";

    /** Lire et Afficher LOG_FILE dans la console
     *
     * @param args
     */
    public static void main(String[] args) {
        try (BufferedReader br = new BufferedReader(new FileReader(LOG_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}