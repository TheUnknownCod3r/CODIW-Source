/************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: 2583.gsc
************************/

func_9308(param_00) {
	if(!isdefined(self.var_10E6D)) {
		return level.failure;
	}

	if(self.team == "allies") {
		return level.failure;
	}

	if(lib_0F18::func_10E8A("is_in_stealth")) {
		return level.success;
	}

	return level.failure;
}

func_12F2D(param_00) {
	if(!isdefined(self.var_10E6D.var_C9A8)) {
		lib_0F18::func_10E8A("set_patrol_style","unaware");
	}

	if(self.var_10E6D.state == 3 && isdefined(self.isnodeoccupied)) {
		lib_0F18::func_10E8A("set_patrol_style","combat",1,self.isnodeoccupied.origin);
		self.var_10E6D.state = 4;
	}

	return level.success;
}