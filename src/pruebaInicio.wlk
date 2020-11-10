import wollok.game.*
import camino.*
import configuracion.*

object tutorial {

	var property music = ["sonidos/b_bersuit.wav", "sonidos/b_damas_gratis_humo.wav", "sonidos/b_damas_gratis_laura.mp3",
		"sonidos/b_la_renga_rebelde.mp3", "sonidos/b_matador.wav", "sonidos/b_pibe_cantina.wav", "sonidos/b_soda_stereo_persiana_americana.wav",
		"sonidos/b_soda_stereo.wav"]

    var index = 0
    var track = game.sound(music.get(index))
 
 
    
    method listaDeTemas(){
        
        track.shouldLoop(true)
        track.play() 
        game.schedule(180000, {track.stop()})
        game.onTick(180000,"Inicio",{
            
            if (track.played()) {
                track.stop()
                self.next()
                track.play()
            }else{track.play()}
            
        } )
       
        
       
    }
    
    method next(){

        index = (index + 1) % music.size()
        track = game.sound(music.get(index))
    }

		
	method iniciar(){
		configurar.board()
		configurar.juego()
		configurar.teclas()
		
		game.schedule(0, {self.listaDeTemas()})
	}
}


