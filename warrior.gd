extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = -400.0
@export var acceleration: float = 1000.0
@export var friction: float = 1200.0

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

# Configurações de Spritesheet (obtidas das imagens na pasta Warrior)
const SPRITE_CONFIG = {
	"idle": {"texture": preload("res://Warrior/Warrior_Idle.png"), "hframes": 6},
	"run": {"texture": preload("res://Warrior/Warrior_Run.png"), "hframes": 8},
	"attack1": {"texture": preload("res://Warrior/Warrior_Attack1.png"), "hframes": 6},
	"attack2": {"texture": preload("res://Warrior/Warrior_Attack2.png"), "hframes": 6},
	"guard": {"texture": preload("res://Warrior/Warrior_Guard.png"), "hframes": 3}
}

enum State { IDLE, RUN, ATTACK1, ATTACK2, GUARD, JUMP, FALL }
var current_state = State.IDLE

# Gravidade padrão do projeto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Conecta o sinal de fim de animação para não travar o estado de ataque
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	# Aplica Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:
			change_state(State.FALL)
		else:
			change_state(State.JUMP)

	var direction = Input.get_axis("ui_left", "ui_right")

	match current_state:
		State.IDLE, State.RUN, State.JUMP, State.FALL:
			handle_horizontal_movement(direction, delta)
			handle_jump_logic()
			handle_attack_logic()
			handle_guard_logic()
		State.ATTACK1, State.ATTACK2, State.GUARD:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
			if current_state == State.GUARD and not Input.is_action_pressed("guard"):
				change_state(State.IDLE)

	move_and_slide()

func handle_horizontal_movement(direction, delta):
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		if is_on_floor():
			change_state(State.RUN)
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		if is_on_floor() and velocity.x == 0:
			change_state(State.IDLE)

func handle_jump_logic():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
		change_state(State.JUMP)

func handle_attack_logic():
	if not is_on_floor(): return

	if Input.is_action_just_pressed("attack1"):
		change_state(State.ATTACK1)
	elif Input.is_action_just_pressed("attack2"):
		change_state(State.ATTACK2)

func handle_guard_logic():
	if is_on_floor() and Input.is_action_pressed("guard"):
		change_state(State.GUARD)

func change_state(new_state):
	if current_state == new_state:
		return

	current_state = new_state

	match current_state:
		State.IDLE:
			setup_sprite("idle")
			play_anim("idle")
		State.RUN:
			setup_sprite("run")
			play_anim("run")
		State.ATTACK1:
			setup_sprite("attack1")
			play_anim("Attack 1")
		State.ATTACK2:
			setup_sprite("attack2")
			play_anim("Attack 2")
		State.GUARD:
			setup_sprite("guard")
			play_anim("guard")

func setup_sprite(anim_key):
	var config = SPRITE_CONFIG[anim_key]
	sprite.texture = config["texture"]
	sprite.hframes = config["hframes"]

func play_anim(anim_name):
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
	else:
		# Fallback se a animação não existir
		if current_state in [State.ATTACK1, State.ATTACK2]:
			await get_tree().create_timer(0.4).timeout
			change_state(State.IDLE)

func _on_animation_finished(anim_name: StringName):
	if anim_name == "Attack 1" or anim_name == "Attack 2":
		change_state(State.IDLE)
