import wollok.game.*
import eventos.*
import pruebaInicio.*

object configurar {

	method  tablero() {
		game.height(40)//20
		game.width(30)//15
		game.cellSize(30)//50
		game.boardGround("tablero.jpg")
	}

	method teclas() {
		
		// Jugador
		keyboard.left().onPressDo({ jugador.moverA(jugador.position().left(1)) })
		keyboard.right().onPressDo({ jugador.moverA(jugador.position().right(1)) })
		keyboard.up().onPressDo({ jugador.moverA(jugador.position().up(1)) })
		keyboard.down().onPressDo({jugador.moverA(jugador.position().down(1)) })
		keyboard.c().onPressDo({ game.say(jugador, jugador.position().toString()) })
		
		//Minijuegos
		keyboard.num8().onPressDo({ miniGameManager.keyUp() })
		keyboard.num5().onPressDo({ miniGameManager.keyDown() })
		keyboard.num4().onPressDo({ miniGameManager.keyLeft() })
		keyboard.num6().onPressDo({ miniGameManager.keyRight() })
		keyboard.s().onPressDo({ miniGameManager.load(miniGameFactory.ppt()) miniGameManager.start() })	
	}
	
}

