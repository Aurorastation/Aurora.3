// 5 sheets == ~12500 matter units == ~100u reagents
// Try to avoid letting people produce more material
// with the kinetic harvester than they put into the
// field in the first place.

/obj/structure/machinery/fusion_fuel_compressor
	name = "fuel compressor"
	icon = 'icons/obj/machinery/fusion.dmi'
	icon_state = "fuel_compressor1"
	density = TRUE
	anchored = TRUE
	layer = 4

/obj/structure/machinery/fusion_fuel_compressor/mouse_drop_receive(atom/dropped, mob/user, params)
	if(user.incapacitated() || !user.Adjacent(src))
		return
	return do_fuel_compression(dropped, user)

/obj/structure/machinery/fusion_fuel_compressor/attackby(obj/item/attacking_item, mob/user)
	return do_fuel_compression(attacking_item, user) || ..()

/obj/structure/machinery/fusion_fuel_compressor/proc/do_fuel_compression(obj/item/thing, mob/user)
	var/skill_level = GET_SKILL_LEVEL(user, REACTOR_SYSTEMS_SKILL_COMPONENT)
	var/is_pro = skill_level >= SKILL_LEVEL_PROFESSIONAL
	if(istype(thing) && thing.reagents && thing.reagents.total_volume && thing.is_open_container())
		var/reagent_cost = is_pro ? 80 : 100
		if(length(thing.reagents.reagent_volumes) > 1)
			to_chat(user, SPAN_WARNING("The contents of \the [thing] are impure and cannot be used as fuel."))
			return 1
		if(thing.reagents.total_volume < reagent_cost)
			to_chat(user, SPAN_WARNING("You need at least [reagent_cost] units of material to form a fuel rod."))
			return 1
		var/singleton/reagent/R = GET_SINGLETON(thing.reagents.reagent_volumes[1])
		visible_message(SPAN_NOTICE("\The [src] compresses the contents of \the [thing] into a new fuel assembly."), visible_message_flags = LOCAL_MESSAGE)
		var/obj/item/fuel_assembly/F = new(get_turf(src), R.type, R.color)
		thing.reagents.remove_reagent(R.type, reagent_cost)
		user.put_in_hands(F)
		return 1
	else if(istype(thing, /obj/structure/machinery/power/supermatter/shard))
		var/obj/item/fuel_assembly/F = new(get_turf(src), MATERIAL_SUPERMATTER)
		visible_message(SPAN_NOTICE("\The [src] compresses \the [thing] into a new fuel assembly."), visible_message_flags = LOCAL_MESSAGE)
		qdel(thing)
		user.put_in_hands(F)
		return 1
	else if(istype(thing, /obj/item/stack/material))
		var/obj/item/stack/material/M = thing
		var/singleton/material/mat = M.get_material()
		var/sheet_cost = is_pro ? 4 : 5
		if(!mat.is_fusion_fuel)
			to_chat(user, SPAN_WARNING("It would be pointless to make a fuel rod out of [mat.use_name]."))
			return
		if(!M.use(sheet_cost))
			to_chat(user, SPAN_WARNING("You need at least [sheet_cost] [mat.sheet_plural_name] to make a fuel rod."))
			return
		var/obj/item/fuel_assembly/F = new(get_turf(src), mat.type)
		visible_message(SPAN_NOTICE("\The [src] compresses the [mat.use_name] into a new fuel assembly."), visible_message_flags = LOCAL_MESSAGE)
		if(is_pro)
			to_chat(user, SPAN_NOTICE("Your expertise with reactor fuel geometry lets you form a full rod using only [sheet_cost] [mat.sheet_plural_name]."))
		user.put_in_hands(F)
		return 1
	return 0
