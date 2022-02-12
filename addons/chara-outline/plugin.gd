tool
extends EditorPlugin

#
# キャラクタアウトライン by あるる（きのもと 結衣） @arlez80
# Character Outline by Yui Kinomoto @arlez80
#
# MIT License
#

func _enter_tree():
	self.add_custom_type( "CharaOutlineRegister", "Node", preload("CharaOutlineRegister.gd"), preload("register_icon.png") )
	self.add_custom_type( "CharaOutline", "Node", preload("CharaOutline.gd"), preload("icon.png") )

func _exit_tree():
	self.remove_custom_type( "CharaOutline" )
	self.remove_custom_type( "CharaOutlineRegister" )
