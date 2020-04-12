/* Staves */

/obj/item/gun/energy/staff
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself."
	icon = 'icons/obj/guns/staffofchange.dmi'
	icon_state = "staffofchange"
	item_state = "staffofchange"
	has_item_ratio = FALSE
	fire_sound = 'sound/magic/Staff_Change.ogg'
	flags = CONDUCT
	slot_flags = SLOT_BACK
	w_class = 4.0
	max_shots = 1
	projectile_type = /obj/item/projectile/change
	origin_tech = list(TECH_COMBAT = 7, TECH_MAGNET = 5, TECH_BLUESPACE = 7)
	self_recharge = 1
	recharge_time = 15
	charge_meter = 0
	pin = /obj/item/device/firing_pin/magic
	has_safety = FALSE

/obj/item/gun/energy/staff/emp_act(severity) // to prevent it from breaking.
	return

obj/item/gun/energy/staff/special_check(var/mob/living/user)
	if(HULK in user.mutations)
		to_chat(user, "<span class='danger'>In your rage you momentarily forget the operation of this stave!</span>")
		return 0
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/new_mob
			var/mob/living/carbon/human/H = user
			for(var/obj/item/W in H)
				if(istype(W, /obj/item/implant))
					qdel(W)
					continue
				H.drop_from_inventory(W)
			playsound(user, 'sound/weapons/emitter.ogg', 40, 1)
			var/obj/item/organ/external/LA = H.get_organ(BP_L_ARM)
			var/obj/item/organ/external/RA = H.get_organ(BP_R_ARM)
			var/obj/item/organ/external/LL = H.get_organ(BP_L_LEG)
			var/obj/item/organ/external/RL = H.get_organ(BP_R_LEG)
			LA.droplimb(0,DROPLIMB_BLUNT)
			RA.droplimb(0,DROPLIMB_BLUNT)
			LL.droplimb(0,DROPLIMB_BLUNT)
			RL.droplimb(0,DROPLIMB_BLUNT)
			playsound(user, 'sound/effects/splat.ogg', 50, 1)
			user.visible_message("<span class = 'danger'>With a sickening series of crunches, [user]'s body shrinks, and they begin to sprout feathers!</span>")
			user.visible_message("<b>[user]</b> screams!")
			new_mob = new /mob/living/simple_animal/parrot(H.loc)
			new_mob.universal_speak = 1
			new_mob.key = H.key
			new_mob.a_intent = "harm"
			qdel(H)
			sleep(20)
			new_mob.say("Poly wanna cracker!")
		return 0
	return 1

/obj/item/gun/energy/staff/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)

/obj/item/gun/energy/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	projectile_type = /obj/item/projectile/animate
	fire_sound = 'sound/magic/wand.ogg'
	max_shots = 10

obj/item/gun/energy/staff/animate/special_check(var/mob/living/user)
	if(HULK in user.mutations)
		to_chat(user, "<span class='danger'>In your rage you momentarily forget the operation of this stave!</span>")
		return 0
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LA = H.get_organ(BP_L_HAND)
			var/obj/item/organ/external/RA = H.get_organ(BP_R_HAND)
			var/active_hand = H.hand
			playsound(user, 'sound/effects/blobattack.ogg', 40, 1)
			user.visible_message("<span class = 'danger'> With a sickening crunch, [user]'s hand rips itself off, and begins crawling away!</span>")
			user.visible_message("<b>[user]</b> screams!")
			user.drop_item()
			if(active_hand)
				LA.droplimb(0,DROPLIMB_EDGE)
				new /mob/living/simple_animal/hostile/mimic/copy(LA.loc, LA)
				qdel(LA)
			else
				RA.droplimb(0,DROPLIMB_EDGE)
				new /mob/living/simple_animal/hostile/mimic/copy(RA.loc, RA)
				qdel(RA)
		return 0
	return 1

obj/item/gun/energy/staff/focus
	name = "mental focus"
	desc = "An artefact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/guns/mental_focus.dmi'
	icon_state = "focus"
	item_state = "focus"
	fire_sound = 'sound/magic/wand.ogg'
	slot_flags = SLOT_BACK
	projectile_type = /obj/item/projectile/forcebolt

obj/item/gun/energy/staff/focus/special_check(var/mob/living/user)
	if(HULK in user.mutations)
		to_chat(user, "<span class='danger'>In your rage you momentarily forget the operation of this stave!</span>")
		return 0
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LA = H.get_organ(BP_L_ARM)
			var/obj/item/organ/external/RA = H.get_organ(BP_R_ARM)
			var/active_hand = H.hand
			playsound(user, 'sound/magic/lightningbolt.ogg', 40, 1)
			to_chat(user, "<span class='warning'>Coruscating waves of energy wreathe around your arm...hot...so <b>hot</b>!</span>")
			user.show_message("<b>[user]</b> screams!",2)
			user.drop_item()
			if(active_hand)
				LA.droplimb(0,DROPLIMB_BURN)
			else
				RA.droplimb(0,DROPLIMB_BURN)
		return 0
	return 1


obj/item/gun/energy/staff/focus/attack_self(mob/living/user as mob)
	if(projectile_type == /obj/item/projectile/forcebolt)
		charge_cost = 400
		to_chat(user, "<span class='warning'>The [src.name] will now strike a small area.</span>")
		projectile_type = /obj/item/projectile/forcebolt/strong
	else
		charge_cost = 200
		to_chat(user, "<span class='warning'>The [src.name] will now strike only a single person.</span>")
		projectile_type = /obj/item/projectile/forcebolt


/obj/item/gun/energy/staff/chaos
	name = "staff of chaos"
	desc = "An artefact that spits bolts of chaotic energy, expect anything."
	icon = 'icons/obj/guns/staff_of_chaos.dmi'
	icon_state = "staffofchaos"
	item_state = "staffofchaos"
	fire_sound = 'sound/magic/Staff_Chaos.ogg'
	flags = CONDUCT
	w_class = 4.0
	max_shots = 5
	projectile_type = /obj/item/projectile/magic
	var/list/possible_projectiles = list(/obj/item/projectile/magic, /obj/item/projectile/change, /obj/item/projectile/forcebolt,
										/obj/item/gun/energy/staff/animate, /obj/item/projectile/magic/fireball, /obj/item/projectile/magic/teleport,
										/obj/item/projectile/temp, /obj/item/projectile/ion, /obj/item/projectile/energy/declone, /obj/item/projectile/meteor,
										/obj/item/projectile/beam/thermaldrill, /obj/item/projectile/beam/energy_net, /obj/item/projectile/energy/bee)

/obj/item/gun/energy/staff/chaos/special_check(var/mob/living/user)
	projectile_type = pick(possible_projectiles)
	if(HULK in user.mutations)
		to_chat(user, "<span class='danger'>In your rage you momentarily forget the operation of this stave!</span>")
		return 0
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			var/obj/P = consume_next_projectile()
			if(P)
				if(process_projectile(P, user, user, pick(BP_HEAD, BP_CHEST)))
					handle_post_fire(user, user)
					user.visible_message("<span class='danger'>\The [src] backfires!</span>")
					user.drop_item()
		return 0
	return 1

//wands

/obj/item/gun/energy/wand
	name = "wand of nothing"
	desc = "A magic stick, this one don't do much however."
	icon = 'icons/obj/wands.dmi'
	icon_state = "nothingwand"
	item_state = "wand"
	has_item_ratio = FALSE
	fire_sound = 'sound/magic/wand.ogg'
	slot_flags = SLOT_BELT
	w_class = 3
	max_shots = 20
	projectile_type = /obj/item/projectile/magic
	origin_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5, TECH_BLUESPACE = 6)
	charge_meter = 0
	pin = /obj/item/device/firing_pin/magic
	charge_failure_message = null
	has_safety = FALSE

/obj/item/gun/energy/wand/get_cell()
	return DEVICE_NO_CELL

/obj/item/gun/energy/wand/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)

/obj/item/gun/energy/wand/special_check(var/mob/living/user)
	if(HULK in user.mutations)
		to_chat(user, "<span class='danger'>In your rage you momentarily forget the operation of this wand!</span>")
		return 0
	return 1

/obj/item/gun/energy/wand/toy
	origin_tech = null

/obj/item/gun/energy/wand/fire
	name = "wand of fire"
	desc = "A wand that can fire destructive flames."
	icon = 'icons/obj/wands.dmi'
	icon_state = "firewand"
	item_state = "firewand"
	fire_sound = 'sound/magic/Fireball.ogg'
	max_shots = 5
	projectile_type = /obj/item/projectile/magic/fireball

/obj/item/gun/energy/wand/fire/special_check(var/mob/living/user)
	if(HULK in user.mutations)
		to_chat(user, "<span class='danger'>In your rage you momentarily forget the operation of this wand!</span>")
		return 0
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			H.IgniteMob(15)
			H.visible_message("<span class='danger'>\The [src] explodes in a shower of fire!</span>")
			H.drop_item()
			qdel(src)
		return 0
	return 1


/obj/item/gun/energy/wand/polymorph
	name = "wand of polymorph"
	desc = "A wand that will change the shape of the its victims."
	icon = 'icons/obj/wands.dmi'
	icon_state = "polywand"
	item_state = "polywand"
	fire_sound = 'sound/magic/Staff_Change.ogg'
	max_shots = 10
	projectile_type = /obj/item/projectile/change

/obj/item/gun/energy/wand/polymorph/special_check(var/mob/living/user)
	if(HULK in user.mutations)
		to_chat(user, "<span class='danger'>In your rage you momentarily forget the operation of this wand!</span>")
		return 0
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			H.drop_item()
			H.visible_message("<span class='danger'>\The [H] collapses on the floor, their body shrinking and growing hair!</span>")
			H.monkeyize()
			H.equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/grown/banana(H), slot_l_hand)
			qdel(src)
		return 0
	return 1

/obj/item/gun/energy/wand/teleport
	name = "wand of teleportation"
	desc = "This wand will send your targets away, or closer, to yourself."
	icon = 'icons/obj/wands.dmi'
	icon_state = "telewand"
	item_state = "telewand"
	fire_sound = 'sound/magic/Wand_Teleport.ogg'
	max_shots = 10
	projectile_type = /obj/item/projectile/magic/teleport

/obj/item/gun/energy/wand/teleport/special_check(var/mob/living/user) //todo: think of something else for this
	if(HULK in user.mutations)
		to_chat(user, "<span class='danger'>In your rage you momentarily forget the operation of this wand!</span>")
		return 0
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/O = H.internal_organs_by_name[pick(H.species.vision_organ || BP_EYES,"appendix",BP_KIDNEYS,BP_LIVER, BP_HEART, BP_LUNGS, BP_BRAIN)]
			if(O == null)
				to_chat(user, "<span class='notice'>You can't make any sense of the arcane glyphs... maybe you should try again.</span>")
			else
				to_chat(user, "<span class='danger'>As you stumble over the arcane glyphs, you feel a twisting sensation in your [O.name]!</span>")
				user.visible_message("<span class='danger'>\A flash of smoke pours out of [user]'s orifices!</span>")
				playsound(user, 'sound/magic/lightningshock.ogg', 40, 1)
				var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
				smoke.set_up(5, 0, user.loc)
				smoke.attach(user)
				smoke.start()
				user.emote("scream")
				user.drop_item()
				if(istype(O))
					O.removed(user)
			qdel(src)
		return 0
	return 1

/obj/item/gun/energy/wand/force
	name = "wand of force"
	desc = "A more portable version of the mental focus, still deadly."
	icon = 'icons/obj/wands.dmi'
	icon_state = "deathwand"
	item_state = "deathwand"
	max_shots = 10
	projectile_type = /obj/item/projectile/forcebolt

/obj/item/gun/energy/wand/force/special_check(var/mob/living/user)
	if(HULK in user.mutations)
		to_chat(user, "<span class='danger'>In your rage you momentarily forget the operation of this wand!</span>")
		return 0
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			H.visible_message("<span class='danger'>\The [src] escapes from [H]'s hand, hitting their face and shattering into pieces!</span>")
			H.apply_damage(35, BRUTE, BP_HEAD, 0, sharp=0, edge=0)
			H.adjustBrainLoss(50, 55)
			H.sdisabilities += CLUMSY
			H.drop_item()
			qdel(src)
		return 0
	return 1

/obj/item/gun/energy/wand/animation
	name = "wand of animation"
	desc = "This wand will create a legion of murderous toilets, for your own leisure."
	icon = 'icons/obj/wands.dmi'
	icon_state = "revivewand"
	item_state = "revivewand"
	max_shots = 10
	projectile_type = /obj/item/projectile/animate

/obj/item/gun/energy/wand/animation/special_check(var/mob/living/user)
	if(HULK in user.mutations)
		to_chat(user, "<span class='danger'>In your rage you momentarily forget the operation of this wand!</span>")
		return 0
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			H.visible_message("<span class='danger'>\The [src] jumps from [H]'s hand and swifts into a crate!</span>")
			new /mob/living/simple_animal/hostile/mimic(H.loc)
			H.drop_item()
			qdel(src)
		return 0
	return 1
