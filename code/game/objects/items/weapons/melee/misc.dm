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
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	hitsound = 'sound/weapons/chainhit.ogg'

/obj/item/melee/chainsword
	name = "chainsword"
	desc = "A deadly chainsaw in the shape of a sword."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "chainswordoff"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 7
	w_class = ITEMSIZE_LARGE
	sharp = 1
	edge = TRUE
	origin_tech = list(TECH_COMBAT = 5)
	attack_verb = list("chopped", "sliced", "shredded", "slashed", "cut", "ripped")
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/active = 0
	can_embed = 0//A chainsword can slice through flesh and bone, and the direction can be reversed if it ever did get stuck

/obj/item/melee/chainsword/attack_self(mob/user)
	active= !active
	if(active)
		playsound(user, 'sound/weapons/saw/chainsawstart.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] rumbles to life."))
		force = 35
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
	force = 25
	throwforce = 15.0
	throw_speed = 5
	throw_range = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	w_class = ITEMSIZE_NORMAL
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

/obj/item/melee/hammer/powered/attack(var/mob/target, var/mob/living/user, var/target_zone)
	..()
	if(prob(trigger_chance))
		if(!on)
			to_chat(user, "<span class='warning'>\The [src] buzzes!</span>")
			return
		playsound(user, 'sound/weapons/beartrap_shut.ogg', 50, 1, -1)
		user.visible_message("<span class='danger'>\The [user] slams \the [target] away with \the [src]!</span>")
		var/T = get_turf(user)
		spark(T, 3, alldirs)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.apply_effect(2, WEAKEN)
		on = FALSE
		update_icon()
		addtimer(CALLBACK(src, PROC_REF(rearm)), reset_time SECONDS)
		if(isrobot(user))
			var/mob/living/silicon/robot/R = user
			if(R.cell)
				R.cell.use(150)

/obj/item/melee/hammer/powered/proc/rearm()
	src.visible_message("<span class='notice'>\The [src] hisses lowly.</span>")
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
	force = 10
	w_class = ITEMSIZE_NORMAL
	reach = 2
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	hitsound = 'sound/weapons/whip.ogg'

/obj/item/melee/whip/attack(mob/target as mob, mob/living/user as mob, var/target_zone)
	..()
	if(ishuman(target))
		if(prob(25))
			if(target_zone == BP_L_HAND || target_zone == BP_L_ARM)
				if (target.l_hand && target.l_hand != src)
					target.drop_l_hand()
			else if(target_zone == BP_R_HAND || target_zone == BP_R_ARM)
				if (target.r_hand && target.r_hand != src)
					target.drop_r_hand()
			user.visible_message("<span class='danger'>\The [user] disarms \the [target] with \the [src]!</span>")
		return

/obj/item/melee/ceremonial_sword
	name = "sol officer ceremonial sword"
	desc = "A ceremonial sword issued to Sol navy officers as part of their dress uniform."
	icon = 'icons/clothing/under/uniforms/sol_uniform.dmi'
	icon_state = "officersword"
	item_state = "officersword"
	contained_sprite = TRUE
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 5
	w_class = ITEMSIZE_LARGE
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
