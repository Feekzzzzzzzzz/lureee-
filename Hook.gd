extends Area2D


var fish_caught = null 

func _on_Hook_area_entered(area):
	if fish_caught == null:  # Check if no fish has been caught
		if area.is_in_group("Fish"):  # Ensure the object is a fish
			fish_caught = area  # Store the caught fish
			fish_caught.catch_fish()  # Call the catch function on the fish


# You can reset this variable when the fish is removed
func _on_Fish_removed():
	fish_caught = null  # Reset when the fish is removed
