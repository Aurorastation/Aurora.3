/*

Miscellaneous traitor devices

BATTERER


*/

/*

The Batterer, like a flashbang but 50% chance to knock people over. Can be either very
effective or pretty fucking useless.

*/

/obj/item/device/batterer
	name = "mind batterer"
	desc = "A strange device with twin antennas."
	icon = 'icons/obj/item/device/batterer.dmi'
	icon_state = "batterer"
	item_state = "electronic"
	throwforce = 5
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 4
	throw_range = 10
	obj_flags = OBJ_FLAG_CONDUCTABLE
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 3, TECH_ILLEGAL = 3)

	var/times_used = 0 //Number of times it's been used.
	var/max_uses = 2

/obj/item/device/batterer/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if(!user) 	return
	if(times_used >= max_uses)
		to_chat(user, SPAN_WARNING("The mind batterer has been burnt out!"))
		return

	user.attack_log += "\[[time_stamp()]\] <span class='warning'>Used [src] to knock down people in the area.</span>"

	for(var/mob/living/carbon/human/M in orange(10, user))
		if(prob(50))
			M.Weaken(rand(10,20))
			if(prob(25))
				M.Stun(rand(5,10))
			to_chat(M, SPAN_DANGER("You feel a tremendous, paralyzing wave flood your mind."))
		else
			to_chat(M, SPAN_DANGER("You feel a sudden, electric jolt travel through your head."))

	playsound(src.loc, 'sound/misc/interference.ogg', 50, 1)
	to_chat(user, SPAN_NOTICE("You trigger [src]."))
	times_used += 1
	if(times_used >= max_uses)
		icon_state = "battererburnt"

/obj/item/device/liidrafier //adminspawn/event injector, designed to easily make someone a lii'dra zombie/actual lii'dra
	name = "Lii'drafication Injector"
	desc = "Use this single-use injector on a Vaurca to grant them access to the Lii'dra Hivenet. Use it on an organic non-Vaurca to infect them with black k'ois. This is an OOC item, do not let anyone see it!"
	icon = 'icons/obj/guns/decloner.dmi'
	icon_state = "decloner"
	item_state = "decloner"

/obj/item/device/liidrafier/attack(mob/living/target_mob, mob/living/user, target_zone)
	return

/obj/item/device/liidrafier/afterattack(atom/A as mob, mob/user as mob)
	var/mob/living/carbon/human/target = A
	if(!istype(target))
		to_chat(user, SPAN_NOTICE("[target] is not a valid target!"))
		return
	if((GLOB.all_languages[LANGUAGE_LIIDRA] in target.languages) || target.internal_organs_by_name["blackkois"])
		to_chat(user, SPAN_NOTICE("[target] is already part of the Lii'dra Hivemind!"))
		return
	if(isvaurca(target))
		to_chat(user, SPAN_NOTICE("You connect [target] to the Lii'dra Hivemind!"))
		to_chat(target, SPAN_NOTICE("You have been connected to the Lii'dra Hivemind!"))
		target.add_language(LANGUAGE_LIIDRA)
		qdel(src)
	else if(!target.isSynthetic())
		to_chat(user, SPAN_NOTICE("You infest [target] with black k'ois!"))
		to_chat(target, SPAN_NOTICE("You have been infested with black k'ois!"))
		var/obj/item/organ/external/affected = target.get_organ(BP_HEAD)
		var/obj/item/organ/internal/parasite/blackkois/infest = new()
		infest.replaced(target, affected)
		qdel(src)
	else
		to_chat(user, SPAN_NOTICE("[target] is not a valid target!"))

