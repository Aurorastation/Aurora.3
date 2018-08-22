//replaces our stun baton code with /tg/station's code
/obj/item/weapon/melee/baton
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
	var/agonyforce = 120
	var/status = 0		//whether the thing is on or not
	var/obj/item/weapon/cell/bcell
	var/hitcost = 1000	//oh god why do power cells carry so much charge? We probably need to make a distinction between "industrial" sized power cells for APCs and power cells for everything else.
	var/baton_color = "#FF6A00"
	var/sheathed = 1 //electrocutes only on harm intent

/obj/item/weapon/melee/baton/Initialize()
	. = ..()
	update_icon()

/obj/item/weapon/melee/baton/loaded/Initialize() //this one starts with a cell pre-installed.
	bcell = new/obj/item/weapon/cell/high(src)
	. = ..()

/obj/item/weapon/melee/baton/get_cell()
	return bcell

/obj/item/weapon/melee/baton/proc/deductcharge(var/chrgdeductamt)
	if(bcell)
		if(bcell.checked_use(chrgdeductamt))
			return 1
		else
			status = 0
			update_icon()
			return 0
	return null

/obj/item/weapon/melee/baton/update_icon()
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

/obj/item/weapon/melee/baton/examine(mob/user)
	if(!..(user, 1))
		return

	if(bcell)
		user <<"<span class='notice'>The baton is [round(bcell.percent())]% charged.</span>"
	else
		user <<"<span class='warning'>The baton does not have a power source installed.</span>"

/obj/item/weapon/melee/baton/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/cell))
		if(!bcell)
			user.drop_from_inventory(W,src)
			bcell = W
			user << "<span class='notice'>You install a cell in [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>[src] already has a cell.</span>"

	else if(isscrewdriver(W))
		if(bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(src))
			bcell = null
			user << "<span class='notice'>You remove the cell from the [src].</span>"
			status = 0
			update_icon()
			return
		..()
	return

/obj/item/weapon/melee/baton/attack_self(mob/user)
	if(bcell && bcell.charge > hitcost)
		status = !status
		user << "<span class='notice'>[src] is now [status ? "on" : "off"].</span>"
		playsound(loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		if(!bcell)
			user << "<span class='warning'>[src] does not have a power source!</span>"
		else
			user << "<span class='warning'>[src] is out of charge.</span>"
	add_fingerprint(user)

/obj/item/weapon/melee/baton/attack(mob/M, mob/user, var/hit_zone)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "<span class='danger'>You accidentally hit yourself with the [src]!</span>"
		user.Weaken(30)
		deductcharge(hitcost)
		return

	if(isrobot(M))
		..()
		return

	var/agony = agonyforce
	var/stun = stunforce
	var/mob/living/L = M

	if(user.disabilities & PACIFIST)
		to_chat(user, "<span class='notice'>You don't want to risk hurting [M]!</span>")
		return 0

	var/target_zone = check_zone(hit_zone)
	if(user.a_intent == I_HURT)
		if (!..())	//item/attack() does it's own messaging and logs
			return 0	// item/attack() will return 1 if they hit, 0 if they missed.
		stun *= 0.5
		if(status)		//Checks to see if the stunbaton is on.
			agony *= 0.5	//whacking someone causes a much poorer contact than prodding them.
			if(sheathed) //however breaking the skin results in a more potent electric shock or some bullshit. im a coder, not a doctor
				L.electrocute_act(force * 2, src, def_zone = target_zone)
			else
				L.electrocute_act(force * 2, src, ground_zero = target_zone)
		else
			agony = 0
		//we can't really extract the actual hit zone from ..(), unfortunately. Just act like they attacked the area they intended to.
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(M)
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
					L.visible_message("<span class='warning'>[L] has been prodded in the [affecting.name] with [src] by [user]. Luckily it was off.</span>")
					return 1
				else
					H.visible_message("<span class='danger'>[L] has been prodded in the [affecting.name] with [src] by [user]!</span>")
					if(!sheathed)
						H.electrocute_act(force * 2, src, ground_zero = target_zone)

		if(isslime(M))
			var/mob/living/carbon/slime/S =  M
			if(!status)
				L.visible_message("<span class='warning'>[S] has been prodded with \the [src] by [user]. Too bad it was off.</span>")
				return 1
			else
				L.visible_message("<span class='danger'>[S] has been prodded with \the [src] by [user]!</span>")

			S.Discipline ++
			if(prob(5))
				S.Discipline = 0
				S.rabid = 1 // heres that "or piss them off part"

		else
			if(!status)
				L.visible_message("<span class='warning'>[L] has been prodded with [src] by [user]. Luckily it was off.</span>")
				return 1
			else
				L.visible_message("<span class='danger'>[L] has been prodded with [src] by [user]!</span>")

	//stun effects
	L.stun_effect_act(stun, agony, target_zone, src)

	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
	msg_admin_attack("[key_name_admin(user)] stunned [key_name_admin(L)] with the [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(L))

	if(status)
		deductcharge(hitcost)

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.forcesay(hit_appends)

	return 1

/obj/item/weapon/melee/baton/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()

//secborg stun baton module

/obj/item/weapon/melee/baton/robot
	hitcost = 300

/obj/item/weapon/melee/baton/robot/attack_self(mob/user)
	//try to find our power cell
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		bcell = R.cell
	return ..()

/obj/item/weapon/melee/baton/robot/attackby(obj/item/weapon/W, mob/user)
	return

/obj/item/weapon/melee/baton/robot/arm
	name = "electrified arm"

/obj/item/weapon/melee/baton/robot/arm/update_icon()
	if(status)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = "[initial(icon_state)]"

	if(icon_state == "[initial(icon_state)]_active")
		set_light(1.3, 1, "[baton_color]")
	else
		set_light(0)

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/weapon/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 0
	agonyforce = 120	//same force as a stunbaton, but uses way more charge.
	hitcost = 2500
	attack_verb = list("poked")
	slot_flags = null
	baton_color = "#FFDF00"
	sheathed = 0

/obj/item/weapon/melee/baton/stunrod
	name = "stunrod"
	desc = "A more-than-lethal weapon used to deal with high threat situations."
	icon = 'icons/obj/stunrod.dmi'
	icon_state = "stunrod"
	item_state = "stunrod"
	force = 7
	baton_color = "#75ACFF"
	origin_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 2)
	contained_sprite = 1
	sheathed = 0

/obj/item/weapon/melee/baton/stunrod/Initialize()
	bcell = new/obj/item/weapon/cell/high(src)
	. = ..()

/obj/item/weapon/melee/baton/stunrod/update_icon() //this is needed due to how contained sprites work
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

/obj/item/weapon/melee/baton/slime // sprites
	name = "Slime Baton"
	desc = "A special baton used to help deal with agressive slimes. Works 95% of the time!"
	icon = 'icons/obj/stunrod.dmi'
	icon_state = "stunrod"
	item_state = "stunrod"
	baton_color = "#75ACFF"
	force = 3
	agonyforce = 60

/obj/item/weapon/melee/baton/slime/Initialize()
	bcell = new/obj/item/weapon/cell/high(src)
	. = ..()

/obj/item/weapon/melee/baton/slime/update_icon()
	icon_state = initial(icon_state)
	item_state = initial(item_state)
