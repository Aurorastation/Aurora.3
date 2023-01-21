/obj/item/melee/cultblade
	name = "eldritch blade"
	desc = "A sword humming with unholy energy. It glows with a dim red light and looks deadly sharp."
	desc_antag = "This sword is a powerful weapon, capable of severing limbs easily, if they are targeted.  Non-believers are unable to use this weapon."
	icon = 'icons/obj/sword.dmi'
	icon_state = "cultblade"
	item_state = "cultblade"
	contained_sprite = TRUE
	force = 25
	armor_penetration = 50 // Narsie's blessing is strong. Also needed so the cult isn't obliterated by the average voidsuit with melee resistance.
	w_class = ITEMSIZE_LARGE
	throwforce = 10
	slot_flags = SLOT_BELT
	edge = TRUE
	sharp = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /singleton/sound_category/sword_pickup_sound
	equip_sound = /singleton/sound_category/sword_equip_sound
	var/does_cult_check = TRUE

	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	can_embed = FALSE //can't get stuck anymore, because blood magic

/obj/item/melee/cultblade/cultify()
	return

/obj/item/melee/cultblade/attack(mob/living/M, mob/living/user, var/target_zone)
	if(iscultist(user) || !does_cult_check)
		return ..()

	var/zone = (user.hand ? BP_L_ARM:BP_R_ARM)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		to_chat(user, SPAN_CULT("An unexplicable force rips through your [affecting.name], tearing the sword from your grasp!"))
	else
		to_chat(user, SPAN_CULT("An unexplicable force rips through you, tearing the sword from your grasp!"))

	//random amount of damage between half of the blade's force and the full force of the blade.
	user.apply_damage(rand(force/2, force), BRUTE, zone, 0, damage_flags = DAM_SHARP|DAM_EDGE)
	user.Weaken(5)

	user.drop_from_inventory(src)
	throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1,3), throw_speed)

	var/spooky = pick('sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg', 'sound/hallucinations/wail.ogg')
	playsound(loc, spooky, 50, 1)

	return TRUE

/obj/item/melee/cultblade/pickup(mob/living/user)
	..()
	if(!iscultist(user))
		to_chat(user, SPAN_CULT("An overwhelming feeling of dread comes over you as you pick up \the [src]. It would be wise to be rid of this blade quickly."))
		user.make_dizzy(120)

/obj/item/melee/cultblade/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/nullrod))
		to_chat(user, SPAN_NOTICE("You cleanse \the [src] of taint, restoring the blade to its original state."))
		var/obj/item/material/sword/blade = new(get_turf(src))
		blade.force = 15
		qdel(src)
		return TRUE

/obj/item/melee/cultblade/mounted
	name = "daemon doomblade"
	force = 40
	does_cult_check = FALSE
