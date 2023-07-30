class_name StaticFog extends Area2D

# The number of collected lights by the player to destroy this Fog.
@export var numberOfLightsToDestroy: int = 0
@export var wisper_sfx : AudioStreamPlayer2D
@export var death_sfx : AudioStreamPlayer2D
static var allInstances: Array[StaticFog]

func _enter_tree():
	if (allInstances.find(self) == -1):
		allInstances.append(self)
	else:
		assert(false, "Can't add {" + self.name + "}, since it is already in the instances' pool")

func _exit_tree():
	var instanceID = allInstances.find(self)
	if (instanceID != -1):
		allInstances.remove_at(allInstances.find(self))
	else:
		assert(false, "Can't remove {" + self.name + "}, since it is not in the instances' pool.")

static func on_light_collected(nbLightCollected: int):
	for fog in allInstances:
		if (fog.numberOfLightsToDestroy <= nbLightCollected):
			fog.queue_free()


func _ready():
	($AnimatedSprite2D as AnimatedSprite2D).play("default")
	wisper_sfx.play()
