/obj/item/ladder_mobile
	name = "mobile ladder"
	desc = "A lightweight deployable ladder, which you can use to move up or down. Or alternatively, you can bash some faces in."
	icon_state = "mobile_ladder"
	item_state = "mobile_ladder"
	icon = 'icons/obj/multiz_items.dmi'
	contained_sprite = TRUE
	throw_range = 3
	force = 10
	w_class = 4.0
	slot_flags = SLOT_BACK

/obj/item/ladder_mobile/proc/place_ladder(atom/A, mob/user)

	if (isopenturf(A))         //Place into open space
		var/turf/below_loc = GetBelow(A)
		if (!below_loc || (istype(/turf/space, below_loc)))
			to_chat(user, "<span class='notice'>Why would you do that?! There is only infinite space there...</span>")
			return
		user.visible_message("<span class='warning'>[user] begins to lower \the [src] into \the [A].</span>",
			"<span class='warning'>You begin to lower \the [src] into \the [A].</span>")
		if (!handle_action(A, user))
			return
		// Create the lower ladder first. ladder/Initialize() will make the upper
		// ladder create the appropriate links. So the lower ladder must exist first.
		var/obj/structure/ladder/mobile/downer = new(below_loc)
		downer.allowed_directions = UP

		new /obj/structure/ladder/mobile(A)

		user.drop_from_inventory(src,get_turf(src))
		qdel(src)

	else if (istype(A, /turf/simulated/floor) || istype(A, /turf/unsimulated/floor))	//Place onto Floor
		var/turf/upper_loc = GetAbove(A)
		if (!upper_loc || !isopenturf(upper_loc))
			to_chat(user, "<span class='notice'>There is something above. You can't deploy!</span>")
			return
		user.visible_message("<span class='warning'>[user] begins deploying \the [src] on \the [A].</span>",
			"<span class='warning'>You begin to deploy \the [src] on \the [A].</span>")
		if (!handle_action(A, user))
			return
		// Ditto here. Create the lower ladder first.
		var/obj/structure/ladder/mobile/downer = new(A)
		downer.allowed_directions = UP

		new /obj/structure/ladder/mobile(upper_loc)

		user.drop_from_inventory(src,get_turf(src))
		qdel(src)

/obj/item/ladder_mobile/afterattack(atom/A, mob/user,proximity)
	if (!proximity)
		return

	place_ladder(A,user)

/obj/item/ladder_mobile/proc/handle_action(atom/A, mob/user)
	if (!do_after(user, 30, act_target = user))
		to_chat(user, "Can't place ladder! You were interrupted!")
		return FALSE
	if (!A || QDELETED(src) || QDELETED(user))
		// Shit was deleted during delay, call is no longer valid.
		return FALSE
	return TRUE

/obj/structure/ladder/mobile
	base_icon = "mobile_ladder"

/obj/structure/ladder/mobile/verb/fold()
	set name = "Fold Ladder"
	set category = "Object"
	set src in oview(1)

	if (usr.incapacitated() || !usr.IsAdvancedToolUser() || !ishuman(usr))
		to_chat(usr, "<span class='warning'>You can't do that right now!</span>")
		return

	var/mob/living/carbon/human/H = usr
	H.visible_message("<span class='notice'>[H] starts folding up [src].</span>",
		"<span class='notice'>You start folding up [src].</span>")

	if (!do_after(H, 30, act_target = src))
		to_chat(H, "<span class='warning'>You are interrupted!</span>")
		return

	if (QDELETED(src))
		return

	var/obj/item/ladder_mobile/R = new(get_turf(H))
	transfer_fingerprints_to(R)

	H.visible_message("<span class='notice'>[H] folds [src] up into [R]!</span>",
		"<span class='notice'>You fold [src] up into [R]!</span>")

	if(target_down)
		QDEL_NULL(target_down)
		qdel(src)
	else
		QDEL_NULL(target_up)
		qdel(src)
