## Finds all folders indexed by the editor filesystem.
## Paths use forward slashes and end with a trailing slash on every platform.
@tool


static func find_folders() -> Array[StringName]:
	var folders: Array[StringName] = []
	var root := EditorInterface.get_resource_filesystem().get_filesystem()
	_append_subfolders(root, folders)
	return folders


static func _append_subfolders(
	directory: EditorFileSystemDirectory,
	folders: Array[StringName],
) -> void:
	for index in directory.get_subdir_count():
		var subdirectory := directory.get_subdir(index)
		folders.append(_normalize_path(subdirectory.get_path()))
		_append_subfolders(subdirectory, folders)


static func _normalize_path(path: String) -> StringName:
	return StringName(path.trim_suffix("/") + "/")
