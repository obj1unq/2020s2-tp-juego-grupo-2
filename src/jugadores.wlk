import wollok.game.*

class Jugador {

	const property camino
	const posiciones = []
	const property image = null
	var property casillaActual = null
	var property position = null

	method inicializar() {
		casillaActual = camino.partida()
		position = casillaActual.ubicacion()
	}

	method avanzar() {
		casillaActual = camino.siguienteA(casillaActual)
//		position = casillaActual.ubicacion()
	}

	method retroceder() {
		casillaActual = camino.anteriorA(casillaActual)
//		position = casillaActual.ubicacion()
	}

//	method avanzar(cantidad) {
//		var tiempoActual = 0
//		cantidad.times({ i =>
//			game.schedule(tiempoActual, { self.avanzar()})
//			tiempoActual += 500
//		})
//	}
	
	method avanzar(cantidad) {
		cantidad.times({ i =>
			self.avanzar()
			posiciones.add(casillaActual.ubicacion())
		})
	}

//	method retroceder(cantidad, tiempo) {
//		var tiempoActual = tiempo
//		cantidad.times({ i =>
//			game.schedule(tiempoActual, { self.retroceder()})
//			tiempoActual += 500
//		})
//	}
	
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
			self.activarEvento()
			self.animarMovimiento()
		} else {
			self.avanzar(movimientos)
			self.activarEvento()
			self.animarMovimiento()
		}
	}
	
	method activarEvento(){
		casillaActual.activarEventoPara(self)
	}
	
	method animarMovimiento(){
		var tiempo = 0
		posiciones.forEach({posicion =>
			game.schedule(tiempo, {position = posicion})
			tiempo += 500
		})			
		posiciones.clear()
	}
	
}
