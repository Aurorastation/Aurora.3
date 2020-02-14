/obj/item/melee/cultblade
	name = "eldritch blade"
	desc = "A sword humming with unholy energy. It glows with a dim red light."
	icon_state = "cultblade"
	item_state = "cultblade"
	icon = 'icons/obj/weapons.dmi'
	w_class = 4
	force = 30
	throwforce = 10
	slot_flags = SLOT_BELT
	edge = TRUE
	sharp = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'

	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	can_embed = FALSE //can't get stuck anymore, because blood magic

/obj/item/melee/cultblade/cultify()
	return

/obj/item/melee/cultblade/attack(mob/living/M, mob/living/user, var/target_zone)
	if(iscultist(user))
		return ..()

	var/zone = (user.hand ? BP_L_ARM:BP_R_ARM)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		to_chat(user, span("cult", "An unexplicable force rips through your [affecting.name], tearing the sword from your grasp!"))
	else
		to_chat(user, span("cult", "An unexplicable force rips through you, tearing the sword from your grasp!"))

	//random amount of damage between half of the blade's force and the full force of the blade.
	user.apply_damage(rand(force/2, force), BRUTE, zone, 0, sharp=1, edge=1)
	user.Weaken(5)

	user.drop_from_inventory(src)
	throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1,3), throw_speed)

	var/spooky = pick('sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg', 'sound/hallucinations/wail.ogg')
	playsound(loc, spooky, 50, 1)

	return TRUE

/obj/item/melee/cultblade/pickup(mob/living/user)
	..()
	if(!iscultist(user))
		to_chat(user, span("cult", "An overwhelming feeling of dread comes over you as you pick up \the [src]. It would be wise to be rid of this blade quickly."))
		user.make_dizzy(120)

/obj/item/melee/cultblade/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/nullrod))
		to_chat(user, span("notice", "You cleanse \the [src] of taint, restoring the blade to its original state."))
		var/obj/item/material/sword/blade = new(get_turf(src))
		blade.force = 15
		qdel(src)