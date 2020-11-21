import wollok.game.*

class Jugador {

	const property camino
	const property image = null
	var property casillaActual = null
	var property position = null
	const posiciones = []

	method inicializar() {
		casillaActual = camino.partida()
		position = casillaActual.ubicacion()
	}

	method avanzar() {
		casillaActual = camino.siguienteA(casillaActual)
	}

	method retroceder() {
		casillaActual = camino.anteriorA(casillaActual)
	}

	method avanzar(cantidad) {
		cantidad.times({ i =>
			self.avanzar()
			posiciones.add(casillaActual.ubicacion())
		})
	}
	
	method retroceder(cantidad) {
		cantidad.times({ i =>
			self.retroceder()
			posiciones.add(casillaActual.ubicacion())
		})
	}
	
	method moverse(movimientos) {
		var tiempoActual = 0
		const hastaLlegada = casillaActual.distanciaA(camino.llegada())
		if (hastaLlegada < movimientos) {
			const retroceso = movimientos - hastaLlegada
			tiempoActual = hastaLlegada * 500 
			self.avanzar(hastaLlegada)
			self.retroceder(retroceso)
		} else {
			self.avanzar(movimientos)
		}
		self.animarMovimiento()
		game.schedule(500 * movimientos, { self.activarEvento() })
	}
	
	method activarEvento(){
		casillaActual.activarEvento()
	}
	
	method animarMovimiento(){
		var tiempo = 0
		posiciones.forEach({posicion =>
			game.schedule(tiempo, {position = posicion})
			tiempo += 500
		})			
		posiciones.clear()
	}
	
	method estaEnLaMeta(){
		return camino.esLlegada(casillaActual)
	}
	
}
