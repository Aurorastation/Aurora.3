//cyborgs presets, mostly used for events/admin bus

/mob/living/silicon/robot/combat
	modtype = "Combat"

/mob/living/silicon/robot/combat/ert
	scrambledcodes = 1
	lawupdate = 0
	lawpreset = /datum/ai_laws/nanotrasen_aggressive
	key_type = /obj/item/device/encryptionkey/ert

/mob/living/silicon/robot/combat/ert/init()
	..()
	if(!jetpack)
