import wollok.game.*
import camino.*
import configuracion.*
import sistemaDeTurnos.*

class Personaje {
	
	var property position
	const property image
		
 	method avanzar(cantidad){
 		    
        if (cantidad > 0){
            camino.llevarASiguiente(self)
            	
        }
        turno.pasar()
    }
    
}
