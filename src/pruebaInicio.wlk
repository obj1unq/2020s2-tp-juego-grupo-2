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

	var property position = camino.casillas().first().posicion()
	method image() {
		return "jugador.png"
	}
	
	method moverA(unaPosicion){
		position = unaPosicion
	}

}