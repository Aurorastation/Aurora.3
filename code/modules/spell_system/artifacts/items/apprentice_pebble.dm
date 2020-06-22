/obj/item/apprentice_pebble
	name = "apprentice pebble"
	desc = "A pebble, it feels warm to the touch."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "pebble"
	origin_tech = list(TECH_BLUESPACE = 6, TECH_MATERIAL = 6, TECH_BIO = 6)
	w_class = ITEMSIZE_SMALL
	var/obj/item/contract/apprentice/contract

/obj/item/apprentice_pebble/Initialize()
	. = ..()
	contract = new /obj/item/contract/apprentice(src)
	SSghostroles.add_spawn_atom("apprentice", src)
	var/area/A = get_area(src)
	if(A)
		say_dead_direct("A wizard apprentice pebble has been created in [A.name]! Spawn at it by using the ghost spawner menu in the ghost tab.")
	
/obj/item/apprentice_pebble/Destroy()
	if(contract)
		QDEL_NULL(contract)
	SSghostroles.remove_spawn_atom("apprentice", src)
	return ..()

/obj/item/apprentice_pebble/proc/spawn_apprentice(var/mob/user)
	var/mob/living/carbon/human/G = new /mob/living/carbon/human(get_turf(src))
	G.ckey = user.ckey
	G.real_name = "[pick(wizard_first)] [pick(wizard_second)]"
	G.name = G.real_name

	G.preEquipOutfit(/datum/outfit/admin/wizard/apprentice, FALSE)
	G.equipOutfit(/datum/outfit/admin/wizard/apprentice, FALSE)

	G.put_in_hands(contract)
	contract = null

	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.set_up(5, 0, get_turf(src))
	smoke.start()

	qdel(src)

/obj/item/apprentice_pebble/pickup(mob/living/user)
	..()
	if(!user.is_wizard())
		to_chat(user, SPAN_WARNING("As you pick up \the [src], you feel a wave of power wash over you."))
		for(var/obj/machinery/light/P in view(7, user))
			P.flicker(1)