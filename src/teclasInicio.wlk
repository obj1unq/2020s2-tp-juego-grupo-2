import wollok.game.*
import eventos.*


class Tecla {
	var property numeroDeImagenActual = 0
	var property image
	const property nombre
	const property position

	method cambiarImagen() {
		numeroDeImagenActual = (numeroDeImagenActual + 1) % 2 
		image = self.nombre() + numeroDeImagenActual + ".png"
	}
	
	method mostrar() {
		if (evento_inicioDelJuego.activo()) {
			game.addVisual(self)
			game.onTick(500, "animacion", { self.cambiarImagen() })
		}
	}
	
	method kill() {
		game.removeVisual(self)
		game.removeTickEvent("animacion")
	}
}

/* 
object teclasInicio inherits Tecla {
	const property position = game.at(0,5)
	
	override method initialize() {
		image = "comienzo0.png"
	} 
	
	override method nombre() = return "comienzo"
	
}

object teclaJugar inherits Tecla {
	const property position = game.at(0,5)
	
	override method initialize() {
		image = "jugar0.png"
	} 
	
	override method nombre() = return "jugar"
}

object teclaSiguiente inherits Tecla {
	const property position = game.at(0,2)
	
	override method initialize() {
		image = "siguiente0.png"
	} 
	
	override method nombre() = return "siguiente"
}
 */