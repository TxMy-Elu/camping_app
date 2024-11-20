package com.example.camping;

import java.time.LocalDate;
import java.util.HashMap;

public class Act {
    private Animateur animateur;
    private Creneaux creneaux;
    private Animation animation;

    /** Constructeur de Activité
     *
     * @param animateur
     * @param creneaux
     */
    public Act(Animateur animateur, Creneaux creneaux) {
        this.animateur = animateur;
        this.creneaux = creneaux;
    }



    /** Get Animateur
     *
     * @return
     */
    public Animateur getAnimateur() {
        return animateur;
    }

    /** Set Animateur
     *
     * @param animateur
     */
    public void setAnimateur(Animateur animateur) {
        this.animateur = animateur;
    }

    /** Get Creneaux
     *
     * @return
     */
    public Creneaux getCreneaux() {
        return creneaux;
    }

    /** Set Creneaux
     *
     * @param creneaux
     */
    public void setCreneaux(Creneaux creneaux) {
        this.creneaux = creneaux;
    }

    /** Get Id de DateHeure
     *
     * @return
     */
    public String getId_DateHeure() {
        return creneaux.getDateHeure().toString();
    }

    /** Get Nom de Animation
     *
     * @return
     */
    public String getNom_Animation() {
        return animation.getNom_Animation();
    }

    /** Get Animation
     *
     * @return
     */
    public Animation getAnimation() {
        return animation;
    }

    /** Set Animation
     *
     * @param animation
     */
    public void setAnimation(Animation animation) {
        this.animation = animation;
    }

    /** toString
     *
     * @return
     */
    @Override
    public String toString() {
        return animateur + "\n" + creneaux + "\n" + animation;
    }

    /** HashMap de Animateur,Creneaux
     *
     * @param currentDate
     * @return currentDate
     */
    public static HashMap<Animateur, Creneaux> getAct(LocalDate currentDate) {
        return DatabaseHelper.getAct(currentDate);
    }
}
