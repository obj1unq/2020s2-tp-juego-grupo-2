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
	
	method correBondi(){
		return new CorreBondi()		
	}
}

/*-----------------------------------------------------------------------------------------------------------
	 									Relator 
-------------------------------------------------------------------------------------------------------------*/

// Visualizar los mensajes de los minijuegos.
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

// Selector de 1 celda x 1 celda

class Selector1x1{
	var property image = "p1.png"
	var property position = game.at(-10,-10)
	var activo = false
	
	method on(){ activo = true }
	method off(){ activo = false }	
	
	method isOn(){ return activo }
}

/*-----------------------------------------------------------------------------------------------------------
	 									Super clase mini juego
-------------------------------------------------------------------------------------------------------------*/
class Minijuego {
	const property position = game.at(5,10)
	const x = self.position().x()
	const y = self.position().y()

	method keyUp(){ /*Sin uso*/	}
	method keyDown(){ /*Sin uso*/	}
	method keyLeft(){ /*Sin uso*/	}
	method keyRight(){ /*Sin uso*/	}

}

/*-----------------------------------------------------------------------------------------------------------
	 									Piedra Papel o tijera
-------------------------------------------------------------------------------------------------------------*/

//Muestra tres opciones en pantalla y 

class PPT inherits Minijuego{
	const property image = "miniTest.png"
	
	const selector = new Selector1x1()
	const posicionesSelector = [game.at(x + 2, y + 5), game.at(x + 8, y + 5), game.at(x + 15, y + 5)]
	var indexSelector = 0
	
	const opcionesJ = [opcionesFactory.piedra(), opcionesFactory.papel(), opcionesFactory.tijera()]
	const opcionesM = [opcionesFactory.piedra(), opcionesFactory.papel(), opcionesFactory.tijera()]
	var eleccionMaquina = null
	var eleccionJugador = null
		
	method elegirMaquina(){
		return opcionesM.get((0 .. 2).anyOne())
	}

	override method keyLeft(){
		if (selector.isOn()) {
			self.posicionSelector(-1)
		}
	}

	override method keyRight(){
		if (selector.isOn()) {
			self.posicionSelector(1)
		}
	}

	
	method posicionSelector(movimientoX){
		indexSelector = ( indexSelector + movimientoX ) % 3
		if (indexSelector < 0) { indexSelector = 2 } 
		selector.position(posicionesSelector.get(indexSelector))
	}
	
	method reboot(){
		game.removeVisual(eleccionMaquina)	
		game.removeVisual(eleccionJugador)
		game.schedule(5000, { 	self.timeOut()  } )
		selector.on()
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
		selector.on()
	}

	method timeOut(){
		selector.off()
		eleccionMaquina = self.elegirMaquina()
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
			if (opcion.valor() == 3){ 1 } //gana 
			else if (opcion.valor() == 2){ 2 } //pierde  
				else {	3 } //empata
	 }
}

class Papel{
	var property image = "Papel.png"
	var property position = game.at(-10,-10)	
	const property valor = 2
	
	method compararCon(opcion){
		return 
			if (opcion.valor() == 1){ 1 } //gana
			else if (opcion.valor() == 3){ 2 } //pierde 
				else { 3 } //empata
		}
}

class Tijera{
	var property image = "Tijera.png"
	var property position = game.at(-10,-10)
	const property valor = 3	
	
	method compararCon(opcion){
		return 
			if (opcion.valor() == 2){ 1 } //gana 
				else if (opcion.valor() == 1){ 2 } //pierde
					else { 3 } //empata
	}
}

object opcionesFactory{
	
	method piedra(){ return new Piedra() }
	method papel(){ return new Papel()	}
	method tijera(){ return new Tijera() }
}


/*-----------------------------------------------------------------------------------------------------------
	 									Preguntas y respuestas
-------------------------------------------------------------------------------------------------------------*/
class PYR inherits Minijuego{
	const property image = "preguntaTest.png"
	
	const pregunta = null

	const selector = new Selector1x1()
	const posicionesRespuestas = [game.at(x + 3,y + 10), game.at(x + 3,y + 12), game.at(x + 3,y + 14)]
	var indexSelector = 0
	
	override method keyUp(){
		if (selector.isOn()) { self.posicionSelector(1) }
	}
	override method keyDown(){
		if (selector.isOn()) { self.posicionSelector(-1) }
	}
	
	method posicionSelector(movimientoX){
		indexSelector = ( indexSelector + movimientoX ) % 3
		if (indexSelector < 0) { indexSelector = 2 } 
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
		selector.on()
		game.schedule(5000, {	self.timeOut()  } )
	}

	method timeOut(){
		selector.off()
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
	 									Se va el bondi
-------------------------------------------------------------------------------------------------------------*/
class CorreBondi inherits Minijuego{
	const property image = "escapetest.png"
	
	const bondi = new Bondi()
	
	const personaje = new PersonajeBondi(position = game.at(x + 9,y + 1))
	var personajeActivo = false

	const filas = new FilasHorizontal()
	const posicionesFilasY = [y + 4, y + 8, y + 12]

	var posicionPersonas = #{}
	
	method movimientoOn(){ personajeActivo = true	}
	method movimientoOff(){ personajeActivo = false }

	method esPosicionValida(posicion){
		return posicion.x().between(x, x + 19) and posicion.y().between(y, y + 17) and not posicionPersonas.contains(posicion)
	}

	method puedeIrA( posicion ){
		return personajeActivo and self.esPosicionValida( posicion )
	}

	override method keyLeft(){
		if (self.puedeIrA(personaje.position().left(1))) {
			personaje.position(personaje.position().left(1))
		}
	}
	override method keyRight(){
		if (self.puedeIrA(personaje.position().right(1))) {
			personaje.position(personaje.position().right(1))
		}
	}
	override method keyUp(){
		if (self.puedeIrA(personaje.position().up(1))) {
			personaje.position(personaje.position().up(1))
		}
	}
	override method keyDown(){
		if (self.puedeIrA(personaje.position().down(1))) {
			personaje.position(personaje.position().down(1))
		}
	}
	
	// Arma las filas tomado la posicion de posicionesFilasY y le asigna una hueco en una posicion al azar (entre 6 y 13)
	// La ultima fila no esta en la lista ya que tiene el hueco en un posicion fija.
	method armarFilas(){
		posicionesFilasY.forEach( { posicionY => filas.armarFila(20, (6 .. 13).anyOne() , game.at(x, posicionY)) } )
		filas.armarFila(20, 10 , game.at(x, y +  16))
	}

	method estaEnLaMeta(_personaje){
		return _personaje.position().y() >= y + 17
	}

	method procesarResultado(){
		if (self.estaEnLaMeta(personaje)){
			relator.decir("Ganaste") //le aviso al tablero que gano jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		} else { 
			relator.decir("Perdiste")	//le aviso al tablero que perdio jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		}
	}
	
	method start(){
		self.armarFilas()
		posicionPersonas = filas.posicionPersonas()
		bondi.position(game.at(x + 8, y +  17))
		game.addVisual(bondi)
		game.addVisual(personaje)
		self.movimientoOn()
		game.schedule(5000, {	self.timeOut()  } )
	}

	method timeOut(){
		self.movimientoOff()
		self.procesarResultado()
	}

	method clear(){
		filas.clear()
		game.removeVisual(bondi)
		game.removeVisual(personaje)
	}
}

class FilasHorizontal{
	const property personas = #{}
	
	// Arma una fila de "largo" hacia la derecha comenzado desde "posicionInicio".
	// Se debe indicar en que numero hay un hueco ("posicionHueco").
	method armarFila(largo, posicionHueco, posicionInicio){
		var x = posicionInicio.x()
		const y = posicionInicio.y()
		largo.times({ i => 
			if (i  != posicionHueco){
				const nuevaPersona = new Persona(position = game.at(x, y))
				game.addVisual(nuevaPersona)
				personas.add(nuevaPersona)
			}
			x ++
		})
	}
	
	method clear(){
		personas.forEach( {  persona => game.removeVisual(persona) })
	}	
	
	method posicionPersonas() {
		return self.personas().map( { persona => persona.position() } )
	}
}

class Persona {
	const property image = "persona.png"
	const property position = game.at(-10,-10)
}

class PersonajeBondi {
	const property image = "P1.PNG"
	var property position = game.at(-10,-10)
}

class Bondi {
	const property image = "bondi.PNG"
	var property position = game.at(-10,-10)
}