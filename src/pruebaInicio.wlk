import wollok.game.*
import camino.*
import configuracion.*

object tutorial {

	method iniciar(){
		configurar.board()
		configurar.juego()
		configurar.teclas()
		
		game.schedule(0, { musica.iniciar() } )
	}
}

object musica {
	var listaDeTemas = ["sonidos/b_bersuit.wav", "sonidos/b_damas_gratis_humo.wav", "sonidos/b_damas_gratis_laura.mp3",
						"sonidos/b_la_renga_rebelde.mp3", "sonidos/b_matador.wav", "sonidos/b_pibe_cantina.wav", 
						"sonidos/b_soda_stereo_persiana_americana.wav", "sonidos/b_soda.wav"]
    var index = 0
    var track
 	const time = 180000
 
    method iniciar(){
        self.mezclarTemas()

        track = game.sound(listaDeTemas.first())
		self.play()

        game.onTick( time,"Musica",{ self.next() } )
    }
    
    method play(){
        track.volume(1)
  		track.play()
        self.fadeOut()
    }
    
    method fadeOut() {
       	game.schedule( time - 5000, { track.volume(0.5) } )
    	game.schedule( time - 4000, { track.volume(0.4) } )
    	game.schedule( time - 3000, { track.volume(0.3) } )
    	game.schedule( time - 2000, { track.volume(0.2) } )
    	game.schedule( time - 1000, { track.volume(0.1) } )
    }
    
    method next(){
        track.stop()
        index = (index + 1) % listaDeTemas.size()
        track = game.sound(listaDeTemas.get(index))
        self.play() 
    }
    
    method stop(){
    	game.removeTickEvent("Musica")
    	track.stop()
    }
    
     method mezclarTemas(){
        const listadoTemporal = []
        listaDeTemas.size().times( { i => 
            const temaActual = listaDeTemas.anyOne()
            listadoTemporal.add(temaActual) 
            listaDeTemas.remove(temaActual)
        } )
        listaDeTemas = listadoTemporal
    }
}

