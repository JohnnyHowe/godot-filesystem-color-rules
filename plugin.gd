@tool
extends EditorPlugin

var FileSystemChangeListener := preload("./src/filesystem_change_listener.gd")
var Synchronizer := preload("./src/synchronizer.gd")

var _filesystem_change_listener
var _synchronizer


func _enter_tree() -> void:
	_synchronizer = Synchronizer.new()
	_synchronizer.start()
	_filesystem_change_listener = FileSystemChangeListener.new()
	_filesystem_change_listener.filesystem_changed.connect(_synchronizer.synchronize)
	_filesystem_change_listener.start()

	if not EditorInterface.get_resource_filesystem().is_scanning():
		_synchronizer.synchronize()


func _exit_tree() -> void:
	_filesystem_change_listener.stop()
	_filesystem_change_listener = null
	_synchronizer.stop()
	_synchronizer = null
