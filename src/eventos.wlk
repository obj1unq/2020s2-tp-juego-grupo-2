import wollok.game.*

/*
 * Para lanzar un mini juego primero hay que cargarlo al manager.
 * El manager recibe los comandos del teclado y se los pasa al minijuego.
 * 
 * miniGameManager.load(miniGame)   - carga el juego
 * miniGameManager.start()			- inicia el juego cargado
 * miniGameManager.clear() 			- envia el mensaje de limpieza al juego cargado, y limpia el juego de la maquina.
 * 
 */

object miniGameManager{
	var miniGame = null
	
	method load(_minigame){
		miniGame = _minigame
	}
	
	method clear(){
		miniGame.clear()
		game.removeVisual(miniGame)
		game.removeVisual(relator)
	}
	
	method start(){
		game.addVisual(miniGame)
		miniGame.start()
		game.addVisual(relator)
	}
	
	method keyUp(){
		miniGame.keyUp()
	}
	method keyDown(){
		miniGame.keyDown()
	}
	method keyLeft(){
		miniGame.keyLeft()
	}
	method keyRight(){
		miniGame.keyRight()
	}
}

object miniGameFactory{
	method ppt(){
		return new PPT()
	}
	
	method pyr(){
		const _pregunta = new Pregunta (image = "preguntaTest.png", valorRespuestas = [false, false, true])
		return new PYR( pregunta = _pregunta, image = _pregunta.image()  )
	}
}

/*-----------------------------------------------------------------------------------------------------------
	 									Relator 
-------------------------------------------------------------------------------------------------------------*/

object relator {
	const property position = game.at(22,26)
	const property image = "pepita.png"
	
	method decir(mensaje){
		game.say(self, mensaje)
	}
}

/*-----------------------------------------------------------------------------------------------------------
	 									Selectores 
-------------------------------------------------------------------------------------------------------------*/

object selector1x1{
	var property image = "p1.png"
	var property position = game.at(-10,-10)
}

/*-----------------------------------------------------------------------------------------------------------
	 									Piedra Papel o tijera! 
-------------------------------------------------------------------------------------------------------------*/

class PPT {
	const property image = "miniTest.png"
	const property position = game.at(5,10)
	const x = self.position().x()
	const y = self.position().y()
	
	const opcionesJ = [opcionesFactory.piedra(), opcionesFactory.papel(), opcionesFactory.tijera()]
	const opcionesM = [opcionesFactory.piedra(), opcionesFactory.papel(), opcionesFactory.tijera()]
	var selectorActivo = false

	const selector = selector1x1
	const posicionesSelector = [game.at(x + 2, y + 5), game.at(x + 8, y + 5), game.at(x + 15, y + 5)]
	var indexSelector = 0
	
	var eleccionMaquina = null
	var eleccionJugador = null

	method selectorOn(){ selectorActivo = true }

	method selectorOff(){ selectorActivo = false }

	method elegirAlAzar(){
		return opcionesM.get((0 .. 2).anyOne())
	}

	method keyLeft(){
		if (selectorActivo) {
			self.posicionSelector(-1)
		}
	}

	method keyRight(){
		if (selectorActivo) {
			self.posicionSelector(1)
		}
	}
	method keyUp(){ /*Sin uso*/	}
	method keyDown(){ /*Sin uso*/	}
	
	method posicionSelector(movimientoX){
		if (indexSelector == 0 and movimientoX < 0) {
			indexSelector = 2
		} else {
		indexSelector = ( indexSelector + movimientoX ) % 3
		}
		selector.position(posicionesSelector.get(indexSelector))
	}
	
	method reboot(){
		game.removeVisual(eleccionMaquina)	
		game.removeVisual(eleccionJugador)
		game.schedule(5000, { 	self.timeOut()  } )
		self.selectorOn()
	}
	
	method procesarResultado(resultado){
		if (resultado == 1){
			relator.decir("Ganaste") //le aviso al tablero que gano jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		} else { 
			if (resultado == 2) {
				relator.decir("Perdiste")	//le aviso al tablero que perdio jugador
				game.schedule( 3000, {	miniGameManager.clear() } )
			}
			else {
				relator.decir("Empate")
				self.reboot()
			}
		}
	}
	
	method start(){
		selector.position(posicionesSelector.get(indexSelector))	
		game.addVisual(selector)
		game.schedule(5000, { self.timeOut() })
		self.selectorOn()
	}

	method timeOut(){
		self.selectorOff()
		eleccionMaquina = self.elegirAlAzar()
		eleccionJugador = opcionesJ.get(indexSelector)
		game.schedule( 1000, { game.addVisualIn(eleccionMaquina, game.at(x + 8, y + 13)) 
							   game.addVisualIn(eleccionJugador, game.at(x + 8, y + 9)) })
		game.schedule( 2000, { self.procesarResultado(eleccionJugador.compararCon(eleccionMaquina))	} )
	}

	method clear(){
		game.removeVisual(eleccionMaquina)	
		game.removeVisual(eleccionJugador)
		game.removeVisual(selector)
	}
}


class Piedra{
	var property image = "Piedra.png"
	var property position = game.at(-10,-10)
	const property valor = 1
	
	method compararCon(opcion){
		return 
		if (opcion.valor() == 3){
			1 //gana
		} else if (opcion.valor() == 2){
			2 //pierde
			} else {
			3 //empata
			}
		}
}

class Papel{
	var property image = "Papel.png"
	var property position = game.at(-10,-10)	
	const property valor = 2
	
	method compararCon(opcion){
		return 
		if (opcion.valor() == 1){
			1 //gana
		} else if (opcion.valor() == 3){
			2 //pierde
			} else {
			3 //empata
			}
		}
}

class Tijera{
	var property image = "Tijera.png"
	var property position = game.at(-10,-10)
	const property valor = 3	
	
	method compararCon(opcion){
		return 
		if (opcion.valor() == 2){
			1 //gana
		} else if (opcion.valor() == 1){
			2 //pierde
			} else {
			3 //empata
			}
		}
}

object opcionesFactory{
	
	method piedra(){
		return new Piedra()
	}
	method papel(){
		return new Papel()
	}
	method tijera(){
		return new Tijera()
	}
}


/*-----------------------------------------------------------------------------------------------------------
	 									Preguntas y respuestas
-------------------------------------------------------------------------------------------------------------*/
class PYR {
	const pregunta = null
	const property image = null
	const property position = game.at(5,10)
	const x = self.position().x()
	const y = self.position().y()

	var selectorActivo = false

	const selector = selector1x1
	const posicionesRespuestas = [game.at(x + 3,y + 10), game.at(x + 3,y + 12), game.at(x + 3,y + 14)]
	var indexSelector = 0
	
	method selectorOn(){ selectorActivo = true	}

	method selectorOff(){ selectorActivo = false }

	method keyLeft(){ /*Sin uso*/	}
	method keyRight(){ /*Sin uso*/ }
	method keyUp(){
		if (selectorActivo) {
			self.posicionSelector(1)
		}
	}
	method keyDown(){
		if (selectorActivo) {
			self.posicionSelector(-1)
		}
	}
	
	method posicionSelector(movimientoX){
		if (indexSelector == 0 and movimientoX < 0) {
			indexSelector = 2
		} else {
		indexSelector = ( indexSelector + movimientoX ) % 3
		}
		selector.position(posicionesRespuestas.get(indexSelector))
	}
	
	method procesarResultado(valorRespuestaElegida){

		if (valorRespuestaElegida){
			relator.decir("Es correcto") //le aviso al tablero que gano jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		} else { 
			relator.decir("No es correcto")	//le aviso al tablero que perdio jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		}
	}
	
	method start(){
		selector.position(posicionesRespuestas.get(indexSelector))	
		game.addVisual(selector)
		self.selectorOn()
		game.schedule(5000, {	self.timeOut()  } )
	}

	method timeOut(){
		self.selectorOff()
		self.procesarResultado( pregunta.valorRespuestas().get(indexSelector) )
	}

	method clear(){
		game.removeVisual(selector)
	}
}

class Pregunta {
	// La imagen de la pregunta va ser la imagen del tablero.
	const property image = null

	// Las repuestas son una lista de bool, cada posicion representa si es correcta o no una respuesta
	// El tamaño de la lista debe coincidir con la canitdad de preguntas en la imagen (Propongo que sean 3)
	const property valorRespuestas = []
}
/*-----------------------------------------------------------------------------------------------------------
	 									|
-------------------------------------------------------------------------------------------------------------*/