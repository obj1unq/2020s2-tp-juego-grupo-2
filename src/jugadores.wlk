import wollok.game.*

class Jugador {

	const property camino
	const property image = null
	var property casillaActual = null
	var property position = null

	method inicializar(){
		casillaActual = camino.partida()
		position = casillaActual.ubicacion()
	}

	method avanzar() {
		casillaActual = camino.siguienteA(casillaActual)
		position = casillaActual.ubicacion()
	}
	
	method retroceder(){
		casillaActual = camino.anteriorA(casillaActual)
		position = casillaActual.ubicacion()
	}
	
	method avanzar(cantidad){
//		self.validarAvance(cantidad)
		cantidad.times({i =>
			self.avanzar()
		})
	}
	
//	method validarAvance(cantidad){
//		if (camino.distanciaALaLlegada(casillaActual) < cantidad){
//			self.error("No puede avanzar mas alla de la meta")
//		}
//	}
	
	method retroceder(cantidad){
//		self.validarRetroceso(cantidad)
		cantidad.times({i => self.retroceder()})
	}
	
//	method validarRetroceso(cantidad){
//		if (camino.distanciaALaPartida(casillaActual) < cantidad) {
//			self.error("No puede retroceder mas alla de la partida")
//		}
//	}

	method moverse(movimientos){
		const hastaLlegada = casillaActual.distanciaA(camino.llegada()) 
		if (hastaLlegada < movimientos){
			const retroceso = movimientos - hastaLlegada
			self.avanzar(hastaLlegada)
			self.retroceder(retroceso)
		}
		else{
			self.avanzar(movimientos)
		}
	}
	
}

