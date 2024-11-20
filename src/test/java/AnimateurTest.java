import com.example.camping.Animateur;
import com.example.camping.ConnexionBDD;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class AnimateurTest {

    private Connection connection;

    @BeforeEach
    public void setUp() {
        // Initialiser la connexion à la base de données
        ConnexionBDD c = new ConnexionBDD();
        connection = c.getConnection();
    }

    @AfterEach
    public void tearDown() {
        // Fermer la connexion à la base de données
        try {
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testAddAnimateur() {
        // Ajouter un animateur
        Animateur.addAnimateur("Doe", "John", "john.doe@example.com");

        // Vérifier que l'animateur a été ajouté
        ArrayList<Animateur> animateurs = Animateur.getAnimateur();
        boolean found = false;
        for (Animateur animateur : animateurs) {
            if (animateur.getNom_Animateur().equals("Doe") && animateur.getPrenom_Animateur().equals("John") && animateur.getEmail_Animateur().equals("john.doe@example.com")) {
                found = true;
                break;
            }
        }
        assertTrue(found, "L'animateur n'a pas été ajouté correctement.");
    }

    @Test
    public void testGetAnimateur() {
        // Ajouter un animateur pour le test
        Animateur.addAnimateur("Smith", "Jane", "jane.smith@example.com");

        // Récupérer la liste des animateurs
        ArrayList<Animateur> animateurs = Animateur.getAnimateur();

        // Vérifier que la liste contient l'animateur ajouté
        boolean found = false;
        for (Animateur animateur : animateurs) {
            if (animateur.getNom_Animateur().equals("Smith") && animateur.getPrenom_Animateur().equals("Jane") && animateur.getEmail_Animateur().equals("jane.smith@example.com")) {
                found = true;
                break;
            }
        }
        assertTrue(found, "L'animateur n'a pas été récupéré correctement.");
    }

    @Test
    public void testDeleteAnimateur() {
        // Ajouter un animateur pour le test
        Animateur.addAnimateur("Brown", "Charlie", "charlie.brown@example.com");

        // Récupérer l'ID de l'animateur ajouté
        ArrayList<Animateur> animateurs = Animateur.getAnimateur();
        int idAnimateur = -1;
        for (Animateur animateur : animateurs) {
            if (animateur.getNom_Animateur().equals("Brown") && animateur.getPrenom_Animateur().equals("Charlie") && animateur.getEmail_Animateur().equals("charlie.brown@example.com")) {
                idAnimateur = animateur.getId_Animateur();
                break;
            }
        }

        // Supprimer l'animateur
        Animateur.deleteAnimateur(idAnimateur);

        // Vérifier que l'animateur a été supprimé
        animateurs = Animateur.getAnimateur();
        boolean found = false;
        for (Animateur animateur : animateurs) {
            if (animateur.getNom_Animateur().equals("Brown") && animateur.getPrenom_Animateur().equals("Charlie") && animateur.getEmail_Animateur().equals("charlie.brown@example.com")) {
                found = true;
                break;
            }
        }
        assertFalse(found, "L'animateur n'a pas été supprimé correctement.");
    }

    @Test
    public void testUpdateAnimateur() {
        // Ajouter un animateur pour le test
        Animateur.addAnimateur("Davis", "David", "david.davis@example.com");

        // Récupérer l'ID de l'animateur ajouté
        ArrayList<Animateur> animateurs = Animateur.getAnimateur();
        int idAnimateur = -1;
        for (Animateur animateur : animateurs) {
            if (animateur.getNom_Animateur().equals("Davis") && animateur.getPrenom_Animateur().equals("David") && animateur.getEmail_Animateur().equals("david.davis@example.com")) {
                idAnimateur = animateur.getId_Animateur();
                break;
            }
        }

        // Mettre à jour l'animateur
        Animateur.updateAnimateur(idAnimateur, "Davis", "David", "david.newemail@example.com");

        // Vérifier que l'animateur a été mis à jour
        animateurs = Animateur.getAnimateur();
        boolean found = false;
        for (Animateur animateur : animateurs) {
            if (animateur.getNom_Animateur().equals("Davis") && animateur.getPrenom_Animateur().equals("David") && animateur.getEmail_Animateur().equals("david.newemail@example.com")) {
                found = true;
                break;
            }
        }
        assertTrue(found, "L'animateur n'a pas été mis à jour correctement.");
    }

    @Test
    public void testGetId_Animateur() {
        // Ajouter un animateur pour le test
        Animateur.addAnimateur("Evans", "Evan", "test@test.fr");

        // Récupérer l'ID de l'animateur ajouté
        ArrayList<Animateur> animateurs = Animateur.getAnimateur();
        int idAnimateur = -1;
        for (Animateur animateur : animateurs) {
            if (animateur.getNom_Animateur().equals("Evans") && animateur.getPrenom_Animateur().equals("Evan") && animateur.getEmail_Animateur().equals("test@test.fr")) {
                idAnimateur = animateur.getId_Animateur();
                break;

            }
        }

        // Vérifier que l'ID de l'animateur est correct
        assertTrue(idAnimateur != -1, "L'ID de l'animateur n'est pas correct.");
    }

    @Test
    public void testGetNom_Animateur() {
        // Ajouter un animateur pour le test
        Animateur.addAnimateur("Evans", "Evan", "test@test.fr");

        // Récupérer le nom de l'animateur ajouté
        ArrayList<Animateur> animateurs = Animateur.getAnimateur();
        String nomAnimateur = "";
        for (Animateur animateur : animateurs) {
            if (animateur.getNom_Animateur().equals("Evans") && animateur.getPrenom_Animateur().equals("Evan") && animateur.getEmail_Animateur().equals("test@test.fr")) {
                nomAnimateur = animateur.getNom_Animateur();
                break;
            }
        }

        // Vérifier que le nom de l'animateur est correct
        assertTrue(nomAnimateur.equals("Evans"), "Le nom de l'animateur n'est pas correct.");
    }
}
