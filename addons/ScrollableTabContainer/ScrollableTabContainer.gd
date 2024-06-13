#@tool
class_name ScrollableTabContainer
extends Control

@export var active_tab_index: int = 0
@export_group("Tab Container")
@export var tabbar_thickness: int = 80
@export var show_text_only_when_active := true
@export var background_color: Color = Color.BLACK
@export var tab_selected_color: Color = Color.DIM_GRAY
@export var tab_hover_color: Color = Color(0.2, 0.2, 0.2, 1)
@export_group("Panel Container")
@export var scroll_direction: ScrollablePanelContainer.ScrollDirection
@export var block_scroll: bool = true

@onready var panelTabContainer: ScrollablePanelContainer
@onready var scrollableTabBar: ScrollableTabBar

@onready var children = get_children()
var verticalContainer: VBoxContainer

func _ready():
	verticalContainer = VBoxContainer.new()
	verticalContainer.set("theme_override_constants/separation", 0)
	verticalContainer.set_anchors_preset(PRESET_FULL_RECT)
	add_child(verticalContainer)
	
	panelTabContainer = ScrollablePanelContainer.new(scroll_direction)
	panelTabContainer.block_scroll = block_scroll
	panelTabContainer.custom_minimum_size = Vector2(size.x, size.y - tabbar_thickness)	
	verticalContainer.add_child(panelTabContainer)
	
	scrollableTabBar = ScrollableTabBar.new()
	scrollableTabBar.show_text_only_when_active = show_text_only_when_active
	scrollableTabBar.background_color = background_color
	scrollableTabBar.tab_selected_color = tab_selected_color
	scrollableTabBar.tab_hover_color = tab_hover_color
	scrollableTabBar.custom_minimum_size = Vector2(size.x, tabbar_thickness)
	verticalContainer.add_child(scrollableTabBar)
	
	panelTabContainer.panel_changed.connect(scrollableTabBar.set_active_tab_no_signal)
	scrollableTabBar.tab_changed.connect(panelTabContainer.set_active_panel_no_signal)
	
	for child in children:
		if child is ScrollablePanel:
			if !Engine.is_editor_hint():
				remove_child(child)
			panelTabContainer.add_panel(child)
			scrollableTabBar.add_tab(child.title, child.icon)
			#child.visible = false

	scrollableTabBar.set_active_tab_no_signal(active_tab_index)
	panelTabContainer.set_active_panel_no_signal(active_tab_index)
