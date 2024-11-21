package com.example.camping;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Animateur {
    private int id_Animateur;
    private String nom_Animateur;
    private String prenom_Animateur;
    private String email_Animateur;

    /** Constructeur des Animateur
     *
     * @param id_Animateur
     * @param nom_Animateur
     * @param prenom_Animateur
     * @param email_Animateur
     */
    public Animateur(int id_Animateur, String nom_Animateur, String prenom_Animateur, String email_Animateur) {
        this.id_Animateur = id_Animateur;
        this.nom_Animateur = nom_Animateur;
        this.prenom_Animateur = prenom_Animateur;
        this.email_Animateur = email_Animateur;
    }

    /** Get Animateur
     *
     * @return
     */
    public static ArrayList<Animateur> getAnimateur() {
        ArrayList<Animateur> lesAnimateur = new ArrayList<>();
        ConnexionBDD c = new ConnexionBDD();
        if (c != null) {
            try (Statement stmt = c.getConnection().createStatement(); ResultSet res = stmt.executeQuery(getQuery())) {

                while (res.next()) {
                    Animateur animateur = new Animateur(res.getInt("id_compte"), res.getString("nom"), res.getString("prenom"), res.getString("email"));
                    lesAnimateur.add(animateur);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return lesAnimateur;
    }

    /** Ajout Animateur par leur nom, prenom, email
     *
     * @param nom
     * @param prenom
     * @param email
     */
    public static void addAnimateur(String nom, String prenom, String email) {
        ConnexionBDD c = new ConnexionBDD();
        if (c != null) {
            try (PreparedStatement stmt = c.getConnection().prepareStatement(getInsertQuery())) {
                stmt.setString(1, nom);
                stmt.setString(2, prenom);
                stmt.setString(3, email);
                stmt.setString(4, "animateur");
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /** Requete SQL Selection all dans compte avec role animateur
     *
     * @return
     */
    private static String getQuery() {
        return "SELECT * FROM compte WHERE role = 'animateur'";
    }

    /** Supprimer Animateur
     *
     * @param idAnimateur
     */
    public static void deleteAnimateur(int idAnimateur) {
        ConnexionBDD c = new ConnexionBDD();
        if (c != null) {
            try (PreparedStatement stmt = c.getConnection().prepareStatement("DELETE FROM compte WHERE id_compte = ? AND role = 'animateur'")) {
                stmt.setInt(1, idAnimateur);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /** Modification Animateur
     *
     * @param idAnimateur
     * @param text
     * @param text1
     * @param text2
     */
    public static void updateAnimateur(int idAnimateur, String text, String text1, String text2) {
        ConnexionBDD c = new ConnexionBDD();
        if (c != null) {
            try (PreparedStatement stmt = c.getConnection().prepareStatement("UPDATE compte SET nom = ?, prenom = ?, email = ? WHERE id_compte = ? AND role = 'animateur'")) {
                stmt.setString(1, text);
                stmt.setString(2, text1);
                stmt.setString(3, text2);
                stmt.setInt(4, idAnimateur);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /** get id de Animateur
     *
     * @return
     */
    public int getId_Animateur() {
        return id_Animateur;
    }

    /** Set id de Animateur
     *
     * @param id_Animateur
     */
    public void setId_Animateur(int id_Animateur) {
        this.id_Animateur = id_Animateur;
    }

    /** Get Nom de Animateur
     *
     * @return
     */
    public String getNom_Animateur() {
        return nom_Animateur;
    }

    /** Set Nom de Animateur
     *
     * @param nom_Animateur
     */
    public void setNom_Animateur(String nom_Animateur) {
        this.nom_Animateur = nom_Animateur;
    }

    /** Get Prenom de Animateur
     *
     * @return
     */
    public String getPrenom_Animateur() {
        return prenom_Animateur;
    }

    /** Set Prenom de Animateur
     *
     * @param prenom_Animateur
     */
    public void setPrenom_Animateur(String prenom_Animateur) {
        this.prenom_Animateur = prenom_Animateur;
    }

    /** Get Email de Animateur
     *
     * @return
     */
    public String getEmail_Animateur() {
        return email_Animateur;
    }

    /** Set Email de Animateur
     *
     * @param email_Animateur
     */
    public void setEmail_Animateur(String email_Animateur) {
        this.email_Animateur = email_Animateur;
    }

    /** toString
     *
     * @return
     */
    @Override
    public String toString() {
        return prenom_Animateur;
    }

    /** Get de Ajout Animateur dans la BDD
     *
     * @return
     */
    private static String getInsertQuery() {
        return "INSERT INTO compte (nom, prenom, email, role) VALUES (?, ?, ?, ?)";
    }
}