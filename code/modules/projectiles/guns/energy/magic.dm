/* Staves */

/obj/item/weapon/gun/energy/staff
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	icon = 'icons/obj/gun.dmi'
	item_icons = null
	icon_state = "staffofchange"
	item_state = "staffofchange"
	fire_sound = 'sound/magic/Staff_Change.ogg'
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	w_class = 4.0
	max_shots = 5
	projectile_type = /obj/item/projectile/change
	origin_tech = null
	self_recharge = 1
	charge_meter = 0

obj/item/weapon/gun/energy/staff/special_check(var/mob/user)
	if(HULK in user.mutations)
		user << "<span class='danger'>In your rage you momentarily forget the operation of this stave!</span>"
		return 0
	if(!(user.faction == "Space Wizard"))
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/new_mob
			var/mob/living/carbon/human/H = user
			for(var/obj/item/W in H)
				if(istype(W, /obj/item/weapon/implant))
					qdel(W)
					continue
				H.drop_from_inventory(W)
			playsound(user, 'sound/weapons/emitter.ogg', 40, 1)
			var/obj/item/organ/external/LA = H.get_organ("l_arm")
			var/obj/item/organ/external/RA = H.get_organ("r_arm")
			var/obj/item/organ/external/LL = H.get_organ("l_leg")
			var/obj/item/organ/external/RL = H.get_organ("r_leg")
			LA.droplimb(0,DROPLIMB_BLUNT)
			RA.droplimb(0,DROPLIMB_BLUNT)
			LL.droplimb(0,DROPLIMB_BLUNT)
			RL.droplimb(0,DROPLIMB_BLUNT)
			playsound(user, 'sound/effects/splat.ogg', 50, 1)
			user.visible_message("<span class = 'danger'> With a sickening series of crunches, [user]'s body shrinks, and they begin to sprout feathers!</span>")
			user.visible_message("<b>[user]</b> screams!",2)
			new_mob = new /mob/living/simple_animal/parrot(H.loc)
			new_mob.universal_speak = 1
			new_mob.key = H.key
			new_mob.a_intent = "harm"
			qdel(H)
			sleep(20)
			new_mob.say("Poly wanna cracker!")
		return 0
	return 1

/obj/item/weapon/gun/energy/staff/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)

/obj/item/weapon/gun/energy/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	projectile_type = /obj/item/projectile/animate
	fire_sound = 'sound/magic/wand.ogg'
	max_shots = 10

obj/item/weapon/gun/energy/staff/animate/special_check(var/mob/user)
	if(HULK in user.mutations)
		user << "<span class='danger'>In your rage you momentarily forget the operation of this stave!</span>"
		return 0
	if(!(user.faction == "Space Wizard"))
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LA = H.get_organ("l_hand")
			var/obj/item/organ/external/RA = H.get_organ("r_hand")
			var/active_hand = H.hand
			playsound(user, 'sound/effects/blobattack.ogg', 40, 1)
			user.visible_message("<span class = 'danger'> With a sickening crunch, [user]'s hand rips itself off, and begins crawling away!</span>")
			user.visible_message("<b>[user]</b> screams!",2)
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

obj/item/weapon/gun/energy/staff/focus
	name = "mental focus"
	desc = "An artefact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "focus"
	item_state = "focus"
	fire_sound = 'sound/magic/wand.ogg'
	slot_flags = SLOT_BACK
	projectile_type = /obj/item/projectile/forcebolt

obj/item/weapon/gun/energy/staff/focus/special_check(var/mob/user)
	if(HULK in user.mutations)
		user << "<span class='danger'>In your rage you momentarily forget the operation of this stave!</span>"
		return 0
	if(!(user.faction == "Space Wizard"))
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LA = H.get_organ("l_arm")
			var/obj/item/organ/external/RA = H.get_organ("r_arm")
			var/active_hand = H.hand
			playsound(user, 'sound/magic/lightningbolt.ogg', 40, 1)
			user << "\red Coruscating waves of energy wreathe around your arm...hot...so <b>hot</b>!"
			user.show_message("<b>[user]</b> screams!",2)
			user.drop_item()
			if(active_hand)
				LA.droplimb(0,DROPLIMB_BURN)
			else
				RA.droplimb(0,DROPLIMB_BURN)
		return 0
	return 1


obj/item/weapon/gun/energy/staff/focus/attack_self(mob/living/user as mob)
	if(projectile_type == /obj/item/projectile/forcebolt)
		charge_cost = 400
		user << "<span class='warning'>The [src.name] will now strike a small area.</span>"
		projectile_type = /obj/item/projectile/forcebolt/strong
	else
		charge_cost = 200
		user << "<span class='warning'>The [src.name] will now strike only a single person.</span>"
		projectile_type = /obj/item/projectile/forcebolt


/obj/item/weapon/gun/energy/staff/chaos
	name = "staff of chaos"
	desc = "An artefact that spits bolts of chaotic energy, expect anything."
	icon = 'icons/obj/wands.dmi'
	icon_state = "staffofchaos"
	item_state = "staffofchaos"
	contained_sprite = 1
	fire_sound = 'sound/magic/Staff_Chaos.ogg'
	flags =  CONDUCT
	w_class = 4.0
	max_shots = 5
	projectile_type = /obj/item/projectile/magic
	var/list/possible_projectiles = list(/obj/item/projectile/magic, /obj/item/projectile/change, /obj/item/projectile/forcebolt,
										/obj/item/weapon/gun/energy/staff/animate, /obj/item/projectile/magic/fireball, /obj/item/projectile/magic/teleport,
										/obj/item/projectile/temp, /obj/item/projectile/ion, /obj/item/projectile/energy/declone, /obj/item/projectile/meteor)

/obj/item/weapon/gun/energy/staff/chaos/special_check(var/mob/user)
	projectile_type = pick(possible_projectiles)
	if(HULK in user.mutations)
		user << "<span class='danger'>In your rage you momentarily forget the operation of this stave!</span>"
		return 0
	if(!(user.faction == "Space Wizard"))
		if(istype(user, /mob/living/carbon/human))
			var/obj/P = consume_next_projectile()
			if(P)
				if(process_projectile(P, user, user, pick("head", "chest")))
					handle_post_fire(user, user)
					user.visible_message("<span class='danger'>\The [src] backfires!</span>")
					user.drop_item()
		return 0
	return 1

//wands

/obj/item/weapon/gun/energy/wand
	name = "wand of nothing"
	desc = "A magic stick, this one don't do much however."
	icon = 'icons/obj/wands.dmi'
	item_icons = null
	icon_state = "nothingwand"
	item_state = "wand"
	contained_sprite = 1
	fire_sound = 'sound/magic/wand.ogg'
	slot_flags = SLOT_BELT
	w_class = 3
	max_shots = 20
	projectile_type = /obj/item/projectile/magic
	origin_tech = null
	charge_meter = 0

/obj/item/weapon/gun/energy/wand/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)

/obj/item/weapon/gun/energy/wand/fire
	name = "wand of fire"
	desc = "A wand that can fire destructive flames."
	icon_state = "firewand"
	item_state = "firewand"
	fire_sound = 'sound/magic/Fireball.ogg'
	max_shots = 5
	projectile_type = /obj/item/projectile/magic/fireball

/obj/item/weapon/gun/energy/wand/polymorph
	name = "wand of polymorph"
	desc = "A wand that will change the shape of the its victims."
	icon_state = "polywand"
	item_state = "polywand"
	fire_sound = 'sound/magic/Staff_Change.ogg'
	max_shots = 10
	projectile_type = /obj/item/projectile/change

/obj/item/weapon/gun/energy/wand/teleport
	name = "wand of teleportation"
	desc = "This wand will send your targets away, or closer, to yourself."
	icon_state = "telewand"
	item_state = "telewand"
	fire_sound = 'sound/magic/Wand_Teleport.ogg'
	max_shots = 10
	projectile_type = /obj/item/projectile/magic/teleport

/obj/item/weapon/gun/energy/wand/force
	name = "wand of force"
	desc = "A more portable version of the mental focus, still deadly."
	icon_state = "deathwand"
	item_state = "deathwand"
	max_shots = 10
	projectile_type = /obj/item/projectile/forcebolt

/obj/item/weapon/gun/energy/wand/animation
	name = "wand of animation"
	desc = "This wand will create a legion of murderous toilets, for your own leisure."
	icon_state = "revivewand"
	item_state = "revivewand"
	max_shots = 10
	projectile_type = /obj/item/projectile/animate