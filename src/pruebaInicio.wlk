import wollok.game.*
import camino.*
import configuracion.*

object tutorial {
	var property music = ["sonidos/pibe_cantina.mp3","sonidos/damas_gratis_laura.mp3","sonidos/soda_stereo.mp3", 
        "sonidos/la_renga_rebelde.mp3","sonidos/bersuit.mp3", "sonidos/matador.mp3","sonidos/damas_gratis_humo.mp3",  
        "sonidos/soda_stereo_persiana_americana.mp3"]

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


