package com.example.camping;

import javafx.scene.control.Alert;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ConnexionBDD {
    private static String driver = "mariadb";
    private static String database = "camping_dev";
    private static String host = "localhost";
    private static String port = "3306";
    private static String username = "root";
    private static String password = "";

    /** Connexion a la BDD
     *
     * @return
     */
    public static Connection initialiserConnexion() {
        String URL = "jdbc:" + driver + "://" + host + ":" + port + "/" + database;
        try {
            return DriverManager.getConnection(URL, username, password);
        } catch (SQLException ex) {
            Alert a = new Alert(Alert.AlertType.ERROR);
            a.setTitle("Erreur");
            a.setContentText("Erreur de connexion à la base de données : " + ex.getMessage());
            a.showAndWait();
            return null;
        }
    }

    /** Initialiser la Connnexion a la BDD
     *
     * @return
     */
    public Connection getConnection() {
        return initialiserConnexion();
    }

    /** Preparation d'instruction SQL
     *
     * @param conn
     * @param query
     * @return
     * @throws SQLException
     */
    public PreparedStatement prepareStatement(Connection conn, String query) throws SQLException {
        if (conn == null) {
            throw new SQLException("Connection is null");
        }
        return conn.prepareStatement(query);
    }
}
