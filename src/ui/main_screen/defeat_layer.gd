extends CanvasLayer

var defeat_by_cover_loss: bool = false
var defeat_by_no_people_left_to_judge: bool = false

func _on_hide_defeat_button_pressed() -> void:
    %DefeatPanel.visible = not %DefeatPanel.visible
    if defeat_by_no_people_left_to_judge:
        %DevilAngry.visible = not %DevilAngry.visible

func update_text(type: String):
    match type:
        "No_people_left_to_judge":
            defeat_by_no_people_left_to_judge = true
            defeat_by_cover_loss = false
            %DefeatLabel.text = "THAT IS NOT ENOUGH SOULS !!!\n\nGO BACK TO HELL"
            %DevilAngry.show()
        "Cover_loss":
            defeat_by_no_people_left_to_judge = false
            defeat_by_cover_loss = true
            %DefeatLabel.text = "WAIT A MINUTE !!! You're not the purgatory judge, you filthy demon.\n\nGET OUT"
            %DevilAngry.hide()
