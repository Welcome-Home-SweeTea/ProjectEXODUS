extends Camera2D

@onready var topLeft = $Limits/Limit1
@onready var botRight = $Limits/Limit2

@export var zoom_factor:float = 650
var min_zoom:float = 0.65
var max_zoom:float = 1.05
var actors = []

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = botRight.position.y
	limit_right = botRight.position.x
	actors += [$"../Player1", $"../Player2"]
	
func move():
	var avrge = Vector2.ZERO
	for a in actors:
		avrge += a.position
	avrge/=actors.size()
	position = avrge
	
func cam_zm():
	var longest_dist:float = 100
	for e in actors:
		for i in actors:
			if e==i: continue
			var dist:float = (e.global_position-i.global_position).length_squared()
			longest_dist = max(max_zoom, dist)
#	var z = max(min_zoom, zoom_factor/sqrt(longest_dist))
	var z = clamp(zoom_factor/sqrt(longest_dist), min_zoom, max_zoom)
	zoom = Vector2(z, z)
	
func _process(_delta):
	move()
	cam_zm()
