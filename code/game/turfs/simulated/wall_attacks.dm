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
	to_chat(user, "<span class='danger'>You smash against the wall!</span>")
	user.do_attack_animation(src)
	take_damage(rand(60,135)*multiplier)
	return 1

/turf/simulated/wall/proc/success_smash(var/mob/user)
	to_chat(user, "<span class='danger'>You smash through the wall!</span>")
	user.do_attack_animation(src)
	spawn(1)
		dismantle_wall(1)
	return 1

/turf/simulated/wall/proc/try_touch(var/mob/user, var/rotting)

	if(rotting)
		if(reinf_material)
			to_chat(user, "<span class='danger'>\The [reinf_material.display_name] feels porous and crumbly.</span>")
		else
			to_chat(user, "<span class='danger'>\The [material.display_name] crumbles under your touch!</span>")
			dismantle_wall()
			return 1

	if(!can_open)
		to_chat(user, "<span class='notice'>You push the wall, but nothing happens.</span>")
		playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
	else
		toggle_open(user)
	return 0


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
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	//get the user's location
	if(!istype(user.loc, /turf))
		return	//can't do this stuff whilst inside objects and such

	if(W)
		radiate()
		if(is_hot(W))
			burn(is_hot(W))

	if(locate(/obj/effect/overlay/wallrot) in src)
		if(W.iswelder())
			var/obj/item/weldingtool/WT = W
			if(WT.remove_fuel(0,user))
				to_chat(user, "<span class='notice'>You burn away the fungi with \the [WT].</span>")
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, "<span class='notice'>\The [src] crumbles away under the force of your [W.name].</span>")
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if(W.iswelder() )
			var/obj/item/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/gun/energy/plasmacutter))
			thermitemelt(user)
			return

		else if( istype(W, /obj/item/melee/energy/blade) )
			var/obj/item/melee/energy/blade/EB = W

			spark(EB, 5)
			to_chat(user, "<span class='notice'>You slash \the [src] with \the [EB]; the thermite ignites!</span>")
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade.ogg', 50, 1)

			thermitemelt(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	if(damage && W.iswelder())

		var/obj/item/weldingtool/WT = W

		if(!WT.isOn())
			return

		if(WT.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5)) && WT && WT.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
				take_damage(-damage)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
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
				to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
				return
			dismantle_verb = "cutting"
			dismantle_sound = 'sound/items/Welder.ogg'
			cut_delay *= 0.7
		else if(istype(W,/obj/item/melee/energy))
			var/obj/item/melee/energy/WT = W
			if(WT.active)
				dismantle_sound = "sparks"
				dismantle_verb = "slicing"
				cut_delay *= 0.5
			else
				to_chat(user, "<span class='notice'>You need to activate the weapon to do that!</span>")
				return
		else if(istype(W,/obj/item/melee/energy/blade))
			dismantle_sound = "sparks"
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else if(istype(W,/obj/item/melee/chainsword))
			var/obj/item/melee/chainsword/WT = W
			if(WT.active)
				dismantle_sound = "sound/weapons/chainsawhit.ogg"
				dismantle_verb = "slicing"
				cut_delay *= 0.8
			else
				to_chat(user, "<span class='notice'>You need to activate the weapon to do that!</span>")
				return
		else if(istype(W,/obj/item/pickaxe))
			var/obj/item/pickaxe/P = W
			dismantle_verb = P.drill_verb
			dismantle_sound = P.drill_sound
			cut_delay -= P.digspeed
		else if(istype(W,/obj/item/melee/arm_blade/))
			dismantle_sound = "pickaxe"
			dismantle_verb = "slicing and stabbing"
			cut_delay *= 1.5

		if(dismantle_verb)

			to_chat(user, "<span class='notice'>You begin [dismantle_verb] through the outer plating.</span>")
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay<0)
				cut_delay = 1

			if(!do_after(user,cut_delay/W.toolspeed))
				return


			//This prevents runtime errors if someone clicks the same wall more than once
			if (!istype(src, /turf/simulated/wall))
				return

			to_chat(user, "<span class='notice'>You remove the outer plating.</span>")
			dismantle_wall()
			user.visible_message("<span class='warning'>The wall was torn open by [user]!</span>")
			return

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)
				if (W.iswirecutter())
					playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
					construction_stage = 5
					to_chat(user, "<span class='notice'>You cut the outer grille.</span>")
					update_icon()
					return
			if(5)
				if (W.isscrewdriver())
					to_chat(user, "<span class='notice'>You begin removing the support lines.</span>")
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,60/W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 5)
						return
					construction_stage = 4
					update_icon()
					to_chat(user, "<span class='notice'>You remove the support lines.</span>")
					return
				else if( istype(W, /obj/item/stack/rods) )
					var/obj/item/stack/O = W
					if(O.get_amount()>0)
						O.use(1)
						construction_stage = 6
						update_icon()
						to_chat(user, "<span class='notice'>You replace the outer grille.</span>")
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
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
				else if (istype(W, /obj/item/gun/energy/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the metal cover.</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user, 60/W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 3
					update_icon()
					to_chat(user, "<span class='notice'>You press firmly on the cover, dislodging it.</span>")
					return
			if(3)
				if (W.iscrowbar())
					to_chat(user, "<span class='notice'>You struggle to pry off the cover.</span>")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(!do_after(user,100/W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 3)
						return
					construction_stage = 2
					update_icon()
					to_chat(user, "<span class='notice'>You pry off the cover.</span>")
					return
			if(2)
				if (W.iswrench())
					to_chat(user, "<span class='notice'>You start loosening the anchoring bolts which secure the support rods to their frame.</span>")
					playsound(src, W.usesound, 100, 1)
					if(!do_after(user,40/W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 2)
						return
					construction_stage = 1
					update_icon()
					to_chat(user, "<span class='notice'>You remove the bolts anchoring the support rods.</span>")
					return
			if(1)
				var/cut_cover
				if(W.iswelder())
					var/obj/item/weldingtool/WT = W
					if( WT.remove_fuel(0,user) )
						cut_cover=1
					else
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
				else if(istype(W, /obj/item/gun/energy/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the support rods.</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user,70/W.toolspeed) || !istype(src, /turf/simulated/wall) || construction_stage != 1)
						return
					construction_stage = 0
					update_icon()
					new /obj/item/stack/rods(src)
					to_chat(user, "<span class='notice'>The support rods drop out as you cut them loose from the frame.</span>")
					return
			if(0)
				if(W.iscrowbar())
					to_chat(user, "<span class='notice'>You struggle to pry off the outer sheath.</span>")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					sleep(100)
					if(!istype(src, /turf/simulated/wall) || !user || !W || !T )	return
					if(user.loc == T && user.get_active_hand() == W )
						to_chat(user, "<span class='notice'>You pry off the outer sheath.</span>")
						dismantle_wall()
					return

	if(istype(W, /obj/item/device/electronic_assembly/wallmount))
		var/obj/item/device/electronic_assembly/wallmount/IC = W
		IC.mount_assembly(src, user)
		return

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src)
		return

	else if(!istype(W,/obj/item/rfd/construction) && !istype(W, /obj/item/reagent_containers))
		//At this point we know that they probably wanna hit it.
		if(user.a_intent != I_HURT || !W.force)
			return attack_hand(user)

		var/damage_to_deal = W.force
		var/weaken = 0
		var/sound_to_play = 'sound/weapons/smash.ogg'
		if(material)
			weaken += material.integrity * 2
			sound_to_play = material.hitsound
		if(reinf_material)
			weaken += reinf_material.integrity * 2
		weaken /= 100 //For reference, plasteel's integrity is 600.
		visible_message("<span class='notice'>[user] retracts their [W] and starts winding up a strike...</span>")
		var/hit_delay = W.w_class * 10 //Heavier weapons take longer to swing, yeah?
		if(do_after(user, hit_delay))
			user.do_attack_animation(src)
			playsound(src, sound_to_play, 50)
			if(damage_to_deal > weaken && (damage_to_deal > MIN_DAMAGE_TO_HIT))
				//Plasteel walls take 24 & 15 minimum damage.
				//Steel walls take 3 & 15 minimum damage.
				damage_to_deal -= weaken
				visible_message("<span class='warning'>[user] strikes \the [src] with \the [W], [is_sharp(W) ? "slicing some of the plating" : "putting a heavy dent on it"]!</span>")
				take_damage(damage_to_deal)
			else
				visible_message("<span class='warning'>[user] strikes \the [src] with \the [W], but it bounces off!</span>")
