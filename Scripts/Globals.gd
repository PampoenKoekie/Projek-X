extends Node

#var resource_global
const save_path :String = "user://SavingSystem.tres"
@onready var resource_global = SavingSystem.new()


var task_name :String
var task_description :String
var task_color :Color = Color.BURLYWOOD
var task_time: int
var task_tint: bool = false
var task_notes: String

var temp_task_name :String
var temp_task_description :String
var temp_task_color :Color
var temp_task_time: int
var temp_task_tint: bool
var temp_task_notes: String

var delete_confirm :bool = false
var date_confirm :bool = false

var stored_data_array :Array = []
var stored_notepad_array :Array[String]
var stored_time: int
var is_new_task :bool = false

func _ready():

	if ResourceLoader.exists(save_path):
		load_resources_now()
	else:
		save_resources_now()

	if resource_global.options_array.is_empty():
		resource_global.options_array.append(delete_confirm)
		resource_global.options_array.append(date_confirm)
	else:
		delete_confirm = resource_global.options_array[1]
		date_confirm = resource_global.options_array[0]

	var note_arr = resource_global.notepad_array
	note_arr.resize(100)

func save_resources_now():
	ResourceSaver.save(resource_global, "user://SavingSystem.tres")

func load_resources_now():
	resource_global = ResourceLoader.load("user://SavingSystem.tres")
