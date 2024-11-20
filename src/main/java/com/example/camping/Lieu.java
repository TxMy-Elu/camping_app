package com.example.camping;

public class Lieu {
    private int id_lieu;
    private String libelle;

    /** Constructeur de Lieu
     *
     * @param id_lieu
     * @param libelle
     */
    public Lieu(int id_lieu, String libelle) {
        this.id_lieu = id_lieu;
        this.libelle = libelle;
    }

    /** Get Id Lieu
     *
     * @return
     */
    public int getId_lieu() {
        return id_lieu;
    }

    /** Set Id Lieu
     *
     * @param id_lieu
     */
    public void setId_lieu(int id_lieu) {
        this.id_lieu = id_lieu;
    }

    /** Get Libelle
     *
     * @return
     */
    public String getLibelle() {
        return libelle;
    }

    /** Set Libelle
     *
     * @param libelle
     */
    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}
