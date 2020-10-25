import wollok.game.*
import camino.*
import configuracion.*


object tutorial {
	method iniciar(){
		configurar.tablero()
		configurar.teclas()
		game.addVisual(jugador)
	}
}


object jugador {

	var property position = game.at(0,0)
	method image() {
		return "jugador.png"
	}
	
	method moverA(unaPosicion){
		position = unaPosicion
	}

}