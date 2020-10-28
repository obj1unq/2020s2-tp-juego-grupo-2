import wollok.game.*
import eventos.*
import sistemaDeTurnos.*
import camino.*
import jugadores.*


object configurar {

	const listacasillas = [ game.at(27, 5), game.at(24,5), game.at(21,5), game.at(18,4), game.at(15,4), game.at(12,4), game.at(9,4), game.at(6,5), game.at(5,7), game.at(5,10), game.at(7,12), game.at(10,12), game.at(13,11), game.at(16,11), game.at(19,11), game.at(22,11), game.at(24,13), game.at(25,17), game.at(23,18), game.at(20,19), game.at(17,19), game.at(14,18), game.at(11,18), game.at(8,18), game.at(5,19), game.at(5,22), game.at(6,25), game.at(9,25), game.at(12,25), game.at(15,25), game.at(18,25), game.at(21,25), game.at(24,25), game.at(27, 25) ]
	const caminoDeJuego = new Camino()
	

	method tablero() {
		game.height(32) // 20
		game.width(30) // 15
		game.cellSize(30) // 50
		game.boardGround("tablero_01.jpg")
		caminoDeJuego.inicializar(listacasillas)
	}

	method teclas() {
	
		// Jugador
//		keyboard.c().onPressDo({ game.say(jugador, jugador.position().toString()) })
//		keyboard.up().onPressDo({ jugador.moverA(jugador.position().up(1)) })
//		keyboard.down().onPressDo({ jugador.moverA(jugador.position().down(1))})
//		keyboard.left().onPressDo({ jugador.moverA(jugador.position().left(1)) })
//		keyboard.right().onPressDo({ jugador.moverA(jugador.position().right(1)) })
	
		// Turno
		keyboard.t().onPressDo({ turno.tirarDados()})
		keyboard.num1().onPressDo({ 
			const jugador1 = new Jugador(camino = caminoDeJuego, image = "persona" + turno.cantidadDePersonajes().toString() +".png")		
			jugador1.inicializar()
			turno.agregarPersonaje(jugador1)})
		keyboard.c().onPressDo({ game.say(jugador1, jugador1.position())})
	
			// Minijuegos
		keyboard.up().onPressDo({ miniGameManager.keyUp()})
		keyboard.down().onPressDo({ miniGameManager.keyDown()})
		keyboard.left().onPressDo({ miniGameManager.keyLeft()})
		keyboard.right().onPressDo({ miniGameManager.keyRight()})
		keyboard.s().onPressDo({ miniGameManager.load(miniGameFactory.ppt())
			miniGameManager.start()
		})
		keyboard.d().onPressDo({ miniGameManager.load(miniGameFactory.pyr())
			miniGameManager.start()
		})
		keyboard.a().onPressDo({ miniGameManager.load(miniGameFactory.correBondi())
			miniGameManager.start()
		})
	}

}

