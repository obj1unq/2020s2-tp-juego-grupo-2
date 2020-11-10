import wollok.game.*
import camino.*
import configuracion.*

object tutorial {
	var property music = ["sonidos/b_bersuit.mp3", "sonidos/b_damas_gratis_humo.mp3", "sonidos/b_damas_gratis_laura.mp3",
		"sonidos/b_la_renga_rebelde.mp3", "sonidos/b_matador.mp3", "sonidos/b_pibe_cantina.mp3", "sonidos/b_soda_stereo_persiana_americana.mp3",
		"sonidos/b_soda_stereo.mp3"]
		
	method iniciar(){
		configurar.board()
		configurar.juego()
		configurar.teclas()
		
		game.schedule(0, {game.sound(music.anyOne()).play()})
	}
}

