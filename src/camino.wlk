import wollok.game.*

//boceteando el camino
class Camino {

	const posiciones
	const property casillas = []

	override method initialize() {
		self.validarParaConstruirse()
		self.construirse(posiciones)
		posiciones.clear()
	}

	method validarParaConstruirse() {
		if (posiciones.isEmpty()) {
			self.error("Un camino no puede ser vacio")
		}
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
		const posicionSiguiente = _casilla.numero() + 1
		return self.casillaNumero(posicionSiguiente)
	}

	method anteriorA(_casilla) {
		const posicionAnterior = _casilla.numero() - 1
		return self.casillaNumero(posicionAnterior)
	}

}

class Casilla {

	const property numero
	const camino
	const position

	override method initialize() {
		self.validarPosicion()
		self.validarNumero()
		self.validarCamino()
	}

	method validarPosicion() {
		if (position.className() != "wollok.game.Position") {
			self.error("Debe recibir una posicion valida")
		}
	}

	method validarNumero() {
		if (numero < 0) {
			self.error("El numero debe ser igual o mayor a cero")
		}
	}

	method validarCamino() {
		if (camino.className() != "camino.Camino") {
			self.error("Debe recibir un camino valido")
		}
	}

	method representacion() {
		return [ position, position.left(1), position.up(1), position.up(1).left(1) ]
	}

	method contiene(unaPosicion) {
		return self.representacion().contains(unaPosicion)
	}

	method ubicacion() {
		return self.representacion().anyOne()
	}

}

