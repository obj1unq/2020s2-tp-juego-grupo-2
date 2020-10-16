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
	}
	
	method start(){
		game.addVisual(miniGame)
		miniGame.start()
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
}


class PPT {
	const property image = "miniTest.png"
	const property position = game.at(0,0)

	const opcionesJ = [opcionesFactory.piedra(), opcionesFactory.papel(), opcionesFactory.tijera()]
	const opcionesM = [opcionesFactory.piedra(), opcionesFactory.papel(), opcionesFactory.tijera()]
	var selectorActivo = false

	const selector = selector1x1
	const posicionesSelector = [game.at(1,1), game.at(8,1), game.at(15,1)]
	var indexSelector = 0
	
	var eleccionMaquina = null
	var eleccionJugador = null

	method selectorOn(){
		selectorActivo = true
	}

	method selectorOff(){
		selectorActivo = false
	}


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
	method keyUp(){}
	method keyDown(){}
	
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
		game.schedule(5000, { self.timeOut() })
		self.selectorOn()
	}
	
	method procesarResultado(resultado){
		if (resultado == 1){
			game.say(self, "Ganaste") //le aviso al tablero que gano jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		} else { 
			if (resultado == 2) {
				game.say(self, "Perdiste")	//le aviso al tablero que perdio jugador
				game.schedule( 3000, { miniGameManager.clear() } )
			}
			else {
				game.say(self, "Empate")
				self.reboot()
			}
		}
	}
	
	method start(){
		game.schedule(5000, { self.timeOut() })
		selector.position(posicionesSelector.get(indexSelector))	
		game.addVisual(selector)
		self.selectorOn()
	}

	method timeOut(){
		self.selectorOff()
		eleccionMaquina = self.elegirAlAzar()
		eleccionJugador = opcionesJ.get(indexSelector)
		game.schedule( 1000, { game.addVisualIn(eleccionMaquina, game.at(8,13)) 
							   game.addVisualIn(eleccionJugador, game.at(8,9)) })
		game.schedule( 2000, { self.procesarResultado(eleccionJugador.compararCon(eleccionMaquina))	} )
	}

	method clear(){
		game.removeVisual(eleccionMaquina)	
		game.removeVisual(eleccionJugador)
		game.removeVisual(selector)
	}
}


object selector1x1{
	var property image = "p1.png"
	var property position = game.at(-10,-10)
	
	method position(x, y){
		position = game.at(x,y)
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