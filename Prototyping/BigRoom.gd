extends Room

const CRYSTAL = preload("res://Objects/Crystal.tscn")
func _on_CrystalDispenser_body_entered(body: Node) -> void:
	if body is Player:
		var crystal = CRYSTAL.instance()
		get_parent().add_child(crystal)
		crystal.global_transform.origin = $Anubis/CrystalPos.global_transform.origin
		$Room2Anubis_TriggerManually.trigger_manually()
		

