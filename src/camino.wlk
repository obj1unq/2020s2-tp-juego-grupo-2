import wollok.game.*

//boceteando el camino
class Camino {

	const property posiciones
	const property casillas = []

	override method initialize() {
		self.construirse(posiciones)
		posiciones.clear()
	}

	method construirse(_posiciones) {
		var _numero = 0
		_posiciones.forEach({ posicion =>
			casillas.add(new Casilla(position = posicion, numero = _numero, camino = self))
		;_numero += 1
		})
	}

	method partida() {
		return casillas.first()
	}

	method llegada() {
		return casillas.last()
	}

	method casillaEn(_posicion) {
		return casillas.findOrElse({ casilla => casilla.contiene(_posicion) }, { self.error("La posicion esta fuera del camino") })
	}

	method esPartida(_casilla) {
		return self.partida() == _casilla
	}

	method esLlegada(_casilla) {
		return self.llegada() == _casilla
	}

	method casillaNumero(unNumero) {
		return casillas.get(unNumero)
	}

	method siguienteA(_casilla) {
		return _casilla.siguiente()
	}

	method anteriorA(_casilla) {
		return _casilla.anterior()
	}

}

class Casilla {

	const property numero
	const camino
	const position

	override method ==(other) {
		return self.representacion() == other.representacion()
	}

	method representacion() {
		return [ position, position.left(1), position.up(1), position.up(1).left(1) ]
	}

	method contiene(unaPosicion) {
		return self.representacion().contains(unaPosicion)
	}

	method esCasilla() {
		return true
	}

	method ubicacion() {
		return self.representacion().anyOne()
	}

	// retorna el numero de la que deberia ser la siguiente casilla
	method siguiente() {
		return camino.casillaNumero(numero + 1)
	}

	// retorna el numero de la que deberia ser la anterior casilla
	method anterior() {
		return camino.casillaNumero(numero - 1)
	}

}

