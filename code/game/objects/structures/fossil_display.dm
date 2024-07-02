/*
	Fossil Display
*/
/obj/structure/fossil_stand
	name = "fossil stand"
	desc = "A stand for displaying fossilised plants or shell."
	icon = 'icons/obj/structure/fossil_stand.dmi'
	icon_state = "f_stand"
	/**
	 * List of the types of fossils this stand accepts
	 */
	var/list/accepts = list(/obj/item/fossil/shell, /obj/item/fossil/plant)
	/**
	 * The icon_state of the fossil on the stand. Used for the skull of skeletons
	 */
	var/fossil
	/**
	 * If this fossil is complete
	 */
	var/complete = FALSE
	/**
	 * If this fossil can be added to/taken from
	 */
	var/locked = FALSE

/obj/structure/fossil_stand/attackby(obj/item/attacking_item, mob/user, params)
	if(is_type_in_list(attacking_item, accepts) && !locked && !complete)
		to_chat(user, SPAN_NOTICE("You place \the [attacking_item] on \the [src]."))
		fossil = attacking_item.icon_state
		update_stand()
		if(istype(attacking_item, /obj/item/fossil/shell))
			name = "shell fossil stand"
		else if(istype(attacking_item, /obj/item/fossil/plant))
			name = "plant fossil stand"
		qdel(attacking_item)
		return
	else if(attacking_item.iswrench())
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You [anchored ? "anchor" : "unanchor"] \the [src] [anchored ? "to" : "from"] the floor."))
		return
	else if(attacking_item.isscrewdriver())
		locked = !locked
		to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src], [locked ? "preventing" : "allowing"] further modification."))
		return
	return ..()

/obj/structure/fossil_stand/attack_hand(mob/living/user)
	if(fossil && !locked)
		var/obj/item/fossil/F
		if(findtext(fossil, "shell"))
			F = new /obj/item/fossil/shell(src)
		else if(findtext(fossil, "plant"))
			F = new /obj/item/fossil/plant(src)
		if(F)
			F.icon_state = fossil
			fossil = null
			name = initial(name)
			to_chat(user, SPAN_NOTICE("You remove \the [F] from \the [src]."))
			user.put_in_active_hand(F)
			update_stand()
	return ..()


/obj/structure/fossil_stand/proc/update_stand()
	if(fossil)
		complete = TRUE
	else
		complete = FALSE
	update_icon()

/obj/structure/fossil_stand/update_icon()
	..()
	ClearOverlays()
	if(istype(src, /obj/structure/fossil_stand/skeleton)) //Need to do this here to overlay under the skull, while still clearing overlays at the correct time
		var/obj/structure/fossil_stand/skeleton/me = src
		if(me.bones)
			if(!me.bone_type)
				me.bone_type = pick("a", "b", "c")
			var/image/bone_overlay = overlay_image(icon, "bones_[me.bone_type][me.bones]")
			AddOverlays(bone_overlay)
	if(fossil)
		var/image/fossil_overlay = overlay_image(icon, fossil)
		AddOverlays(fossil_overlay)

/obj/structure/fossil_stand/verb/name_fossil()
	set name = "Name Fossil"
	set category = "Object"
	set src in range(1)

	if(!complete)
		to_chat(usr, SPAN_WARNING("You need to finish the fossil before you can name it!"))
		return

	var/fossil_name = input(usr, "Name the Fossil!") as text|null
	if(fossil_name)
		name = "[initial(name)] - [fossil_name]"

/obj/structure/fossil_stand/skeleton
	name = "fossil display"
	desc = "A large display for a fossilised creature."
	icon = 'icons/obj/structure/skeleton_stand.dmi'
	icon_state = "f_stand_large"
	accepts = list(/obj/item/fossil/bone, /obj/item/fossil/skull)
	var/bones = 0
	var/bone_type

/obj/structure/fossil_stand/skeleton/attackby(obj/item/attacking_item, mob/user, params)
	if(is_type_in_list(attacking_item, accepts) && !locked)
		if(istype(attacking_item, /obj/item/fossil/skull) && !fossil)
			to_chat(user, SPAN_NOTICE("You place \the [attacking_item] on \the [src]."))
			fossil = attacking_item.icon_state
		else if(istype(attacking_item, /obj/item/fossil/bone) && bones < 4)
			to_chat(user, SPAN_NOTICE("You add \the [attacking_item] to \the [src]."))
			bones++
		update_stand()
		qdel(attacking_item)
		return
	return ..()

/obj/structure/fossil_stand/skeleton/attack_hand(mob/living/user)
	if(fossil && !locked)
		var/obj/item/fossil/F
		if(findtext(fossil, "horned"))
			F = new /obj/item/fossil/skull/horned(src)
		else
			F = new /obj/item/fossil/skull(src)
		F.icon_state = fossil
		fossil = null
		to_chat(user, SPAN_NOTICE("You remove \the [F] from \the [src]."))
		user.put_in_active_hand(F)
		update_stand()
	else if(bones && !locked)
		var/obj/item/fossil/bone/F = new /obj/item/fossil/bone(src)
		bones--
		to_chat(user, SPAN_NOTICE("You remove \the [F] from \the [src]."))
		user.put_in_active_hand(F)
		update_stand()
	return ..()

/obj/structure/fossil_stand/skeleton/update_stand()
	if(bones == 4 && fossil)
		complete = TRUE
		name = initial(name)
	else
		name = "[initial(name)] - incomplete"
		complete = FALSE
	update_icon()
