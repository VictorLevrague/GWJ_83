extends Node

@export var first_music:AudioStreamMP3

@export var sfx_activated: bool = true
@export var music_activated: bool = true
var music_volume_modifier
var sfx_volume_modifier

func _ready():
    AudioManager.get_node("Music").stream = first_music
    %Music.play()
