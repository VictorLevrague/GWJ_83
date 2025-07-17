extends Node

@export var first_music:AudioStreamMP3

func _ready():
    AudioManager.get_node("Music").stream = first_music
    %Music.play()
