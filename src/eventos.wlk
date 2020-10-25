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
		game.removeVisual(relator)
	}
	
	method start(){
		game.addVisual(miniGame)
		miniGame.start()
		game.addVisual(relator)
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
	 									Relator 
-------------------------------------------------------------------------------------------------------------*/

// Para visualiza los mensajes de los minijuegos en una posicion determinada del tablero
object relator {
	var property position = game.at(0,0)
	const property image = "vacio.png"
	
	method decir(mensaje){
		game.say(self, mensaje)
	}
}


/*-----------------------------------------------------------------------------------------------------------
	 									Resultados 
-------------------------------------------------------------------------------------------------------------*/


object resultadoPGE {
	var property image = "resultadoGana.png"
	var property position = game.at(-10,-10)
	
	method gana() {
		image = "resultadoGana.png" 	
	}

	method pierde() {
		image = "resultadoPierde.png"	
	}

	method empata() {
		image = "resultadoEmpata.png"
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
	 									Piedra Papel o tijera
-------------------------------------------------------------------------------------------------------------*/

//Muestra tres opciones en pantalla y 

class PPT inherits Minijuego{
	const property image = "ppt.png"
	
	var index = 0
	
	const opcionesJugador = []
	const opcionesMaquina = []
	var eleccionMaquina = null

	var seleccionActivo = false
			
	method seleccionOn(){
		seleccionActivo = true
	}

	method seleccionOff(){
		seleccionActivo = false
	}

	method elegirMaquina(){
		return opcionesMaquina.get((0 .. 2).anyOne())
	}

	override method keyLeft(){
		if (seleccionActivo) {
			self.seleccionarOpcion(-1)
		}
	}
	override method keyRight(){
		if (seleccionActivo) {
			self.seleccionarOpcion(1)
		}
	}

	
	method seleccionarOpcion(movimientoX){
		opcionesJugador.get(index).desactivar()
		index = ( index + movimientoX ) % 3
		if (index < 0) { 
			index = 2
		} 
		opcionesJugador.get(index).activar()
	}
	
	method reboot(){
		game.removeVisual(resultadoPGE)
		eleccionMaquina.desactivar()
		self.seleccionOn()
		game.schedule(5000, { 	self.timeOut()  } )
	}
	
	method procesarResultado(resultado){
		if (resultado == 1){
			resultadoPGE.gana()
			game.addVisualIn(resultadoPGE,game.at(10,14)) //le aviso al tablero que gano jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		} else { 
			if (resultado == 2) {
				resultadoPGE.pierde()
				game.addVisualIn(resultadoPGE,game.at(10,14))	//le aviso al tablero que perdio jugador
				game.schedule( 3000, {	miniGameManager.clear() } )
			}
			else {
				resultadoPGE.empata()
				game.addVisualIn(resultadoPGE,game.at(10,14))
				game.schedule(5000, { self.reboot() } )
			}
		}
	}
	
	override method start(){
		const piedraMaquina = opcionesFactory.piedra()
		const papelMaquina = opcionesFactory.papel()
		const tijeraMaquina = opcionesFactory.tijera()
		[piedraMaquina, papelMaquina, tijeraMaquina].forEach( { objeto => opcionesMaquina.add(objeto)} )
		const piedraJugador = opcionesFactory.piedra()
		const papelJugador = opcionesFactory.papel()
		const tijeraJugador = opcionesFactory.tijera()
		[piedraJugador, papelJugador, tijeraJugador].forEach( { objeto => opcionesJugador.add(objeto)} )
		game.addVisualIn(piedraMaquina, game.at(6,17))
		game.addVisualIn(papelMaquina, game.at(12,21))
		game.addVisualIn(tijeraMaquina, game.at(18,17))
		game.addVisualIn(piedraJugador, game.at(6,8))
		game.addVisualIn(papelJugador, game.at(12,5))
		game.addVisualIn(tijeraJugador, game.at(18,8))
		opcionesJugador.get(index).activar()
		self.seleccionOn()
		game.schedule(5000, { self.timeOut() })
	}

	method timeOut(){
		self.seleccionOff()
		eleccionMaquina = self.elegirMaquina()
		const eleccionJugador = opcionesJugador.get(index)
		game.schedule( 1000, { eleccionMaquina.activar() })
		game.schedule( 2000, { self.procesarResultado(eleccionJugador.compararCon(eleccionMaquina))	} )
	}

	override method clear(){
		game.removeVisual(resultadoPGE)
		opcionesJugador.forEach( { opcion => game.removeVisual(opcion) } )
		opcionesMaquina.forEach( { opcion => game.removeVisual(opcion) } )
	}
}

class Piedra{
	var property image = "piedra_0.png"
	var property position = game.at(-10,-10)
	const property valor = 1
	
	method compararCon(opcion){
		return 
			if (opcion.valor() == 3){ 1 } //gana 
			else if (opcion.valor() == 2){ 2 } //pierde  
				else {	3 } //empata
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
			if (opcion.valor() == 1){ 1 } //gana
			else if (opcion.valor() == 3){ 2 } //pierde 
				else { 3 } //empata
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
			if (opcion.valor() == 2){ 1 } //gana 
				else if (opcion.valor() == 1){ 2 } //pierde
					else { 3 } //empata
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
	var property image = "p_selector.png"
	var property position = game.at(-10,-10)
	var activo = false
	
	method on(){ activo = true }
	method off(){ activo = false }	
	
	method isOn(){ return activo }
}

/*-----------------------------------------------------------------------------------------------------------
	 									Preguntas y respuestas
-------------------------------------------------------------------------------------------------------------*/
class PYR inherits Minijuego{
	const property image = null
	
	const pregunta = null

	const selector = new Selector3x3()
	const posicionesRespuestas = [game.at(1,4), game.at(1,7), game.at(1,10)]
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
			relator.decir("¿SABES QUE SI?") //le aviso al tablero que gano jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		} else { 
			relator.decir("Esta mal... pero no taaan mal")	//le aviso al tablero que perdio jugador
			game.schedule( 3000, { miniGameManager.clear() } )
		}
	}
	
	override method start(){
		relator.position(game.at(23,14))
		selector.position(posicionesRespuestas.get(indexSelector))	
		game.addVisual(selector)
		selector.on()
		game.schedule(5000, {	self.timeOut()  } )
	}

	method timeOut(){
		selector.off()
		self.procesarResultado( pregunta.valorRespuestas().get(indexSelector) )
	}

	override method clear(){
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
			game.addVisualIn(resultadoPGE,game.at(10,14))
			game.schedule( 3000, { miniGameManager.clear() } )
		} else { 
			resultadoPGE.pierde() //le aviso al tablero que perdio jugador
			game.addVisualIn(resultadoPGE,game.at(10,14))
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
		game.schedule(5000, {	self.timeOut()  } )
	}

	method timeOutBondi(){
		var time = 500
		8.times{ i =>
			game.schedule(time, { bondi.position(bondi.position().right(1)) } )
			time = time + 100
		}
		game.schedule(time, { 	bondi.image("vacio.png")
								self.procesarResultado() } )	
	}

	method timeOut(){
		self.movimientoOff()
		self.timeOutBondi()
	}

	override method clear(){
		filas.clear()
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