/obj/item/material/fishing_rod
	name = "crude fishing rod"
	desc = "A crude rod made for catching fish."
	desc_extended = "A tool usable on puddles to attempt to catch fish by swiping it over them.\
	Any food containing things like protein, sugar, or standard nutriment can be attached to the rod, allowing for faster fishing based on the amount.\
	You can examine the rod to check if it has bait attached, and examine it automatically if so.\
	\
	Ctrl clicking the rod will remove any attached bait from the rod."
	icon_state = "fishing_rod"
	item_state = "fishing_rod"
	force_divisor = 0.25
	throwforce = 7
	sharp = TRUE
	attack_verb = list("whipped", "battered", "slapped", "fished", "hooked")
	hitsound = 'sound/weapons/punchmiss1.ogg'
	applies_material_colour = TRUE
	default_material = "wood"

	var/obj/item/reagent_containers/food/snacks/Bait
	var/bait_type = /obj/item/reagent_containers/food/snacks

	var/cast = FALSE

/obj/item/material/fishing_rod/examine(mob/user)
	. = ..()
	if(Bait)
		. += "<span class='notice'>It has [Bait] hanging on its hook: </span>"
		. += Bait.examine(user)

/obj/item/material/fishing_rod/CtrlClick(mob/user)
	if((src.loc == user || Adjacent(user)) && Bait)
		Bait.forceMove(get_turf(user))
		to_chat(user, "<span class='notice'>You remove the bait from \the [src].</span>")
		Bait = null
	else
		..()

/obj/item/material/fishing_rod/Initialize()
	. = ..()
	update_icon()

/obj/item/material/fishing_rod/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, bait_type))
		if(Bait)
			Bait.forceMove(get_turf(user))
			to_chat(user, "<span class='notice'>You swap \the [Bait] with \the [I].</span>")
		Bait = I
		user.drop_from_inventory(Bait)
		Bait.forceMove(src)
		update_bait()
	return ..()

/obj/item/material/fishing_rod/update_icon()
	cut_overlays()
	..()

/obj/item/material/fishing_rod/proc/update_bait()
	if(istype(Bait, bait_type))
		var/foodvolume
		for(var/datum/reagents/re in Bait.reagents.reagent_data)
			if(Bait.reagents.has_reagent(/singleton/reagent/nutriment) || Bait.reagents.has_reagent(/singleton/reagent/nutriment/protein) || Bait.reagents.has_reagent(/singleton/reagent/nutriment/glucose) || Bait.reagents.has_reagent(/singleton/reagent/nutriment/fishbait))
				foodvolume += re.total_volume

		toolspeed = initial(toolspeed) * min(0.75, (0.5 / max(0.5, (foodvolume / Bait.reagents.maximum_volume))))

	else
		toolspeed = initial(toolspeed)

/obj/item/material/fishing_rod/proc/consume_bait()
	if(Bait)
		qdel(Bait)
		Bait = null
		return TRUE
	return FALSE

/obj/item/material/fishing_rod/attack(var/mob/M as mob, var/mob/user as mob, var/def_zone)
	if(cast)
		to_chat(user, "<span class='notice'>You cannot cast \the [src] when it is already in use!</span>")
		return FALSE
	update_bait()
	return ..()

/obj/item/material/fishing_rod/modern
	name = "fishing rod"
	desc = "A refined rod for catching fish."
	icon_state = "fishing_rod_modern"
	item_state = "fishing_rod"
	reach = 4
	default_material = "titanium"

	toolspeed = 0.75

/obj/item/material/fishing_rod/modern/cheap
	name = "cheap fishing rod"
	desc = "Mass produced, but somewhat reliable."
	default_material = "plastic"

	toolspeed = 0.9
