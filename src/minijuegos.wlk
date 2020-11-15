import wollok.game.*
import sistemaDeTurnos.*
import eventos.*


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
		game.addVisual(miniGame.pantalla())
		game.schedule( 2000, { game.removeVisual(miniGame.pantalla())
							   game.addVisual(miniGame)
						  	   miniGame.start() } )
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
	method enter(){
		if (self.hasGameLoaded()){ miniGame.enter() }
	}
}

object miniGameFactory{
	method ppt(){
		return new PPT()
	}
	
	method pyr(_pregunta){
		return new PYR( pregunta = _pregunta, image = _pregunta.image()  )
	}
	
	method correBondi(){
		return new CorreBondi()		
	}
}

object preguntasFactory{

	method nueva(_image, _valorRespuestas){
		return 	new Pregunta (image = _image, valorRespuestas = _valorRespuestas)
	}
}


/*-----------------------------------------------------------------------------------------------------------
	 									Resultados
-------------------------------------------------------------------------------------------------------------*/

object resultadoSilvio_PGE {
	var property image = "resultadoGana.png"
	var property position = game.at(10,11)
	var sound = null
	
	method playSound(){	
		game.sound(sound).play()
	}
	
	method gana() {
		image = "silvio_ganaste.png"
 		sound = "sonidos/win.mp3"
	}

	method pierde() {
		image = "silvio_perdiste.png"
		sound = "sonidos/lose.mp3"	
	}

	method empata() {
		image = "silvio_empate.png"
		sound = "sonidos/empate.mp3"
	}	
}

object resultadoGuido_PYR{
	var property position = game.at(21,13)
	var property image = "respuestaCorrecta.png"
	var sound = null

	method playSound(){	
		game.sound(sound).play()
	}
	method gana() {
		image = "respuesta_correcta.png"
		sound = "sonidos/sabes_que_si.mp3"
	}
	method pierde() {
		image = "respuesta_incorrecta.png"
		sound = "sonidos/esta_mal.mp3"
	}
}

/*-----------------------------------------------------------------------------------------------------------
	 									Timer
-------------------------------------------------------------------------------------------------------------*/


object timer{
	var property image = "vacio.png"
	var property position = game.at(14,28)
	var property running = false

	//Solo admite numeros del 1 al 9
	method countdown(segundos){
		var tickNumber = segundos
		running = true
		
		self.tick(tickNumber)
		tickNumber --
		
		game.onTick(1000, "Countdown", { self.tick(tickNumber)
										 self.checkEndCountDown(tickNumber) 
										 tickNumber -- })
	}
	
	method tick(tickNumber){
		image = (tickNumber).toString() + ".png"
		game.sound("sonidos/timer.wav").play()
	}

	method checkEndCountDown(tickNumber){
		if (tickNumber < 1){
			self.stop()
			running = false
		}	
	}
	
	method stop(){
		if(running){	
			game.removeTickEvent("Countdown")
			running = false
		}
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
	method enter(){ /*Sin uso*/	}

	method finalizar(objResultado, eventoResultado){
			game.addVisual(objResultado)
			objResultado.playSound()
			game.schedule( 4000, { miniGameManager.clear() } )		
			game.schedule( 4500, { eventoResultado.activar() })
	}

	method procesarResultado(gano, objResultado){
		if (gano){
			objResultado.gana() 
			self.finalizar(objResultado, self.recompensa())
		} else { 
			objResultado.pierde() 
			self.finalizar(objResultado, self.castigo())
		}
	}
	
	method start()
	method clear()
	method pantalla()
	method recompensa()
	method castigo()
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
	
	method seleccionarOpcionSiActivo(opcion, movimientoAchequear){
		if (seleccionActivo and movimientoAchequear) {
			self.seleccionarOpcion(opcion)
		}
		
	}
	
	override method keyLeft(){
		self.seleccionarOpcionSiActivo(-1, seleccionHorizontal)
	}
	
	override method keyRight(){
		self.seleccionarOpcionSiActivo(1, seleccionHorizontal)
	}
	
	override method keyUp(){
		self.seleccionarOpcionSiActivo(1, seleccionVertical)
	}
	
	override method keyDown(){
		self.seleccionarOpcionSiActivo(-1, seleccionVertical)
	}
	
	override method enter(){
		if (timer.running()){
			self.timeout()
			timer.stop()	
			game.sound("sonidos/select.mp3").play()
		}
	}
	
	method seleccionarOpcion(movimientoX){
		self.opciones().get(index).desactivar()
		index = ( index + movimientoX ) % 3
		if (index < 0) { 
			index = 2
		}
		self.opciones().get(index).activar()
					game.sound("sonidos/move.wav").play()
	}
	
	method opciones()	
	method timeout()
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
	const countdownTime = 5
	
	override method pantalla() {
		return pantalla_ppt
	}
	
	override method recompensa(){
		return new Recompensa(movimientos = 2)
	}
	
	override method castigo(){
		return new Castigo(movimientos = 2)		
	}
	
	override method opciones() {
		return opcionesJugador
	}

	method elegirMaquina(){
		return opcionesMaquina.get((0 .. 2).anyOne())
	}

	method prepararOpcionesMaquina(){
		const piedraMaquina = opcionesFactory.piedra()
		const papelMaquina = opcionesFactory.papel()
		const tijeraMaquina = opcionesFactory.tijera()
		[piedraMaquina, papelMaquina, tijeraMaquina].forEach( { objeto => opcionesMaquina.add(objeto)} )

		game.addVisualIn(piedraMaquina, game.at(6,17))
		game.addVisualIn(papelMaquina, game.at(12,21))
		game.addVisualIn(tijeraMaquina, game.at(18,17))
	}
	
	method prepararOpcionesJugador(){
		const piedraJugador = opcionesFactory.piedra()
		const papelJugador = opcionesFactory.papel()
		const tijeraJugador = opcionesFactory.tijera()
		[piedraJugador, papelJugador, tijeraJugador].forEach( { objeto => opcionesJugador.add(objeto)} )

		game.addVisualIn(piedraJugador, game.at(6,8))
		game.addVisualIn(papelJugador, game.at(12,5))
		game.addVisualIn(tijeraJugador, game.at(18,8))
	}
	
	override method start(){
		//Configuro el selector
		self.selectorHorizontal()

		//Configuro las opciones
		self.prepararOpcionesMaquina()
		self.prepararOpcionesJugador()
		
		//Activo la eleccion inicial
		self.opciones().get(index).activar()
		
		//Arranco el contador y habilito la seleccion
		game.addVisual(timer)
		self.startCountdown(countdownTime)
		self.seleccionOn()
	}
	
	method startCountdown(segundos){
		timer.countdown(segundos)
		game.onTick(segundos * 1000, "PPT_Countdown", { self.timeout() })
	}
	
	method stopCountdown(){
		game.removeTickEvent("PPT_Countdown")		
	}
	
	override method timeout(){
		self.stopCountdown()
		self.seleccionOff()
		eleccionMaquina = self.elegirMaquina()
		const eleccionJugador = opcionesJugador.get(index)
		game.schedule( 1000, { eleccionMaquina.activar() })
		game.schedule( 1500, { self.procesarResultadoPPT(eleccionJugador.compararCon(eleccionMaquina), resultadoSilvio_PGE) } )
	}

	method procesarResultadoPPT(resultadoPPT, objResultado){
		if (resultadoPPT == 3) {
				objResultado.empata()
				game.addVisual(objResultado)
				objResultado.playSound()
				game.schedule( 3000, { self.reboot() } )
		} else {
			self.procesarResultado(resultadoPPT == 1, objResultado)
		}
		
	}
	
	method reboot(){
		game.removeVisual(resultadoSilvio_PGE)
		eleccionMaquina.desactivar()
		self.startCountdown(countdownTime)
		self.seleccionOn()
	}

	override method clear(){
		game.removeVisual(timer)
		game.removeVisual(resultadoSilvio_PGE)
		opcionesJugador.forEach( { opcion => game.removeVisual(opcion) } )
		opcionesMaquina.forEach( { opcion => game.removeVisual(opcion) } )
	}
}

class OpcionPPT {
	var property image = null
	const imageActivo 
	const imageInactivo 
	var property position = null
	const property valor
	//Valores para comparar recibe es una lista con los valores correspondientes a [LeGanaA, PierdeCon]
	const valoresParaComparar 
	
	override method initialize(){
		image = imageInactivo
	}
	
	method compararCon(opcion){
		return 
			if (opcion.valor() == valoresParaComparar.get(0)){ //gana 
				1 
			} 
			else if (opcion.valor() == valoresParaComparar.get(1)){ //pierde
				2
			}   
			else {	//empata
			
				3
			} 	 
	}	
	
	method activar(){
		image = imageActivo		
	}
	method desactivar(){
		image = imageInactivo		
	}
}		

object pantalla_ppt{
	const property image = "pantalla_ppt.png"
	const property position = game.at(0,0)
}

object opcionesFactory{
	method piedra(){ return new OpcionPPT(imageActivo = "piedra_1.png", imageInactivo = "piedra_0.png", valor = 1, valoresParaComparar = [3,2] ) }
	method papel() { return new OpcionPPT(imageActivo = "papel_1.png",  imageInactivo = "papel_0.png",  valor = 2, valoresParaComparar = [1,3] ) }
	method tijera(){ return new OpcionPPT(imageActivo = "tijera_1.png", imageInactivo = "tijera_0.png", valor = 3, valoresParaComparar = [2,1] ) }
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
	const countdownTime = 9
	
	override method pantalla() {
		return pantalla_pyr
	}
	
	override method recompensa(){
		return new Recompensa(movimientos = 2)
	}
	
	override method castigo(){
		return new Castigo(movimientos = 2)		
	}
	
	
	override method opciones() {
		return opciones
	}

	method prepararOpciones(){
		opciones.add(new Selector3x3(position = game.at(1,4)))
		opciones.add(new Selector3x3(position = game.at(1,7)))
		opciones.add(new Selector3x3(position = game.at(1,10)))
		opciones.forEach({ opcion => game.addVisual(opcion) })
	}

	override method start(){
		//configuro el selector
		self.selectorVertical()

		//Preparo las opciones
		self.prepararOpciones()

		//Activo la eleccion inicial
		self.opciones().get(index).activar()

		//Inicio el contador e inicio el juego
		self.startCountdown(countdownTime)
		self.seleccionOn()
	}
	
	method startCountdown(segundos){
		game.addVisual(timer)
		timer.countdown(segundos)
		game.onTick(segundos * 1000, "PYR_Countdown", { self.timeout() })
	}

	override method timeout(){
		game.removeTickEvent("PYR_Countdown")
		self.seleccionOff()
		self.procesarResultado( pregunta.valorRespuestas().get(index), resultadoGuido_PYR )
	}

	override method clear(){
		game.removeVisual(timer)
		game.removeVisual(resultadoGuido_PYR)
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

object pantalla_pyr{
	const property image = "pantalla_pyr.png"
	const property position = game.at(0,0)
}

/*-----------------------------------------------------------------------------------------------------------
	 									Se va el bondi
-------------------------------------------------------------------------------------------------------------*/
class CorreBondi inherits Minijuego{
	const property image = "correBondi.png"
	
	var personajeActivo = false

	const posicionesFilasY = [9, 13, 17, 21]

	override method recompensa(){
		return new Recompensa(movimientos = 2)
	}
	
	override method castigo(){
		return new Castigo(movimientos = 2)		
	}
	
	override method pantalla() {
		return pantalla_bondi
	}

	method movimientoOn(){  personajeActivo = true	}
	method movimientoOff(){ personajeActivo = false }	

	method esPosicionValida(posicion){
		return posicion.x().between(5, 24) and posicion.y().between(6, 22) and ( not posicionesFilasY.contains(posicion.y()) or filaHorizontal.posicionHuecos().contains(posicion) )
	}

	method puedeIrA( posicion ){
		return personajeActivo and self.esPosicionValida( posicion )
	}

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
		posicionesFilasY.subList(0, posicionesFilasY.size() - 2) .forEach( { posicionY => filaHorizontal.armarFila(20, (6 .. 13).anyOne() , game.at(5, posicionY)) } )
		filaHorizontal.armarFila(20, 10, game.at(5, posicionesFilasY.last()))
	}

	method estaEnLaMeta(_personaje){
		return _personaje.position().y() >= bondi.position().y()
	}

	method prepararJuego(){
		bondi.inicializar()
		self.armarFilas()
		pjBondi.inicializar()		
	}
	
	method calcularTiempo(){
		var posicionHorizontalAComparar = pjBondi.position()
		var distanciaHorizontal = 0

		filaHorizontal.posicionHuecos().forEach({ posicion => distanciaHorizontal +=  self.calcularDistanciaEnX( posicion, posicionHorizontalAComparar )  
												  posicionHorizontalAComparar = posicion } )
		const distanciaVertical = bondi.position().y() - pjBondi.position().y()
		return (( distanciaHorizontal + distanciaVertical).div(6) + 1 ).min(9)
	}

	method calcularDistanciaEnX(posicion1, posicion2){
		return (posicion1.x() - posicion2.x()).abs()
	}
	
	override method start(){
		self.prepararJuego()
		self.startCountdown(self.calcularTiempo())
		self.movimientoOn()
	}

	method startCountdown(segundos){
		game.addVisual(timer)
		timer.countdown(segundos)
		game.onTick(segundos * 1000, "PPT_Countdown", { self.timeout() })
	}

	method timeout(){
		game.removeTickEvent("PPT_Countdown")
		self.movimientoOff()
		self.arrancarBondi()
	}

	method arrancarBondi(){
		bondi.avanzar(8)
		game.schedule(1000, { bondi.image("vacio.png")
							  self.procesarResultado(self.estaEnLaMeta(pjBondi), resultadoSilvio_PGE) } )	
	}

	override method clear(){
		filaHorizontal.clear()
		game.removeVisual(timer)
		game.removeVisual(resultadoSilvio_PGE)
		game.removeVisual(bondi)
		game.removeVisual(pjBondi)
	}
	
}

object filaHorizontal{
	var property personas = #{}
	var property posicionHuecos = #{}
	
	// Arma una fila de "largo" hacia la derecha comenzado desde "posicionInicio".
	// Se debe indicar en que numero hay un hueco ("posicionHueco").
	method armarFila(largo, posicionHueco, posicionInicio){
		var x = posicionInicio.x()
		const y = posicionInicio.y()
		largo.times({ i => 
			if (i  == posicionHueco){
				posicionHuecos.add(game.at(x,y))
			} 
			else {
				const nuevaPersona = new Persona(position = game.at(x, y), image =  ["persona1.png","persona2.png","persona3.png"].anyOne())
				game.addVisual(nuevaPersona)
				personas.add(nuevaPersona)
			}
			x ++
		})
	}
	
	method clear(){
		personas.forEach( {  persona => game.removeVisual(persona) })
		personas = #{}
		posicionHuecos = #{}
	}	
}


object pjBondi {
	var property position = null
	
	method inicializar(){
		position = game.at(15, 6)
		game.addVisual(self)
	}
	
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
	var property position = null
	
	method inicializar(){
		position = game.at(13, 22)
		image = "bondi.png"
		game.addVisual(self)
	}
	
	method avanzar(posiciones){
		var time = 100
		game.sound("sonidos/bondi.wav").play()
		posiciones.times{ i =>
			game.schedule(time, { self.position(self.position().right(1)) } )
			time = time + 100
		}
	}
	
}

class Persona {
	const property image = null
	const property position = null
}

object pantalla_bondi {
	const property image = "pantalla_bondi.png"
	const property position = game.at(0,0)
}