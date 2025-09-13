/************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: 3614.gsc
************************/

func_5374() {
	precacheitem("car_grenade");
	thread func_5375();
}

func_5375() {
	scripts\engine\utility::waitframe();
	var_00 = getentarray("scriptable","code_classname");
	foreach(var_02 in var_00) {
		if(issubstr(var_02.model,"veh_")) {
			var_02 thread func_5376();
		}
	}
}

func_5376() {
	self.var_ED = "vehicle";
	for(;;) {
		self waittill("scriptableNotification",var_00,var_01);
		switch(var_00) {
			case "onfire":
			case "flareup":
				thread func_329E();
				break;
	
			case "vehicle_death":
				self notify("destroyed");
				if(isdefined(self.var_329F)) {
					self.var_329F delete();
				}
				self.var_C528 = undefined;
				break;
		}
	}
}

func_329E() {
	if(isdefined(self.var_329F)) {
		return;
	}

	self endon("destroyed");
	self.var_C528 = 1;
	wait(0.2);
	self.var_329F = magicgrenade("car_grenade",self.origin + (0,0,10),self.origin,9999,0);
	self.var_329F.var_C182 = 1;
	self.var_329F makeunusable();
}