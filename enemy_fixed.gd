extends CharacterBody2D

@export var speed: float = 50
@export var move_direction: int = -1  # -1 = يسار, 1 = يمين
var is_dead: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_area: Area2D = $DeathArea
@onready var ray_left: RayCast2D = $RayCast2DLeft
@onready var ray_right: RayCast2D = $RayCast2DRight

func _ready():
	death_area.body_entered.connect(_on_death_area_body_entered)
	sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	if is_dead:
		return  # العدو ميت → مايتحركش

	# حركة العدو
	velocity.x = move_direction * speed
	move_and_slide()

	# انعكاس الاتجاه بالرايكاست
	if move_direction == -1 and ray_left.is_colliding():
		flip_direction()
	elif move_direction == 1 and ray_right.is_colliding():
		flip_direction()

	# تشغيل أنيميشن المشي
	if not sprite.is_playing():
		sprite.play("walk")

	# قلب الشكل حسب الاتجاه
	sprite.flip_h = (move_direction == -1)

func flip_direction():
	move_direction *= -1
	velocity.x = 0

func _on_death_area_body_entered(body):
	if body.is_in_group("player"):
		die()
		if body.has_method("bounce"):
			body.bounce()  # اللاعب يرتد بعد القفز على العدو

func die():
	if is_dead:
		return

	is_dead = true
	sprite.play("die")
	$CollisionShape2D.disabled = true
	death_area.monitoring = false
	velocity = Vector2.ZERO

func _on_animation_finished():
	if is_dead:
		queue_free()



func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene() # Replace with function body.
