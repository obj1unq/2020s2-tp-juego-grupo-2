import wollok.game.*
import eventos.*
import pruebaInicio.*
import sistemaDeTurnos.*
import personajes.*
import camino.*

const listacasillas = [game.at(27, 6),game.at(24,6),game.at(21,6),game.at(18,6),game.at(15,6),
	game.at(12,6),game.at(9,6),game.at(6,6),game.at(5,9),game.at(5,13),game.at(7,15),
	game.at(10,15),game.at(13,14),game.at(16,14),game.at(19,13),game.at(22,14),game.at(24,16),
	game.at(25,20),game.at(23,23),game.at(20,23),game.at(17,23),game.at(14,23),game.at(11,22),
	game.at(8,22),game.at(5,24),game.at(5,28),game.at(6,31),game.at(9,32),game.at(12,32),
	game.at(15,31),game.at(15,31),game.at(18,31),game.at(21,31),game.at(24,31),game.at(27, 31)]


object configurar {

	method  tablero() {
		game.height(32)//20
		game.width(30)//15
		game.cellSize(30)//50
		game.boardGround("tablero_01.jpg")
		const camino = new Camino(posiciones = listacasillas)
		camino.construirse(listacasillas)
	}

	method teclas() {
		
		// Jugador
		keyboard.c().onPressDo({ game.say(jugador, jugador.position().toString()) })
		
		//Minijuegos
		keyboard.up().onPressDo({ miniGameManager.keyUp() })
		keyboard.down().onPressDo({ miniGameManager.keyDown() })
		keyboard.left().onPressDo({ miniGameManager.keyLeft() })
		keyboard.right().onPressDo({ miniGameManager.keyRight() })
		keyboard.s().onPressDo({ miniGameManager.load(miniGameFactory.ppt()) miniGameManager.start() })	
		keyboard.d().onPressDo({ miniGameManager.load(miniGameFactory.pyr()) miniGameManager.start() })	
		keyboard.a().onPressDo({ miniGameManager.load(miniGameFactory.correBondi()) miniGameManager.start() })	
	}
	
}

