/*************************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: behaviortree\pamgrier.gsc
*************************************/

func_2AD0() {
	if(isdefined(level.var_119E["pamgrier"])) {
		return;
	}

	var_00 = spawnstruct();
	var_00.var_1581 = [];
	var_00.var_1581[0] = ::scripts\aitypes\pamgrier\behaviors::init;
	var_00.var_1581[1] = ::scripts\aitypes\pamgrier\behaviors::updateeveryframe;
	var_00.var_1581[2] = ::lib_0C2B::func_3E48;
	var_00.var_1581[3] = ::scripts\aitypes\pamgrier\behaviors::decideaction;
	var_00.var_1581[4] = ::scripts\aitypes\pamgrier\behaviors::doaction_tick;
	var_00.var_1581[5] = ::scripts\aitypes\pamgrier\behaviors::doaction_begin;
	var_00.var_1581[6] = ::scripts\aitypes\pamgrier\behaviors::doaction_end;
	var_00.var_1581[7] = ::scripts\aitypes\pamgrier\behaviors::followenemy_tick;
	var_00.var_1581[8] = ::scripts\aitypes\pamgrier\behaviors::followenemy_begin;
	var_00.var_1581[9] = ::scripts\aitypes\pamgrier\behaviors::followenemy_end;
	level.var_119E["pamgrier"] = var_00;
}

func_DEE8() {
	func_2AD0();
	btregistertree("pamgrier");
}