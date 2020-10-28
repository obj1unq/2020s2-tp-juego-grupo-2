import wollok.game.*
import jugadores.*

object turno {

	var index = 0
	const property listaDePersonajes = []

	method agregarPersonaje(personaje) {
		game.addVisual(personaje)
		listaDePersonajes.add(personaje)
	}

	method jugadorActivo() {
		return listaDePersonajes.get(index)
	}

	method cantidadDePersonajes() {
		return listaDePersonajes.size()
	}

	method tirarDados() {
		const movimiento = dado.serLanzado()
		const jugador = self.jugadorActivo()
			// jugador.movimientoCompleto(movimiento)
		game.schedule(2500, { jugador.moverse(movimiento)})
		self.pasar()
	}

	method pasar() {
		index = (index + 1) % self.cantidadDePersonajes()
	}

}

object dado {

	const property position = game.center()
	var property image = "dado_4.png"
	var property resultado = null

	method nuevoResultado() {
		resultado = 1.randomUpTo(6).roundUp()
	}

	method animacionDeGiro() {
		var time = 0
		7.times{ i =>
			game.schedule(time, ({ image = "dado_" + self.simulacion().toString() + ".png"}))
			game.schedule(time, { game.addVisual(self)})
			time += 200
			game.schedule(time, { game.removeVisual(self)})
		}
	}

	method simulacion() {
		return 1.randomUpTo(6).roundUp()
	}

	method mostrarResultado() {
		game.schedule(1400, { image = "dado_" + resultado.toString() + ".png"
		; game.addVisual(self)
		})
		game.schedule(2400, { game.removeVisual(self)})
	}

	method serLanzado() {
		self.nuevoResultado()
		self.animacionDeGiro()
		self.mostrarResultado()
		return resultado
	}

}

