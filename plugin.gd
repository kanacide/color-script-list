@tool
extends EditorPlugin

var script_list: ItemList

# Optional: pin specific folders to specific colors.
# Anything not listed here gets an auto-generated color.
const FOLDER_OVERRIDES := {
	# "res://player": Color.BLUE,
	# "res://ui": Color.ORANGE,
}

func _enter_tree() -> void:
	_setup.call_deferred()

func _exit_tree() -> void:
	if is_instance_valid(script_list):
		if script_list.draw.is_connected(_on_list_draw):
			script_list.draw.disconnect(_on_list_draw)
		_reset_colors()
	script_list = null

func _setup() -> void:
	var script_editor := EditorInterface.get_script_editor()
	script_list = _find_script_list(script_editor)
	
	if script_list == null:
		push_error("ColorScriptList: Could not find script list.")
		return
	
	script_list.draw.connect(_on_list_draw)
	_on_list_draw()

func _on_list_draw() -> void:
	var changed := false
	for i in script_list.item_count:
		var color := _get_color_for_item(i)
		if script_list.get_item_custom_fg_color(i) != color:
			script_list.set_item_custom_fg_color(i, color)
			changed = true
	if changed:
		script_list.queue_redraw.call_deferred()

func _get_color_for_item(index: int) -> Color:
	var path := script_list.get_item_tooltip(index)
	
	if "::" in path:
		path = path.get_slice("::", 0)
	
	if not path.begins_with("res://"):
		return Color.WHITE
	
	return _color_for_folder(path.get_base_dir())

func _color_for_folder(folder: String) -> Color:
	if FOLDER_OVERRIDES.has(folder):
		return FOLDER_OVERRIDES[folder]
	
	var hue := float(folder.hash() % 360) / 360.0
	return Color.from_hsv(hue, 0.45, 1.0)

func _reset_colors() -> void:
	for i in script_list.item_count:
		script_list.set_item_custom_fg_color(i, Color(0, 0, 0, 0))

func _find_script_list(node: Node) -> ItemList:
	for child in node.get_children():
		if child is ItemList:
			return child
		var result := _find_script_list(child)
		if result != null:
			return result
	return null
