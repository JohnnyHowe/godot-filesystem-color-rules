@tool
class_name FileSystemColorRules
extends Resource

const FileSystemColorRule := preload("./filesystem_color_rule.gd")


## Rules are evaluated in array order; the last matching rule wins.
@export var rules: Array[FileSystemColorRule]:
	set(value):
		_disconnect_child_rule_listeners()
		rules = value
		_on_rules_changed()


func _on_rules_changed() -> void:
	_initialize_null_rule_entries()
	_connect_child_rule_listeners()
	changed.emit()


func _connect_child_rule_listeners() -> void:
	for rule in rules:
		if not rule.changed.is_connected(_on_child_rule_changed):
			rule.changed.connect(_on_child_rule_changed)


func _disconnect_child_rule_listeners() -> void:
	for rule in rules:
		if rule != null and rule.changed.is_connected(_on_child_rule_changed):
			rule.changed.disconnect(_on_child_rule_changed)


func _on_child_rule_changed() -> void:
	changed.emit()


func _initialize_null_rule_entries() -> void:
	for i in range(rules.size()):
		if rules[i] == null:
			rules[i] = FileSystemColorRule.new()
