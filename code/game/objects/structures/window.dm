/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/structures.dmi'
	density = 1
	w_class = 3
	layer = 3.2//Just above doors
	anchored = 1.0
	flags = ON_BORDER
	obj_flags = OBJ_FLAG_ROTATABLE
	var/maxhealth = 14.0
	var/maximal_heat = T0C + 100 		// Maximal heat before this window begins taking damage from fire
	var/damage_per_fire_tick = 2.0 		// Amount of damage per fire tick. Regular windows are not fireproof so they might as well break quickly.
	var/health
	var/ini_dir = null
	var/state = 2
	var/reinf = 0
	var/basestate
	var/shardtype = /obj/item/material/shard
	var/glasstype = null // Set this in subtypes. Null is assumed strange or otherwise impossible to dismantle, such as for shuttle glass.
	var/silicate = 0 // number of units of silicate

	atmos_canpass = CANPASS_PROC

/obj/structure/window/examine(mob/user)
	. = ..(user)

	if(health == maxhealth)
		to_chat(user, span("notice", "It looks fully intact."))
	else
		var/perc = health / maxhealth
		if(perc > 0.75)
			to_chat(user, span("notice", "It has a few cracks."))
		else if(perc > 0.5)
			to_chat(user, span("warning", "It looks slightly damaged."))
		else if(perc > 0.25)
			to_chat(user, span("warning", "It looks moderately damaged."))
		else
			to_chat(user, span("danger", "It looks heavily damaged."))
	if(silicate)
		if (silicate < 30)
			to_chat(user, span("notice", "It has a thin layer of silicate."))
		else if (silicate < 70)
			to_chat(user, span("notice", "It is covered in silicate."))
		else
			to_chat(user, span("notice", "There is a thick layer of silicate covering it."))

/obj/structure/window/proc/take_damage(var/damage = 0,  var/sound_effect = 1)
	var/initialhealth = health

	if(silicate)
		damage = damage * (1 - silicate / 200)

	health = max(0, health - damage)

	if(health <= 0)
		shatter()
	else
		if(sound_effect)
			playsound(loc, 'sound/effects/glass_hit.ogg', 100, 1)
		if(health < maxhealth / 4 && initialhealth >= maxhealth / 4)
			visible_message(span("danger", "[src] looks like it's about to shatter!"))
			playsound(loc, "glasscrack", 100, 1)
		else if(health < maxhealth / 2 && initialhealth >= maxhealth / 2)
			visible_message(span("warning", "[src] looks seriously damaged!"))
			playsound(loc, "glasscrack", 100, 1)
		else if(health < maxhealth * 3/4 && initialhealth >= maxhealth * 3/4)
			visible_message(span("warning", "Cracks begin to appear in [src]!"))
			playsound(loc, "glasscrack", 100, 1)
	return

/obj/structure/window/proc/apply_silicate(var/amount)
	if(health < maxhealth) // Mend the damage
		health = min(health + amount * 3, maxhealth)
		if(health == maxhealth)
			visible_message("[src] looks fully repaired." )
	else // Reinforce
		silicate = min(silicate + amount, 100)
		updateSilicate()

/obj/structure/window/proc/updateSilicate()
	cut_overlays()

	var/image/img = image(icon, icon_state)
	img.color = "#ffffff"
	img.alpha = silicate * 255 / 100
	add_overlay(img)

/obj/structure/window/proc/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message(span("warning", "\The [src] shatters!"))
	if(dir == SOUTHWEST)
		var/index = null
		index = 0
		while(index < 2)
			new shardtype(loc) //todo pooling?
			if(reinf)
				new /obj/item/stack/rods(loc)
			index++
	else
		new shardtype(loc) //todo pooling?
		if(reinf)
			new /obj/item/stack/rods(loc)
	qdel(src)
	return

/obj/structure/window/bullet_act(var/obj/item/projectile/Proj)

	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage) return

	..()
	take_damage(proj_damage)
	return


/obj/structure/window/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			shatter(0)
			return
		if(3.0)
			if(prob(50))
				shatter(0)
				return
			else
				take_damage(rand(10,30))

//TODO: Make full windows a separate type of window.
//Once a full window, it will always be a full window, so there's no point
//having the same type for both.
/obj/structure/window/proc/is_full_window()
	return (dir == SOUTHWEST || dir == SOUTHEAST || dir == NORTHWEST || dir == NORTHEAST)

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(is_full_window())
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) & dir)
		return !density
	else
		return 1


/obj/structure/window/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSGLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1


/obj/structure/window/hitby(AM as mob|obj)
	..()
	visible_message(span("danger", "[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf) tforce *= 0.25
	if(health - tforce <= 7 && !reinf)
		anchored = 0
		update_nearby_icons()
		step(src, get_dir(AM, src))
	take_damage(tforce)

/obj/structure/window/attack_hand(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message(span("danger", "[user] smashes through [src]!"))
		user.do_attack_animation(src)
		shatter()

	else if (user.a_intent == I_HURT)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(H) || (H.is_berserk()))
				attack_generic(H,25)
				return

		playsound(src.loc, 'sound/effects/glass_knock.ogg', 90, 1)
		user.do_attack_animation(src)
		user.visible_message(span("danger", "\The [user] bangs against \the [src]!"),
							span("danger", "You bang against \the [src]!"),
							"You hear a banging sound.")
	else
		playsound(src.loc, 'sound/effects/glass_knock.ogg', 60, 1)
		user.visible_message("[user] knocks on \the [src.name].",
							"You knock on \the [src.name].",
							"You hear a knocking sound.")
	return

/obj/structure/window/attack_generic(var/mob/user, var/damage)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(damage >= 10)
		visible_message(span("danger", "[user] smashes into [src]!"))
		take_damage(damage)
	else
		visible_message(span("notice", "\The [user] bonks \the [src] harmlessly."))
		playsound(src.loc, 'sound/effects/glass_hit.ogg', 10, 1, -2)
	user.do_attack_animation(src)
	return 1

/obj/structure/window/do_simple_ranged_interaction(var/mob/user)
	visible_message(span("notice", "Something knocks on \the [src]."))
	playsound(loc, 'sound/effects/glass_hit.ogg', 50, 1)
	return TRUE

/obj/structure/window/attackby(obj/item/W, mob/user)
	if(!istype(W) || istype(W, /obj/item/flag))
		return
	if(istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if(istype(G.affecting,/mob/living))
			grab_smash_attack(G, BRUTE)
			return

	if(W.flags & NOBLUDGEON) return

	if(W.isscrewdriver())
		if(reinf && state >= 1)
			state = 3 - state
			update_nearby_icons()
			playsound(loc, W.usesound, 75, 1)
			to_chat(user, (state == 1 ? span("notice", "You have unfastened the window from the frame.") : span("notice", "You have fastened the window to the frame.")))
		else if(reinf && state == 0)
			anchored = !anchored
			update_nearby_icons()
			playsound(loc, W.usesound, 75, 1)
			to_chat(user, (anchored ? span("notice", "You have fastened the frame to the floor.") : span("notice", "You have unfastened the frame from the floor.")))
		else if(!reinf)
			anchored = !anchored
			update_nearby_icons()
			playsound(loc, W.usesound, 75, 1)
			to_chat(user, (anchored ? span("notice", "You have fastened the window to the floor.") : span("notice", "You have unfastened the window.")))
	else if(W.iscrowbar() && reinf && state <= 1)
		state = 1 - state
		playsound(loc, W.usesound, 75, 1)
		to_chat(user, (state ? span("notice", "You have pried the window into the frame.") : span("notice", "You have pried the window out of the frame.")))
	else if(W.iswrench() && !anchored && (!state || !reinf))
		if(!glasstype)
			to_chat(user, span("notice", "You're not sure how to dismantle \the [src] properly."))
		else
			visible_message(span("notice", "[user] dismantles \the [src]."))
			if(dir == SOUTHWEST)
				var/obj/item/stack/material/mats = new glasstype(loc)
				mats.amount = is_fulltile() ? 4 : 2
			else
				new glasstype(loc)
			qdel(src)
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			hit(W.force)
			if(health <= 7)
				anchored = 0
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/glass_hit.ogg', 75, 1)
		..()
	return

/obj/structure/window/proc/grab_smash_attack(obj/item/grab/G, var/damtype = BRUTE)
	var/mob/living/M = G.affecting
	var/mob/living/user = G.assailant

	var/state = G.state
	qdel(G)	//gotta delete it here because if window breaks, it won't get deleted

	var/def_zone = ran_zone(BP_HEAD, 20)
	var/blocked = M.run_armor_check(def_zone, "melee")
	switch (state)
		if(1)
			M.visible_message(span("warning", "[user] slams [M] against \the [src]!"))
			M.apply_damage(7, damtype, def_zone, blocked, src)
			hit(10)
		if(2)
			M.visible_message(span("danger", "[user] bashes [M] against \the [src]!"))
			if (prob(50))
				M.Weaken(1)
			M.apply_damage(10, damtype, def_zone, blocked, src)
			hit(25)
		if(3)
			M.visible_message(span("danger", "<big>[user] crushes [M] against \the [src]!</big>"))
			M.Weaken(5)
			M.apply_damage(20, damtype, def_zone, blocked, src)
			hit(50)

/obj/structure/window/proc/hit(var/damage, var/sound_effect = 1)
	if(reinf) damage *= 0.5
	take_damage(damage)
	return

/obj/structure/window/Initialize(mapload, start_dir = null, constructed=0)
	. = ..()

	//player-constructed windows
	if (constructed)
		anchored = 0

	if (start_dir)
		set_dir(start_dir)

	health = maxhealth

	ini_dir = dir

	update_nearby_tiles(need_rebuild=1)
	update_nearby_icons()


/obj/structure/window/Destroy()
	density = 0
	update_nearby_tiles()
	var/turf/location = loc
	loc = null
	for(var/obj/structure/window/W in orange(location, 1))
		W.update_icon()
	loc = location
	return ..()


/obj/structure/window/Move()
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	if(dir & (dir - 1))
		return 1
	return 0

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	cut_overlays()
	if(!is_fulltile())
		icon_state = "[basestate]"
		return
	var/list/dirs = list()
	if(anchored)
		for(var/obj/structure/window/W in orange(src,1))
			if(W.anchored && W.density && W.type == src.type && W.is_fulltile()) //Only counts anchored, not-destroyed fill-tile windows.
				dirs += get_dir(src, W)

	var/list/connections = dirs_to_corner_states(dirs)

	icon_state = ""
	for(var/i = 1 to 4)
		var/image/I = image(icon, "[basestate][connections[i]]", dir = 1<<(i-1))
		add_overlay(I)

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > maximal_heat)
		hit(damage_per_fire_tick, 0)
	..()


/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... anything, really should shatter it."
	icon_state = "window"
	basestate = "window"
	glasstype = /obj/item/stack/material/glass
	maximal_heat = T0C + 100
	damage_per_fire_tick = 2.0
	maxhealth = 12.0

/obj/structure/window/phoronbasic
	name = "phoron window"
	desc = "A borosilicate alloy window. It seems to be quite strong."
	basestate = "phoronwindow"
	icon_state = "phoronwindow"
	shardtype = /obj/item/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronglass
	maximal_heat = T0C + 2000
	damage_per_fire_tick = 1.0
	maxhealth = 40.0

/obj/structure/window/phoronreinforced
	name = "reinforced borosilicate window"
	desc = "A borosilicate alloy window, with rods supporting it. It seems to be very strong."
	basestate = "phoronrwindow"
	icon_state = "phoronrwindow"
	shardtype = /obj/item/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronrglass
	reinf = 1
	maximal_heat = T0C + 4000
	damage_per_fire_tick = 1.0 // This should last for 80 fire ticks if the window is not damaged at all. The idea is that borosilicate windows have something like ablative layer that protects them for a while.
	maxhealth = 80.0

/obj/structure/window/phoronreinforced/skrell
	name = "advanced borosilicate-alloy window"
	desc = "A window made out of a higly advanced borosilicate alloy. It seems to be extremely strong."
	basestate = "phoronwindow"
	icon_state = "phoronwindow"
	maxhealth = 250

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	basestate = "rwindow"
	maxhealth = 40.0
	reinf = 1
	maximal_heat = T0C + 750
	damage_per_fire_tick = 2.0
	glasstype = /obj/item/stack/material/glass/reinforced


/obj/structure/window/Initialize(mapload, constructed = 0)
	. = ..()

	//player-constructed windows
	if (!mapload && constructed)
		state = 0

/obj/structure/window/reinforced/full
    dir = 5
    icon_state = "fwindow"

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	basestate = "twindow"
	opacity = 1

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"
	basestate = "fwindow"
	maxhealth = 30

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/smooth/shuttle_window.dmi'
	icon_state = "shuttle_window"
	basestate = "window"
	maxhealth = 40
	reinf = 1
	basestate = "w"
	dir = 5
	smooth = SMOOTH_TRUE
	can_be_unanchored = TRUE

/obj/structure/window/shuttle/legion
	name = "cockpit window"
	icon = 'icons/obj/smooth/shuttle_window_legion.dmi'
	health = 160
	maxhealth = 160

/obj/structure/window/shuttle/palepurple
	icon = 'icons/obj/smooth/shuttle_window_palepurple.dmi'

/obj/structure/window/shuttle/skrell
	name = "advanced borosilicate alloy window"
	desc = "It looks extremely strong. Might take many good hits to crack it."
	icon = 'icons/obj/smooth/skrell_window_purple.dmi'
	health = 500
	maxhealth = 500
	smooth = SMOOTH_MORE|SMOOTH_DIAGONAL
	canSmoothWith = list(
		/turf/simulated/wall/shuttle/skrell,
		/obj/structure/window/shuttle/skrell
	)

/obj/structure/window/shuttle/crescent
	desc = "It looks rather strong."

/obj/structure/window/shuttle/crescent/take_damage()
	return

/obj/structure/window/shuttle/update_nearby_icons()
	queue_smooth_neighbors(src)

/obj/structure/window/update_icon()
	queue_smooth(src)

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	var/id

/obj/structure/window/reinforced/polarized/proc/toggle()
	if(opacity)
		animate(src, color="#FFFFFF", time=5)
		set_opacity(0)
	else
		animate(src, color="#222222", time=5)
		set_opacity(1)

/obj/structure/window/reinforced/crescent/attack_hand()
	return

/obj/structure/window/reinforced/crescent/attackby()
	return

/obj/structure/window/reinforced/crescent/ex_act(var/severity = 2.0)
	return

/obj/structure/window/reinforced/crescent/hitby()
	return

/obj/structure/window/reinforced/crescent/take_damage()
	return

/obj/structure/window/reinforced/crescent/shatter()
	return

/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for polarized windows."
	var/range = 16

/obj/machinery/button/windowtint/attack_hand(mob/user as mob)
	if(..())
		return 1

	toggle_tint()

/obj/machinery/button/windowtint/proc/toggle_tint()
	use_power(5)

	active = !active
	update_icon()

	for(var/obj/structure/window/reinforced/polarized/W in range(src,range))
		if (W.id == src.id || !W.id)
			spawn(0)
				W.toggle()
				return

/obj/machinery/button/windowtint/power_change()
	..()
	if(active && !powered(power_channel))
		toggle_tint()

/obj/machinery/button/windowtint/update_icon()
	icon_state = "light[active]"
