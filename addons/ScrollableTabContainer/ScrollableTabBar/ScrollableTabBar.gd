#@tool
class_name ScrollableTabBar
extends ScrollContainer

const ScrollableTabBar_Button = preload("ScrollableTabBar_Button.gd")

## Emitted when tab changes
signal tab_changed(tab: int)
## Emitted when a tab is clicked on, even if it is the current tab
signal tab_clicked(tab: int)

@export var tabbar_thickness:Vector2 = Vector2(0, 80.0)
@export var displayed_tab_count = 4
@export var show_text_only_when_active := false
@export var currentTab: int = 0;
@export_group("Theme Overrides")
@export var background_color: Color = Color.BLACK
@export var tab_selected_color: Color = Color.DIM_GRAY
@export var tab_hover_color: Color = Color(0.2, 0.2, 0.2, 1)

@onready var tab_container: Container;

func _init():
	name = "ScrollableTabBar"
	set_anchors_preset(PRESET_FULL_RECT)
	horizontal_scroll_mode = 3
	vertical_scroll_mode = 3
	follow_focus = true

	tab_container = HBoxContainer.new()
	tab_container.alignment = BoxContainer.ALIGNMENT_CENTER
	tab_container.size_flags_vertical = 3
	tab_container.size_flags_horizontal = 3
	tab_container.set("theme_override_constants/separation", 0)
	add_child(tab_container)

func _ready():
	if tab_container.get_child_count() > 0:
		var indexToDisplay: int = currentTab if tab_container.get_child_count() > currentTab else tab_container.get_child_count()
		_set_active_tab(indexToDisplay)

func add_tab(title: String = "", icon: Texture2D = null) -> void:
	var new_button = new_tabbar_button(title, icon)
	tab_container.add_child(new_button)
	var indexToDisplay: int = currentTab if tab_container.get_child_count() > currentTab else tab_container.get_child_count()
	_set_active_tab(indexToDisplay)
	
func new_tabbar_button(title: String = "", icon: Texture2D = null) -> ScrollableTabBar_Button:
	var tabbar_button := ScrollableTabBar_Button.new(icon, title, background_color, tab_hover_color, tab_selected_color)
	tabbar_button.custom_minimum_size = Vector2(size.x / displayed_tab_count, tabbar_thickness.y)
	tabbar_button.set("theme_override_constants/icon_max_width", tabbar_button.size.x / 2)
	tabbar_button.connect("button_up", Callable(self, "on_tab_clicked").bind(tab_container.get_child_count()))
	tabbar_button.set_meta("text", tabbar_button.text)
	if show_text_only_when_active:
		# hide text by default, only the active one will be activated in set_active_tab_no_signal
		tabbar_button.text = ""
	return tabbar_button
	
func on_tab_clicked(tabIndex: int) -> void:
	emit_signal("tab_clicked", tabIndex)
	_set_active_tab(tabIndex)
	
func _set_active_tab(tabIndex: int) -> void:
	var currentIndexBeforeCall = currentTab
	set_active_tab_no_signal(tabIndex)
	if currentTab != currentIndexBeforeCall:
		emit_signal("tab_changed", currentTab)

func set_active_tab_no_signal(tabIndex: int) -> void:
	var newActiveTab: Button = tab_container.get_child(tabIndex)
	newActiveTab.set_pressed_no_signal(true)
	if show_text_only_when_active:
		newActiveTab.text = newActiveTab.get_meta("text")
	
	if tabIndex != currentTab:
		var currentActiveTab = tab_container.get_child(currentTab)
		currentActiveTab.set_pressed_no_signal(false)
		
		newActiveTab.grab_focus()
		
		if show_text_only_when_active:
			currentActiveTab.set_meta("text", currentActiveTab.text)
			currentActiveTab.text = ""
				
		currentTab = tabIndex
		
