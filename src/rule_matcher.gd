## Matches normalized folder paths against ordered regular-expression rules.
## When multiple rules match a folder, the last matching rule wins.
@tool


const COLORS := preload("./colors.gd")


static func match_folders(
	folders: Array[StringName],
	rules: Dictionary[StringName, COLORS.Colors],
) -> Dictionary[StringName, StringName]:
	var matched_colors: Dictionary[StringName, StringName] = {}

	for pattern in rules:
		var regex := RegEx.new()
		var compile_error := regex.compile(String(pattern))
		if compile_error != OK:
			push_error("Invalid filesystem color rule regex: %s" % pattern)
			continue

		var color: COLORS.Colors = rules[pattern]
		if not COLORS.COLOR_NAMES.has(color):
			push_error("Invalid filesystem color rule color: %s" % color)
			continue

		for folder in folders:
			if regex.search(String(folder)) != null:
				matched_colors[folder] = COLORS.COLOR_NAMES[color]

	return matched_colors
