extends CharacterBody2D
@onready var tile_map = $"../TileMap"



var is_moving = false
const SPEED = 5
var dist_remaining = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	prints(int(position.x-36)%64,int(position.y-36)%64)
	if is_moving:
		move(velocity)
		prints(position.x,position.y)
		if velocity.y != 0:
			if int(position.y-36)%64 == 0:
				is_moving = false
		elif velocity.x != 0:
			if int(position.x-36)%64 == 0:
				is_moving = false
	if not is_moving:
		if Input.is_action_pressed("up"):
			newMove(Vector2.UP)
		elif Input.is_action_pressed("left"):
			newMove(Vector2.LEFT)
		elif Input.is_action_pressed("right"):
			newMove(Vector2.RIGHT)
		elif Input.is_action_pressed("down"):
			newMove(Vector2.DOWN)

	

func newMove(direction: Vector2):
	var current_tile = tile_map.local_to_map(global_position)
	var target_tile = Vector2i(current_tile.x+direction.x,current_tile.y+direction.y)
	
	if not tile_map.get_cell_tile_data(0,target_tile).get_custom_data("walkable"):
		return
	dist_remaining = 64
	move(direction)

func move(direction: Vector2):
	position.x += direction[0]*min(SPEED,dist_remaining)
	position.y += direction[1]*min(SPEED,dist_remaining)
	
	velocity.x = direction[0]
	velocity.y = direction[1]
	
	dist_remaining -= SPEED
	
	is_moving = true
