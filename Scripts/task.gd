extends Control
class_name Task

@onready var delete_confirm_panel = %DeleteTask

var load_seconds :int
var load_minutes :int
var load_hours :int

var time_keep_seconds :int
var time_keep_minutes :int
var time_keep_hours :int

var time_active :bool = false
var time_total :int
var check_current_time :int = 0
var is_tint :bool

var current_notes :String

@onready var inst = get_index()
@onready var time_particles = %TimeButtonParticles

func _ready():
	load_current_notes(inst)
	check_if_new_task()

func load_current_notes(idx):
	current_notes = Globals.resource_global.notepad_array[idx]

func check_if_new_task():
	if Globals.is_new_task == true:
		%ColorRibbon.color = Globals.task_color
		%TaskHeaderLabel.text = str(Globals.task_name)
		%TaskDescribeLabel.text = str(Globals.task_description)
	else:
		%ColorRibbon.color = Globals.temp_task_color
		%TaskHeaderLabel.text = str(Globals.temp_task_name)
		%TaskDescribeLabel.text = str(Globals.temp_task_description)
		%TaskTint.visible = Globals.temp_task_tint
		var get_id = get_index()
		var get_array = Globals.resource_global.save_array
		var get_time = get_array[get_id][3]
		check_current_time = get_time
		load_seconds = get_time % 60
		load_minutes = get_time / 60
		time_keep_seconds = load_seconds
		time_keep_minutes = load_minutes
		convert_time_load()

func convert_time_load ():
	if time_keep_seconds < 10:
		%TimeLabelSeconds.text = "0" + str(time_keep_seconds)
	else:
		%TimeLabelSeconds.text = str(time_keep_seconds)

	if time_keep_minutes < 10:
		%TimeLabelMinutes.text = "0" + str(time_keep_minutes)
	else:
		%TimeLabelMinutes.text = str(time_keep_minutes)

func _process(delta: float) -> void:
	if time_keep_seconds < 10:
		%TimeLabelSeconds.text = "0" + str(time_keep_seconds)
	else:
		%TimeLabelSeconds.text = str(time_keep_seconds)

func _on_checkmark_button_pressed() -> void:
	if %TaskTint.visible == false:
		%TaskTint.visible = true
		Globals.task_tint = true
		Globals.resource_global.save_array[inst][4] = Globals.task_tint
	else:
		%TaskTint.visible = false
		Globals.task_tint = false
		Globals.resource_global.save_array[inst][4] = Globals.task_tint

	Globals.save_resources_now()

func _on_delete_button_pressed() -> void:
	if Globals.delete_confirm == true:
		delete_confirm_panel.visible = true

	else:
		var get_id = get_index()
		var get_array = Globals.resource_global.save_array
		var get_notes_arr = Globals.resource_global.notepad_array
		get_array.remove_at(get_id)
		get_notes_arr.remove_at(get_id)
		Globals.save_resources_now()
		queue_free()

func _on_timer_timeout() -> void:
	time_keep_seconds += 1
	time_total += 1

	if time_keep_seconds == 60:
		time_keep_minutes += 1
		time_keep_seconds = 0

		if time_keep_minutes < 10:
			%TimeLabelMinutes.text = "0" + str(time_keep_minutes)
		else:
			%TimeLabelMinutes.text = str(time_keep_minutes)

func _on_timer_button_pressed() -> void:

	if time_active == false:
		time_particles.emitting = true
		%Timer.start()
		time_active = true

	elif time_active == true:
		time_particles.emitting = false
		%Timer.stop()
		time_active = false
		store_time()

func store_time():
	Globals.resource_global.save_array[inst][3] = check_current_time + time_total
	Globals.save_resources_now()

func _on_button_yes_pressed():
	var get_id = get_index()
	var get_array = Globals.resource_global.save_array
	var get_notes_arr = Globals.resource_global.notepad_array
	get_array.remove_at(get_id)
	get_notes_arr.remove_at(get_id)
	Globals.save_resources_now()
	queue_free()

func _on_button_no_pressed():
	delete_confirm_panel.visible = false

func _on_notepad_button_pressed():
	var index = get_index()
	%TextEdit.text = Globals.resource_global.notepad_array[index]
	%NotesWindow.title = str(Globals.resource_global.save_array[index][0])
	%NotesWindow.visible = !%NotesWindow.visible
	Globals.resource_global.notepad_array.remove_at(index)
	Globals.resource_global.notepad_array.insert(index, current_notes)

	Globals.save_resources_now()

func _on_text_edit_text_changed():
	current_notes = %TextEdit.text
	Globals.task_notes = current_notes


func _on_notes_window_close_requested():
	var index = get_index()
	var note_arr = Globals.resource_global.notepad_array
	%NotesWindow.visible = false
	
	note_arr.remove_at(index)
	note_arr.insert(index, current_notes)
	Globals.save_resources_now()
	print(note_arr)



func _on_notepad_button_mouse_entered():
	%ColorRibbon.scale = Vector2(1.07, 1.07)


func _on_notepad_button_mouse_exited():
	%ColorRibbon.scale = Vector2(1, 1)
