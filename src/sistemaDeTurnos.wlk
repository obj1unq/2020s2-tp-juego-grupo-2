import configuracion.*
import camino.*
import personajes.*
import wollok.game.*

object turno{
	
	var index = 0
	const property listaDePersonajes = []
	
    method crearPersonaje(personaje){
    	game.addVisual(personaje)
    	listaDePersonajes.add(personaje)
    }
    
    method jugadorActivo(){
    	return listaDePersonajes.get(index)
    }
         
    method cantidadDePersonajes(){
		return listaDePersonajes.size()
	}
	
	method tirarDados(){   	
    	return 1.randomUpTo(6).roundUp()
    }
	
	method pasar(){
		index = (index + 1) % self.cantidadDePersonajes()
	}
	
	
}

object dado{

	const property position = game.center()

	method tirar(){

		self.girar()
		self.nroQueSalio()
	}

	method nroQueSalio(){

		const image = cara.crear()

		game.schedule(2000,{ game.addVisual(image) } ) 
		game.schedule(4500,{ game.removeVisual(image) } )
	}

	method movimiento(tiempo){

		var image
		
		image = cara.crear()
		game.schedule(tiempo,{game.addVisual(image)})
		game.schedule(tiempo*1.3,{ game.removeVisual(image) } )

	}
	
	method girar(){
		7.times({i => self.movimiento(i*300)})
	}

}

class CaraDelDado{

	const property image
	const property position
}

object cara{
	
	method crear(){
		return new CaraDelDado( image = "dado_" + nro.random().toString() + ".png", position = dado.position() )
	}
}

object nro {
	
	method random(){
		return 1.randomUpTo(6).roundUp()	
	}
}
	
	
	
	
	
	
