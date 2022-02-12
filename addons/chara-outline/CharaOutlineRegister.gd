extends Node

#
# キャラクタアウトライン by あるる（きのもと 結衣） @arlez80
# Character Outline by Yui Kinomoto @arlez80
#
# MIT License
#

# 登録した場合、これは不要
class_name CharaOutlineRegister

export(NodePath) var register_path:NodePath
export(bool) var outline_disable:bool = false

export(bool) var enable_target_list:bool = false
export(Dictionary) var target_list:Dictionary = {}
