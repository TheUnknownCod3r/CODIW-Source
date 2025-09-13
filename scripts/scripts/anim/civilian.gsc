/*************************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: scripts\anim\civilian.gsc
*************************************/

cover() {
	self endon("killanimscript");
	self aiclearanim(%root,0.2);
	scripts\anim\utility::func_12EB9();
	if(scripts\anim\utility::func_9E40()) {
		var_00 = "idle_combat";
	}
	else
	{
		var_00 = "idle_noncombat";
	}

	var_01 = undefined;
	if(isdefined(self.var_1FBB) && isdefined(level.var_EC85[self.var_1FBB])) {
		var_01 = level.var_EC85[self.var_1FBB][var_00];
	}

	if(!isdefined(var_01)) {
		if(!isdefined(level.var_EC85["default_civilian"])) {
			return;
		}

		var_01 = level.var_EC85["default_civilian"][var_00];
	}

	thread func_BC1C();
	for(;;) {
		self _meth_82E3("idle",scripts\engine\utility::random(var_01),%root,1,0.2,1);
		self waittillmatch("end","idle");
	}
}

func_BC1C() {
	self endon("killanimscript");
	while(!isdefined(self.var_3C34)) {
		wait(1);
	}
}

func_02C8() {
	cover();
}

func_79BE() {
	return level.var_3FD8[randomint(level.var_3FD8.size)];
}