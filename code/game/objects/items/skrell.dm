/obj/item/stellascope
	name = "stellascope"
	desc = "An antique and delicate looking instrument used to study the stars."
	icon = 'icons/obj/skrell_items.dmi'
	icon_state = "starscope"
	w_class = 1
	matter = list("glass" = 200)
	drop_sound = 'sound/items/drop/glass.ogg'
	var/list/constellations = list("Island", "Hatching Egg", "Star Chanter", "Jiu'x'klua", "Stormcloud", "Gnarled Tree", "Poet", "Bloated Toad", "Qu'Poxiii", "Fisher")
	var/selected_constellation

/obj/item/stellascope/Initialize()
	. = ..()
	pick_constellation()

/obj/item/stellascope/examine(mob/user)
	..(user)
	to_chat(user, "\The [src] display the \"[selected_constellation]\".")

/obj/item/stellascope/throw_impact(atom/hit_atom)
	..()
	visible_message("<span class='notice'>\The [src] lands on \the [pick_constellation()].</span>")

/obj/item/stellascope/attack_self(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isskrell(H))
			H.visible_message("<span class='notice'>\The [H] holds the brassy instrument up to \his eye and peers at something unseen.</span>",
							"<span class='notice'>You see the starry edgy of srom floating on the void of space.</span>")

/obj/item/stellascope/proc/pick_constellation()
	var/chosen_constellation = pick(constellations)
	selected_constellation = chosen_constellation
	return chosen_constellation