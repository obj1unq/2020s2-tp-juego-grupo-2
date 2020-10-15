import wollok.game.*

//boceteando el camino
object camino {

	const property partida = new Celda(position = (game.at(27, 6)), siguiente = primerTramo.primera())
	const property llegada = new Celda(position = game.at(27, 31), siguiente = null)
	const celdas = []

}

object primerTramo {

	const property tramo = [ new Celda(position = (game.at(24,6)), siguiente = null) ]

	method primera() {
		return tramo.first()
	}

}

class Celda {

	const property position
	const property anterior = null
	const property siguiente // Celda

	method position() {
		const ubicacion = [ position, position.up(1), position.left(1), position.up(1).left(1) ]
		return ubicacion.anyOne()
	}

}

