## Updates Godot's folder colors while preserving manually assigned colors.
## Paths recorded in GENERATED_PATHS_SETTING are owned by this addon.
@tool


const FOLDER_COLORS_SETTING := &"file_customization/folder_colors"
const GENERATED_PATHS_SETTING := &"filesystem_color_rules/generated_folder_paths"


static func update(generated_colors: Dictionary[StringName, StringName]) -> bool:
	var current_colors := _get_current_colors()
	var updated_colors := current_colors.duplicate()

	for path in _get_previous_generated_paths():
		updated_colors.erase(path)

	for path in generated_colors:
		updated_colors[path] = StringName(String(generated_colors[path]).to_lower())

	var generated_paths := PackedStringArray(generated_colors.keys())
	generated_paths.sort()

	var colors_changed := (
		updated_colors != current_colors
		or updated_colors.is_empty() and ProjectSettings.has_setting(FOLDER_COLORS_SETTING)
	)
	var generated_paths_changed := (
		generated_paths != _get_previous_generated_paths()
		or generated_paths.is_empty() and ProjectSettings.has_setting(GENERATED_PATHS_SETTING)
	)

	if not colors_changed and not generated_paths_changed:
		return false

	_set_or_remove(FOLDER_COLORS_SETTING, updated_colors)
	_set_or_remove(GENERATED_PATHS_SETTING, generated_paths)
	return ProjectSettings.save() == OK


static func _get_current_colors() -> Dictionary[StringName, StringName]:
	var colors: Dictionary[StringName, StringName] = {}
	var setting: Dictionary = ProjectSettings.get_setting(FOLDER_COLORS_SETTING, {})
	for path in setting:
		colors[StringName(path)] = StringName(setting[path])
	return colors


static func _get_previous_generated_paths() -> PackedStringArray:
	return ProjectSettings.get_setting(GENERATED_PATHS_SETTING, PackedStringArray())


static func _set_or_remove(setting: StringName, value: Variant) -> void:
	ProjectSettings.set_setting(setting, null if value.is_empty() else value)
