extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D
var animation_played = false

func _ready():
	# ربط الإشارة 'animation_finished' لتشغيل دالة عند انتهاء الأنيميشن
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _on_body_entered(body):
	# تأكد من أن الأنيميشن يُشغل مرة واحدة فقط
	if not animation_played:
		animation_played = true
		animated_sprite_2d.play("new_animation")
		# تأكد من عدم تشغيل الأنيميشن مرة أخرى بعد انتهائه

func _on_animation_finished():
	# بعد الانتهاء من الأنيميشن، حذف العنصر
	queue_free()
