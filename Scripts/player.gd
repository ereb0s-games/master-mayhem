extends CharacterBody2D

@onready var Lab = $Label
@onready var Cam = $Camera2D
@onready var dash_cooldown = $DashTimer
@onready var dash_particles = $DashParticles

var can_dash = true
var store_jump = false
var is_dashing = false

@export_category("Player Movement")
@export var dash_force = 5000.0 
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

func _ready():
	get_tree().root.size_changed.connect(update_zoom)
	update_zoom()
	# Make sure the timer signal is connected in the editor or here:
	dash_cooldown.timeout.connect(_on_dash_timer_timeout)

func update_zoom():
	if DisplayServer.window_get_mode() >= 2: # Maximize or Fullscreen
		Cam.zoom = Vector2(1, 1)
	else:
		Cam.zoom = Vector2(0.5, 0.5)

func _physics_process(delta: float) -> void:
	if Globals.PlrHealth == 0:
		$"DeathScreen".visible = true
		get_tree().paused = true
	Lab.text = "Zoom: " + str(Cam.zoom)
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump Logic (Simplified)
	if (Input.is_action_just_pressed("w") or Input.is_action_just_pressed("ui_accept")):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		else:
			store_jump = true # Buffer the jump
			
	if store_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		store_jump = false

	# Horizontal Movement
	var direction := Input.get_axis("a", "d")
	var current_speed = SPEED
	if !is_dashing:
		if direction:
			velocity.x = lerp(velocity.x, direction * current_speed, 0.1)
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
	else:
		pass

	# Dash & Physics Apply
	if Input.is_action_just_pressed("dash") and can_dash:
		perform_dash(direction)
	
	move_and_slide()

func perform_dash(dir):
	if dir == 0: return 
	can_dash = false
	is_dashing = true
	
	velocity.x = dir * dash_force
	dash_particles.emitting = true
	
	# START THE COOLDOWN
	dash_cooldown.start()

	await get_tree().create_timer(0.15).timeout
	
	is_dashing = false

func _on_dash_timer_timeout():
	can_dash = true
