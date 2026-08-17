## Synchronizes rule-generated folder colors with Godot's project settings.
@tool
extends RefCounted


const FolderColorUpdater := preload("./folder_color_updater.gd")
const FolderFinder := preload("./folder_finder.gd")
const RuleMatcher := preload("./rule_matcher.gd")
const RulesFinder := preload("./rules_finder.gd")


var _is_synchronizing := false
var _synchronize_again := false
var _rules: FileSystemColorRules


func start() -> void:
	_set_rules(RulesFinder.find_rules_or_null())


func stop() -> void:
	_set_rules(null)


func synchronize() -> void:
	if _is_synchronizing:
		_synchronize_again = true
		return

	_is_synchronizing = true
	while true:
		_synchronize_again = false
		_synchronize_once()
		if not _synchronize_again:
			break
	_is_synchronizing = false


func _synchronize_once() -> void:
	var generated_colors: Dictionary[StringName, StringName] = {}
	_set_rules(RulesFinder.find_rules_or_null())

	if _rules != null:
		var folders := FolderFinder.find_folders()
		generated_colors = RuleMatcher.match_folders(folders, _rules.rules)

	if FolderColorUpdater.update(generated_colors):
		EditorInterface.get_resource_filesystem().scan()


func _set_rules(rules: FileSystemColorRules) -> void:
	if rules == _rules:
		return

	if _rules != null:
		_rules.changed.disconnect(synchronize)

	_rules = rules
	if _rules != null:
		_rules.changed.connect(synchronize)
