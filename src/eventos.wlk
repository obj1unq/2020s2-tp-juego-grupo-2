import wollok.game.*
import minijuegos.*
import sistemaDeTurnos.*


/*----------------------------------------------------------------------------------------
  
								Turnos
 
----------------------------------------------------------------------------------------*/

object evento_finalizarTurno {

	method activar(){
		game.addVisual(evento_FinDelTurno)
		game.schedule(1500,{ game.removeVisual(evento_FinDelTurno)
								 turno.pasar()
								 tablero.activar() })
	}
}

/*----------------------------------------------------------------------------------------
	
								Minijuegos

----------------------------------------------------------------------------------------*/


object evento_ppt {
	
	method activar(){
		miniGameManager.load(miniGameFactory.ppt())
		miniGameManager.start()
	}
}

object evento_pyr {
	
	var property preguntas = [
	 preguntasFactory.nueva("p_pe.png",  [false, true, false])
	,preguntasFactory.nueva("p_lh.png",  [false, false, true])
	,preguntasFactory.nueva("p_alf.png", [true, false, false])
	,preguntasFactory.nueva("p_gu.png",  [false, true, false])
	,preguntasFactory.nueva("p_mo.png",  [true, false, false])
	,preguntasFactory.nueva("p_io.png",  [false, false, true])
	,preguntasFactory.nueva("p_ba.png",  [false, true, false])
	,preguntasFactory.nueva("p_ri.png",  [true, false, false])
	]

	var index = 0	
	
	override method initialize(){
		self.mezclarPreguntas()
	}

	method mezclarPreguntas(){
		const listadoTemporal = []
		preguntas.size().times( { i => 
			const preguntaActual = preguntas.anyOne()
			listadoTemporal.add(preguntaActual) 
			preguntas.remove(preguntaActual)
		} )
		preguntas = listadoTemporal
	}
	
	method activar(){
		miniGameManager.load(miniGameFactory.pyr(preguntas.get(index)))
		miniGameManager.start()
		index = (index + 1) % preguntas.size()
	}
}

object evento_bondi {
	method activar(){
		miniGameManager.load(miniGameFactory.correBondi())
		miniGameManager.start()
	}
}

/*----------------------------------------------------------------------------------------
	
								Recompensas y castigos

----------------------------------------------------------------------------------------*/



class Recompensa {
	const movimientos = 2
	
	method activar(){
		turno.jugadorActivo().avanzar(movimientos)
		turno.jugadorActivo().animarMovimiento()	
		game.schedule(500 * movimientos, { turno.jugadorActivo().activarEvento() })
	}
}


class Castigo {
	const movimientos = 2
	
	method activar(){
		turno.jugadorActivo().retroceder(movimientos)
		turno.jugadorActivo().animarMovimiento()
		game.schedule(500 * movimientos, { turno.jugadorActivo().activarEvento() })
	}

}


/*----------------------------------------------------------------------------------------
	
										Pantallas

----------------------------------------------------------------------------------------*/

class Opciones {
	var opcionesActivo = false

	method activarOpciones(){
		opcionesActivo = true
	}

	method desactivarOpciones(){
		opcionesActivo = false
	}
}


object evento_inicioDelJuego inherits Opciones {
	const property image = "inicio.png"
	const property position = game.at(0,0)
	
	
	override method initialize(){
		self.activarOpciones()
	}

	method activar(){}

	method iniciar(){
		if (opcionesActivo){
			self.desactivarOpciones()
			game.removeVisual(self)
			tablero.activar()
			game.sound("sonidos/a_jugar.mp3").play()
		}
	}
}


object evento_FinDelTurno {
	var property image = "fin_del_turno.png"
	const property position = game.at(0,0)
}

object evento_finDelJuego inherits Opciones {
	
	method activar(){
		game.sound("sonidos/llegada_0.mp3").play()
		imagenGanador.ganador(turno.numeroJugadorActivo())
		game.addVisual(imagenGanador)
		game.onTick(1000, "opcionesFin", { opcionesFin.cambiarImagen() })
		game.addVisual(opcionesFin)
		self.activarOpciones()
	}
	
	method volverAjugar(){
		if (opcionesActivo) {
			game.removeVisual(imagenGanador)
			game.removeVisual(opcionesFin)
			game.removeTickEvent("opcionesFin")
			self.desactivarOpciones()
			//Reinicio el tablero
			turno.reiniciarSistemaDeTurnos()
			tablero.activar()
		}
	}
	
	method salir(){
		if (opcionesActivo)	{
			game.stop()
		}
	}

}

object imagenGanador {
	const property position = game.at(0,0)
	var property image = "ganador_0.png"
	
	method ganador(numero){
		image = "ganador_" + numero.toString() + ".png"
	}
}

object opcionesFin{
	const property position = game.at(5,5)
	var property image = "opcionesFin0.png"
	var numeroDeImagenActual = 0

	method cambiarImagen(){
		numeroDeImagenActual = (numeroDeImagenActual + 1) % 2 
		image = "opcionesFin" + numeroDeImagenActual + ".png"
	}
}