import wollok.game.*
import eventos.*
import sistemaDeTurnos.*
import camino.*
import jugadores.*
import pantallas.*


object configurar {

	const caminoDeJuego = new Camino()
	
	method tablero() {
		const listacasillas = [ game.at(27, 5), game.at(24,5), game.at(21,5), game.at(18,4), game.at(15,4), game.at(12,4), game.at(9,4), game.at(6,5), game.at(5,7), game.at(5,10), game.at(7,12), game.at(10,12), game.at(13,11), game.at(16,11), game.at(19,11), game.at(22,11), game.at(24,13), game.at(25,17), game.at(23,18), game.at(20,19), game.at(17,19), game.at(14,18), game.at(11,18), game.at(8,18), game.at(5,19), game.at(5,22), game.at(6,25), game.at(9,25), game.at(12,25), game.at(15,25), game.at(18,25), game.at(21,25), game.at(24,25), game.at(27, 25) ]
		const posPremios = [4,7,10,14,24,31]
		const posCastigos = [2,13,17,29,32]
		caminoDeJuego.construirse(listacasillas)
		caminoDeJuego.generarPremios(posPremios)
		caminoDeJuego.generarCastigos(posCastigos)
		game.height(32) // 20
		game.width(30) // 15
		game.cellSize(30) // 50
		game.boardGround("tablero_01.jpg")
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
			const jugador1 = new Jugador(camino = caminoDeJuego, image = "jugador" + turno.cantidadDePersonajes().toString() +".png")		
			jugador1.inicializar()
			turno.agregarPersonaje(jugador1)})
		keyboard.c().onPressDo({ game.say(jugador1, jugador1.position())})	
	
		// Minijuegos
		keyboard.up().onPressDo({ miniGameManager.keyUp()})
		keyboard.down().onPressDo({ miniGameManager.keyDown()})
		keyboard.left().onPressDo({ miniGameManager.keyLeft()})
		keyboard.right().onPressDo({ miniGameManager.keyRight()})
		
		const pe  = preguntasFactory.nueva("p_pe.png",  [false, true, false])
		const lh  = preguntasFactory.nueva("p_lh.png",  [false, false, true])
		const alf = preguntasFactory.nueva("p_alf.png", [true, false, false])
		const gu  = preguntasFactory.nueva("p_gu.png",  [false, true, false])
		const mo  = preguntasFactory.nueva("p_mo.png",  [true, false, false])
		const io  = preguntasFactory.nueva("p_io.png",  [false, false, true])
		const ba  = preguntasFactory.nueva("p_ba.png",  [false, true, false])
		const ri  = preguntasFactory.nueva("p_ri.png",  [true, false, false])
		
		const listPYR = [pe,lh,alf,gu,mo,io,ba,ri]

		
		keyboard.s().onPressDo({ miniGameManager.load( miniGameFactory.ppt()) miniGameManager.start() })
		keyboard.d().onPressDo({ miniGameManager.load( miniGameFactory.pyr(listPYR.anyOne()) ) miniGameManager.start() })
		keyboard.a().onPressDo({ miniGameManager.load( miniGameFactory.correBondi()) miniGameManager.start() })

		//Fin Del Juego
		keyboard.q().onPressDo( { finDelJuego.salir()} )
		keyboard.enter().onPressDo( { finDelJuego.volverAjugar() } )
		keyboard.p().onPressDo( { finDelJuego.ganador(1) } )
	}

}

