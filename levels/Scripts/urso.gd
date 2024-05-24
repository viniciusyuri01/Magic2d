extends KinematicBody2D

# Variáveis para configurar a IA do inimigo
var speed = 100
var velocity = Vector2.ZERO
var player_in_range = false
var attack_cooldown = false

func _ready():
	# Obter o nó "DetectionArea" que é um filho direto deste nó (urso)
	var detection_area = get_node("DetectionArea")
	# Conectar sinais de detecção de corpo ao script
	if not detection_area.is_connected("body_entered", self, "_on_DetectionArea_body_entered"):
		detection_area.connect("body_entered", self, "_on_DetectionArea_body_entered")
	if not detection_area.is_connected("body_exited", self, "_on_DetectionArea_body_exited"):
		detection_area.connect("body_exited", self, "_on_DetectionArea_body_exited")

func _physics_process(_delta):

	# Verifica se o jogador está na área de detecção
	if player_in_range and Global.player != null:
		var direction = (Global.player.position - position).normalized()
		velocity = direction * speed

		# Ataca se o cooldown do ataque permitir
		if not attack_cooldown:
			attack()
			attack_cooldown = true
			# Inicia um temporizador para o cooldown do ataque
			yield(get_tree().create_timer(1), "timeout")
			attack_cooldown = false
	else:
		velocity = Vector2.ZERO

	# Move o inimigo com a velocidade calculada
	velocity = move_and_slide(velocity)

func attack():
	# Código de ataque (exemplo: reduzir vida do jogador)
	if Global.player != null:
		Global.player.health -= 10

func _on_DetectionArea_body_entered(body):
	# Verifica se o corpo que entrou na área é o jogador
	if body.name == "player":
		player_in_range = true

func _on_DetectionArea_body_exited(body):
	# Verifica se o corpo que saiu da área é o jogador
	if body.name == "player":
		player_in_range = false
