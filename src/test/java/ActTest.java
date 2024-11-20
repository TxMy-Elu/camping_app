
import com.example.camping.Act;
import com.example.camping.Animateur;
import com.example.camping.Animation;
import com.example.camping.Creneaux;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.Calendar;
import java.util.HashMap;

import static org.junit.jupiter.api.Assertions.*;

class ActTest {

    private Act act;
    private Animateur animateur;
    private Creneaux creneaux;
    private Animation animation;

    @BeforeEach
    void setUp() {
        animateur = new Animateur(1, "John", "Doe", "test@test.fr");
        creneaux = new Creneaux(1, Calendar.getInstance(), 1, 1);
        animation = new Animation(1, "Test", "Test description");
        act = new Act(animateur, creneaux);
        act.setAnimation(animation);
    }

    @Test
    void testGetAnimateur() {
        assertEquals(animateur, act.getAnimateur());
    }

    @Test
    void testSetAnimateur() {
        Animateur newAnimateur = new Animateur(2, "Jane", "Doe", "test@test.fr");
        act.setAnimateur(newAnimateur);
        assertEquals(newAnimateur, act.getAnimateur());
    }

    @Test
    void testGetCreneaux() {
        assertEquals(creneaux, act.getCreneaux());
    }

    @Test
    void testSetCreneaux() {
        Creneaux newCreneaux = new Creneaux(2, Calendar.getInstance(), 2, 2);
        act.setCreneaux(newCreneaux);
        assertEquals(newCreneaux, act.getCreneaux());
    }

    @Test
    void testGetId_DateHeure() {
        assertEquals(creneaux.getDateHeure().toString(), act.getId_DateHeure());
    }

    @Test
    void testGetNom_Animation() {
        assertEquals(animation.getNom_Animation(), act.getNom_Animation());
    }

    @Test
    void testToString() {
        String expected = animateur.toString() + "\n" + creneaux.toString() + "\n" + animation.toString();
        assertEquals(expected, act.toString());
    }

    @Test
    void testGetAct() {
        LocalDate currentDate = LocalDate.now();
        HashMap<Animateur, Creneaux> result = Act.getAct(currentDate);
        assertNotNull(result);
    }

    @Test
    void testGetAnimation() {
        assertEquals(animation, act.getAnimation());
    }

    @Test
    void testSetAnimation() {
        Animation newAnimation = new Animation(2, "Test2", "Test description 2");
        act.setAnimation(newAnimation);
        assertEquals(newAnimation, act.getAnimation());
    }


}
