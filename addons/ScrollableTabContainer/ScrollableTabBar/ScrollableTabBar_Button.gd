class_name ScrollableTabBar_Button
extends Button

func _init(button_icon: Texture2D = null, button_text: String = "", normal_color: Color = Color.BLACK, hover_color: Color = Color.DIM_GRAY, selected_color: Color = Color.DIM_GRAY):
	icon = button_icon
	text = button_text
	name = button_text
	#output.custom_minimum_size = Vector2(size.x / displayed_tab_count, tabbar_min_size.y)
	vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	expand_icon = true
	mouse_filter = Control.MOUSE_FILTER_PASS
	toggle_mode = true
	icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	action_mode=BaseButton.ACTION_MODE_BUTTON_PRESS
	#output.set("theme_override_constants/icon_max_width", tabbar_button.size.x / 2)
	var idle_style = StyleBoxFlat.new()
	idle_style.bg_color = normal_color
	set("theme_override_styles/normal", idle_style)
	var pressed_style = StyleBoxFlat.new()
	pressed_style.bg_color = selected_color
	set("theme_override_styles/pressed", pressed_style)
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = hover_color
	set("theme_override_styles/hover", hover_style)
	set("theme_override_styles/focus", StyleBoxEmpty.new())
