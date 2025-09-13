/**************************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: behaviortree\crab_mini.gsc
**************************************/

func_2AD0() {
	if(isdefined(level.var_119E["crab_mini"])) {
		return;
	}

	var_00 = spawnstruct();
	var_00.var_1581 = [];
	var_00.var_1581[0] = ::scripts\aitypes\crab_mini\behaviors::initbehaviors;
	var_00.var_1581[1] = ::scripts\aitypes\crab_mini\behaviors::updateeveryframe;
	var_00.var_1581[2] = ::lib_0C2B::func_3E48;
	var_00.var_1581[3] = ::scripts\aitypes\crab_mini\behaviors::decideaction;
	var_00.var_1581[4] = ::scripts\aitypes\dlc3\bt_action_api::doaction_tick;
	var_00.var_1581[5] = ::scripts\aitypes\dlc3\bt_action_api::doaction_begin;
	var_00.var_1581[6] = ::scripts\aitypes\dlc3\bt_action_api::doaction_end;
	var_00.var_1581[7] = ::scripts\aitypes\crab_mini\behaviors::followenemy_tick;
	var_00.var_1581[8] = ::scripts\aitypes\crab_mini\behaviors::followenemy_begin;
	var_00.var_1581[9] = ::scripts\aitypes\crab_mini\behaviors::followenemy_end;
	var_00.var_1581[10] = ::lib_0C2B::notargetfound;
	level.var_119E["crab_mini"] = var_00;
}

func_DEE8() {
	func_2AD0();
	btregistertree("crab_mini");
}