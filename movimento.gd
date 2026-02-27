extends Sprite2D

@export var velocidade: float = 200.0

func _process(delta):
	var direcao = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direcao.x += 1
	if Input.is_action_pressed("ui_left"):
		direcao.x -= 1
	if Input.is_action_pressed("ui_down"):
		direcao.y += 1
	if Input.is_action_pressed("ui_up"):
		direcao.y -= 1

	if direcao.length() > 0:
		direcao = direcao.normalized()

	position += direcao * velocidade * delta
