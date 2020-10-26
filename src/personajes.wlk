import wollok.game.*
import camino.*
import configuracion.*
import sistemaDeTurnos.*

class Personaje {

	var property position
	const property image

// 	method avanzar(cantidad){
// 		    
//        if (cantidad > 0){
//            camino.llevarASiguiente(self)
//            	
//        }
//        turno.pasar()
//    }
}

class Jugador {

	const property camino
	var property position = null
	var property casillaActual = null

	override method initialize() {
		self.validarCamino()
		casillaActual = camino.partida()
		position = casillaActual.ubicacion()
	}

	method validarCamino() {
		if (camino.className() != "camino.Camino") {
			self.error("Debe recibir un camino")
		}
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
		self.validarAvance(cantidad)
		cantidad.times({i =>
			self.avanzar()
		})
	}
	
	method validarAvance(cantidad){
		if (camino.distanciaALaLlegada(casillaActual) < cantidad){
			self.error("No puede avanzar mas alla de la meta")
		}
	}
	
	method retroceder(cantidad){
		self.validarRetroceso(cantidad)
		cantidad.times({i => self.retroceder()})
	}
	
	method validarRetroceso(cantidad){
		if (camino.distanciaALaPartida(casillaActual) < cantidad) {
			self.error("No puede retroceder mas alla de la partida")
		}
	}

	method moverse(movimientos){
		const hastaLlegada = camino.distanciaALaLlegada(casillaActual) 
		if (hastaLlegada < movimientos){
			const retroceso = movimientos - hastaLlegada
			self.avanzar(hastaLlegada)
			self.retroceder(retroceso)
		}
	}
	
}

