import wollok.game.*

object tablero{
	var activo = false
	
	method activar(){
		activo = true
	}
	
	method desactivar(){
		activo = false
	}
	
	method activo(){
		return activo
	}
	
}

object turno {

	var index = 0
	const property listaDePersonajes = []

	method agregarPersonaje(personaje) {
		if (tablero.activo()){
			self.validarParaAgregar()
			game.addVisual(personaje)
			listaDePersonajes.add(personaje)
		}
	}
	
	method validarParaAgregar(){
		if (self.cantidadDePersonajes() == 4){
			self.error("La cantidad maxima de jugadores esta en el juego")
		}
	}

	method jugadorActivo() {
		return listaDePersonajes.get(index)
	}
	
	method numeroJugadorActivo(){
		return index
	}

	method cantidadDePersonajes() {
		return listaDePersonajes.size()
	}

	method tirarDados() {
		if (tablero.activo() and not listaDePersonajes.isEmpty()) {
			const movimiento = dado.serLanzado()
			const jugador = self.jugadorActivo()
			game.schedule(2500, { jugador.moverse(movimiento)})
			tablero.desactivar()
		}
	}

	method pasar() {
		index = (index + 1) % self.cantidadDePersonajes()
	}
	
	method reiniciarSistemaDeTurnos(){
		listaDePersonajes.forEach( { personaje => game.removeVisual(personaje) listaDePersonajes.remove(personaje)} )
		index = 0
	}
}

object dado {

	const property position = game.at(13,14)
	var property image = "dado_4.png"
	var property resultado = null

	method nuevoResultado() {
		resultado = (1 .. 6).anyOne()
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
		return (1 .. 6).anyOne()
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

