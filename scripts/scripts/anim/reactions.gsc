/**************************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: scripts\anim\reactions.gsc
**************************************/

main() {
	if(getdvarint("ai_iw7",0) == 1) {
		return;
	}

	self endon("killanimscript");
	scripts\anim\utility::func_9832("reactions");
	func_BF22();
}

func_951D() {}

func_DD51() {
	thread func_325D();
}

func_38FD() {
	return !isdefined(self.var_A9D9) || gettime() - self.var_A9D9 > 2000;
}

func_325E() {}

func_325D() {
	self endon("killanimscript");
	if(isdefined(self.disablebulletwhizbyreaction)) {
		return;
	}

	for(;;) {
		self waittill("bulletwhizby",var_00);
		if(!isdefined(var_00.team) || self.team == var_00.team) {
			continue;
		}

		if(isdefined(self.covernode) || isdefined(self.var_1E2C)) {
			continue;
		}

		if(self.a.pose != "stand") {
			continue;
		}

		if(!func_38FD()) {
			continue;
		}

		self.var_13D13 = var_00;
		self _meth_8015(::func_325E);
	}
}

func_41C3() {
	self endon("killanimscript");
	wait(0.3);
	self _meth_8306();
}

func_7FE1() {}

func_10F51() {}

func_BF20() {
	self endon("death");
	self endon("endNewEnemyReactionAnim");
	self.var_A9D9 = gettime();
	self.a.movement = "stop";
	if(isdefined(self._stealth) && self.opcode::OP_inequality != "combat") {
		func_10F51();
	}
	else
	{
		var_00 = func_7FE1();
		self aiclearanim(%root,0.2);
		self _meth_82E7("reactanim",var_00,1,0.2,1);
		scripts\anim\shared::donotetracks("reactanim");
	}

	self notify("newEnemyReactionDone");
}

func_BF22() {
	self endon("death");
	if(isdefined(self.var_560E)) {
		return;
	}

	if(!func_38FD()) {
		return;
	}

	if(self.a.pose == "prone" || isdefined(self.a.onback)) {
		return;
	}

	self animmode("gravity");
	if(isdefined(self.isnodeoccupied)) {
		func_BF20();
	}
}