/**************************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: behaviortree\crab_boss.gsc
**************************************/

func_2AD0() {
	if(isdefined(level.var_119E["crab_boss"])) {
		return;
	}

	var_00 = spawnstruct();
	var_00.var_1581 = [];
	var_00.var_1581[0] = ::scripts\aitypes\crab_boss\behaviors::initbehaviors;
	var_00.var_1581[1] = ::scripts\aitypes\crab_boss\behaviors::updateeveryframe;
	var_00.var_1581[2] = ::lib_0C2B::func_3E48;
	var_00.var_1581[3] = ::scripts\aitypes\crab_boss\behaviors::decideaction;
	var_00.var_1581[4] = ::scripts\aitypes\dlc3\bt_action_api::doaction_tick;
	var_00.var_1581[5] = ::scripts\aitypes\dlc3\bt_action_api::doaction_begin;
	var_00.var_1581[6] = ::scripts\aitypes\dlc3\bt_action_api::doaction_end;
	level.var_119E["crab_boss"] = var_00;
}

func_DEE8() {
	func_2AD0();
	btregistertree("crab_boss");
}