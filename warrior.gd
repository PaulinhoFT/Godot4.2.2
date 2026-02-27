extends CharacterBody2D

@export var speed: float = 150.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

enum State { IDLE, RUN, ATTACK1, ATTACK2, GUARD }
var current_state = State.IDLE

func _ready():
	# Garante que o sinal de fim de animação esteja conectado
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)
	else:
		push_error("AnimationPlayer não encontrado no Guerreiro!")

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	match current_state:
		State.IDLE, State.RUN:
			handle_movement_logic(direction, delta)
			handle_attack_logic()
			handle_guard_logic()
		State.ATTACK1, State.ATTACK2:
			# Reduz velocidade gradualmente durante o ataque
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		State.GUARD:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			if not Input.is_action_pressed("guard"):
				change_state(State.IDLE)

	move_and_slide()

func handle_movement_logic(direction: Vector2, delta: float):
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
		sprite.flip_h = direction.x < 0 if direction.x != 0 else sprite.flip_h
		change_state(State.RUN)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if velocity.length() < 10:
			change_state(State.IDLE)

func handle_attack_logic():
	if Input.is_action_just_pressed("attack1"):
		change_state(State.ATTACK1)
	elif Input.is_action_just_pressed("attack2"):
		change_state(State.ATTACK2)

func handle_guard_logic():
	if Input.is_action_pressed("guard"):
		change_state(State.GUARD)

func change_state(new_state):
	if current_state == new_state:
		return

	current_state = new_state

	match current_state:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.ATTACK1:
			animation_player.play("Attack 1")
		State.ATTACK2:
			animation_player.play("Attack 2")
		State.GUARD:
			animation_player.play("guard")

func _on_animation_finished(anim_name: StringName):
	# Retorna ao estado IDLE após os ataques terminarem
	if anim_name == "Attack 1" or anim_name == "Attack 2":
		change_state(State.IDLE)
