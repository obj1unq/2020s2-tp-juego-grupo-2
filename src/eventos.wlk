import wollok.game.*
import minijuegos.*
import sistemaDeTurnos.*
import musica.*
import teclasInicio.*


/*----------------------------------------------------------------------------------------
  
								Turnos
 
----------------------------------------------------------------------------------------*/

object evento_finalizarTurno {

	method activar(){
		game.addVisual(pantalla_finDelTurno)
		game.schedule(1500,{ game.removeVisual(pantalla_finDelTurno)
								 turno.pasar()
								 tablero.activar() })
	}
}

object pantalla_finDelTurno {
	var property image = "fin_del_turno.png"
	const property position = game.at(0,0)
}


/*----------------------------------------------------------------------------------------
	
								Minijuegos

----------------------------------------------------------------------------------------*/

//Evento piedra papel o tijera
object evento_ppt {
	
	method activar(){
		miniGameManager.load(miniGameFactory.ppt())
		miniGameManager.start()
	}
}

//Evento preguntas y respuestas
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

//Evento corre el bondi
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
	var sound = "sonidos/win.mp3"
	
	method playSound(){	
		game.sound(sound).play()
	}
	
	method activar(){
		evento_numero.cambiarA(movimientos)
		self.playSound()
		game.addVisual(evento_avanzar)
		game.addVisual(evento_numero)
		game.schedule(1500, { 		game.removeVisual(evento_avanzar)
									game.removeVisual(evento_numero)
		})
		game.schedule(2000, {self.ejecutar()})
		
	}
	
	method ejecutar(){
		
		turno.jugadorActivo().avanzar(movimientos)
		turno.jugadorActivo().animarMovimiento()	
		if (turno.jugadorActivo().estaEnLaMeta()) {
			game.schedule(500 * movimientos, { evento_finDelJuego.activar() })			
		}
		else {
			game.schedule(500 * movimientos, { evento_finalizarTurno.activar() })
		}
		
	}
}

class Castigo {
	const movimientos = 2
	var sound = "sonidos/lose.mp3"
	
	method playSound(){	
		game.sound(sound).play()
	}
	
	method activar(){
		game.addVisual(evento_retroceder)
		self.playSound()
		evento_numero.cambiarA(movimientos)
		game.addVisual(evento_numero)
		game.schedule(1500, { 		game.removeVisual(evento_retroceder)
									game.removeVisual(evento_numero)
		})
		game.schedule(2000, {self.ejecutar()})
		
	}
	
	method ejecutar(){
		
		turno.jugadorActivo().retroceder(movimientos)
		turno.jugadorActivo().animarMovimiento()
		game.schedule(500 * movimientos, { evento_finalizarTurno.activar() })
			
	}
}

object evento_numero {
	const property position = game.at(13,14)	
	var property image = null
	
	method cambiarA(numero){
		image = numero.toString() + ".png"
	}

}

object evento_avanzar {
	var property image = "pantalla_avanzas.png"
	const property position = game.at(0,0)
}

object evento_retroceder {
	var property image = "pantalla_retrocedes.png"
	const property position = game.at(0,0)
}

/*----------------------------------------------------------------------------------------
	
										Pantallas

----------------------------------------------------------------------------------------*/


//La clase opciones tiene los metodos para identificar si se aceptan o no el input de las teclas.
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
	var property image = "intro.jpg"
	const property position = game.at(0,0)
	var property activo = true
	
	const teclaJugar = new Tecla(nombre="jugar", position=game.at(0,5), image="jugar0.png")
	const property teclasInicio = new Tecla(nombre="comienzo", position=game.at(0,5), image="comienzo0.png")
	const teclaSiguiente = new Tecla(nombre="siguiente", position=game.at(0,2), image="siguiente0.png")
	const teclaGlosario = new Tecla(nombre="glosario", position=game.at(1,29), image="glosario0.png")
	
	method inicializar() {
		self.activarOpciones()
		teclasInicio.mostrar()
	}

	method desactivar(){
		activo = false
	}

	method iniciar(){
		teclaGlosario.mostrar()
		if (opcionesActivo){
			self.desactivarOpciones()
			self.desactivar()
			self.validarKillTeclas()
			game.removeVisual(self)
			tablero.activar()
			musica.stopCronica()
			musica.iniciarPlaylist()
		}
	}
	
	method objetivo() {
		if (opcionesActivo){
			image = "placa_1.jpg"
			self.validarKillTeclas()
			self.validarMostrar(teclaSiguiente)
		}
	}
	
	method tutorial() {
		if (opcionesActivo){
			image = "placa_2.jpg"
			self.validarKillTeclas()
			game.schedule(10000, { 	self.validarMostrar(teclaJugar)	} )
		}
	}
	
	method validarKillTeclas() {
		self.validarKill(teclasInicio)
		self.validarKill(teclaJugar)
		self.validarKill(teclaSiguiente)
	}
	
	method validarKill(tecla){
		if (game.hasVisual(tecla)) {
			tecla.kill()
		}
	}
	
	method validarMostrar(tecla){
		if (not game.hasVisual(tecla)){
				tecla.mostrar()
			}
	}
}

object evento_finDelJuego inherits Opciones {
	// Como wollok solo puede reproducir una vez cada audio seteo la variable 
	// cada vez que se ejecuta por si se vuelve a jugar.
	var himno 
	
	method activar(){
		himno = game.sound("sonidos/himno.mp3")
		musica.stopPlaylist()
		himno.shouldLoop(true)
		himno.play()
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
			//Reinicio la musica
			himno.stop()
			musica.iniciarPlaylist()
		}
	}
	
	method salir(){
		if (opcionesActivo)	{
			game.stop()
		}
	}

}

object glosario inherits Opciones {
	const property image = "glosario.jpg"
	const property position = game.at(0,0)
	
	method mostrarOQuitar() {
		if (not opcionesActivo) {
			self.activarOpciones()
			game.addVisual(self)
		} else {
			game.removeVisual(self)
			self.desactivarOpciones()
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

