//replaces our stun baton code with /tg/station's code
/obj/item/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	slot_flags = SLOT_BELT
	force = 5
	sharp = 0
	edge = 0
	throwforce = 7
	w_class = 3
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beaten")
	var/stunforce = 0
	var/agonyforce = 70
	var/status = 0		//whether the thing is on or not
	var/obj/item/cell/bcell
	var/hitcost = 1000
	var/baton_color = "#FF6A00"
	var/sheathed = 1 //electrocutes only on harm intent

/obj/item/melee/baton/Initialize()
	. = ..()
	update_icon()

/obj/item/melee/baton/loaded/Initialize() //this one starts with a cell pre-installed.
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

/obj/item/melee/baton/examine(mob/user)
	if(!..(user, 1))
		return

	if(bcell)
		to_chat(user, "<span class='notice'>The baton is [round(bcell.percent())]% charged.</span>")
	else
		to_chat(user, "<span class='warning'>The baton does not have a power source installed.</span>")

/obj/item/melee/baton/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cell))
		if(!bcell)
			user.drop_from_inventory(W,src)
			bcell = W
			to_chat(user, "<span class='notice'>You install a cell in [src].</span>")
			update_icon()
		else
			to_chat(user, "<span class='notice'>[src] already has a cell.</span>")

	else if(W.isscrewdriver())
		if(bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(src))
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			status = 0
			update_icon()
			return
		..()
	return

/obj/item/melee/baton/attack_self(mob/user)
	if(bcell && bcell.charge > hitcost)
		status = !status
		to_chat(user, "<span class='notice'>[src] is now [status ? "on" : "off"].</span>")
		playsound(loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		if(!bcell)
			to_chat(user, "<span class='warning'>[src] does not have a power source!</span>")
		else
			to_chat(user, "<span class='warning'>[src] is out of charge.</span>")
	add_fingerprint(user)

/obj/item/melee/baton/attack(mob/living/L, mob/user, var/hit_zone)
	if(!L) return

	if(status && (user.is_clumsy()) && prob(50))
		to_chat(user, "<span class='danger'>You accidentally hit yourself with the [src]!</span>")
		user.Weaken(30)
		deductcharge(hitcost)
		return

	if(isrobot(L))
		..()
		return

	var/agony = agonyforce
	var/stun = stunforce

	if(user.is_pacified())
		to_chat(user, "<span class='notice'>You don't want to risk hurting [L]!</span>")
		return 0

	var/target_zone = check_zone(hit_zone)
	if(user.a_intent == I_HURT)
		if (!..())	//item/attack() does it's own messaging and logs
			return 0	// item/attack() will return 1 if they hit, 0 if they missed.
		stun *= 0.5
		if(status)		//Checks to see if the stunbaton is on.
			agony *= 0.5	//whacking someone causes a much poorer contact than prodding them.
			if(iscarbon(L))
				var/mob/living/carbon/C = L
				if(sheathed) //however breaking the skin results in a more potent electric shock or some bullshit. im a coder, not a doctor
					C.electrocute_act(force * 2, src, def_zone = target_zone)
				else
					C.electrocute_act(force * 2, src, ground_zero = target_zone)
		else
			agony = 0
		//we can't really extract the actual hit zone from ..(), unfortunately. Just act like they attacked the area they intended to.
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(L)
		//copied from human_defense.dm - human defence code should really be refactored some time.
		if (ishuman(L))
			user.lastattacked = L	//are these used at all, if we have logs?
			L.lastattacker = user

			if (user != L) // Attacking yourself can't miss
				target_zone = get_zone_with_miss_chance(user.zone_sel.selecting, L)

			if(!target_zone)
				L.visible_message("<span class='warning'>[user] misses [L] with \the [src]!</span>")
				return 0

			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affecting = H.get_organ(target_zone)
			if (affecting)
				if(!status)
					L.visible_message("<span class='warning'>[L] has been prodded in the [affecting.name] with \the [src] by [user]. Luckily it was off.</span>")
					return 1
				else
					H.visible_message("<span class='danger'>[L] has been prodded in the [affecting.name] with \the [src] by [user]!</span>")
					var/intent = "(INTENT: [user? uppertext(user.a_intent) : "N/A"])"
					admin_attack_log(user, L, "was stunned by this mob with [src] [intent]", "stunned this mob with [src] [intent]", "stunned with [src]")
					if(!sheathed)
						H.electrocute_act(force * 2, src, ground_zero = target_zone)
		if(isslime(L))
			var/mob/living/carbon/slime/S =  L
			if(!status)
				L.visible_message("<span class='warning'>[S] has been prodded with \the [src] by [user]. Too bad it was off.</span>")
				return TRUE
			else
				L.visible_message("<span class='danger'>[S] has been prodded with \the [src] by [user]!</span>")

			S.discipline++
			if(prob(1))
				S.discipline = 0
				S.rabid = TRUE // heres that "or piss them off part"

		else
			if(!status)
				L.visible_message("<span class='warning'>[L] has been prodded with \the [src] by [user]. Luckily it was off.</span>")
				return TRUE
			else
				L.visible_message("<span class='danger'>[L] has been prodded with \the [src] by [user]!</span>")

	//stun effects
	L.stun_effect_act(stun, agony, target_zone, src)

	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	if(status)
		deductcharge(hitcost)

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.forcesay(hit_appends)

	return 1

/obj/item/melee/baton/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()

//secborg stun baton module

/obj/item/melee/baton/robot
	hitcost = 300

/obj/item/melee/baton/robot/attack_self(mob/user)
	//try to find our power cell
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		bcell = R.cell
	return ..()

/obj/item/melee/baton/robot/attackby(obj/item/W, mob/user)
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

/obj/item/melee/baton/stunrod
	name = "stunrod"
	desc = "A more-than-lethal weapon used to deal with high threat situations."
	icon = 'icons/obj/stunrod.dmi'
	icon_state = "stunrod"
	item_state = "stunrod"
	force = 7
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
