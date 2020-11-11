import wollok.game.*
import camino.*
import configuracion.*

object tutorial {

	var property music = ["sonidos/b_bersuit.wav", "sonidos/b_damas_gratis_humo.wav", "sonidos/b_damas_gratis_laura.mp3",
		"sonidos/b_la_renga_rebelde.mp3", "sonidos/b_matador.wav", "sonidos/b_pibe_cantina.wav", "sonidos/b_soda_stereo_persiana_americana.wav",
		"sonidos/b_soda.wav"]

    var index = 0
    var track = game.sound(music.anyOne())
 	const time = 180000
 
    
    method listaDeTemas(){
        
        self.mezclarTemas()
        track.shouldLoop(true)
        track.play()
        self.fadeOut()
        track.volume(1)
        game.onTick(time,"Inicio",{
            
            if (track.played()) {
            	
            	self.fadeOut()
            	track.volume(1)
                self.next()
                track.play()
                
            }else{track.play()}
            
        } )
       
    }
    
    method fadeOut() {
    	
    	self.bajarVolumen()
        game.schedule(time, { track.stop() })
    }
    
    method bajarVolumen() {
    	game.schedule(time - 5000, {track.volume(0.5)})
    	game.schedule(time - 4000, {track.volume(0.4)})
    	game.schedule(time - 3000, {track.volume(0.3)})
    	game.schedule(time - 2000, {track.volume(0.2)})
    	game.schedule(time - 1000, {track.volume(0.1)})
    }
    
    method next(){
		
        index = (index + 1) % music.size()
        track = game.sound(music.get(index))

    }
    
     method mezclarTemas(){
        const listadoTemporal = []
        music.size().times( { i => 
            const temaActual = music.anyOne()
            listadoTemporal.add(temaActual) 
            music.remove(temaActual)
        } )
        music = listadoTemporal
    }

		
	method iniciar(){
		configurar.board()
		configurar.juego()
		configurar.teclas()
		
		game.schedule(0, {self.listaDeTemas()})
	}
}


