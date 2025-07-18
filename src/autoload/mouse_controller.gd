extends Node

func _process(_delta):
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
        Input.set_custom_mouse_cursor(load("res://assets/icons/hammer_pressed.png"), Input.CURSOR_IBEAM)
    else:
        Input.set_custom_mouse_cursor(load("res://assets/icons/hammer.png"), Input.CURSOR_ARROW)
