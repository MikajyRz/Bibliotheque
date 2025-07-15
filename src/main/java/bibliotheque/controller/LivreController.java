package bibliotheque.controller;

import bibliotheque.service.LivreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/livres")
public class LivreController {

    @Autowired
    private LivreService livreService;

    @GetMapping("/{id}/disponibilite")
    public ResponseEntity<?> getDisponibilite(@PathVariable Long id) {
        Object result = livreService.getDisponibiliteParLivre(id);

        if (result instanceof Boolean && !(Boolean) result) {
            return ResponseEntity.ok("Aucun exemplaire disponible pour ce livre.");
        }
        return ResponseEntity.ok(result);
    }
}
