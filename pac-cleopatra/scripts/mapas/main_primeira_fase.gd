extends Node2D
func _ready():
	var player = $Player
	if GlobalVars.player_position != Vector2.ZERO:
		player.global_position = GlobalVars.player_position
