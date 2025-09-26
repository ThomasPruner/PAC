extends CharacterBody2D

signal hit
@export var speed = 300
var last_direction = 1 # 1 = direita, -1 = esquerda

# Configurações da câmera
@export var camera_zoom = Vector2(1.0, 1.0)
@export var camera_smoothing = 5.0
@export var map_size = Vector2(4000, 4000)

var camera: Camera2D

func _ready():
	camera = $Camera2D
	
	# Configurar câmera
	camera.zoom = camera_zoom
	camera.enabled = true
	
	# Definir limites da câmera baseados no tamanho do mapa
	setup_camera_limits()
	
	# Configurar câmera para seguir o player suavemente
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = camera_smoothing

func setup_camera_limits():
	# Limites simples da câmera - permite que ela se mova livremente pelo mapa
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = map_size.x
	camera.limit_bottom = map_size.y

func _physics_process(delta):
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_down"):
		input_dir.y += 1
	if Input.is_action_pressed("move_up"):
		input_dir.y -= 1

	# Normaliza e aplica velocidade
	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * speed
		$AnimatedSprite2D.play("Walking")

		if velocity.x < 0:
			last_direction = -1
		elif velocity.x > 0:
			last_direction = 1
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()

	move_and_slide()

	# Flip horizontal conforme a direção
	$AnimatedSprite2D.flip_h = (last_direction == -1)
	
	# Atualizar posição da câmera para seguir o player
	update_camera_position()

func update_camera_position():
	# A câmera já está configurada para seguir o player automaticamente
	# devido ao position_smoothing_enabled = true
	# Mas podemos adicionar lógica adicional se necessário
	pass

func set_camera_zoom(new_zoom: float):
	"""Ajusta o zoom da câmera"""
	camera_zoom = Vector2(new_zoom, new_zoom)
	camera.zoom = camera_zoom
	setup_camera_limits()  # Recalcular limites com novo zoom

func get_camera_bounds() -> Rect2:
	"""Retorna os limites atuais da câmera"""
	return Rect2(
		camera.limit_left,
		camera.limit_top,
		camera.limit_right - camera.limit_left,
		camera.limit_bottom - camera.limit_top
	)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
