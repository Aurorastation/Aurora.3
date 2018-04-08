/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit"
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	icon_living = "shade"
	icon_dead = "shade_dead"
	maxHealth = 50
	health = 50
	universal_speak = 1
	speak_emote = list("hisses")
	emote_hear = list("wails","screeches")
	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches"
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "drained the life from"
	minbodytemp = 0
	maxbodytemp = 4000
	min_oxy = 0
	max_co2 = 0
	max_tox = 0
	speed = -1
	stop_automated_movement = 1
	status_flags = 0
	faction = "cult"
	status_flags = CANPUSH
	hunger_enabled = 0
	appearance_flags = NO_CLIENT_COLOR

/mob/living/simple_animal/shade/cultify()
	return

/mob/living/simple_animal/shade/death()
	visible_message("<span class='warning'>[src] lets out a contented sigh as their form unwinds.</span>")
	new /obj/item/weapon/ectoplasm(loc)
	. = ..()

/mob/living/simple_animal/shade/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
	if(istype(O, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/S = O;
		S.transfer_soul("SHADE", src, user)
		return

/mob/living/simple_animal/shade/can_fall()
	return FALSE

/mob/living/simple_animal/shade/can_ztravel()
	return TRUE

/mob/living/simple_animal/shade/CanAvoidGravity()
	return TRUE
