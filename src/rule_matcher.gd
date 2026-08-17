## Matches normalized folder paths against ordered regular-expression rules.
## When multiple rules match a folder, the last matching rule wins.
@tool


const COLORS := preload("./colors.gd")
const FileSystemColorRule := preload("./filesystem_color_rule.gd")


static func match_folders(
	folders: Array[StringName],
	rules: Array[FileSystemColorRule],
) -> Dictionary[StringName, StringName]:
	var matched_colors: Dictionary[StringName, StringName] = {}

	for rule in rules:
		var regex := RegEx.new()
		var compile_error := regex.compile(String(rule.pattern))
		if compile_error != OK:
			push_error(
				"Invalid regex in filesystem color rule '%s': %s"
				% [rule.name, rule.pattern]
			)
			continue

		if not COLORS.COLOR_NAMES.has(rule.color):
			push_error(
				"Invalid color in filesystem color rule '%s': %s"
				% [rule.name, rule.color]
			)
			continue

		for folder in folders:
			if regex.search(String(folder)) != null:
				matched_colors[folder] = COLORS.COLOR_NAMES[rule.color]

	return matched_colors
