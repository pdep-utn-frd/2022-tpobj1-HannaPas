import wollok.game.*
    
const velocidad = 250


object juego{

        method configurar(){
		game.width(16)
		game.height(11)
		game.title("Robot Game")
		game.boardGround("fondo21.png")
		game.addVisual(suelo)
		game.addVisual(obstaculo)
		game.addVisual(moneda)
		game.addVisual(robot)
		game.cellSize(37)
		game.addVisual(contador)
		game.addVisual(puntuacion)
		
	
		keyboard.space().onPressDo{ self.jugar()}
	        game.onCollideDo(robot,{ obstaculo => obstaculo.chocar()})
     	        game.whenCollideDo(robot, {moneda=> moneda.chocar()})		
	} 
	
	method iniciar(){
		robot.iniciar()
		contador.iniciar()
		obstaculo.iniciar()
		moneda.iniciar()
	}
	
	method jugar(){
		if (robot.estaVivo()) 
			robot.saltar()
		else {
	              game.removeVisual(gameOver)
	              game.addVisual(robot)
	              game.addVisual(moneda)
	              game.addVisual(obstaculo)
	              self.iniciar()
		}
	}
	
	method terminar(){
		sonidogameover.play()
		game.addVisual(gameOver)
		obstaculo.detener()
		moneda.detener()
		contador.detener()
		game.removeVisual(robot)
		robot.morir()	
	}
	
}

object gameOver {
	method position() = game.at(game.width()-12 , game.height()-9)
        method image() = "gameover.png" 
}

object moneda {
                const posicionInicial = game.at(game.width()-5,suelo.position().y()+2)
	        var position = posicionInicial
	        var aparece 
	method image() = "moneda1.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(3000,"aparece",{self.aparecer()})
		game.onTick(velocidad,"moverMoneda",{self.mover()})
		aparece=true
	}
	
	method aparecer(){
			if(not aparece){
 			game.addVisual(self)
 			aparece=true
 			}	
	}
	method mover(){
	        position = position.left(1)
	        if (position.x() == -1)
	            position = (posicionInicial)
	}
	  
	method chocar(){
		sonidomoneda.play()	
		contador.Bonus()
		game.removeVisual(self)
		aparece = false
	}
        method detener(){
		game.removeTickEvent("moverMoneda")
		if(aparece)
		game.removeVisual(self)
		game.removeTickEvent("aparece")
	}

}


object  sonidomoneda{
	method play(){
		game.sound("sonidomoneda.mp3").play()

}
}

object sonidogameover{
	method play(){
		game.sound("sonidogameover.mp3").play()
	}
}
object color {
	const property rojo = "FF0000FF"
}

object puntuacion {
       method text() = "Puntaje: "
       method textColor()= color.rojo()
       method position() = game.at(1,game.height()-2)
}



object contador {
                var contador = 0
	method text() = contador.toString()
	method textColor() = color.rojo()
	method position() = game.at(3, game.height()-2)
	
	method Bonus() {
		contador = contador + 20
	}
	method iniciar(){
		contador = 0
		game.onTick(1000,"contador",{self.sumar()})
	}
	method sumar(){
		contador= contador + 1
	}
	method detener(){
		game.removeTickEvent("contador")
	}
}

object obstaculo {
	 
	        const posicionInicial = game.at(game.width()-1,suelo.position().y()+1)
	        var position = posicionInicial	
	method image() = "obstaculo.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverobstaculo",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
	            position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
        method detener(){
		game.removeTickEvent("moverobstaculo")
		game.removeVisual(self)
	}
}

object suelo{
	 
	method position() = game.at(0,0)
	method image() = "suelo.png" 
}


object robot {
	        var vivo 
	        var position = game.at(2,suelo.position().y()+1)
	method image() = "robot.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()+1) {
			self.subir()
			game.schedule(velocidad*2,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		vivo = false
		
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}