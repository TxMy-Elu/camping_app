package com.example.camping;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.*;

import static com.example.camping.ConnexionBDD.initialiserConnexion;

public class DatabaseHelper {

    /**
     * Get Animation List
     *
     * @return
     */
    public static List<String> getAnimations() {
        List<String> animations = new ArrayList<>();
        try (Connection conn = initialiserConnexion(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT nom FROM animation")) {

            while (rs.next()) {
                animations.add(rs.getString("nom"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animations;
    }

    /**
     * Get Animateur List
     *
     * @return
     */
    public static List<String> getAnimateurs() {
        List<String> animateurs = new ArrayList<>();
        try (Connection conn = initialiserConnexion(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT nom, prenom FROM animateur")) {

            while (rs.next()) {
                animateurs.add(rs.getString("nom") + " " + rs.getString("prenom"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return animateurs;
    }

    /**
     * Get Lieux en List
     *
     * @return
     */
    public static List<String> getLieux() {
        List<String> lieux = new ArrayList<>();
        try (Connection conn = initialiserConnexion(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT libelle FROM lieu")) {

            while (rs.next()) {
                lieux.add(rs.getString("libelle"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lieux;
    }

    /**
     * Get Id Animation List
     *
     * @return
     */
    public static List<String> getIdAnimation() {
        List<String> id = new ArrayList<>();
        try (Connection conn = initialiserConnexion(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT id_creneaux FROM creneaux ORDER BY id_creneaux ASC")) {

            while (rs.next()) {
                id.add(rs.getString("id_creneaux"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return id;
    }

    /**
     * Ajout de planning
     *
     * @param Animateur
     * @param Animation
     * @param Lieu
     * @param date
     * @param dure
     */
    public static void ajoutPlanning(String Animateur, String Animation, String Lieu, LocalDateTime date, String dure) {
        ConnexionBDD c = new ConnexionBDD();
        if (c != null) {
            try {
                Statement stmt = c.getConnection().createStatement();
                // l'id de l'animation selon son nom
                ResultSet res = stmt.executeQuery("SELECT id FROM animation WHERE nom = '" + Animation + "'");
                res.next();
                int id_Animation = res.getInt("id");
                // l'id de l'animateur selon son nom
                res = stmt.executeQuery("SELECT id_animateur FROM animateur WHERE nom = '" + Animateur.split(" ")[0] + "' AND prenom = '" + Animateur.split(" ")[1] + "'");
                res.next();
                int id_Animateur = res.getInt("id_animateur");
                // l'id du lieu selon son nom
                res = stmt.executeQuery("SELECT id_lieu FROM lieu WHERE libelle = '" + Lieu + "'");
                res.next();
                int id_Lieu = res.getInt("id_lieu");

                // appel ma procedure stockée pour ajouter un créneau
                stmt.execute("CALL ajoutCreneau('" + date + "', " + id_Animation + ", " + id_Lieu + ", " + dure + ", " + id_Animateur + ")");

                System.out.println("Ajout de planning réussi");

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Verification de Ajout
     *
     * @param dates
     * @param i
     * @return
     */
    public static boolean verifAjout(LocalDateTime dates, int i, int id_animateur) {
        ConnexionBDD c = new ConnexionBDD();
        if (c != null) {
            try {
                Statement stmt = c.getConnection().createStatement();
                ResultSet res = stmt.executeQuery("select checkAjout('" + dates + "', " + i + ", " + id_animateur + ")");
                res.next();
                return res.getBoolean(1);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * Get Activiter avec HashMap de Animateur et Creneaux
     *
     * @param currentDate
     * @return
     */
    public static HashMap<Animateur, Creneaux> getAct(LocalDate currentDate) {
        HashMap<Animateur, Creneaux> lesAct = new HashMap<>();
        ConnexionBDD c = new ConnexionBDD();
        if (c != null) {
            try {
                Statement stmt = c.getConnection().createStatement();
                ResultSet res = stmt.executeQuery(getQuery(currentDate));
                while (res.next()) {
                    Animateur _animateur = new Animateur(res.getInt("id_animateur"), res.getString("nom"), res.getString("prenom"), res.getString("email"));
                    Date date = res.getDate("date_heure");
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(date);
                    Creneaux _creneaux = new Creneaux(res.getInt("id_creneaux"), cal, res.getInt("id"), res.getInt("id_lieu"));
                    lesAct.put(_animateur, _creneaux);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return lesAct;
    }

    /**
     * GetQuery
     *
     * @param currentDate
     * @return
     */
    private static String getQuery(LocalDate currentDate) {
        LocalDate startOfWeek = currentDate.with(java.time.DayOfWeek.MONDAY);
        LocalDate endOfWeek = currentDate.with(java.time.DayOfWeek.SUNDAY);
        return "SELECT * FROM relation1 " + "INNER JOIN animateur ON animateur.id_animateur = relation1.id_animateur " + "INNER JOIN creneaux ON creneaux.id_creneaux = relation1.id_creneaux " + "INNER JOIN animation ON animation.id = creneaux.id " + "WHERE creneaux.date_heure BETWEEN '" + startOfWeek + "' AND '" + endOfWeek + "' " + "ORDER BY creneaux.date_heure ASC";
    }

    /**
     * Add Animateur
     *
     * @param nom
     * @param prenom
     * @param email
     */
    public static void addAnimateur(String nom, String prenom, String email) {
        try (Connection conn = initialiserConnexion(); PreparedStatement pstmt = conn.prepareStatement("INSERT INTO animateur (nom, prenom, email) VALUES (?, ?, ?)")) {
            pstmt.setString(1, nom);
            pstmt.setString(2, prenom);
            pstmt.setString(3, email);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Supression de Animateur
     *
     * @param id
     */
    public static void deleteAnimateur(int id) {
        try (Connection conn = initialiserConnexion(); PreparedStatement pstmt = conn.prepareStatement("DELETE FROM animateur WHERE id_animateur = ?")) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Modification de Animateur
     *
     * @param id
     * @param nom
     * @param prenom
     * @param email
     */
    public static void updateAnimateur(int id, String nom, String prenom, String email) {
        try (Connection conn = initialiserConnexion(); PreparedStatement pstmt = conn.prepareStatement("UPDATE animateur SET nom = ?, prenom = ?, email = ? WHERE id_animateur = ?")) {
            pstmt.setString(1, nom);
            pstmt.setString(2, prenom);
            pstmt.setString(3, email);
            pstmt.setInt(4, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Ajout de Animation
     *
     * @param nom
     * @param descriptif
     */
    public static void addAnimation(String nom, String descriptif) {
        try (Connection conn = initialiserConnexion(); PreparedStatement pstmt = conn.prepareStatement("INSERT INTO animation (nom, descriptif) VALUES (?, ?)")) {
            pstmt.setString(1, nom);
            pstmt.setString(2, descriptif);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Supression de Animation
     *
     * @param id
     */
    public static void deleteAnimation(int id) {
        try (Connection conn = initialiserConnexion(); PreparedStatement pstmt = conn.prepareStatement("DELETE FROM animation WHERE id = ?")) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Modification de Animation
     *
     * @param id
     * @param nom
     * @param descriptif
     */
    public static void updateAnimation(int id, String nom, String descriptif) {
        try (Connection conn = initialiserConnexion(); PreparedStatement pstmt = conn.prepareStatement("UPDATE animation SET nom = ?, descriptif = ? WHERE id = ?")) {
            pstmt.setString(1, nom);
            pstmt.setString(2, descriptif);
            pstmt.setInt(3, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Verification du login et mdp lors de la connexion
     *
     * @param login
     * @param password
     */
    public static void verifUser(String login, String password) {
        try (Connection conn = initialiserConnexion(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM compte WHERE login = '" + login + "' AND password = '" + password + "'")) {

            if (!rs.next()) {
                throw new CustomException("Login ou mot de passe incorrect", "Erreur d'authentification", null);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (CustomException e) {
            throw new RuntimeException(e);
        }
    }

    public static int getIdAnimateur(String nomAnim, String prenomAnim) {
        int id = -1;
        try (Connection conn = initialiserConnexion(); Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT id_animateur FROM animateur WHERE nom = '" + nomAnim + "' AND prenom = '" + prenomAnim + "'")) {
            rs.next();
            id = rs.getInt("id_animateur");
            return id;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return id;
    }
}
