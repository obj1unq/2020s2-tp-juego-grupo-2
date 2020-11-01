import wollok.game.*
import camino.*
import configuracion.*

object tutorial {
	var property music = ["sonidos/bersuit.mp3", "sonidos/damas_gratis_humo.mp3", "sonidos/damas_gratis_laura.mp3",
		"sonidos/la_renga_rebelde.mp3", "sonidos/matador.mp3", "sonidos/pibe_cantina.mp3", "sonidos/soda_stereo_persiana_americana.mp3",
		"sonidos/soda_stereo.mp3"]
		
	method iniciar(){
		configurar.tablero()
		configurar.teclas()
		
		game.schedule(0, {game.sound(music.anyOne()).play()})
	}
}

