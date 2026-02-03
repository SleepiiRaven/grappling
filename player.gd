extends RigidBody2D

@onready var ray = $RayCast2D
@onready var grapple = $Grapple

var collision_point : Vector2

# We can adjust this in the Inspector to change how fast the ship accelerates.
@export var thrust_power: float = 1
@export var pull_power: float = 40

func _physics_process(delta):
	if Input.is_action_pressed("boost"):
		var force = global_position.direction_to(get_global_mouse_position())
		
		force = force.normalized() * thrust_power
		
		apply_central_force(force)

	ray.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("grapple"):
		var collider = ray.get_collider()
		if collider:
			collision_point = ray.get_collision_point()
			
			var distance = collision_point.distance_to(global_position)
			grapple.length = distance
			grapple.global_rotation_degrees = ray.global_rotation_degrees - 90
			
			grapple.node_b = grapple.get_path_to(collider)
	
	if Input.is_action_just_released("grapple"):
		grapple.node_b = NodePath("")
		
		collision_point = Vector2.ZERO
	
	if Input.is_action_pressed("reel") and collision_point != Vector2.ZERO:
		print(grapple.get_node(grapple.node_b))
		var dir = global_position.direction_to(collision_point)
		$RayCast2D2.target_position = dir * 500
		apply_central_force(dir * pull_power)
