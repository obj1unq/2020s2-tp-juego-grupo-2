import wollok.game.*

class Jugador {

	const property camino
	const property image = null
	var property casillaActual = null
	var property position = null

	method inicializar() {
		casillaActual = camino.partida()
		position = casillaActual.ubicacion()
	}

	method avanzar() {
		casillaActual = camino.siguienteA(casillaActual)
		position = casillaActual.ubicacion()
	}

	method retroceder() {
		casillaActual = camino.anteriorA(casillaActual)
		position = casillaActual.ubicacion()
	}

	method avanzar(cantidad, tiempo) {
		var tiempoActual = tiempo
		cantidad.times({ i =>
			game.schedule(tiempoActual, { self.avanzar()})
			tiempoActual += 500
		})
		return tiempoActual
	}

	method retroceder(cantidad, tiempo) {
		var tiempoActual = tiempo
		cantidad.times({ i =>
			game.schedule(tiempoActual, { self.retroceder()})
			tiempoActual += 500
		})
	}

	method moverse(movimientos) {
		const hastaLlegada = casillaActual.distanciaA(camino.llegada())
		var tiempoActual = 0
		if (hastaLlegada < movimientos) {
			const retroceso = movimientos - hastaLlegada
			tiempoActual = self.avanzar(hastaLlegada, tiempoActual)
			self.retroceder(retroceso, tiempoActual)
		} else {
			self.avanzar(movimientos, tiempoActual)
		}
	}

}

