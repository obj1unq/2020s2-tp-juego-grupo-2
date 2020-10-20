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