extends Node2D

const arrowSprite = preload("res://Scenes/ArrowAmmoSprite.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.arrow_ammo_system = self
	_on_Timer_timeout()

func manage_arrows():
	var xpos = 0
	for child in $Parent.get_children():
		child.queue_free()
	for arrow in Globals.arrows:
		var arrow_instance = arrowSprite.instance()
		$Parent.call_deferred("add_child", arrow_instance)
		arrow_instance.position.x -= xpos
		xpos -= 10
		if Globals.arrows > 7:
			$Label.set_text("× " + str(Globals.arrows))
			break;
		else: $Label.set_text("")

func _on_Timer_timeout():
	Globals.arrows += Globals.ammo
	manage_arrows()
	$Timer.start(Globals.get_arrow_time)