@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("ScrollableTabContainer", 	"ScrollContainer", 	preload("ScrollableTabContainer.gd"), 								preload("scrollable_tabbar.svg"))
	add_custom_type("ScrollablePanel", 			"PanelContainer", 	preload("ScrollablePanelContainer/ScrollablePanel.gd"), 			preload("ScrollablePanelContainer/panel.svg"))
	add_custom_type("ScrollablePanelContainer", "ScrollContainer", 	preload("ScrollablePanelContainer/ScrollablePanelContainer.gd"), 	preload("ScrollablePanelContainer/panel.svg"))
	add_custom_type("ScrollableTabBar", 		"ScrollContainer", 	preload("ScrollableTabBar/ScrollableTabBar.gd"), 					preload("ScrollableTabBar/tabbar.svg"))
	add_custom_type("ScrollableTabBar_Button", 	"Button", 			preload("ScrollableTabBar/ScrollableTabBar_Button.gd"), 			preload("ScrollableTabBar/tabbar_button.svg"))

func _exit_tree():
	remove_custom_type("ScrollableTabContainer")
	remove_custom_type("ScrollablePanel")
	remove_custom_type("ScrollablePanelContainer")
	remove_custom_type("ScrollableTabBar")
	remove_custom_type("ScrollableTabBar_Button")
