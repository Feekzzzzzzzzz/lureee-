extends Node2D

var Fish = preload("res://Fishing object/Fish.tscn")
var fish_species_1 = preload("res://Fishing object/Fish_species1.tscn")
var fish_species_2 = preload("res://Fishing object/Fish_species2.tscn")
var spawnrng = RandomNumberGenerator.new()
var speedrng = RandomNumberGenerator.new()
var fish_caught = null  # Variable to store the currently caught fish

var health = 100  # Player starts with 100 health
var max_health = 100  # Maximum health


func _process(_delta):
	get_node("YSort/Players/String").rect_size.y = get_node("YSort/Players/Hook").global_position.y - 178.999817
		# Check if a fish was caught when reeling in
	if fish_caught != null:
		increase_health(5)  # Add 5 to health for catching a fish
		increase_health(5)  # Add 5 to health for catching a fish


func _on_Cast_pressed():
	if get_node("AnimationPlayer").current_animation != "Hook":
		get_node("AnimationPlayer").play("Cast")
		get_node("YSort/Players/AnimatedSprite").play("fishing")
		get_node("UI/Cast").hide()
		get_node("UI/Reel").show()
		# Reduce health by 1 if no fish is caught after cast
		if fish_caught == null:
			reduce_health(1)


func _on_Reel_pressed():
	get_node("YSort/Players/AnimatedSprite").play("hook")
	get_node("UI/Cast").show()
	get_node("UI/Reel").hide()
	get_node("AnimationPlayer").play("Hook")
	fish_caught = null  # Reset the caught fish variable for the next round


func _ready():
	update_health_bar()  # Initialize the health bar at the start


func reduce_health(amount):
	health -= amount  # Subtract health
	health = clamp(health, 0, max_health)  # Ensure health doesn't go below 0
	update_health_bar()  # Update the health bar display


func increase_health(amount):
	health += amount  # Add health
	health = clamp(health, 0, max_health)  # Ensure health doesn't exceed max health
	update_health_bar()  # Update the health bar display


func update_health_bar():
	var health_bar = get_node("UI/HealthBar")  # Reference to your health bar node
	health_bar.value = health  # Update the health bar's value


func _on_Spawn_timeout():
	var fish = Fish.instance()
	get_node("YSort").add_child(fish)
	fish.position.y = spawnrng.randi_range(500, 640)
	fish.speed = speedrng.randi_range(100, 200)
	
	var fish_species1 = fish_species_1.instance()
	get_node("YSort").add_child(fish_species1)
	fish_species1.position.y = spawnrng.randi_range(440, 640)
	fish_species1.speed = speedrng.randi_range(110, 220)
	
	var fish_species2 = fish_species_2.instance()
	get_node("YSort").add_child(fish_species2)
	fish_species2.position.y = spawnrng.randi_range(420, 680)
	fish_species2.speed = speedrng.randi_range(120, 230)
	
	# Connect the fish_removed signal to the _on_fish_removed function
	fish.connect("fish_removed", self, "_on_fish_removed")


func _on_Hook_body_entered(body):
	# Ensure that we can only catch one fish at a time
	if fish_caught == null and body.is_in_group("Fish"):
		fish_caught = body  # Store the reference of the caught fish
		body.being_dragged = true  # Start dragging the fish
		body.catch_fish()  # Call the fish's catch function to handle its behavior


func _on_fish_removed():
	fish_caught = null  # Reset the fish_caught variable to allow catching another fish
