extends Control

@onready var task_panel = preload("res://Scenes/task.tscn")
@onready var color_panel = %Panel
@onready var particles = %ParticlesAddTask
@onready var anim_player = %Player
@onready var menu_popup = %PopupPanel
@onready var menu_color_popup = %PopupColors
@onready var menu_delete_confirm = %DeleteConfirmButton
@onready var menu_date_confirm = %ShowDateButton
var random_color :Color

func _ready() -> void:
	menu_delete_confirm.button_pressed = Globals.delete_confirm
	menu_date_confirm.button_pressed = Globals.date_confirm
	date_time_visibility()

	%DateLabel.text = get_date()
	var color_p = color_panel.get("theme_override_styles/panel")
	color_p.bg_color = Globals.task_color
	Globals.is_new_task = false

	if Globals.resource_global.save_array.is_empty():
		print("save_array is Empty, ahoena niekies")
	else:
		load_info()

func _process(delta):
	var horlosie = Time.get_time_string_from_system()
	%TimeLabel.text = horlosie.substr(0, 5)

func load_info():
	print("hallo")
	for i in Globals.resource_global.save_array:
		Globals.temp_task_name = i[0]
		Globals.temp_task_description = i[1]
		Globals.temp_task_color = i[2]
		Globals.temp_task_time = i[3]
		Globals.temp_task_tint = i[4]

		var load_task = task_panel.instantiate()
		$ScrollContainer/VBoxContainer.add_child(load_task)

func _on_add_button_pressed():
	run_particles()
	Globals.is_new_task = true
	var new_task = task_panel.instantiate()
	$ScrollContainer/VBoxContainer.add_child(new_task)

	#Add the data to an array to store in a Resource
	Globals.stored_data_array = [
		Globals.task_name,
		Globals.task_description,
		Globals.task_color,
		Globals.task_time,
		Globals.task_tint]

	#Store the above array to the Save Resource in a new Array called Save_Array
	Globals.resource_global.save_array.append(Globals.stored_data_array)
	Globals.save_resources_now()
	%EditTaskName.clear()
	%EditTask.clear()

func _on_edit_task_name_text_changed(new_text:String):
	Globals.task_name = new_text

func _on_edit_task_text_changed(new_text:String):
	Globals.task_description = new_text

func _on_exit_button_pressed():
	Globals.save_resources_now()
	get_tree().quit()

func _on_change_color_button_pressed() -> void:
	menu_color_popup.visible = true

	#Globals.task_color = random_color

func run_particles():
	%ParticleTimer.start()
	particles.emitting = true

func _on_particle_timer_timeout() -> void:
	particles.emitting = false

func _on_add_button_mouse_entered() -> void:
	anim_player.play("Add_Button_Anim")

func _on_add_button_mouse_exited() -> void:
	anim_player.play_backwards("Add_Button_Anim")

func get_date():
	var date = Time.get_date_string_from_system()
	return str(date)

func _on_button_menu_pressed():
	menu_popup.visible = true

func change_color(color :String):
	random_color = Color.html(color)
	var new_style = color_panel.get("theme_override_styles/panel")
	new_style.bg_color = random_color
	Globals.task_color = random_color
	print(Globals.task_color)

func _on_color_01_pressed():
	change_color("1C3B85")

func _on_color_02_pressed():
	change_color("3E8BDA")

func _on_color_03_pressed():
	change_color("40908E")

func _on_color_04_pressed():
	change_color("409049")

func _on_color_05_pressed():
	change_color("79B846")

func _on_color_06_pressed():
	change_color("B2D345")

func _on_color_07_pressed():
	change_color("FDF952")

func _on_color_08_pressed():
	change_color("ECBD40")

func _on_color_09_pressed():
	change_color("DF9039")

func _on_color_10_pressed():
	change_color("CB3D2A")

func _on_color_11_pressed():
	change_color("EE6299")

func _on_color_12_pressed():
	change_color("9D2B77")

func _on_color_13_pressed():
	change_color("531B72")

func _on_color_14_pressed():
	change_color("000000")

func _on_color_15_pressed():
	change_color("B3B3B3")

func _on_color_16_pressed():
	change_color("FAE1B9")

func _on_color_17_pressed():
	change_color("F7CB85")

func _on_color_18_pressed():
	change_color("734E42")

func _on_color_19_pressed():
	change_color("957365")

func _on_color_20_pressed():
	change_color("C7A79B")

func _on_color_21_pressed():
	change_color("362010")

func _on_delete_confirm_button_pressed():
	Globals.delete_confirm = !Globals.delete_confirm
	Globals.resource_global.options_array.remove_at(1)
	Globals.resource_global.options_array.insert(1, Globals.delete_confirm)
	Globals.save_resources_now()
	print(Globals.resource_global)

func _on_show_date_button_pressed():
	Globals.date_confirm = !Globals.date_confirm
	Globals.resource_global.options_array.remove_at(0)
	Globals.resource_global.options_array.insert(0, Globals.date_confirm)
	Globals.save_resources_now()
	date_time_visibility()

func date_time_visibility():
	var arr = Globals.resource_global.options_array
	%DateHeadingLabel.visible = arr[0]
	%DateLabel.visible = arr[0]
	%TimeLabel.visible = arr[0]

