//Various Soaps

/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/soap.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_janitor.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "soap"
	item_state = "soap"
	w_class = ITEMSIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	flags = OPENCONTAINER
	var/key_data
	var/clean_msg
	var/last_clean
	var/capacity = 10
	drop_sound = 'sound/misc/slip.ogg'

/obj/item/soap/New()
	..()
	create_reagents(capacity)
	wet()

/obj/item/soap/proc/wet()
	playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
	reagents.add_reagent(/decl/reagent/spacecleaner, capacity)

/obj/item/soap/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/key))
		if(!key_data)
			to_chat(user, SPAN_NOTICE("You imprint \the [I] into \the [src]."))
			var/obj/item/key/K = I
			key_data = K.key_data
			update_icon()
		return TRUE
	return ..()

/obj/item/soap/update_icon()
	overlays.Cut()
	if(key_data)
		overlays += image('icons/obj/items.dmi', icon_state = "soap_key_overlay")

/obj/item/soap/Crossed(AM as mob|obj)
	if(isliving(AM))
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(H.shoes?.item_flags & LIGHTSTEP)
				return
		var/mob/living/M =	AM
		M.slip("the [src.name]",3)

/obj/item/soap/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, SPAN_NOTICE("You need to take that [target.name] off before cleaning it."))
	else if(istype(target,/obj/structure/sink) || istype(target,/obj/structure/sink))
		to_chat(user, SPAN_NOTICE("You wet \the [src] in the sink."))
		wet()
	else if (istype(target, /obj/structure/mopbucket) || istype(target, /obj/item/reagent_containers/glass) || istype(target, /obj/structure/reagent_dispensers/watertank))
		if (target.reagents && target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("You wet \the [src] in the [target]."))
			wet()
		else
			to_chat(user, "\The [target] is empty!")
	else
		if (!(last_clean && world.time < last_clean + 120))
			to_chat(user, "You start scrubbing the [target.name]")
			clean_msg = TRUE
			last_clean = world.time
		else
			clean_msg = FALSE
		playsound(loc, 'sound/effects/mop.ogg', 25, 1)
		if (do_after(user, 25, needhand = 0))
			target.clean_blood()
			if(clean_msg)
				to_chat(user, SPAN_NOTICE("You scrub \the [target.name] out."))
			if(istype(target, /turf) || istype(target, /obj/effect/decal/cleanable) || istype(target, /obj/effect/overlay))
				var/turf/T = get_turf(target)
				if(T)
					T.clean(src, user)
	return

//attack_as_weapon
/obj/item/soap/attack(mob/living/target, mob/living/user, var/target_zone)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_sel &&user.zone_sel.selecting == BP_MOUTH )
		user.visible_message(SPAN_DANGER("\The [user] washes \the [target]'s mouth out with soap!"))
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //prevent spam
		return
	..()

/obj/item/soap/nanotrasen
	desc = "A NanoTrasen-brand bar of soap. Smells of acai berries and white chocolate."
	icon_state = "soapnt"
	item_state = "soapnt"

/obj/item/soap/plant
	desc = "A green bar of soap. Smells like dirt and plants."

/obj/item/soap/deluxe
	icon_state = "soapdeluxe"
	item_state = "soapdeluxe"

/obj/item/soap/deluxe/Initialize()

	. = ..()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."

/obj/item/soap/syndie
	desc = "A lackluster bar of soap. It smells like cranberries."
	icon_state = "soapsyndie"
	item_state = "soapsyndie"
	capacity = 20

/obj/item/soap/space_soap
	desc = "Smells like cedarwood and almonds."
	icon_state = "space_soap"

/obj/item/soap/water_soap
	desc = "Smells like rain water and vanilla."
	icon_state = "water_soap"

/obj/item/soap/fire_soap
	desc = "Smells like charcoal and chestnuts."
	icon_state = "fire_soap"

/obj/item/soap/rainbow_soap
	desc = "Smells like carnations and honey."
	icon_state = "rainbow_soap"

/obj/item/soap/diamond_soap
	desc = "Smells like saffron and vanilla."
	icon_state = "diamond_soap"

/obj/item/soap/uranium_soap
	desc = "Smells like lime."
	icon_state = "uranium_soap"

/obj/item/soap/silver_soap
	desc = "Smells like birch and amaranth."
	icon_state = "silver_soap"

/obj/item/soap/brown_soap
	desc = "Smells like cinnamon and cognac."
	icon_state = "brown_soap"

/obj/item/soap/white_soap
	desc = "Smells like nutmeg and oats."
	icon_state = "white_soap"

/obj/item/soap/grey_soap
	desc = "Smells like bergamot and lilies."
	icon_state = "grey_soap"

/obj/item/soap/pink_soap
	desc = "Smells like cherry blossoms."
	icon_state = "pink_soap"

/obj/item/soap/purple_soap
	desc = "Smells like lavender."
	icon_state = "purple_soap"

/obj/item/soap/blue_soap
	desc = "Smells like cardamom."
	icon_state = "blue_soap"

/obj/item/soap/cyan_soap
	desc = "Smells like bluebells and peaches."
	icon_state = "cyan_soap"

/obj/item/soap/green_soap
	desc = "Smells like rosemary and thyme."
	icon_state = "green_soap"

/obj/item/soap/yellow_soap
	desc = "Smells like citron and ginger."
	icon_state = "yellow_soap"

/obj/item/soap/orange_soap
	desc = "Smells like oranges and dark chocolate."
	icon_state = "orange_soap"

/obj/item/soap/red_soap
	desc = "Smells like roses and oats."
	icon_state = "red_soap"

/obj/item/soap/golden_soap
	desc = "Smells like agave nectar."
	icon_state = "golden_soap"

/obj/random/soap/
	name = "Random Soap"
	desc = "This is a random soap."
	icon = 'icons/obj/soap.dmi'
	icon_state = "soap"

/obj/random/soap/item_to_spawn()
		return pick(/obj/item/soap, \
					/obj/item/soap/nanotrasen, \
					/obj/item/soap/deluxe,\
					/obj/item/soap/space_soap,\
					/obj/item/soap/space_soap,\
					/obj/item/soap/water_soap,\
					/obj/item/soap/fire_soap,\
					/obj/item/soap/rainbow_soap,\
					/obj/item/soap/diamond_soap,\
					/obj/item/soap/uranium_soap,\
					/obj/item/soap/silver_soap,\
					/obj/item/soap/brown_soap,\
					/obj/item/soap/white_soap,\
					/obj/item/soap/grey_soap,\
					/obj/item/soap/pink_soap,\
					/obj/item/soap/purple_soap,\
					/obj/item/soap/blue_soap,\
					/obj/item/soap/cyan_soap,\
					/obj/item/soap/green_soap,\
					/obj/item/soap/yellow_soap,\
					/obj/item/soap/orange_soap,\
					/obj/item/soap/red_soap,\
					/obj/item/soap/golden_soap,\
)
