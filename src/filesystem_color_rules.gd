@tool
class_name FileSystemColorRules
extends Resource

const COLORS := preload("./colors.gd")


## Maps regular-expression patterns to folder colors.
## Rules are evaluated in dictionary order; the last matching rule wins.
@export var rules: Dictionary[StringName, COLORS.Colors]:
	set(value):
		rules = value
		changed.emit()
