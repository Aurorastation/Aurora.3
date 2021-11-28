//Interactions
/turf/simulated/wall/proc/toggle_open(var/mob/user)

	if(can_open == WALL_OPENING)
		return

	if(density)
		can_open = WALL_OPENING
		//flick("[material.icon_base]fwall_opening", src)
		sleep(15)
		density = 0
		set_opacity(0)
		update_icon()
		set_light(0)
	else
		can_open = WALL_OPENING
		//flick("[material.icon_base]fwall_closing", src)
		density = 1
		set_opacity(1)
		update_icon()
		sleep(15)
		set_light(1)

	can_open = WALL_CAN_OPEN
	update_icon()

/turf/simulated/wall/proc/fail_smash(var/mob/user, var/multiplier = 1)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*2.5)
	to_chat(user, SPAN_DANGER("You smash against the wall!"))
	user.do_attack_animation(src)
	take_damage(rand(60,135)*multiplier)
	return 1

/turf/simulated/wall/proc/success_smash(var/mob/user)
	to_chat(user, SPAN_DANGER("You smash through the wall!"))
	user.do_attack_animation(src)
	spawn(1)
		dismantle_wall(1)
	return 1

/turf/simulated/wall/proc/try_touch(var/mob/user, var/rotting)
	if(rotting)
		if(reinf_material)
			to_chat(user, SPAN_WARNING("\The [reinf_material.display_name] feels porous and crumbly."))
		else
			to_chat(user, SPAN_WARNING("\The [material.display_name] crumbles under your touch!"))
			dismantle_wall()
			return TRUE

	user.visible_message(SPAN_NOTICE("\The [user] starts feeling around and pushing on \the [src]..."), SPAN_NOTICE("You start feeling around and pushing on \the [src]..."))
	if(!do_after(user, 30, TRUE, src))
		return

	if(!can_open)
		to_chat(user, SPAN_NOTICE("You push the wall, but nothing happens."))
		playsound(src, hitsound, 25, TRUE)
	else
		toggle_open(user)
	return FALSE


/turf/simulated/wall/attack_hand(var/mob/user)

	radiate()
	add_fingerprint(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if (HULK in user.mutations)
		if (rotting || !prob(material.hardness))
			success_smash(user)
		else
			fail_smash(user, 2)
			return 1

	if(ishuman(user) && user.a_intent == I_GRAB)
		var/mob/living/carbon/human/H = user
		var/turf/destination = GetAbove(H)

		if(destination)
			var/turf/start = get_turf(H)
			if(start.CanZPass(H, UP) && destination.CanZPass(H, UP))
				H.climb(UP, src)
				return

	try_touch(user, rotting)

/turf/simulated/wall/attack_generic(var/mob/user, var/damage, var/attack_message, var/wallbreaker)

	radiate()
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if(!damage || !wallbreaker)
		try_touch(user, rotting)
		return


	if(rotting)
		return success_smash(user)

	if(reinf_material)
		if((wallbreaker == 2) && (damage >= max(material.hardness,reinf_material.hardness)))
			return success_smash(user)
	else if(damage >= material.hardness)
		return success_smash(user)
	return fail_smash(user, wallbreaker)

/turf/simulated/wall/attackby(obj/item/W, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!user)
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	//get the user's location
	if(!istype(user.loc, /turf))
		return	//can't do this stuff whilst inside objects and such

	if(istype(W, /obj/item/plastique))
		return

	if(W)
		radiate()
		if(is_hot(W))
			burn(is_hot(W))

	if(locate(/obj/effect/overlay/wallrot) in src)
		if(W.iswelder())
			var/obj/item/weldingtool/WT = W
			if(WT.remove_fuel(0,user))
				to_chat(user, SPAN_NOTICE("You burn away the fungi with \the [WT]."))
				playsound(src, 'sound/items/welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(W.sharp)
			user.visible_message("<b>[user]</b> starts scraping the rot away with \the [W].", SPAN_NOTICE("You start scraping the rot away with \the [W]."))
			if(do_after(user, rand(3 SECONDS, 5 SECONDS), TRUE))
				user.visible_message("<b>[user]</b> scrapes away the rot with \the [W].", SPAN_NOTICE("You start scraping away the rot with \the [W]."))
				playsound(src, W.hitsound, W.get_clamped_volume(), TRUE)
				for(var/obj/effect/overlay/wallrot/WR in src)
					WR.scrape(user)
				return
		else if(W.force >= 10)
			user.do_attack_animation(src, W)
			to_chat(user, SPAN_NOTICE("\The [src] crumbles away under the force of your [W]."))
			dismantle_wall(TRUE)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(W.isFlameSource())
			thermitemelt(user)
			return

		else if(istype(W, /obj/item/gun/energy/plasmacutter))
			thermitemelt(user)
			return

		else if( istype(W, /obj/item/melee/energy/blade) )
			var/obj/item/melee/energy/blade/EB = W

			spark(EB, 5)
			to_chat(user, SPAN_NOTICE("You slash \the [src] with \the [EB], igniting the thermite!"))
			playsound(src, /decl/sound_category/spark_sound, 50, 1)
			playsound(src, 'sound/weapons/blade.ogg', 50, 1)

			thermitemelt(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	if(damage && W.iswelder())

		var/obj/item/weldingtool/WT = W

		if(!WT.isOn())
			return

		if(WT.remove_fuel(0,user))
			to_chat(user, SPAN_NOTICE("You start repairing the damage to [src]."))
			playsound(src, 'sound/items/welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5)) && WT && WT.isOn())
				to_chat(user, SPAN_NOTICE("You finish repairing the damage to [src]."))
				take_damage(-damage)
		else
			to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
			return
		return

	// Basic dismantling.
	if(isnull(construction_stage) || !reinf_material)

		var/cut_delay = 60 - material.cut_delay
		var/dismantle_verb
		var/dismantle_sound

		if(W.iswelder())
			var/obj/item/weldingtool/WT = W
			if(!WT.isOn())
				return
			if(!WT.remove_fuel(0,user))
				to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
				return
			dismantle_verb = "cutting"
			dismantle_sound = 'sound/items/welder.ogg'
			cut_delay *= 0.7
		else if(istype(W, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/PC = W
			if(PC.check_power_and_message(user))
				return
			dismantle_sound = PC.fire_sound
			dismantle_verb = "slicing"
			cut_delay *= 0.8
		else if(istype(W,/obj/item/melee/energy))
			var/obj/item/melee/energy/WT = W
			if(WT.active)
				dismantle_sound = /decl/sound_category/spark_sound
				dismantle_verb = "slicing"
				cut_delay *= 0.5
			else
				to_chat(user, SPAN_NOTICE("You need to activate the weapon to do that!"))
				return
		else if(istype(W,/obj/item/melee/energy/blade))
			dismantle_sound = /decl/sound_category/spark_sound
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else if(istype(W,/obj/item/melee/chainsword))
			var/obj/item/melee/chainsword/WT = W
			if(WT.active)
				dismantle_sound = 'sound/weapons/saw/chainsawhit.ogg'
				dismantle_verb = "slicing"
				cut_delay *= 0.8
			else
				to_chat(user, SPAN_NOTICE("You need to activate the weapon to do that!"))
				return
		else if(istype(W,/obj/item/pickaxe))
			var/obj/item/pickaxe/P = W
			dismantle_verb = P.drill_verb
			dismantle_sound = P.drill_sound
			cut_delay -= P.digspeed
		else if(istype(W,/obj/item/melee/arm_blade/))
			dismantle_sound = /decl/sound_category/pickaxe_sound
			dismantle_verb = "slicing and stabbing"
			cut_delay *= 1.5

		if(dismantle_verb)
			to_chat(user, SPAN_NOTICE("You begin [dismantle_verb] through the outer plating."))

			if(cut_delay<0)
				cut_delay = 1

			if(!do_after(user,cut_delay/W.toolspeed))
				return

			//This prevents runtime errors if someone clicks the same wall more than once
			if (!istype(src, /turf/simulated/wall))
				return

			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)
			W.use_resource(user, 1)
			dismantle_wall()
			user.visible_message(SPAN_WARNING("The wall was torn open by \the [user]!"), SPAN_NOTICE("You remove the outer plating."))
			return

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)
				if (W.iswirecutter())
					playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
					construction_stage = 5
					to_chat(user, SPAN_NOTICE("You cut the outer grille."))
					update_icon()
					return
			if(5)
				if (W.isscrewdriver())
					to_chat(user, SPAN_NOTICE("You begin removing the support lines."))
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,60/W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 5)
						return
					construction_stage = 4
					update_icon()
					to_chat(user, SPAN_NOTICE("You remove the support lines."))
					return
				else if( istype(W, /obj/item/stack/rods) )
					var/obj/item/stack/O = W
					if(O.get_amount()>0)
						O.use(1)
						construction_stage = 6
						update_icon()
						to_chat(user, SPAN_NOTICE("You replace the outer grille."))
						return
			if(4)
				var/cut_cover
				if(W.iswelder())
					var/obj/item/weldingtool/WT = W
					if(!WT.isOn())
						return
					if(WT.remove_fuel(0,user))
						cut_cover=1
					else
						to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
						return
				else if (istype(W, /obj/item/gun/energy/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					to_chat(user, SPAN_NOTICE("You begin slicing through the metal cover."))
					playsound(src, 'sound/items/welder.ogg', 100, 1)
					if(!do_after(user, 60/W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 3
					update_icon()
					to_chat(user, SPAN_NOTICE("You press firmly on the cover, dislodging it."))
					return
			if(3)
				if (W.iscrowbar())
					to_chat(user, SPAN_NOTICE("You struggle to pry off the cover."))
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,100/W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 3)
						return
					construction_stage = 2
					update_icon()
					to_chat(user, SPAN_NOTICE("You pry off the cover."))
					return
			if(2)
				if (W.iswrench())
					to_chat(user, SPAN_NOTICE("You start loosening the anchoring bolts which secure the support rods to their frame."))
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,40/W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 2)
						return
					construction_stage = 1
					update_icon()
					to_chat(user, SPAN_NOTICE("You remove the bolts anchoring the support rods."))
					return
			if(1)
				var/cut_cover
				if(W.iswelder())
					var/obj/item/weldingtool/WT = W
					if( WT.remove_fuel(0,user) )
						cut_cover=1
					else
						to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
						return
				else if(istype(W, /obj/item/gun/energy/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					to_chat(user, SPAN_NOTICE("You begin slicing through the support rods."))
					playsound(src, 'sound/items/welder.ogg', 100, 1)
					if(!do_after(user,70/W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 1)
						return
					construction_stage = 0
					update_icon()
					new /obj/item/stack/rods(src)
					to_chat(user, SPAN_NOTICE("The support rods drop out as you cut them loose from the frame."))
					return
			if(0)
				if(W.iscrowbar())
					to_chat(user, SPAN_NOTICE("You struggle to pry off the outer sheath."))
					playsound(src, W.usesound, 100, 1)
					sleep(100)
					if(!istype(src, /turf/simulated/wall) || !user || !W || !T )	return
					if(user.loc == T && user.get_active_hand() == W )
						to_chat(user, SPAN_NOTICE("You pry off the outer sheath."))
						dismantle_wall()
					return

	if(istype(W, /obj/item/device/electronic_assembly/wallmount))
		var/obj/item/device/electronic_assembly/wallmount/IC = W
		IC.mount_assembly(src, user)
		return

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src, user)
		return

	else if(!istype(W,/obj/item/rfd/construction) && !istype(W, /obj/item/reagent_containers))
		if(user.a_intent != I_HURT || !W.force)
			return

		var/damage_to_deal = W.force
		var/weaken = 0
		var/sound_to_play = 'sound/weapons/smash.ogg'
		if(material)
			weaken += material.integrity * 2.5
			sound_to_play = material.hitsound
		if(reinf_material)
			weaken += reinf_material.integrity * 2.5
		weaken /= 100 //For reference, plasteel's integrity is 600.
		user.do_attack_animation(src)
		playsound(src, sound_to_play, 50)
		if(damage_to_deal > weaken && (damage_to_deal > MIN_DAMAGE_TO_HIT))
			//Plasteel walls take 24 & 15 minimum damage.
			//Steel walls take 3 & 15 minimum damage.
			damage_to_deal -= weaken
			visible_message(SPAN_WARNING("[user] strikes \the [src] with \the [W], [is_sharp(W) ? "slicing some of the plating" : "putting a heavy dent on it"]!"))
			take_damage(damage_to_deal)
		else
			visible_message(SPAN_WARNING("[user] strikes \the [src] with \the [W], but it bounces off!"))
			playsound(src, hitsound, 25, 1)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
