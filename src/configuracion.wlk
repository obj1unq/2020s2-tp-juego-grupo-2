import wollok.game.*
import minijuegos.*
import sistemaDeTurnos.*
import camino.*
import jugadores.*
import eventos.*


object configurar {

	const caminoDeJuego = new Camino()
	
	method juego() {
		//configuracion e inicializacion de camino
		const listacasillas = [ game.at(27, 5), game.at(24,5), game.at(21,4), game.at(18,4), game.at(15,4), game.at(12,4), game.at(9,4), game.at(6,5), game.at(5,7), game.at(5,10), game.at(7,12), game.at(10,12), game.at(13,11), game.at(16,11), game.at(19,11), game.at(22,11), game.at(24,13), game.at(25,16), game.at(23,18), game.at(20,19), game.at(17,19), game.at(14,18), game.at(11,18), game.at(8,18), game.at(5,19), game.at(5,22), game.at(6,25), game.at(9,25), game.at(12,25), game.at(15,25), game.at(18,25), game.at(21,25), game.at(24,25), game.at(27, 25) ]
		const posPremios = [4,7,10,14,24,30]
		const posCastigos = [2,13,17,29,32]
		const posPPT = [3,12,21]
		const posPYR = [6,15,16]
		const posBondi =[9,18,27]
		const premioStandar = new Recompensa()
		const castigoStandar = new Castigo()
		const verde = new Semaforo(image="verde.png")
		const rojo = new Semaforo(image="rojo.png")
		const amarillo = new Semaforo(image="amarillo.png")
		caminoDeJuego.construirse(listacasillas)
		//Agregamos los eventos al tablero
		caminoDeJuego.generarEventoEnCasillas(premioStandar, posPremios)
		caminoDeJuego.generarEventoEnCasillas(castigoStandar, posCastigos)
		caminoDeJuego.generarEventoEnCasillas(evento_ppt, posPPT)
		caminoDeJuego.generarEventoEnCasillas(evento_pyr, posPYR)
		caminoDeJuego.generarEventoEnCasillas(evento_bondi, posBondi)
		caminoDeJuego.colocarImagenesEnCasillas(verde, posPremios)
		caminoDeJuego.colocarImagenesEnCasillas(rojo, posCastigos)
		caminoDeJuego.colocarImagenesEnCasillas(amarillo, posPPT)
		caminoDeJuego.colocarImagenesEnCasillas(amarillo, posPYR)
		caminoDeJuego.colocarImagenesEnCasillas(amarillo, posBondi)
	}

	method board() {
		//Configuracion inicial del tablero
		game.title("El juego de las estrellas de Cronica")
		game.height(32) // 20
		game.width(30) // 15
		game.cellSize(30) // 50
		game.boardGround("tablero_01.jpg")
		
	}

	method teclas() {
	
	
		// Turno
		keyboard.t().onPressDo({ turno.tirarDados()})
		keyboard.num1().onPressDo({ turno.agregarPersonaje(new Jugador(camino = caminoDeJuego, image = "jugador" + turno.cantidadDePersonajes().toString() +".png")) })	
	
		// Minijuegos
		keyboard.up().onPressDo({ miniGameManager.keyUp()})
		keyboard.down().onPressDo({ miniGameManager.keyDown()})
		keyboard.left().onPressDo({ miniGameManager.keyLeft()})
		keyboard.right().onPressDo({ miniGameManager.keyRight()})
		

		//Inicio del juego
		keyboard.space().onPressDo( { evento_inicioDelJuego.iniciar()} )


		//Fin Del Juego
		keyboard.q().onPressDo( { evento_finDelJuego.salir()} )
		keyboard.enter().onPressDo( { evento_finDelJuego.volverAjugar() 
									   miniGameManager.enter() } )
	}

}

	

