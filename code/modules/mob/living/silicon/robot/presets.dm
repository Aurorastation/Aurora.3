//cyborgs presets, mostly used for events/admin bus

/mob/living/silicon/robot/combat
	modtype = "Combat"
	spawn_module = /obj/item/weapon/robot_module/combat
	cell_type = /obj/item/weapon/cell/super

/mob/living/silicon/robot/combat/ert
	scrambledcodes = 1
	lawupdate = 0
	lawpreset = /datum/ai_laws/nanotrasen_aggressive
	idcard_type = /obj/item/weapon/card/id/centcom/ERT
	key_type = /obj/item/device/encryptionkey/ert

/mob/living/silicon/robot/combat/ert/init()
	..()
	if(!jetpack)
		jetpack = new /obj/item/weapon/tank/jetpack/carbondioxide/synthetic(src)