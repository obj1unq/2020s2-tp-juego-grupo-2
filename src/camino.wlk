import wollok.game.*

//boceteando el camino
object camino {

	const property partida = new Casilla(position = (game.at(27, 6)), siguiente = primerTramo.primera())
	const property llegada = new Casilla(position = game.at(27, 31), siguiente = null)
	const property casillas = primerTramo
	

	method llevarASiguiente(jugador){
		const casillaActual = self.estaEn(jugador)
		jugador.position(casillaActual.siguiente())
	}
	
	method estaEn(jugador){
		const posicion = jugador.position()
		return self.casillas().any({casilla => casilla.contiene(posicion)})
	}
	
	
}

object primerTramo {

	const property tramo = [ new Casilla(position = (game.at(24,6)), siguiente = null) ]

	method primera() {
		return tramo.first()
	}

}

class Casilla {

	const property position
	const property anterior = null
	const property siguiente // Casilla

	method position() {
		const ubicacion = [position, position.up(1), position.left(1), position.up(1).left(1)]
		return ubicacion.anyOne()
	}
	
	method contiene(unaPosicion){
		return self.position().contains(unaPosicion) 
	}

}

