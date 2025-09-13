/************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: 3649.gsc
************************/

func_F701() {
	level.player setperk("specialty_fastreload",1);
}

func_12CBC() {
	level.player unsetperk("specialty_fastreload",1);
}

setstaticuicircles() {
	level.player setperk("specialty_bulletaccuracy",1);
}

unsetspotter() {
	level.player unsetperk("specialty_bulletaccuracy",1);
}

setquickswap() {
	level.player setperk("specialty_quickswap",1);
}

unsetquickswap() {
	level.player unsetperk("specialty_quickswap",1);
}

func_F712() {
	level.player setperk("specialty_reducedsway",1);
	level.player setviewkickscale(0.35);
}

func_12CBE() {
	level.player unsetperk("specialty_reducedsway",1);
	level.player setviewkickscale(1);
}

func_F80F() {
	level.player setperk("specialty_quickdraw",1);
}

func_12D12() {
	level.player unsetperk("specialty_quickdraw",1);
}

func_F636() {
	level.player setperk("specialty_sprintfire",1);
}

func_12C6F() {
	level.player unsetperk("specialty_sprintfire",1);
}

setextraequipment() {
	lib_0B2A::func_6240(1);
}

unsetextraequipment() {
	lib_0B2A::func_6240(0);
}

setblastshield() {
	level.player setperk("specialty_explosivearmor",1);
}

unsetblastshield() {
	level.player unsetperk("specialty_explosivearmor",1);
}

func_F700() {
	scripts\sp\_gameskill::func_F52D(0.85,0.75);
	scripts\sp\_gameskill::func_12E5A();
}

func_12CBB() {
	scripts\sp\_gameskill::func_F52D(1,1);
	scripts\sp\_gameskill::func_12E5A();
}

func_F849() {
	if(isdefined(self.perks) && isdefined(self.perks["specialty_shocker"])) {
		self.perks["specialty_shocker"] = undefined;
	}

	scripts\sp\_utility::func_13705();
	scripts\sp\_utility::func_12641("weapon_iw7_knife_perk_tr");
	scripts\sp\_utility::_meth_82EA("iw7_knife_perk");
}

func_12D2F() {
	scripts\sp\_utility::func_1143E();
}

func_F83E() {
	if(isdefined(self.perks) && isdefined(self.perks["specialty_slasher"])) {
		self.perks["specialty_slasher"] = undefined;
	}

	scripts\sp\_utility::func_13705();
	scripts\sp\_utility::func_12641("weapon_iw7_knife_upgrade1_tr");
	scripts\sp\_utility::_meth_82EA("iw7_knife_upgrade1");
}

func_12D2A() {
	scripts\sp\_utility::func_1143E();
}

func_11314(param_00,param_01,param_02) {
	level.player endon("death");
	level.player endon(param_02);
	var_03 = level.player getweaponslistoffhands();
	if(scripts\engine\utility::array_contains(var_03,param_00)) {
		level.player takeweapon(param_00);
		level.player giveweapon(param_01);
	}

	for(;;) {
		level.player waittill("equipment_change");
		var_03 = level.player getweaponslistoffhands();
		if(scripts\engine\utility::array_contains(var_03,param_00)) {
			level.player takeweapon(param_00);
			level.player giveweapon(param_01);
		}
	}
}

func_E0A3(param_00,param_01) {
	var_02 = level.player getweaponslistoffhands();
	if(scripts\engine\utility::array_contains(var_02,param_01)) {
		level.player takeweapon(param_01);
		level.player giveweapon(param_00);
	}
}

func_FAB8() {
	thread func_11314("frag","frag_up1","unsetUpgradeFrag1");
}

func_12D5A() {
	level.player notify("unsetUpgradeFrag1");
	thread func_E0A3("frag","frag_up1");
}

func_FAB9() {
	func_FAB8();
	level.player.var_735A = 1;
}

func_12D5B() {
	func_12D5A();
	level.player.var_735A = undefined;
}

func_FAC0() {
	level.player.var_612D.var_4A6D = 0.5;
	level.player.var_612D.var_4A6C = 0.75;
	level.player.var_612D.var_4A6E = 0.1;
	level.player.var_612D.var_12F6D = 1;
}

func_12D62() {
	level.player.var_612D.var_4A6D = 0.35;
	level.player.var_612D.var_4A6C = 0.6;
	level.player.var_612D.var_4A6E = 0.2;
	level.player.var_612D.var_12F6D = 0;
}

func_FAC1() {
	level.player.var_612D.var_12F6D = 2;
}

func_12D63() {
	level.player.var_612D.var_12F6D = 0;
}

func_FAB2() {
	level.player.var_202A = 1;
}

func_12D54() {
	level.player.var_202A = undefined;
}

func_FAB3() {
	func_FAB2();
	level.player.var_202B = 1;
}

func_12D55() {
	func_12D54();
	level.player.var_202B = undefined;
}

func_FABC() {
	level.player.var_F179.var_45BF = 1;
}

func_12D5E() {
	level.player.var_F179.var_45BF = 0;
}

func_FABD() {
	func_FABC();
	level.player.var_F179.var_9076 = 1;
}

func_12D5F() {
	func_12D5E();
	level.player.var_F179.var_9076 = 0;
}

func_FABA() {
	level.player.var_885E = 1;
	level.player.var_885D = 1;
}

func_12D5C() {
	level.player.var_885E = undefined;
	level.player.var_885D = undefined;
}

func_FABE() {
	level.player notify("unsetUpgradeShield1");
	thread func_11314("offhandshield","offhandshield_up1","unsetUpgradeShield1");
	level.player.var_C337.var_9936 = 1;
}

func_12D60() {
	level.player notify("unsetUpgradeShield1");
	thread func_E0A3("offhandshield","offhandshield_up1");
	level.player.var_C337.var_9936 = 0;
}

func_FAB6() {
	level.player.var_5CB3 = 1;
	thread func_11314("supportdrone","supportdrone_up2","unsetUpgradeDrone1");
}

func_12D58() {
	level.player.var_5CB3 = undefined;
	level.player notify("unsetUpgradeDrone1");
	thread func_E0A3("supportdrone","supportdrone_up2");
}

func_FAB4() {
	level.player.var_4759.var_389C = 1;
}

func_12D56() {
	level.player.var_4759.var_389C = 0;
}