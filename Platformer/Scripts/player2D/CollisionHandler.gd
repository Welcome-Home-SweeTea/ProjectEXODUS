extends Node

@export var hitbox : Area2D
@export var hurtbox : Area2D
@export var hitspark_handler : Node

@export var registered_targets : Dictionary = {}
@export var player : Player
@export var damage : int
@export var blockstun : int
@export var hitstun : int
@export var hitspark : String

func _ready() -> void:
	hitbox.area_entered.connect(hit_landed)

func _physics_process(delta: float) -> void:
	pass

func new_hit(new_damage: int, new_blockstun: int, new_hitstun: int, new_hitspark: String) -> void:
	registered_targets = {}
	damage = new_damage
	blockstun = new_blockstun
	hitstun = new_hitstun
	hitspark = new_hitspark

func hit_landed(area: Area2D) -> void:
	var body = area.get_parent()
	if (area.name == "Hurtbox" and body == player.opponent and !registered_targets.has(body)):
		registered_targets[body] = 1
		body.collision_handler.hit_recieved(player, damage, blockstun, hitstun, hitspark)
		print("eat this!")

func hit_recieved(body: Node2D, damage: int, blockstun: int, hitstun: int, hitspark: String) -> void:
	hitspark_handler.play_hitspark_animaion(hitspark)
	print("ouch!")
