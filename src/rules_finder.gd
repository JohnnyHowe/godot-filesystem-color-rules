## Finds and loads the instance of the rules object in the project.
## Expects it at res://filesystem_color_rules.tres
@tool


static func find_rules_or_null() -> FileSystemColorRules:
	return ResourceLoader.load("res://filesystem_color_rules.tres") as FileSystemColorRules
