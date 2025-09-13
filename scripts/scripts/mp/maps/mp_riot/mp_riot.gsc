/***********************************************
 * Decompiled by Bog
 * Edited by SyndiShanX
 * Script: scripts\mp\maps\mp_riot\mp_riot.gsc
***********************************************/

main() {
	scripts\mp\maps\mp_riot\mp_riot_precache::main();
	scripts\mp\maps\mp_riot\gen\mp_riot_art::main();
	scripts\mp\maps\mp_riot\mp_riot_fx::main();
	scripts\mp\load::main();
	scripts\mp\compass::setupminimap("compass_map_mp_riot");
	setdvar("r_lightGridEnableTweaks",1);
	setdvar("r_lightGridIntensity",1.33);
	setdvar("sm_sunCascadeSizeMultiplier1",2);
	setdvar("r_umbraMinObjectContribution",8);
	setdvar("r_umbraaccurateocclusionthreshold",400);
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_outfit"] = "urban";
	game["axis_outfit"] = "woodland";
	level.var_C7B3 = getentarray("OutOfBounds","targetname");
	thread func_FA7D();
	thread func_CDA4("mp_riot_ads");
	thread managephysicsprops();
	thread fix_collision();
	thread move_sd_startspawns();
	level.modifiedspawnpoints["56 -2404 200"]["mp_front_spawn_axis"]["remove"] = 1;
	level.modifiedspawnpoints["1152 -1614 172"]["mp_front_spawn_axis"]["remove"] = 1;
	level.modifiedspawnpoints["929 1886 184"]["mp_front_spawn_allies"]["remove"] = 1;
	level.modifiedspawnpoints["-1028 -1156 20"]["mp_koth_spawn"]["remove"] = 1;
	level.kothextraprimaryspawnpoints = [];
	level.kothextraprimaryspawnpoints["23 -3134 130"] = ["1","2","5"];
	level.kothextraprimaryspawnpoints["-1794 -607 24"] = ["1","4"];
	level.kothextraprimaryspawnpoints["-2021 -556 24"] = ["3"];
	level.kothextraprimaryspawnpoints["-1533 -348 24"] = ["4"];
	level.kothextraprimaryspawnpoints["-165 -634 184"] = ["3"];
	level.kothextraprimaryspawnpoints["-207 1210 184"] = ["4"];
}

fix_collision() {
	var_00 = getent("player32x32x8","targetname");
	var_01 = spawn("script_model",(-1756,1772,372));
	var_01.angles = (300,0,0);
	var_01 clonebrushmodeltoscriptmodel(var_00);
	var_02 = getent("player256x256x8","targetname");
	var_03 = spawn("script_model",(84,-1790,608));
	var_03.angles = (0,0,-90);
	var_03 clonebrushmodeltoscriptmodel(var_02);
	var_04 = getent("player256x256x256","targetname");
	var_05 = spawn("script_model",(-104,1184,928));
	var_05.angles = (340,0,0);
	var_05 clonebrushmodeltoscriptmodel(var_04);
	var_06 = getent("player32x32x8","targetname");
	var_07 = spawn("script_model",(-1284,-714,520));
	var_07.angles = (75,0,0);
	var_07 clonebrushmodeltoscriptmodel(var_06);
	var_08 = getent("clip512x512x8","targetname");
	var_09 = spawn("script_model",(-1662,2688,1184));
	var_09.angles = (270,0,0);
	var_09 clonebrushmodeltoscriptmodel(var_08);
	var_0A = getent("clip32x32x8","targetname");
	var_0B = spawn("script_model",(-1972,-1987,200));
	var_0B.angles = (0,0,-90);
	var_0B clonebrushmodeltoscriptmodel(var_0A);
	var_0C = getent("player32x32x256","targetname");
	var_0D = spawn("script_model",(-1976,-1976,640));
	var_0D.angles = (0,0,0);
	var_0D clonebrushmodeltoscriptmodel(var_0C);
	var_0E = getent("player32x32x256","targetname");
	var_0F = spawn("script_model",(-1976,-1976,896));
	var_0F.angles = (0,0,0);
	var_0F clonebrushmodeltoscriptmodel(var_0E);
	var_10 = getent("player32x32x256","targetname");
	var_11 = spawn("script_model",(-1572,2506,630));
	var_11.angles = (0,0,0);
	var_11 clonebrushmodeltoscriptmodel(var_10);
	var_12 = getent("player256x256x8","targetname");
	var_13 = spawn("script_model",(614,2176,424));
	var_13.angles = (272,0,0);
	var_13 clonebrushmodeltoscriptmodel(var_12);
	var_14 = getent("clip32x32x8","targetname");
	var_15 = spawn("script_model",(-1076,1404,174));
	var_15.angles = (0,0,0);
	var_15 clonebrushmodeltoscriptmodel(var_14);
	var_16 = getent("clip32x32x8","targetname");
	var_17 = spawn("script_model",(-1999,1873,174));
	var_17.angles = (0,0,0);
	var_17 clonebrushmodeltoscriptmodel(var_16);
	var_18 = getent("clip128x128x8","targetname");
	var_19 = spawn("script_model",(48,-1000,176));
	var_19.angles = (0,0,0);
	var_19 clonebrushmodeltoscriptmodel(var_18);
	var_1A = getent("clip128x128x8","targetname");
	var_1B = spawn("script_model",(112,1104,174));
	var_1B.angles = (0,0,0);
	var_1B clonebrushmodeltoscriptmodel(var_1A);
}

func_FA7D() {
	level.var_114C3 = 600;
	level.var_114C4 = 1200;
	level.var_BF61 = -1;
	var_00 = getentarray("watertank_invulnerable","targetname");
	foreach(var_02 in var_00) {
		var_02 thread func_12E48();
	}
}

func_12E48() {
	self setcandamage(1);
	for(;;) {
		self waittill("damage",var_00,var_01,var_02,var_03,var_04);
		if(!issubstr(var_04,"BULLET")) {
			continue;
		}

		if(!func_37F6()) {
			continue;
		}

		var_05 = func_7D54(var_01,var_02,var_03);
		if(!isdefined(var_05)) {
			continue;
		}

		func_1C33();
		var_05 = vectortoangles(var_05);
		playfx(level._effect["vfx_imp_glass_water_fishtank_riot"],var_03,anglestoforward(var_05),anglestoup(var_05));
		playfx(level._effect["vfx_water_stream_fishtank_riot"],var_03,anglestoforward(var_05),anglestoup(var_05));
		playsoundatpos(var_03,"dst_aquarium_puncture");
	}
}

func_7D54(param_00,param_01,param_02) {
	var_03 = param_00.origin;
	var_04 = param_02 - var_03;
	var_05 = bullettrace(var_03,var_03 + 1.5 * var_04,0,param_00,0);
	if(isdefined(var_05["normal"]) && isdefined(var_05["entity"]) && var_05["entity"] == self) {
		return var_05["normal"];
	}

	return undefined;
}

func_37F6() {
	if(gettime() < level.var_BF61) {
		return 0;
	}

	return 1;
}

func_1C33() {
	level.var_BF61 = gettime() + randomfloatrange(level.var_114C3,level.var_114C4);
}

func_CDA4(param_00) {
	wait(30);
	playcinematicforalllooping(param_00);
}

managephysicsprops() {
	level endon("game_ended");
	for(;;) {
		level waittill("connected",var_00);
		if(!var_00 ishost()) {
			thread triggerphysicsbump();
		}
	}
}

triggerphysicsbump() {
	var_00 = (-786.5,-2572,40);
	var_01 = 200;
	wait(5);
	var_02 = physics_volumecreate(var_00,1000);
	var_02 physics_volumesetasfocalforce(1,var_00,var_01);
	var_02 physics_volumeenable(1);
	var_02 physics_volumesetactivator(1);
	var_02.time = gettime();
	var_02.var_720E = var_01;
	var_02 physics_volumesetasfocalforce(1,var_00,var_01);
	wait(0.1);
	var_02 delete();
}

move_sd_startspawns() {
	if(level.gametype == "sd") {
		wait(0.1);
		var_00 = scripts\mp\spawnlogic::getspawnpointarray("mp_sd_spawn_defender");
		foreach(var_02 in var_00) {
			var_03 = anglestoright(var_02.angles);
			if(distance(var_02.origin,(-500,3060,176.124)) < 10) {
				var_02.origin = (-600,2564,176);
				var_02.alternates = [];
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin + var_03 * 45);
				continue;
			}

			if(distance(var_02.origin,(-596,3064,172.002)) < 10) {
				var_02.origin = (-686,2564,176);
				var_02.alternates = [];
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin + var_03 * 45);
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin - var_03 * 45);
				continue;
			}

			if(distance(var_02.origin,(-700,3064,176.124)) < 10) {
				var_02.origin = (-790,2564,180);
				var_02.alternates = [];
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin + var_03 * 45);
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin - var_03 * 45);
				continue;
			}

			if(distance(var_02.origin,(-500,3140,176.124)) < 10) {
				var_02.origin = (-600,2644,176);
				var_02.alternates = [];
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin + var_03 * 45);
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin - var_03 * 45);
				continue;
			}

			if(distance(var_02.origin,(-596,3144,172.002)) < 10) {
				var_02.origin = (-686,2644,176);
				var_02.alternates = [];
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin + var_03 * 45);
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin - var_03 * 45);
				continue;
			}

			if(distance(var_02.origin,(-700,3144,176.124)) < 10) {
				var_02.origin = (-790,2644,180);
				var_02.alternates = [];
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin + var_03 * 45);
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin - var_03 * 45);
				continue;
			}

			if(distance(var_02.origin,(-500,3220,176.124)) < 10) {
				var_02.origin = (-600,2724,176);
				var_02.alternates = [];
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin + var_03 * 45);
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin - var_03 * 45);
				continue;
			}

			if(distance(var_02.origin,(-596,3224,172.002)) < 10) {
				var_02.origin = (-686,2724,176);
				var_02.alternates = [];
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin + var_03 * 45);
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin - var_03 * 45);
				continue;
			}

			if(distance(var_02.origin,(-700,3224,176.124)) < 10) {
				var_02.origin = (-790,2724,180);
				var_02.alternates = [];
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin + var_03 * 45);
				scripts\mp\spawnlogic::func_17A7(var_02,var_02.origin - var_03 * 45);
			}
		}
	}
}