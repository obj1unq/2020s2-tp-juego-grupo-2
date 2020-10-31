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

	method hasGameLoaded(){
		return miniGame != null
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
		if (self.hasGameLoaded()){ miniGame.keyUp() }
	}
	method keyDown(){
		if (self.hasGameLoaded()){ miniGame.keyDown() }
	}
	method keyLeft(){
		if (self.hasGameLoaded()){ miniGame.keyLeft() }
	}
	method keyRight(){
		if (self.hasGameLoaded()){ miniGame.keyRight() }
	}
}

object miniGameFactory{
	method ppt(){
		return new PPT()
	}
	
	method pyr(){
		const _pregunta = new Pregunta (image = "p_pe.png", valorRespuestas = [false, true, false])
		return new PYR( pregunta = _pregunta, image = _pregunta.image()  )
	}
	
	method correBondi(){
		return new CorreBondi()		
	}
}


/*-----------------------------------------------------------------------------------------------------------
	 									ResultadosPGE
-------------------------------------------------------------------------------------------------------------*/


object resultadoPGE {
	var property image = "resultadoGana.png"
	var property position = game.at(10,15)
	
	method gana() {
		image = "silvio_ganaste.png" 	
	}

	method pierde() {
		image = "silvio_perdiste.png"	
	}

	method empata() {
		image = "silvio_empate.png"
	}	
}


/*-----------------------------------------------------------------------------------------------------------
	 									Timer
-------------------------------------------------------------------------------------------------------------*/


object timer{
	var property image = "vacio.png"
	var property position = game.at(14,28)

	//Solo admite numeros del 1 al 9
	method countDown(segundos){
		image = segundos.toString() + ".png"
		var time = 1000 * segundos
		game.sound("sonidos/timer.wav").play()
		segundos.times( { i => 
			game.schedule(time, { image = (i - 1).toString() + ".png" 
								  game.sound("sonidos/timer.wav").play()
			} )
			time = time - 1000
		})
	}

}


/*-----------------------------------------------------------------------------------------------------------
	 									Super clase mini juego
-------------------------------------------------------------------------------------------------------------*/

class Minijuego {
	const property position = game.at(0,0)

	method keyUp(){ /*Sin uso*/	}
	method keyDown(){ /*Sin uso*/	}
	method keyLeft(){ /*Sin uso*/	}
	method keyRight(){ /*Sin uso*/	}

	method image()
	method start()
	method clear()
}


/*-----------------------------------------------------------------------------------------------------------
	 									Super clase mini juego con selector de 3 opciones
-------------------------------------------------------------------------------------------------------------*/

class MinijuegoConSelector inherits Minijuego{
	
	var index = 0
	var seleccionActivo = false
	var seleccionVertical = true
	var seleccionHorizontal = false

	method selectorVertical(){
		seleccionVertical = true
		seleccionHorizontal = false
	}

	method selectorHorizontal(){
		seleccionVertical = false
		seleccionHorizontal = true
	}
			
	method seleccionOn(){
		seleccionActivo = true
	}

	method seleccionOff(){
		seleccionActivo = false
	}
	
	override method keyLeft(){
		if (seleccionActivo and seleccionHorizontal) {
			self.seleccionarOpcion(-1)
		}
	}
	
	override method keyRight(){
		if (seleccionActivo and seleccionHorizontal) {
			self.seleccionarOpcion(1)
		}
	}
	
	override method keyUp(){
		if (seleccionActivo and seleccionVertical) { 
			self.seleccionarOpcion(1)
		}
	}
	
	override method keyDown(){
		if (seleccionActivo and seleccionVertical) { 
			self.seleccionarOpcion(-1)
		}
	}
	
	method seleccionarOpcion(movimientoX){
		self.opciones().get(index).desactivar()
		index = ( index + movimientoX ) % 3
		if (index < 0) { 
			index = 2
		}
		self.opciones().get(index).activar()
	}
	
	method opciones()	
}

/*-----------------------------------------------------------------------------------------------------------
	 									Piedra Papel o tijera
-------------------------------------------------------------------------------------------------------------*/

//Muestra tres opciones en pantalla y 

class PPT inherits MinijuegoConSelector{
	const property image = "ppt.png"
	
	const opcionesJugador = []
	const opcionesMaquina = []
	var eleccionMaquina = null
	
	override method opciones() {
		return opcionesJugador
	}

	method elegirMaquina(){
		return opcionesMaquina.get((0 .. 2).anyOne())
	}

	method reboot(){
		game.removeVisual(resultadoPGE)
		eleccionMaquina.desactivar()
		self.seleccionOn()
		self.startCountDown()
	}
	
	method procesarResultado(resultado){
		if (resultado == 1){
			resultadoPGE.gana()
			game.addVisualIn(resultadoPGE,game.at(10,11)) //le aviso al tablero que gano jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		} 
		else if (resultado == 2) {
				resultadoPGE.pierde()
				game.addVisualIn(resultadoPGE,game.at(10,11))	//le aviso al tablero que perdio jugador
				game.schedule( 3000, { miniGameManager.clear() } )
		}
		else {
				resultadoPGE.empata()
				game.addVisualIn(resultadoPGE,game.at(10,11))
				game.schedule( 3000, { self.reboot() } )
		}
	}
	
	method startCountDown(){
		timer.countDown(5)
		game.schedule(5000, { self.timeOut() })
		self.seleccionOn()
	}
	
	override method start(){
		//Configuro el selector
		self.selectorHorizontal()
		//Preparo las opciones de la maquina
		const piedraMaquina = opcionesFactory.piedra()
		const papelMaquina = opcionesFactory.papel()
		const tijeraMaquina = opcionesFactory.tijera()
		[piedraMaquina, papelMaquina, tijeraMaquina].forEach( { objeto => opcionesMaquina.add(objeto)} )
		//Preparo las opciones del Jugador
		const piedraJugador = opcionesFactory.piedra()
		const papelJugador = opcionesFactory.papel()
		const tijeraJugador = opcionesFactory.tijera()
		[piedraJugador, papelJugador, tijeraJugador].forEach( { objeto => opcionesJugador.add(objeto)} )
		//Agrego las visuales
		game.addVisualIn(piedraMaquina, game.at(6,17))
		game.addVisualIn(papelMaquina, game.at(12,21))
		game.addVisualIn(tijeraMaquina, game.at(18,17))
		game.addVisualIn(piedraJugador, game.at(6,8))
		game.addVisualIn(papelJugador, game.at(12,5))
		game.addVisualIn(tijeraJugador, game.at(18,8))
		game.addVisual(timer)
		//Activo la eleccion inicial
		self.opciones().get(index).activar()
		//Arranco el contador y empieza el juego
		self.startCountDown()
	}

	method timeOut(){
		self.seleccionOff()
		eleccionMaquina = self.elegirMaquina()
		const eleccionJugador = opcionesJugador.get(index)
		game.schedule( 1000, { eleccionMaquina.activar() })
		game.schedule( 1500, { self.procesarResultado(eleccionJugador.compararCon(eleccionMaquina))	} )
	}

	override method clear(){
		game.removeVisual(timer)
		game.removeVisual(resultadoPGE)
		opcionesJugador.forEach( { opcion => game.removeVisual(opcion) } )
		opcionesMaquina.forEach( { opcion => game.removeVisual(opcion) } )
	}
}

class Piedra{
	var property image = "piedra_0.png"
	const property valor = 1
	
	method compararCon(opcion){
		return 
			if (opcion.valor() == 3){ //gana 
				1 
			} 
			else if (opcion.valor() == 2){ //pierde
				2
			}   
			else {	//empata
			
				3
			} 	 
	}	
	
	method activar(){
		image = "piedra_1.png"		
	}
	method desactivar(){
		image = "piedra_0.png"		
	}
	
}

class Papel{
	var property image = "papel_0.png"
	var property position = game.at(-10,-10)	
	const property valor = 2
	
	method compararCon(opcion){
		return 
			if (opcion.valor() == 1){ //gana
				1
			} 
			else if (opcion.valor() == 3){ //pierde
				2
			}  
			else { //empata
				3
			} 
	}

	method activar(){
		image = "papel_1.png"		
	}
	method desactivar(){
		image = "papel_0.png"		
	}

}

class Tijera{
	var property image = "tijera_0.png"
	var property position = game.at(-10,-10)
	const property valor = 3	
	
	method compararCon(opcion){
		return 
			if (opcion.valor() == 2){ //gana  
				1
			} 
			else if (opcion.valor() == 1){ //pierde 
				2
			}
			else { //empata
				3
			} 
	}
	method activar(){
		image = "tijera_1.png"		
	}
	method desactivar(){
		image = "tijera_0.png"		
	}
	
}

object opcionesFactory{
	
	method piedra(){ return new Piedra() }
	method papel(){ return new Papel()	}
	method tijera(){ return new Tijera() }
}

/*-----------------------------------------------------------------------------------------------------------
	 									Selector
-------------------------------------------------------------------------------------------------------------*/

// Selector PYR

class Selector3x3{
	var property image = "selector0.png"
	var property position = game.at(-10,-10)

	method activar(){
		image = "selector1.png"
		
	}

	method desactivar(){
		image = "selector0.png"
		
	}

}

/*-----------------------------------------------------------------------------------------------------------
	 									Preguntas y respuestas
-------------------------------------------------------------------------------------------------------------*/
class PYR inherits MinijuegoConSelector{
	const property image = null
	
	const pregunta = null
	const opciones = []
	
	override method opciones() {
		return opciones
	}

	method procesarResultado(valorRespuestaElegida){
		if (valorRespuestaElegida){
			resultadoPYR.gana()
			game.addVisual(resultadoPYR) //le aviso al tablero que gano jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		} else { 
			resultadoPYR.pierde()
			game.addVisual(resultadoPYR) //le aviso al tablero que gano jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		}
	}
	
	override method start(){
		//configuro el selector
		self.selectorVertical()
		//Creo y agrego las imagenes del selector
		opciones.add(new Selector3x3(position = game.at(1,4)))
		opciones.add(new Selector3x3(position = game.at(1,7)))
		opciones.add(new Selector3x3(position = game.at(1,10)))
		opciones.forEach({ opcion => game.addVisual(opcion) })
		//Activo la eleccion inicial
		self.opciones().get(index).activar()
		//Inicio el contador e inicio el juego
		game.addVisual(timer)
		timer.countDown(5)
		game.schedule(5000, {	self.timeOut()  } )
		self.seleccionOn()
	}

	method timeOut(){
		self.seleccionOff()
		self.procesarResultado( pregunta.valorRespuestas().get(index) )
	}

	override method clear(){
		game.removeVisual(timer)
		game.removeVisual(resultadoPYR)
		opciones.forEach({ opcion => game.removeVisual(opcion) })
	}
}

class Pregunta {
	// La imagen de la pregunta va ser la imagen del tablero.
	const property image = null

	// Las repuestas son una lista de bool, cada posicion representa si es correcta o no una respuesta
	// El tamaño de la lista debe coincidir con la canitdad de preguntas en la imagen (Propongo que sean 3)
	const property valorRespuestas = []
}

object resultadoPYR{
	var property position = game.at(21,13)
	var property image = "respuestaCorrecta.png"

	method gana() {
		image = "respuesta_correcta.png"
	}
	method pierde() {
		image = "respuesta_incorrecta.png"
	}
}

/*-----------------------------------------------------------------------------------------------------------
	 									Se va el bondi
-------------------------------------------------------------------------------------------------------------*/
class CorreBondi inherits Minijuego{
	const property image = "correBondi.png"
	
	var personajeActivo = false

	const filas = new FilasHorizontal()
	const posicionesFilasY = [9, 13, 17, 21]
	

	method esPosicionValida(posicion){
		return posicion.x().between(5, 24) and posicion.y().between(6, 22) and ( not posicionesFilasY.contains(posicion.y()) or filas.posicionHuecos().contains(posicion) )
	}

	method puedeIrA( posicion ){
		return personajeActivo and self.esPosicionValida( posicion )
	}

	method movimientoOn(){ personajeActivo = true	}
	method movimientoOff(){ personajeActivo = false }

	override method keyLeft(){
		if (self.puedeIrA(pjBondi.position().left(1))) {
			pjBondi.position(pjBondi.position().left(1))
		}
	}
	override method keyRight(){
		if (self.puedeIrA(pjBondi.position().right(1))) {
			pjBondi.position(pjBondi.position().right(1))
		}
	}
	override method keyUp(){
		if (self.puedeIrA(pjBondi.position().up(1))) {
			pjBondi.position(pjBondi.position().up(1))
		}
	}
	override method keyDown(){
		if (self.puedeIrA(pjBondi.position().down(1))) {
			pjBondi.position(pjBondi.position().down(1))
		}
	}
	
	// Arma las filas tomado la posicion de posicionesFilasY (sin el ulitmo elemento) y le asigna una hueco en una posicion al azar (entre 6 y 13)
	// La ultima fila tiene el hueco en un posicion fija, por eso no va en el forEach.
	method armarFilas(){
		posicionesFilasY.subList(0, posicionesFilasY.size() - 2) .forEach( { posicionY => filas.armarFila(20, (6 .. 13).anyOne() , game.at(5, posicionY)) } )
		filas.armarFila(20, 10 , game.at(5, posicionesFilasY.last()))
	}

	method estaEnLaMeta(_personaje){
		return _personaje.position().y() >= bondi.position().y()
	}

	method procesarResultado(){
		if (self.estaEnLaMeta(pjBondi)){
			resultadoPGE.gana() //le aviso al tablero que gano el jugador
			game.addVisualIn(resultadoPGE,game.at(10,11))
			game.schedule( 3000, { miniGameManager.clear() } )
		} else { 
			resultadoPGE.pierde() //le aviso al tablero que perdio jugador
			game.addVisualIn(resultadoPGE,game.at(10,11))
			game.schedule( 3000, { miniGameManager.clear() } )
		}
	}
	
	override method start(){
		bondi.position(game.at(13, 22))
		bondi.image("bondi.png")
		game.addVisual(bondi)
		self.armarFilas()
		pjBondi.position(game.at(15, 6))
		game.addVisual(pjBondi)
		self.movimientoOn()
		game.addVisual(timer)
		timer.countDown(5)
		game.schedule(5000, {	self.timeOut()  } )
	}

	method timeOutBondi(){
		var time = 100
		game.sound("sonidos/bondi.wav").play()
		8.times{ i =>
			game.schedule(time, { bondi.position(bondi.position().right(1)) } )
			time = time + 100
		}
		game.schedule(time + 100, { bondi.image("vacio.png")
								self.procesarResultado() } )	
	}

	method timeOut(){
		self.movimientoOff()
		self.timeOutBondi()
	}

	override method clear(){
		filas.clear()
		game.removeVisual(timer)
		game.removeVisual(resultadoPGE)
		game.removeVisual(bondi)
		game.removeVisual(pjBondi)
	}
}

class FilasHorizontal{
	const property personas = #{}
	const property posicionHuecos = #{}
	
	// Arma una fila de "largo" hacia la derecha comenzado desde "posicionInicio".
	// Se debe indicar en que numero hay un hueco ("posicionHueco").
	method armarFila(largo, posicionHueco, posicionInicio){
		var x = posicionInicio.x()
		const y = posicionInicio.y()
		largo.times({ i => 
			if (i  != posicionHueco){
				const nuevaPersona = new Persona(position = game.at(x, y), image =  ["persona1.png","persona2.png","persona3.png"].anyOne())
				game.addVisual(nuevaPersona)
				personas.add(nuevaPersona)
			} 
			else {
				posicionHuecos.add(game.at(x,y))
			}
			x ++
		})
	}
	
	method clear(){
		personas.forEach( {  persona => game.removeVisual(persona) })
	}	
}

class Persona {
	const property image = null
	const property position = game.at(-10,-10)
}

object pjBondi {
	var property position = game.at(-10,-10)
	
	method image() {
		return 
		if (self.position().y() == bondi.position().y()){
			"vacio.png"
		}
		else "persona0.png"
	}
}

object bondi {
	var property image = "bondi.png"
	var property position = game.at(-10,-10)
}