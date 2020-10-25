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

}

