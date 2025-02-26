extends Node

@export var anim_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#anim_player = get_node("AnimationPlayer")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func play_hitspark_animaion(name: String) -> void:
	assert(anim_player.has_animation(name))
	anim_player.play(name)
