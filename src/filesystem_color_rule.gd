@tool
extends Resource

const COLORS := preload("./colors.gd")


@export var name: StringName:
	set(value):
		name = value
		resource_name = String(value)

@export var pattern: StringName:
	set(value):
		pattern = value
		changed.emit()

@export var color := COLORS.Colors.PINK:
	set(value):
		color = value
		changed.emit()
