@tool
## Observes editor filesystem changes and emits a settled change notification.
extends RefCounted


signal filesystem_changed


var _editor_filesystem: EditorFileSystem
var _is_change_pending := false


func start() -> void:
	if _editor_filesystem != null:
		return

	_editor_filesystem = EditorInterface.get_resource_filesystem()
	_editor_filesystem.filesystem_changed.connect(_on_editor_filesystem_changed)


func stop() -> void:
	if _editor_filesystem == null:
		return

	_editor_filesystem.filesystem_changed.disconnect(_on_editor_filesystem_changed)
	_editor_filesystem = null
	_is_change_pending = false


func _on_editor_filesystem_changed() -> void:
	if _is_change_pending:
		return

	_is_change_pending = true
	_emit_filesystem_changed.call_deferred()


func _emit_filesystem_changed() -> void:
	if not _is_change_pending or _editor_filesystem == null:
		return

	_is_change_pending = false
	filesystem_changed.emit()
