extends Node2D

@export var intputDialog: FileDialog
@export var outputDialog: FileDialog
@export var acceptedExtensions: PackedStringArray
@export var startButton: Button
@export var ffmpeg: String = "/usr/bin/ffmpeg"

var inputFiles: PackedStringArray
var inputFolder: String
var outputFolder: String

func _init():
	print(OS.get_name())

func _on_input_button_pressed() -> void:
	intputDialog.popup_centered()

func _on_output_button_pressed() -> void:
	outputDialog.popup_centered()
	
func _on_input_dialog_dir_selected(dir:String) -> void:
	print("Input folder has been selected: " + dir)
	inputFolder = dir
	inputFiles.clear()
	_list_folder_content(dir)
	_check_if_ready()

func _on_output_dialog_dir_selected(dir: String) -> void:
	print("Output folder has been selected: " + dir)
	outputFolder = dir
	_check_if_ready()

func _on_start_button_pressed() -> void:
	_start_convert()

func _list_folder_content(path:String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print("Found file: " + file_name)
			print("Extension: " + file_name.get_extension())
			var ext = file_name.get_extension()
			for extension: String in acceptedExtensions:
				if extension.nocasecmp_to(ext) == 0:
					inputFiles.append(file_name)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	print(inputFiles)

func _check_if_ready() -> void:
	if not inputFolder.is_empty() and not outputFolder.is_empty():
		startButton.disabled = false
	else:
		startButton.disabled = true

func _start_convert():
	if OS.get_name() == "Linux":
		for file: String in inputFiles:
			#var exit_code = OS.execute(ffmpeg, ["i", inputFolder + "/" + file, "-c:v", "dnxhd", "-profile:v", "dnxhr_hq", "-pix_fmt", "yuv422p", "-c:a", "copy", outputFolder + "/" + file], output)
			var exit_code = OS.execute_with_pipe("ffmpeg", [])
			print(exit_code)
			print(exit_code["stdio"].get_as_text())
