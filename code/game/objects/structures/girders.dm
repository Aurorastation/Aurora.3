/obj/structure/girder
	desc = "The basic building block of all walls."
	desc_info = "Use metal sheets on this to build a normal wall.<br>\
	A false wall can be made by using a crowbar on this girder, and then adding some material.<br>\
	You can dismantle the grider with a wrench, or add support struts with a screwdriver to enable further reinforcement.<br>\
	If reinforced, before you can dismantle it, you must first unscrew the support struts, then cut them with wirecutters."
	icon_state = "girder"
	anchored = 1
	density = 1
	layer = ABOVE_CABLE_LAYER
	w_class = ITEMSIZE_HUGE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/state = 0
	var/health = 200
	var/cover = 50 //how much cover the girder provides against projectiles.
	build_amt = 2
	var/material/reinf_material
	var/reinforcing = 0
	var/plating = FALSE

/obj/structure/girder/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	var/state
	var/current_damage = health / initial(health)
	switch(current_damage)
		if(0 to 0.2)
			state = SPAN_DANGER("The support struts are collapsing!")
		if(0.2 to 0.4)
			state = SPAN_WARNING("The support struts are warped!")
		if(0.4 to 0.8)
			state = SPAN_NOTICE("The support struts are dented, but holding together.")
		if(0.8 to 1)
			state = SPAN_NOTICE("The support struts look completely intact.")
	. += state

/obj/structure/girder/displaced
	name = "displaced girder"
	icon_state = "displaced"
	anchored = 0
	health = 50
	cover = 25

/obj/structure/girder/bullet_act(var/obj/item/projectile/Proj)
	//Girders only provide partial cover. There's a chance that the projectiles will just pass through. (unless you are trying to shoot the girder)
	if(Proj.original != src && !prob(cover))
		return PROJECTILE_CONTINUE //pass through

	var/damage = Proj.get_structure_damage()
	if(!damage)
		return

	if(!istype(Proj, /obj/item/projectile/beam))
		damage *= 0.4 //non beams do reduced damage

	take_damage(damage)

	return ..()

/obj/structure/girder/proc/take_damage(var/damage)
	health -= damage
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] falls apart!</span>")
		dismantle()

/obj/structure/girder/proc/reset_girder()
	anchored = 1
	cover = initial(cover)
	health = min(health,initial(health))
	state = 0
	icon_state = initial(icon_state)
	reinforcing = 0
	if(reinf_material)
		reinforce_girder()

/obj/structure/girder/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench() && state == 0)
		if(anchored && !reinf_material)
			to_chat(user, "<span class='notice'>Now disassembling the girder...</span>")
			if(attacking_item.use_tool(src, user, 40, volume = 50))
				if(!src) return
				to_chat(user, "<span class='notice'>You dissasembled the girder!</span>")
				dismantle()
		else if(!anchored)
			to_chat(user, "<span class='notice'>Now securing the girder...</span>")
			if(attacking_item.use_tool(src, user, 40, volume = 50))
				to_chat(user, "<span class='notice'>You secured the girder!</span>")
				reset_girder()

	else if(istype(attacking_item, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/PC = attacking_item
		to_chat(user, SPAN_NOTICE("You start lining up \the [PC] to the joints of \the [src]..."))
		if(do_after(user, 2 SECONDS))
			if(!src)
				return
			playsound(loc, PC.fire_sound, 100, 1)
			to_chat(user, SPAN_NOTICE("You blast apart the girder!"))
			attacking_item.use_resource(user, 1)
			dismantle()

	else if(istype(attacking_item, /obj/item/melee/energy))
		var/obj/item/melee/energy/WT = attacking_item
		if(WT.active)
			to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
			if(attacking_item.use_tool(src, user, 30, volume = 50))
				if(!src) return
				to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
				dismantle()
		else
			to_chat(user, "<span class='notice'>You need to activate the weapon to do that!</span>")
			return

	else if(istype(attacking_item, /obj/item/melee/energy/blade))
		to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
		if(attacking_item.use_tool(src, user, 30, volume = 50))
			if(!src) return
			to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
			dismantle()

	else if(istype(attacking_item, /obj/item/melee/chainsword))
		var/obj/item/melee/chainsword/WT = attacking_item
		if(WT.active)
			to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
			if(WT.use_tool(src, user, 60, volume = 50))
				if(!src) return
				to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
				dismantle()
		else
			to_chat(user, "<span class='notice'>You need to activate the weapon to do that!</span>")
			return

	else if(istype(attacking_item, /obj/item/pickaxe/diamonddrill))
		to_chat(user, "<span class='notice'>You drill through the girder!</span>")
		dismantle()

	else if(istype(attacking_item, /obj/item/melee/arm_blade/))
		to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
		if(do_after(user,150))
			if(!src)
				return
			to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
			dismantle()

	else if(attacking_item.isscrewdriver())
		if(state == 2)
			to_chat(user, "<span class='notice'>Now unsecuring support struts...</span>")
			if(attacking_item.use_tool(src, user, 40, volume = 50))
				if(!src)
					return
				to_chat(user, "<span class='notice'>You unsecured the support struts!</span>")
				state = 1
		else if(anchored && !reinf_material)
			attacking_item.play_tool_sound(get_turf(src), 50)
			reinforcing = !reinforcing
			to_chat(user, "<span class='notice'>\The [src] can now be [reinforcing? "reinforced" : "constructed"]!</span>")
			return

	else if(attacking_item.iswirecutter() && state == 1)
		to_chat(user, "<span class='notice'>Now removing support struts...</span>")
		if(attacking_item.use_tool(src, user, 40, volume = 50))
			if(!src) return
			to_chat(user, "<span class='notice'>You removed the support struts!</span>")
			reinf_material = null
			reset_girder()

	else if(attacking_item.iscrowbar() && state == 0 && anchored)
		to_chat(user, "<span class='notice'>Now dislodging the girder...</span>")
		if(attacking_item.use_tool(src, user, 40, volume = 50))
			if(!src) return
			to_chat(user, "<span class='notice'>You dislodged the girder!</span>")
			icon_state = "displaced"
			anchored = 0
			health = 50
			cover = 25

	else if(istype(attacking_item, /obj/item/stack/material))
		if(reinforcing && !reinf_material)
			if(!reinforce_with_material(attacking_item, user))
				return ..()
		else
			if(!construct_wall(attacking_item, user))
				return ..()

	else if(attacking_item.force)
		var/damage_to_deal = attacking_item.force
		var/weaken = 0
		if(reinf_material)
			weaken += reinf_material.integrity * 3 //Since girders don't have a secondary material, buff 'em up a bit.
		weaken /= 100
		user.do_attack_animation(src)
		playsound(src, 'sound/weapons/smash.ogg', 50)
		if(damage_to_deal > weaken && (damage_to_deal > MIN_DAMAGE_TO_HIT))
			damage_to_deal -= weaken
			visible_message("<span class='warning'>[user] strikes \the [src] with \the [attacking_item], [is_sharp(attacking_item) ? "slicing" : "denting"] a support rod!</span>")
			take_damage(damage_to_deal)
		else
			visible_message("<span class='warning'>[user] strikes \the [src] with \the [attacking_item], but it bounces off!</span>")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return

	return ..()

/obj/structure/girder/proc/construct_wall(obj/item/stack/material/S, mob/user)
	if(S.get_amount() < 2)
		to_chat(user, "<span class='notice'>There isn't enough material here to construct a wall.</span>")
		return 0

	var/material/M = SSmaterials.get_material_by_name(S.default_type)
	if(!istype(M))
		return 0

	var/wall_fake
	add_hiddenprint(usr)

	if(M.integrity < 50)
		to_chat(user, "<span class='notice'>This material is too soft for use in wall construction.</span>")
		return 0

	if(!plating)
		to_chat(user, "<span class='notice'>You begin adding the plating...</span>")
		plating = TRUE
	else
		return TRUE

	if(!do_after(user,40) || !S.use(2))
		plating = FALSE
		return 1 //once we've gotten this far don't call parent attackby()

	plating = FALSE

	if(anchored)
		to_chat(user, "<span class='notice'>You added the plating!</span>")
	else
		to_chat(user, "<span class='notice'>You create a false wall! Push on it to open or close the passage.</span>")
		wall_fake = 1

	var/turf/Tsrc = get_turf(src)
	var/original_type = Tsrc.type
	Tsrc.ChangeTurf(/turf/simulated/wall)
	var/turf/simulated/wall/T = Tsrc
	T.under_turf = original_type
	T.set_material(M, reinf_material)
	if(wall_fake)
		T.can_open = 1
	T.add_hiddenprint(usr)
	qdel(src)
	return 1

/obj/structure/girder/proc/reinforce_with_material(obj/item/stack/material/S, mob/user) //if the verb is removed this can be renamed.
	if(reinf_material)
		to_chat(user, "<span class='notice'>\The [src] is already reinforced.</span>")
		return 0

	if(S.get_amount() < 2)
		to_chat(user, "<span class='notice'>There isn't enough material here to reinforce the girder.</span>")
		return 0

	var/material/M = SSmaterials.get_material_by_name(S.default_type)
	if(!istype(M) || M.integrity < 50)
		to_chat(user, "You cannot reinforce \the [src] with that; it is too soft.")
		return 0

	to_chat(user, "<span class='notice'>Now reinforcing...</span>")
	if (!do_after(user,40) || !S.use(2))
		return 1 //don't call parent attackby() past this point
	to_chat(user, "<span class='notice'>You added reinforcement!</span>")

	reinf_material = M
	reinforce_girder()
	return 1

/obj/structure/girder/proc/reinforce_girder()
	cover = reinf_material.hardness
	health = 500
	state = 2
	icon_state = "reinforced"
	reinforcing = 0

/obj/structure/girder/attack_hand(mob/user as mob)
	if((user.mutations & HULK))
		visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
		dismantle()
		return
	return ..()


/obj/structure/girder/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(30))
				dismantle()
				return
			else
				health -= rand(60,180)

		if(3.0)
			if (prob(5))
				dismantle()
				return
			else
				health -= rand(40,80)

	if(health <= 0)
		dismantle()
	return

/obj/structure/girder/attack_generic(var/mob/user, var/damage, var/attack_message = "smashes apart", var/wallbreaker)
	if(!damage || !wallbreaker)
		return FALSE
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] [attack_message] \the [src]!</span>")
	dismantle()
	return TRUE

/obj/structure/girder/cult
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	health = 250
	cover = 70
	appearance_flags = NO_CLIENT_COLOR

/obj/structure/girder/cult/dismantle()
	new /obj/effect/decal/remains/human(get_turf(src))
	qdel(src)

/obj/structure/girder/cult/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		to_chat(user, "<span class='notice'>Now disassembling the girder...</span>")
		if(attacking_item.use_tool(src, user, 40, volume = 50))
			to_chat(user, "<span class='notice'>You dissasembled the girder!</span>")
			dismantle()

	else if(istype(attacking_item, /obj/item/gun/energy/plasmacutter))
		to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
		if(attacking_item.use_tool(src, user, 30, volume = 50))
			to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
		dismantle()

	else if(istype(attacking_item, /obj/item/pickaxe/diamonddrill))
		to_chat(user, "<span class='notice'>You drill through the girder!</span>")
		new /obj/effect/decal/remains/human(get_turf(src))
		dismantle()

	else if(istype(attacking_item, /obj/item/melee/energy))
		var/obj/item/melee/energy/WT = attacking_item
		if(WT.active)
			to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
			if(attacking_item.use_tool(src, user, 30, volume = 50))
				to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
			dismantle()
		else
			to_chat(user, "<span class='notice'>You need to activate the weapon to do that!</span>")
			return

	else if(istype(attacking_item, /obj/item/melee/energy/blade))
		to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
		if(attacking_item.use_tool(src, user, 30, volume = 50))
			to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
		dismantle()

	else if(istype(attacking_item, /obj/item/melee/chainsword))
		var/obj/item/melee/chainsword/WT = attacking_item
		if(WT.active)
			to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
			if(WT.use_tool(src, user, 60, volume = 50))
				to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
			dismantle()
		else
			to_chat(user, "<span class='notice'>You need to activate the weapon to do that!</span>")
			return


/obj/structure/girder/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (!mover)
		return 1
	if(istype(mover,/obj/item/projectile) && density)
		if (prob(50))
			return 1
		else
			return 0
	else if(mover.checkpass(PASSTABLE))
//Animals can run under them, lots of empty space
		return 1
	return ..()
