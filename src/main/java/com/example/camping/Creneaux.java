package com.example.camping;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;

public class Creneaux {
    private int id_creneaux;
    private Calendar dateHeure;
    private int id;
    private int id_lieu;

    /** Constucteur de creneaux
     *
     * @param id_creneaux
     * @param dateHeure
     * @param id
     * @param id_lieu
     */
    public Creneaux(int id_creneaux, Calendar dateHeure, int id, int id_lieu) {
        this.id_creneaux = id_creneaux;
        this.dateHeure = dateHeure;
        this.id = id;
        this.id_lieu = id_lieu;
    }

    /** Get Id de Crenaux
     *
     * @return
     */
    public int getId_creneaux() {
        return id_creneaux;
    }

    /** Set Id de Creneaux
     *
     * @param id_creneaux
     */
    public void setId_creneaux(int id_creneaux) {
        this.id_creneaux = id_creneaux;
    }

    /** Get DateHeure
     *
     * @return
     */
    public Calendar getDateHeure() {
        return dateHeure;
    }

    /** Set DateHeure
     *
     * @param dateHeure
     */
    public void setDateHeure(Calendar dateHeure) {
        this.dateHeure = dateHeure;
    }

    /** Get Id Creneaux
     *
     * @return
     */
    public int getId() {
        return id;
    }

    /** Set Id Creneaux
     *
     * @param id
     */
    public void setId(int id) {
        this.id = id;
    }

    /** Get Id de Lieu
     *
     * @return
     */
    public int getId_lieu() {
        return id_lieu;
    }

    /** Set Id de Lieu
     *
     * @param id_lieu
     */
    public void setId_lieu(int id_lieu) {
        this.id_lieu = id_lieu;
    }

    /** toString
     *
     * @return
     */
    @Override
    public String toString() {
        ConnexionBDD c = new ConnexionBDD();
        if (c != null) {
            try (Statement stmt = c.getConnection().createStatement(); ResultSet res = stmt.executeQuery(getQueryCre())) {
                while (res.next()) {
                    return res.getString("nom") + "\n" + res.getString("libelle") + "             id: " + res.getInt("id_creneaux");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return "";
    }

    /** GetQuery
     *
     * @return
     */
    private String getQueryCre() {
        return "SELECT nom, libelle, id_creneaux FROM creneaux inner join animation on creneaux.id = animation.id inner join lieu on creneaux.id_lieu = lieu.id_lieu where id_creneaux = " + id_creneaux;
    }
}
