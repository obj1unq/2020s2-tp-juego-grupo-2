import wollok.game.*
import camino.*

object tutorial {
	method iniciar(){
		config.configurarTeclas()
		game.addVisual(jugador)
	}
}


object jugador {

	var property position = camino.partida().siguiente().position()
	method image() {
		return "jugador.png"
	}
	
	method moverA(unaPosicion){
		position = unaPosicion
	}

}

object config {

	method configurarTeclas() {
		keyboard.left().onPressDo({ jugador.moverA(jugador.position().left(1)) })
		keyboard.right().onPressDo({ jugador.moverA(jugador.position().right(1)) })
		keyboard.up().onPressDo({ jugador.moverA(jugador.position().up(1)) })
		keyboard.down().onPressDo({jugador.moverA(jugador.position().down(1)) })
		keyboard.c().onPressDo({ game.say(jugador, jugador.position().toString()) })
	}
}
