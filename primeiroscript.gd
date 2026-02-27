extends Node2D

#var vidas = 5
var tempoRestante = 64.5
var nomeFase = "Fase da Agua"
var powerUp = false

#VARIAVEL
var vidas: int = 5
#CONSTANTE
const VIDAS_PLAYER = 5

func _ready():
	print("Hello, World! " + str(5+6))
	print(vidas)
	print(tempoRestante)
	print(nomeFase)
	print(powerUp)
	powerUp = true
	print(powerUp)
	vidas = vidas + 1
	print(vidas)
	pass 
	
"""
func _process(delta):
	pass

func _physics_process(delta):
	pass
"""
