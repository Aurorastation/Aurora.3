/obj/structure/flora
	name = "flora parent object"
	desc = DESC_PARENT
	anchored = TRUE
	density = TRUE
	var/cutting
	/// Whether or not you can shelter under this.
	var/protects_against_weather = FALSE
	/**
	 * List of fluff characteristics to be found on cellular/soil analysis
	 */
	var/list/sample_data = list("Cellular structure typical of wild plantlife")
	/**
	 * Whether this is actually a rock
	 */
	var/is_rock = FALSE

/obj/structure/flora/proc/dig_up(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] begins digging up \the [src]..."))
	if(do_after(user, 150))
		if(Adjacent(user))
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [src]!"))
			qdel(src)

/obj/structure/flora/proc/can_dig()
	return FALSE

/obj/structure/flora/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.is_shovel() && can_dig())
		dig_up(user)
		return
	..()
