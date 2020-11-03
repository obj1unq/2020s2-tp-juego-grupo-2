import wollok.game.*


object finDelJuego {
	
	method ganador(numero){
		imagenGanador.ganador(numero)
		game.addVisual(imagenGanador)
		game.onTick(1000, "opcionesFin", { opcionesFin.cambiarImagen() })
		game.addVisual(opcionesFin)
	}
	
	method volverAjugar(){
		game.removeVisual(imagenGanador)
		game.removeVisual(opcionesFin)
		game.removeTickEvent("opcionesFin")
		
		//aca va como reiniciar

	}
	
	method salir(){
		game.stop()
	}

}

object imagenGanador {
	const property position = game.at(0,0)
	var property image = "ganador_0.png"
	
	method ganador(numero){
		image = "ganador_" + numero.toString() + ".png"
	}
}

object opcionesFin{
	const property position = game.at(5,5)
	var property image = "opcionesFin0.png"
	var numeroDeImagenActual = 0

	method cambiarImagen(){
		numeroDeImagenActual = (numeroDeImagenActual + 1) % 2 
		image = "opcionesFin" + numeroDeImagenActual + ".png"
	}
}