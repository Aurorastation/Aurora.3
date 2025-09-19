/obj/item/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	slot_flags = SLOT_BELT
	force = 11
	sharp = 0
	edge = FALSE
	throwforce = 7
	w_class = WEIGHT_CLASS_NORMAL
	drop_sound = 'sound/items/drop/metalweapon.ogg'
	pickup_sound = 'sound/items/pickup/metalweapon.ogg'
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beaten")
	var/stunforce = 0
	var/agonyforce = 60
	/// Whether the thing is on or not
	var/status = 0
	var/obj/item/cell/bcell
	var/hitcost = 1000
	var/baton_color = "#FF6A00"
	/// Electrocutes only on harm intent
	var/sheathed = 1

/obj/item/melee/baton/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The baton needs to be turned on to apply the stunning effect; left-click it in-hand to toggle power."
	. += "On Harm intent, you will inflict damage when using it, regardless if it is on or not."
	. += "Each stun reduces the baton's charge, which can be replenished by putting it inside a weapon recharger."

/obj/item/melee/baton/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
	. = ..()
	if(!distance <= 1)
		return
	if(bcell)
		. += "The baton is [round(bcell.percent())]% charged."
	else
		. += "The baton does not have a power source installed."

/obj/item/melee/baton/Initialize()
	. = ..()
	update_icon()

/**
 * This one starts with a cell pre-installed.
 */
/obj/item/melee/baton/loaded/Initialize()
	bcell = new/obj/item/cell/high(src)
	. = ..()

/obj/item/melee/baton/get_cell()
	return bcell

/obj/item/melee/baton/proc/deductcharge(var/chrgdeductamt)
	if(bcell)
		if(bcell.checked_use(chrgdeductamt))
			return 1
		else
			status = 0
			update_icon()
			return 0
	return null

/obj/item/melee/baton/update_icon()
	if(status)
		icon_state = "[initial(name)]_active"
	else if(!bcell)
		icon_state = "[initial(name)]_nocell"
	else
		icon_state = "[initial(name)]"

	if(icon_state == "[initial(name)]_active")
		set_light(1.3, 1, "[baton_color]")
	else
		set_light(0)

/obj/item/melee/baton/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/cell))
		if(attacking_item.w_class != WEIGHT_CLASS_NORMAL)
			to_chat(user, SPAN_WARNING("\The [attacking_item] is too [attacking_item.w_class < WEIGHT_CLASS_NORMAL ? "small" : "large"] to fit here."))
			return
		if(!bcell)
			user.drop_from_inventory(attacking_item, src)
			bcell = attacking_item
			to_chat(user, SPAN_NOTICE("You install a cell in [src]."))
			update_icon()
		else
			to_chat(user, SPAN_NOTICE("[src] already has a cell."))

	else if(attacking_item.isscrewdriver())
		if(bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(src))
			bcell = null
			to_chat(user, SPAN_NOTICE("You remove the cell from the [src]."))
			status = 0
			update_icon()
			return
		..()
	return

/obj/item/melee/baton/attack_self(mob/user)
	if(bcell && bcell.charge > hitcost)
		status = !status
		to_chat(user, SPAN_NOTICE("[src] is now [status ? "on" : "off"]."))
		playsound(loc, /singleton/sound_category/spark_sound, 75, 1, -1)
		update_icon()
	else
		status = 0
		if(!bcell)
			to_chat(user, SPAN_WARNING("[src] does not have a power source!"))
		else
			to_chat(user, SPAN_WARNING("[src] is out of charge."))
	add_fingerprint(user)

/obj/item/melee/baton/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(!target_mob)
		return

	if(status && (user.is_clumsy()) && prob(50))
		to_chat(user, SPAN_DANGER("You accidentally hit yourself with the [src]!"))
		user.Weaken(30)
		deductcharge(hitcost)
		return

	if(isrobot(target_mob))
		..()
		return

	var/agony = agonyforce
	var/stun = stunforce

	if(user.is_pacified())
		to_chat(user, SPAN_NOTICE("You don't want to risk hurting [target_mob]!"))
		return 0

	target_zone = check_zone(target_zone)
	if(user.a_intent == I_HURT)
		if (!..())	//item/attack() does it's own messaging and logs
			return 0	// item/attack() will return 1 if they hit, 0 if they missed.
		stun *= 0.5
		if(status)		//Checks to see if the stunbaton is on.
			agony *= 0.5	//whacking someone causes a much poorer contact than prodding them.
			if(iscarbon(target_mob))
				var/mob/living/carbon/C = target_mob
				if(sheathed) //however breaking the skin results in a more potent electric shock or some bullshit. im a coder, not a doctor
					C.electrocute_act(force * 2, src, def_zone = target_zone)
				else
					C.electrocute_act(force * 2, src, ground_zero = target_zone)
		else
			agony = 0
		//we can't really extract the actual hit zone from ..(), unfortunately. Just act like they attacked the area they intended to.
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(target_mob)
		//copied from human_defense.dm - human defence code should really be refactored some time.
		if (ishuman(target_mob))
			user.lastattacked = target_mob	//are these used at all, if we have logs?
			target_mob.lastattacker = user

			if (user != target_mob) // Attacking yourself can't miss
				target_zone = get_zone_with_miss_chance(user.zone_sel.selecting, target_mob)

			if(!target_zone)
				target_mob.visible_message(SPAN_WARNING("[user] misses [target_mob] with \the [src]!"))
				return 0

			var/mob/living/carbon/human/H = target_mob
			var/obj/item/organ/external/affecting = H.get_organ(target_zone)
			if (affecting)
				if(!status)
					target_mob.visible_message(SPAN_WARNING("[target_mob] has been prodded in the [affecting.name] with \the [src] by [user]. Luckily it was off."))
					return 1
				else
					H.visible_message(SPAN_DANGER("[target_mob] has been prodded in the [affecting.name] with \the [src] by [user]!"))
					var/intent = "(INTENT: [user? uppertext(user.a_intent) : "N/A"])"
					admin_attack_log(user, target_mob, "was stunned by this mob with [src] [intent]", "stunned this mob with [src] [intent]", "stunned with [src]")
					if(!sheathed)
						H.electrocute_act(force * 2, src, ground_zero = target_zone)
		if(isslime(target_mob))
			var/mob/living/carbon/slime/S =  target_mob
			if(!status)
				target_mob.visible_message(SPAN_WARNING("[S] has been prodded with \the [src] by [user]. Too bad it was off."))
				return TRUE
			else
				target_mob.visible_message(SPAN_DANGER("[S] has been prodded with \the [src] by [user]!"))

			S.discipline++
			if(prob(1))
				S.discipline = 0
				S.rabid = TRUE // heres that "or piss them off part"

		else
			if(!status)
				target_mob.visible_message(SPAN_WARNING("[target_mob] has been prodded with \the [src] by [user]. Luckily it was off."))
				return TRUE
			else
				target_mob.visible_message(SPAN_DANGER("[target_mob] has been prodded with \the [src] by [user]!"))

	//stun effects
	target_mob.stun_effect_act(stun, agony, target_zone, src)

	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	if(status)
		deductcharge(hitcost)

	return 1

/obj/item/melee/baton/emp_act(severity)
	. = ..()

	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.

//secborg stun baton module

/obj/item/melee/baton/robot
	hitcost = 300

/obj/item/melee/baton/robot/attack_self(mob/user)
	//try to find our power cell
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		bcell = R.cell
	return ..()

/obj/item/melee/baton/robot/attackby(obj/item/attacking_item, mob/user)
	return

/obj/item/melee/baton/robot/arm
	name = "electrified arm"

/obj/item/melee/baton/robot/arm/update_icon()
	if(status)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = "[initial(icon_state)]"

	if(icon_state == "[initial(icon_state)]_active")
		set_light(1.3, 1, "[baton_color]")
	else
		set_light(0)

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 0
	agonyforce = 60	//Marginally more inefficient.
	hitcost = 2000
	attack_verb = list("poked")
	slot_flags = null
	baton_color = "#FFDF00"
	sheathed = 0

/obj/item/melee/baton/cattleprod/Initialize(mapload, var/cable_color)
	. = ..()
	var/image/I = image(icon, null, "stunprod_cable")
	if(!cable_color)
		cable_color = COLOR_RED
	I.color = cable_color
	AddOverlays(I)

/obj/item/melee/baton/stunrod
	name = "stunrod"
	desc = "A more-than-lethal weapon used to deal with high threat situations."
	icon = 'icons/obj/stunrod.dmi'
	icon_state = "stunrod"
	item_state = "stunrod"
	force = 16
	agonyforce = 80
	hitcost = 1000
	baton_color = "#75ACFF"
	origin_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 2)
	contained_sprite = 1
	sheathed = 0

/obj/item/melee/baton/stunrod/Initialize()
	bcell = new/obj/item/cell/high(src)
	. = ..()

/obj/item/melee/baton/stunrod/update_icon() //this is needed due to how contained sprites work
	if(status)
		icon_state = "[initial(name)]_active"
		item_state = "[initial(name)]_active"
	else if(!bcell)
		icon_state = "[initial(name)]_nocell"
		item_state = "[initial(name)]"
	else
		icon_state = "[initial(name)]"
		item_state = "[initial(name)]"

	..()

/obj/item/melee/baton/slime // sprites
	name = "Slime Baton"
	desc = "A special baton used to help deal with agressive slimes. Works 95% of the time!"
	icon = 'icons/obj/stunrod.dmi'
	icon_state = "stunrod"
	item_state = "stunrod"
	baton_color = "#75ACFF"
	force = 3
	hitcost = 1000
	agonyforce = 50

/obj/item/melee/baton/slime/Initialize()
	bcell = new/obj/item/cell/high(src)
	. = ..()

/obj/item/melee/baton/slime/update_icon()
	icon_state = initial(icon_state)
	item_state = initial(item_state)
