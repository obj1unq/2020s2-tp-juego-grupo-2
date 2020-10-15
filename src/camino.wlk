import wollok.game.*

//boceteando el camino
object camino {

	//listacasillas [(24,6),(21,6),(18,6),(15,6),(12,6),(9,6),(6,6),(5,9),
	//(5,13),(7,15),(10,15),(13,14),(16,14),(19,13),(22,14),(24,16),(25,20),
	//(23,23),(20,23),(17,23),(14,23),(11,22),(8,22),(5,24),(5,28),(6,31),
	//(9,32),(12,32),(15,31),(15,31),(18,31),(21,31),(24,31)]

	const property partida = new Casilla(position = (game.at(27, 6)), siguiente = primerTramo.primera())
	const property llegada = new Casilla(position = game.at(27, 31), siguiente = null)
	const property casillas = primerTramo.tramo()
	

	method llevarASiguiente(jugador){
		const posicion = jugador.position()
		const casillaActual = self.estaEn(posicion)
		jugador.position(casillaActual.siguiente().position())
	}
	
	method estaEn(posicion){
//		const posicion = jugador.position()
		return self.casillas().find({casilla => casilla.contiene(posicion)})
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

	//la idea es q se utilice para asignar el lugar que ocupa un visual
	method position() {
		return self.posicionConcreta().anyOne()
	}
	
	//esta retorna las posiciones que representan la casilla
	method posicionConcreta(){
		return [position, position.up(1), position.left(1), position.up(1).left(1)]
	}
	
	//retorna si una posicion forma parte de la representacion de la casilla
	method contiene(unaPosicion){
		return self.posicionConcreta().contains(unaPosicion) 
	}

}

