/obj/item/melee
	icon = 'icons/obj/weapons.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/weapons/lefthand_melee.dmi',
		slot_r_hand_str = 'icons/mob/items/weapons/righthand_melee.dmi'
		)

/obj/item/melee/should_equip()
	return TRUE

/obj/item/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 7
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	hitsound = 'sound/weapons/chainhit.ogg'

/obj/item/melee/chainsword
	name = "chainsword"
	desc = "A deadly chainsaw in the shape of a sword."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "chainswordoff"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	force = 22
	throwforce = 7
	w_class = WEIGHT_CLASS_BULKY
	sharp = 1
	edge = TRUE
	origin_tech = list(TECH_COMBAT = 5)
	attack_verb = list("chopped", "sliced", "shredded", "slashed", "cut", "ripped")
	hitsound = 'sound/weapons/bladeslice.ogg'
	surgerysound = 'sound/weapons/saw/chainsword.ogg'
	var/active = 0
	can_embed = 0//A chainsword can slice through flesh and bone, and the direction can be reversed if it ever did get stuck

/obj/item/melee/chainsword/attack_self(mob/user)
	active= !active
	if(active)
		playsound(user, 'sound/weapons/saw/chainsawstart.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] rumbles to life."))
		force = 38
		hitsound = 'sound/weapons/saw/chainsword.ogg'
		icon_state = "chainswordon"
		slot_flags = null
	else
		to_chat(user, SPAN_NOTICE("\The [src] slowly powers down."))
		force = initial(force)
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		slot_flags = initial(slot_flags)
	user.regenerate_icons()

/obj/item/melee/chainsword/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target) && active)
		cleave(user, target)
	..()

//This is essentially a crowbar and a baseball bat in one.
/obj/item/melee/hammer
	name = "kneebreaker hammer"
	desc = "A heavy hammer made of plasteel, the other end could be used to pry open doors."
	icon = 'icons/obj/kneehammer.dmi'
	icon_state = "kneehammer"
	item_state = "kneehammer"
	contained_sprite = TRUE
	slot_flags = SLOT_BELT
	force = 31
	throwforce = 15.0
	throw_speed = 5
	throw_range = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_MATERIAL = 3, TECH_ILLEGAL = 2)

/obj/item/melee/hammer/iscrowbar()
	if(ismob(loc))
		var/mob/M = loc
		if(M.a_intent && M.a_intent == I_HURT)
			return FALSE
	return TRUE

/obj/item/melee/hammer/ishammer()
	return TRUE

/obj/item/melee/hammer/powered
	name = "powered hammer"
	desc = "A heavily modified plasteel hammer, it seems to be powered by a robust hydraulic system."
	icon = 'icons/obj/kneehammer.dmi'
	icon_state = "hammeron"
	item_state = "hammeron"
	origin_tech = list(TECH_MATERIAL = 5, TECH_ILLEGAL = 2, TECH_COMBAT = 3)
	var/on = TRUE
	var/trigger_chance = 30
	var/reset_time = 30 // reset time in seconds

/obj/item/melee/hammer/powered/update_icon()
	if(on)
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	else
		icon_state = "hammeroff"
		item_state = "hammeroff"

/obj/item/melee/hammer/powered/attack(mob/living/target_mob, mob/living/user, target_zone)
	..()
	if(prob(trigger_chance))
		if(!on)
			to_chat(user, SPAN_WARNING("\The [src] buzzes!"))
			return
		playsound(user, 'sound/weapons/beartrap_shut.ogg', 50, 1, -1)
		user.visible_message(SPAN_DANGER("\The [user] slams \the [target_mob] away with \the [src]!"))
		var/T = get_turf(user)
		spark(T, 3, GLOB.alldirs)
		step_away(target_mob,user,15)
		sleep(1)
		step_away(target_mob,user,15)
		sleep(1)
		step_away(target_mob,user,15)
		sleep(1)
		step_away(target_mob,user,15)
		sleep(1)
		if(ishuman(target_mob))
			var/mob/living/carbon/human/H = target_mob
			H.apply_effect(2, WEAKEN)
		on = FALSE
		update_icon()
		addtimer(CALLBACK(src, PROC_REF(rearm)), reset_time SECONDS)
		if(isrobot(user))
			var/mob/living/silicon/robot/R = user
			if(R.cell)
				R.cell.use(150)

/obj/item/melee/hammer/powered/proc/rearm()
	src.visible_message(SPAN_NOTICE("\The [src] hisses lowly."))
	on = TRUE
	update_icon()

/obj/item/melee/hammer/powered/hegemony
	name = "hegemony powered hammer"
	desc = "A heavily modified plasteel hammer, it seems to be powered by a robust hydraulic system. This one has the colours of the Izweski Hegemony on it."
	icon_state = "hammeron-hegemony"
	item_state = "hammeron-hegemony"
	trigger_chance = 50

/obj/item/melee/whip
	name = "whip"
	desc = "A whip made of fine leather, perfect for a space archaeologist."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "whip"
	item_state = "chain"
	slot_flags = SLOT_BELT
	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	reach = 2
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	hitsound = 'sound/weapons/whip.ogg'

/obj/item/melee/whip/attack(mob/living/target_mob, mob/living/user, target_zone)
	..()
	if(ishuman(target_mob))
		if(prob(25))
			if(target_zone == BP_L_HAND || target_zone == BP_L_ARM)
				if (target_mob.l_hand && target_mob.l_hand != src)
					target_mob.drop_l_hand()
			else if(target_zone == BP_R_HAND || target_zone == BP_R_ARM)
				if (target_mob.r_hand && target_mob.r_hand != src)
					target_mob.drop_r_hand()
			user.visible_message(SPAN_DANGER("\The [user] disarms \the [target_mob] with \the [src]!"))
		return

/obj/item/melee/ceremonial_sword
	name = "sol officer ceremonial sword"
	desc = "A ceremonial sword issued to Sol navy officers as part of their dress uniform."
	icon = 'icons/obj/sword.dmi'
	icon_state = "officersword"
	item_state = "officersword"
	contained_sprite = TRUE
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	force = 22
	throwforce = 5
	w_class = WEIGHT_CLASS_BULKY
	sharp = 1
	edge = TRUE
	can_embed = 0
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/melee/ceremonial_sword/marine
	name = "sol marine ceremonial sword"
	desc = "A ceremonial sword issued to Sol marine officers as part of their dress uniform."
	icon_state = "marineofficersword"
	item_state = "marineofficersword"

/obj/item/melee/dinograbber
	name = "dino grabber"
	desc = "A plastic T-Rex head on a thin aluminum tube. A piece of string links the jaw and a trigger, allowing you to grab \
	objects with it. Perfect for annoying your friends!"
	icon = 'icons/obj/dinograbber.dmi'
	icon_state = "dinograbber"
	item_state = "dinograbber"
	contained_sprite = TRUE
	slot_flags = SLOT_BELT
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 7
	throw_range = 15
	attack_verb = list("grabbed at")
	var/drop_result = FALSE

/obj/item/melee/dinograbber/attack(mob/living/target_mob, mob/living/user, target_zone)
	..()

	if(!ishuman(target_mob))
		return
	drop_result = FALSE

	// 20% chance to disarm someone per hit, not including the chance to miss with the weapon
	if(prob(20))
		// If hit in a valid zone, check and drop the item held in the respective hand, only working for items that are weight class small or below
		switch(target_zone)
			if(BP_L_HAND, BP_L_ARM)
				if(target_mob.l_hand && (target_mob.l_hand != src) && target_mob.l_hand.w_class <= WEIGHT_CLASS_SMALL)
					target_mob.drop_l_hand()
					drop_result = TRUE

			if(BP_R_HAND, BP_R_ARM)
				if(target_mob.r_hand && (target_mob.r_hand != src) && target_mob.r_hand.w_class <= WEIGHT_CLASS_SMALL)
					target_mob.drop_r_hand()
					drop_result = TRUE

	// Visible messages for either result.
	if(drop_result)
		user.visible_message(SPAN_DANGER("\The [user] disarms \the [target_mob] with \the [src]!"), SPAN_NOTICE("You successfully disarm \the [target_mob] with \the [src]!"))
	else
		user.visible_message(SPAN_DANGER("\The [user] fail to disarm \the [target_mob] with \the [src]!"), SPAN_NOTICE("You fail to disarm \the [target_mob] with \the [src]!"))
