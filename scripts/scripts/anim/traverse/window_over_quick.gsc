/*******************************************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: scripts\anim\traverse\window_over_quick.gsc
*******************************************************/

main() {
	if(self.type == "dog") {
		scripts\anim\traverse\shared::func_586D("window_40",40);
		return;
	}

	func_A4CC();
}

func_A4CC() {
	var_00 = [];
	var_00["traverseAnim"] = %traverse_window_quick;
	if(getdvarint("ai_iw7",0) == 0) {
		scripts\anim\traverse\shared::func_5AC3(var_00);
		return;
	}

	self waittill("killanimscript");
}