extends CharacterBody2D

signal hit
@export var speed = 300
var last_direction = 1 # 1 = direita, -1 = esquerda

# Configurações da câmera
@export var camera_zoom = Vector2(1.0, 1.0)
@export var camera_smoothing = 5.0

# Limites específicos para cada fase baseados nas dimensões reais dos backgrounds
var fase_limits = {
	"main_primeira_fase": {
		# Baseado nas posições: Player(14,-14), Escriba(2658,1674), Comerciante(-14,1708), Joalheiro(1992,161)
		# Background: (1374, 1626) - expandindo limites para garantir cobertura completa
		"left": 0,
		"top": 0,
		"right": 4000,
		"bottom": 4000
	},
	"main_segunda_fase": {
		# Background: posição (-1086.62, -356.5), escala (1.89844, 1.57813), offset (1077, 992)
		# Collision shapes: x de 66 a 1852, y de 0 a 2430
		# Ajustando limites para ficar mais preciso baseado nos collision shapes
		"left": 50,
		"top": -50,
		"right": 1900,
		"bottom": 2450
	},
	"main_terceira_fase": {
		# Background: posição (811.5, 908.5), escala (1.58301, 1.77637)
		# Collision shapes: x de -57 a 1681, y de -14 a 1814
		# Ajustando limites para ficar mais preciso baseado nos collision shapes
		"left": 0,
		"top": 0,
		"right": 1550,
		"bottom": 1850
	}
}

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
	# Detectar a fase atual baseada no nome da cena
	var current_scene_name = get_tree().current_scene.scene_file_path.get_file().get_basename()
	print("=== DETECTANDO FASE ===")
	print("Nome da cena detectado: ", current_scene_name)
	print("Fases disponíveis: ", fase_limits.keys())
	
	# Usar limites específicos da fase ou padrão se não encontrar
	var limits = fase_limits.get(current_scene_name, {
		"left": 0,
		"top": 0,
		"right": 2000,
		"bottom": 2000
	})
	
	print("Limites escolhidos: ", limits)
	
	# Aplicar os limites da câmera
	camera.limit_left = limits.left
	camera.limit_top = limits.top
	camera.limit_right = limits.right
	camera.limit_bottom = limits.bottom
	
	print("Limites da câmera aplicados:")
	print("- Left: ", camera.limit_left)
	print("- Top: ", camera.limit_top)
	print("- Right: ", camera.limit_right)
	print("- Bottom: ", camera.limit_bottom)

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
		
		if !$andar.playing:
			$andar.play()
		
		
		if velocity.x < 0:
			last_direction = -1
		elif velocity.x > 0:
			last_direction = 1
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()
		$andar.stop()

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

func update_camera_limits_for_scene():
	"""Atualiza os limites da câmera quando mudar de cena"""
	call_deferred("setup_camera_limits")

func force_camera_limits_update():
	"""Força a atualização dos limites da câmera imediatamente"""
	print("=== FORÇANDO ATUALIZAÇÃO DOS LIMITES ===")
	setup_camera_limits()

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
	# Atualizar limites da câmera quando o player for posicionado
	update_camera_limits_for_scene()
	# Forçar atualização após um pequeno delay
	get_tree().create_timer(0.5).timeout.connect(force_camera_limits_update)
