extends ProgressBar

var ANIMATION_DURATION = 0.5

func set_and_animate(value: float):
    var tween = create_tween()
    tween.tween_property(self, "value", value, ANIMATION_DURATION)
    await tween.finished
