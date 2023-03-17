tool
extends EditorPlugin

var button
var plugin


func find_viewport_3d(node: Node, recursive_level):
    if node.get_class() == "SpatialEditor":
        return node.get_child(1).get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
    else:
        recursive_level += 1
        if recursive_level > 15:
            return null
        for child in node.get_children():
            var result = find_viewport_3d(child, recursive_level)
            if result != null:
                return result


func _enter_tree():
    plugin = EditorPlugin.new()
    button = Button.new()
    button.text = "Save Camera"
    button.connect("pressed", self, "save_camera")

    add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button)


func _exit_tree():
    remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button)


func save_camera():
    var editor_viewport_3d = find_viewport_3d(get_node("/root/EditorNode"), 0)
    var editor_camera_3d = editor_viewport_3d.get_child(0).get_child(0)
    # Get the camera's transform and instantiate a new camera with it
    var camera = Camera.new()
    camera.transform = editor_camera_3d.transform
    camera.fov = editor_camera_3d.fov
    camera.near = editor_camera_3d.near
    camera.far = editor_camera_3d.far

    # Add the camera to the edited scene
    var root = plugin.get_editor_interface().get_edited_scene_root()
    root.add_child(camera)
    camera.owner = root



