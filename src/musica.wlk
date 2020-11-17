import wollok.game.*

object musica {
	
	const temaCronica = game.sound("sonidos/cronica_musica.wav")
	var playlist = ["sonidos/b_bersuit.wav", "sonidos/b_damas_gratis_humo.wav", "sonidos/b_damas_gratis_laura.mp3",
						"sonidos/b_la_renga_rebelde.mp3", "sonidos/b_matador.wav", "sonidos/b_pibe_cantina.wav", 
						"sonidos/b_soda_stereo_persiana_americana.wav", "sonidos/b_soda.wav"]
	var index = 0
    var track
	var fadeoutRunning = false
	// Tiempo entre temas
	// Hay que tener en cuenta que al tiempo se le suman los 5000ms del fadeout (El tema mas largo de la playlist dura 170000ms)
 	const time = 155000  
 	
 	method playCronica(){
 		temaCronica.shouldLoop(true)
 		temaCronica.play()
 	}
 	
 	method stopCronica(){
 		temaCronica.stop()
 	}
 
    method iniciarPlaylist(){
    	game.sound("sonidos/a_jugar.mp3").play()
    	
        self.mezclarTemas()

        track = game.sound(playlist.first())
		self.play()

        game.onTick( time,"Musica",{ self.fadeout() } )
    }
    
    method play(){
        track.volume(1)
  		track.play()
    }
    
    method fadeout() {
    	var volumen = 0.5
    	fadeoutRunning = true

    	game.onTick(1000,"Fadeout", { track.volume(volumen) 
    								  volumen = volumen - 0.1
    								  self.validarNext(volumen)
    	})
    }

    method stopFadeout(){
    	if (fadeoutRunning) {
    		game.removeTickEvent("Fadeout")
    		fadeoutRunning = false
    	}
    }
    
	method validarNext(volumen){
		if (volumen < 0.1){
			self.stopFadeout()
			self.next()
		}
	}
    
    method next(){
        track.stop()
        index = (index + 1) % playlist.size()
        track = game.sound(playlist.get(index))
        self.play() 
    }
    
    method stopPlaylist(){
    	game.removeTickEvent("Musica")
    	self.stopFadeout()
    	track.stop()
    }
    
     method mezclarTemas(){
        const listadoTemporal = []
        playlist.size().times( { i => 
            const temaActual = playlist.anyOne()
            listadoTemporal.add(temaActual) 
            playlist.remove(temaActual)
        } )
        playlist = listadoTemporal
    }
}

