import wollok.game.*
import eventos.*
import sistemaDeTurnos.*

//boceteando el camino
class Camino {

	const property casillas = []

	method construirse(_posiciones) {
		var _numero = 0
		const numUltima = _posiciones.size() - 1
		_posiciones.forEach({ posicion =>
			casillas.add(new Casilla(position = posicion, numero = _numero))
			_numero += 1
		})
		self.poner_En(evento_finDelJuego, numUltima)
	}

	method partida() {
		return casillas.first()
	}

	method llegada() {
		return casillas.last()
	}

	method casillaEn(_posicion) {
		return casillas.findOrElse({ casilla => casilla.contiene(_posicion) }, { self.error("La posicion esta fuera del camino") })
	}

	method esPartida(_casilla) {
		return self.partida() == _casilla
	}

	method esLlegada(_casilla) {
		return self.llegada() == _casilla
	}

	method casillaNumero(unNumero) {
		return casillas.get(unNumero)
	}

	method siguienteA(_casilla) {
		const posicionSiguiente = _casilla.numeroSiguiente()
		return self.casillaNumero(posicionSiguiente)
	}

	method anteriorA(_casilla) {
		const posicionAnterior = _casilla.numeroAnterior()
		return self.casillaNumero(posicionAnterior)
	}
	
	method poner_En(evento, numCasilla){
		self.casillaNumero(numCasilla).asignarEvento(evento)
	}
	
	method generarEventoEnCasillas(evento, numerosCasillas){
		numerosCasillas.forEach({casilla => self.poner_En(evento, casilla)})
	}
}

class Casilla {

	const property numero
	var property evento = null
	const property position

	method representacion() {
		return [ position, position.left(1), position.up(1), position.up(1).left(1) ]
	}

	method contiene(unaPosicion) {
		return self.representacion().contains(unaPosicion)
	}

	method ubicacion() {
		return self.representacion().anyOne()
	}
	
	method numeroSiguiente(){
		return numero + 1
	}
	
	method numeroAnterior(){
		return numero - 1
	}
	
	method distanciaA(_casillaDestino){
		return (_casillaDestino.numero() - self.numero()).abs()
	}

	method asignarEvento(_evento){
		evento = _evento
	}
	
	method activarEvento(){
		if (self.tieneEvento()){
		evento.activar()			
		}
		else {
			evento_finalizarTurno.activar()
		}
	}
	
	method tieneEvento() {
		return evento != null
	}

}

class Semaforo {
		const property image
		var property position = null
	}