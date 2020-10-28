import wollok.game.*
import jugadores.*

object turno{
	
	var index = 0
	const property listaDePersonajes = []
	
    method agregarPersonaje(personaje){
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
		dado.serLanzado()
    	const movimiento = dado.resultado()
    	const jugador = self.jugadorActivo()
    	//jugador.movimientoCompleto(movimiento)
    	jugador.moverse(movimiento)
    	self.pasar()
    }
	
	method pasar(){
		index = (index + 1) % self.cantidadDePersonajes()
	}
	
}

object dado{

	const property position = game.center()
	var property image = "dado_4.png"
	var property resultado = null
	
	method nuevoResultado(){
		resultado = 1.randomUpTo(6).roundUp()
	}
	
	method animacionDeGiro(){
		var time = 0
		7.times{ i => game.schedule(time, ({image = "dado_" + self.simulacion().toString() + ".png"}))
			game.schedule(time, {game.addVisual(self)})
			time += 200
			game.schedule(time, {game.removeVisual(self)})
		}
	}
	
	method simulacion(){
		return 1.randomUpTo(6).roundUp()
		}
	
	method mostrarResultado(){
		game.schedule(1400, {image = "dado_" + resultado.toString() + ".png"; game.addVisual(self)})
		game.schedule(2400, {game.removeVisual(self)})
	}

	method serLanzado(){
		self.nuevoResultado()
		self.animacionDeGiro()
		self.mostrarResultado()
		//return resultado
	}
}
















//	method tirar(){
//
//		self.girar()
//		self.nroQueSalio()
//	}
//
//	method nroQueSalio(){
//
//		const image = cara.crear()
//
//		game.schedule(2000,{ game.addVisual(image) } ) 
//		game.schedule(4500,{ game.removeVisual(image) } )
//	}
//
//	method movimiento(tiempo){
//
//		var image
//		
//		image = cara.crear()
//		game.schedule(tiempo,{game.addVisual(image)})
//		game.schedule(tiempo*1.3,{ game.removeVisual(image) } )
//
//	}
//	
//	method girar(){
//		7.times({i => self.movimiento(i*300)})
//	}
//
//}
//
//class CaraDelDado{
//
//	const property image
//	const property position
//}
//
//object cara{
//	
//	method crear(){
//		return new CaraDelDado( image = "dado_" + nro.random().toString() + ".png", position = dado.position() )
//	}
//}
//
//object nro {
//	
//	method random(){
//		return 1.randomUpTo(6).roundUp()	
//	}
//}
	
	
	
	
	
	
