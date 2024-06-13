class_name ScrollablePanelContainer
extends ScrollContainer

signal panel_changed(panelIndex)

enum ScrollDirection {HORIZONTAL = 0, VERTICAL = 1}

@onready var panels_container: BoxContainer

@export var scroll_direction: ScrollDirection = ScrollDirection.HORIZONTAL
@export var block_scroll: bool = true
@export var current_panelIndex: int = 0

var scroll_speed := Vector2(25, 25)
var target_scroll: int = 0
var is_scrolling := false

func _init(scroll_direction:int = ScrollDirection.HORIZONTAL):
	self.scroll_direction = scroll_direction
	name = "ScrollablePanelContainer"
	scroll_vertical = scroll_direction == ScrollDirection.VERTICAL
	scroll_horizontal = scroll_direction == ScrollDirection.HORIZONTAL
	horizontal_scroll_mode = 3
	vertical_scroll_mode = 3
	set_anchors_preset(PRESET_FULL_RECT)
	
	panels_container = BoxContainer.new()
	panels_container.size_flags_vertical = 3
	panels_container.size_flags_horizontal = 3
	panels_container.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(panels_container)

func _ready() -> void:
	for child in get_children():
		if (child is PanelContainer):
			remove_child(child)
			add_panel(child)
	
	get_tree().get_root().size_changed.connect(resize)
	panels_container.sort_children.connect(resize)
	gui_input.connect(_manage_input)
	resize()
	
func horizontal() -> bool:
	return scroll_direction == ScrollDirection.HORIZONTAL

func add_panel(child: PanelContainer) -> void:
	panels_container.add_child(child)
	child.mouse_filter = Control.MOUSE_FILTER_PASS
	child.visible = true

func resize() -> void:
	var minimum_size = panels_container.get_child_count() * (size.x if horizontal() else size.y)
	panels_container.custom_minimum_size = Vector2(minimum_size, size.y) if horizontal() else Vector2(size.x, minimum_size)
	for i in panels_container.get_child_count():
		panels_container.get_child(i).size = size
		panels_container.get_child(i).position = Vector2(size.x * i, 0) if horizontal() else Vector2(0, size.y * i)
		
func _process(delta: float) -> void:
	var position = panels_container.position.x if horizontal() else panels_container.position.y
	var speed = scroll_speed.x if horizontal() else scroll_speed.y
	var distance_to_travel = target_scroll - abs(position)
	
	if distance_to_travel < 0:
		if horizontal(): scroll_horizontal = max(target_scroll, scroll_horizontal - speed)
		else: scroll_vertical = max(target_scroll, scroll_vertical - speed)
	elif distance_to_travel > 0:
		if horizontal(): scroll_horizontal = min(target_scroll, scroll_horizontal + speed)
		else: scroll_vertical = min(target_scroll, scroll_vertical + speed)
	elif distance_to_travel == 0 and !is_scrolling:
		set_active_panel(which_panelIndex_index_is_visible())
		

func _manage_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			set_active_panel(get_previous_index())
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			set_active_panel(get_next_index())
	elif event is InputEventScreenDrag:
		var target = Vector2(target_scroll - event.relative.x, 0) if horizontal() else Vector2(0, target_scroll - event.relative.y)
		set_target_scroll(target)
	elif event is InputEventScreenTouch:
		is_scrolling = event.is_pressed()
		
func set_target_scroll(new_value: Vector2) -> void:
	var local_size = size.x if horizontal() else size.y;
	var target = new_value.x if horizontal() else new_value.y;
	if block_scroll:
		var start_of_previous_panel = local_size * get_previous_index()
		var start_of_next_panel = local_size * get_next_index()
		target = clamp(target, start_of_previous_panel, start_of_next_panel)
	target_scroll = int(clamp(target, 0, (panels_container.get_child_count() - 1) * local_size))

func which_panelIndex_index_is_visible() -> int:
	var position = panels_container.position.x if horizontal() else panels_container.position.y
	var local_size = size.x if horizontal() else size.y
	
	var result: int = abs(position / local_size)
	var offset_from_base_index = abs(int(position) % int(local_size))
	if offset_from_base_index > local_size / 2:
		result += 1
	return result

func get_previous_index() -> int:
	return max(0, current_panelIndex - 1)

func get_next_index() -> int:
	return min(current_panelIndex + 1, panels_container.get_child_count() - 1)
	
func set_active_panel(panelIndex: int) -> void:
	var index_before_change = current_panelIndex
	set_active_panel_no_signal(panelIndex)
	if index_before_change != current_panelIndex:
		emit_signal("panel_changed", current_panelIndex)

func set_active_panel_no_signal(panelIndex: int) -> void:
	current_panelIndex = clamp(panelIndex, 0, panels_container.get_child_count() - 1)
	var target := Vector2(current_panelIndex * size.x, 0) if horizontal() else Vector2(0, current_panelIndex * size.y)
	set_target_scroll(target)
