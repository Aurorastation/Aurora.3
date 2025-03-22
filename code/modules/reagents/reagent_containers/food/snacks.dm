//Food items that are eaten normally and don't leave anything behind.
/obj/item/reagent_containers/food/snacks
	name = "snack"
	desc = "Yummy!"
	icon_state = null
	center_of_mass = list("x"=16, "y"=16)
	w_class = WEIGHT_CLASS_SMALL
	is_liquid = FALSE
	var/slice_path
	var/slices_num
	var/dried_type = null
	var/dry = 0
	var/coating = null // coating typepath, NOT decl
	var/icon/flat_icon = null //Used to cache a flat icon generated from dipping in batter. This is used again to make the cooked-batter-overlay
	var/do_coating_prefix = TRUE
	//If 0, we wont do "battered thing" or similar prefixes. Mainly for recipes that include batter but have a special name

	var/cooked_icon = null
	//Used for foods that are "cooked" without being made into a specific recipe or combination.
	//Generally applied during modification cooking with oven/fryer
	//Used to stop deepfried meat from looking like slightly tanned raw meat, and make it actually look cooked

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
	var/flavor = null // set_flavor()

/obj/item/reagent_containers/food/snacks/proc/on_dry(var/newloc)
	if(dried_type == type)
		name = "dried [name]"
		color = "#AAAAAA"
		dry = TRUE
		if(newloc)
			forceMove(newloc)
		return TRUE
	new dried_type(newloc || src.loc)
	qdel(src)
	return TRUE

/obj/item/reagent_containers/food/snacks/standard_splash_mob(var/mob/user, var/mob/target)
	return TRUE //Returning TRUE will cancel everything else in a long line of things it should do.

/obj/item/reagent_containers/food/snacks/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/food/snacks/standard_feed_mob(var/mob/user, var/mob/target)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(!istype(target))
		return

	if(isliving(target))
		var/mob/living/L = target
		if(L.isSynthetic() && !isipc(L)) //Catches bots, drones, borgs, etc. IPCs are handled below at the human level
			return FALSE

	if (isanimal(target))
		var/mob/living/simple_animal/SA = target
		if(!(reagents && SA.reagents))
			return

		var/m_bitesize = bitesize * SA.bite_factor//Modified bitesize based on creature size
		var/amount_eaten = m_bitesize
		m_bitesize = min(m_bitesize, reagents.total_volume)

		if (!SA.can_eat() || ((user.reagents.maximum_volume - user.reagents.total_volume) < m_bitesize * 0.5))
			to_chat(user, SPAN_DANGER("\The [target.name] can't stomach anymore food!"))
			return

		amount_eaten = reagents.trans_to_mob(SA, min(reagents.total_volume,m_bitesize), CHEM_INGEST)

		if (amount_eaten)
			bitecount++
			shake_animation()
			playsound(loc, pick('sound/effects/creatures/nibble1.ogg','sound/effects/creatures/nibble2.ogg'), 30, 1)
			if (amount_eaten >= m_bitesize)
				user.visible_message(SPAN_NOTICE("\The [user] feeds \the [target] \the [src]."))
				if (!istype(target.loc, /turf))//held mobs don't see visible messages
					to_chat(target, SPAN_NOTICE("\The [user] feeds you \the [src]."))
			else
				user.visible_message(SPAN_NOTICE("\The [user] feeds \the [target] a tiny bit of \the [src]. <b>It looks full.</b>"))
				if (!istype(target.loc, /turf))
					to_chat(target, SPAN_NOTICE("\The [user] feeds you a tiny bit of \the [src]. <b>You feel pretty full!</b>"))
			return 1
	else
		var/fullness = 0
		if(!istype(user, /mob/living/carbon))
			fullness = user.max_nutrition > 0 ? (user.nutrition + (REAGENT_VOLUME(user.reagents, /singleton/reagent/nutriment) * 25)) / user.max_nutrition : CREW_NUTRITION_OVEREATEN + 0.01
		else
			var/mob/living/carbon/eater = user
			fullness = eater.get_fullness()
		fullness += (user.overeatduration/600)*0.5

		var/is_full = (fullness >= user.max_nutrition)

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.species && H.species.bypass_food_fullness())
				is_full = FALSE

		if(user == target)
			if(!user.can_eat(src))
				return

			var/feedback_message
			if(is_full)
				feedback_message = "You cannot force any more of \the [src] to go down your throat!"
			else if(fullness <= CREW_NUTRITION_VERYHUNGRY)
				feedback_message = "You hungrily [is_liquid ? "chug a portion" : "chew out a piece"] of \the [src] and [is_liquid ? "swallow" : "gobble"] it!"
			else if(fullness <= CREW_NUTRITION_HUNGRY)
				feedback_message = "You hungrily begin to [is_liquid ? "drink" : "eat"] \the [src]."
			else if(fullness <= CREW_NUTRITION_SLIGHTLYHUNGRY)
				feedback_message = "You [is_liquid ? "have a drink" : "take a bite"] of \the [src]."
			else if(fullness <= CREW_NUTRITION_FULL)
				feedback_message = "You [is_liquid ? "have a drink" : "take a bite"] of \the [src]."
			else if(fullness <= CREW_NUTRITION_OVEREATEN)
				feedback_message = "You unwillingly [is_liquid ? "sip" : "chew"] a bit of \the [src]."

			if(is_full)
				to_chat(user, SPAN_DANGER(feedback_message))
				return
			reagents.trans_to_mob(target, min(reagents.total_volume,bitesize), CHEM_INGEST)
		else
			if(!target.can_force_feed(user, src))
				return
			if(is_full)
				to_chat(user, SPAN_WARNING("\The [target] can't stomach any more food!"))
				return

			other_feed_message_start(user,target)
			if(!do_mob(user, target))
				return
			other_feed_message_finish(user,target)

			var/contained = reagentlist()
			target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been fed [name] by [key_name(user)] Reagents: [contained]</font>"
			user.attack_log += "\[[time_stamp()]\] <span class='warning'>Fed [name] to [key_name(target)] Reagents: [contained]</span>"
			msg_admin_attack("[key_name_admin(user)] fed [key_name_admin(target)] with [name] Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))
			reagents.trans_to_mob(target, min(reagents.total_volume,bitesize), CHEM_INGEST)

	feed_sound(target)
	bitecount++
	on_consume(user, target)

	return 1

/obj/item/reagent_containers/food/snacks/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 1)
		return
	if (coating)
		var/singleton/reagent/coating_reagent = GET_SINGLETON(coating)
		. += SPAN_NOTICE("It's coated in [coating_reagent.name]!")
	if (!bitecount)
		return
	else if (bitecount==1)
		. += SPAN_NOTICE("\The [src] was bitten by someone!")
	else if (bitecount<=3)
		. += SPAN_NOTICE("\The [src] was bitten [bitecount] time\s!")
	else
		. += SPAN_NOTICE("\The [src] was bitten multiple times!")

/obj/item/reagent_containers/food/snacks/attackby(obj/item/attacking_item, mob/user)

	if(istype(attacking_item, /obj/item/pen))

		var/selection = tgui_input_list(user, "Which attribute do you wish to edit?", "Food Editor", list("Name","Description","Cancel"), "Cancel")
		if(selection == "Name")
			var/input_clean_name = sanitize( tgui_input_text(user, "What is the name of this food?", "Set Food Name", max_length = MAX_LNAME_LEN), MAX_LNAME_LEN )
			if(input_clean_name)
				name = input_clean_name
			else
				name = initial(name)
		else if(selection == "Description")
			var/input_clean_desc = sanitize( tgui_input_text(user, "What is the description of this food?", "Set Food Description", max_length = MAX_MESSAGE_LEN), MAX_MESSAGE_LEN )
			if(input_clean_desc)
				desc = input_clean_desc
			else
				desc = initial(desc)
		return

	if(istype(attacking_item, /obj/item/storage))
		..() // -> item/attackby()
		return

	// Eating with forks
	if(istype(attacking_item, /obj/item/material/kitchen/utensil))
		var/obj/item/material/kitchen/utensil/U = attacking_item
		if(istype(attacking_item, /obj/item/material/kitchen/utensil/fork) && (is_liquid))
			to_chat(user, SPAN_NOTICE("You uselessly pass \the [U] through \the [src]."))
			playsound(user.loc, /singleton/sound_category/generic_pour_sound, 10, 1)
			return
		else
			if(U.scoop_food)
				if(!U.reagents)
					U.create_reagents(5)

				if(U.reagents.total_volume > 0)
					to_chat(user, SPAN_WARNING("You already have \the [src] on \the [U]."))
					return

				to_chat(user, SPAN_NOTICE("You scoop up some of \the [src] with \the [U]."))

				bitecount++
				U.ClearOverlays()
				U.loaded = src.name
				var/image/I = new(U.icon, "loadedfood")
				I.color = src.filling_color
				U.AddOverlays(I)

				reagents.trans_to_obj(U, min(reagents.total_volume,U.transfer_amt))
				if(is_liquid)
					U.is_liquid = TRUE
				on_consume(user, user)
				return

	if(is_sliceable())
		//these are used to allow hiding edge items in food that is not on a table/tray
		var/can_slice_here = isturf(src.loc) && ((locate(/obj/structure/table) in src.loc) || (locate(/obj/machinery/optable) in src.loc) || (locate(/obj/item/tray) in src.loc))
		var/hide_item = !has_edge(attacking_item) || !can_slice_here

		if(hide_item && user.a_intent == I_HURT)
			if (attacking_item.w_class >= src.w_class || is_robot_module(attacking_item))
				return

			to_chat(user, SPAN_WARNING("You slip \the [attacking_item] inside \the [src]."))
			user.remove_from_mob(attacking_item)
			attacking_item.dropped(user)
			add_fingerprint(user)
			contents += attacking_item
			return

		if(has_edge(attacking_item))
			if (!can_slice_here)
				to_chat(user, SPAN_WARNING("You cannot slice \the [src] here! You need a table or at least a tray to do it."))
				return

			var/slices_lost = 0
			if(attacking_item.w_class > 3)
				user.visible_message(SPAN_NOTICE("\The [user] crudely slices \the [src] with [attacking_item]!"), SPAN_NOTICE("You crudely slice \the [src] with your [attacking_item]!"))
				slices_lost = rand(1,min(1,round(slices_num/2)))
			else
				user.visible_message(SPAN_NOTICE("\The [user] slices \the [src]!"), SPAN_NOTICE("You slice \the [src]!"))

			var/reagents_per_slice = reagents.total_volume/slices_num
			for(var/i=1 to (slices_num-slices_lost))
				var/obj/item/reagent_containers/food/slice = new slice_path (src.loc)
				reagents.trans_to_obj(slice, reagents_per_slice)
				slice.filling_color = filling_color
				slice.update_icon()
			qdel(src)
			return

/obj/item/reagent_containers/food/snacks/proc/is_sliceable()
	return (slices_num && slice_path && slices_num > 0)

/obj/item/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.forceMove(get_turf(src))
	return ..()

//Code for dipping food in batter
/**
 * Perform checks, then apply any applicable coatings.
 *
 * @param dip /obj The object to attempt to dip src into.
 * @param user /mob The mob attempting to dip src into dip.
 *
 * @return TRUE if coating applied, FALSE otherwise
 */
/obj/item/reagent_containers/food/snacks/proc/attempt_apply_coating(obj/dip, mob/user)
	if(!dip.is_open_container() || istype(dip, /obj/item/reagent_containers/food) || !Adjacent(user))
		return
	for (var/reagent_type in dip.reagents?.reagent_volumes)
		if(!ispath(reagent_type, /singleton/reagent/nutriment/coating))
			continue
		return apply_coating(dip.reagents, reagent_type, user)

//This proc handles drawing coatings out of a container when this food is dipped into it
/obj/item/reagent_containers/food/snacks/proc/apply_coating(var/datum/reagents/holder, var/applied_coating, var/mob/user)
	if (coating)
		var/singleton/reagent/coating_reagent = GET_SINGLETON(coating)
		to_chat(user, "[src] is already coated in [coating_reagent.name]!")
		return FALSE

	var/singleton/reagent/nutriment/coating/applied_coating_reagent = GET_SINGLETON(applied_coating)

	//Calculate the reagents of the coating needed
	var/req = 0
	for (var/r in reagents.reagent_volumes)
		if (ispath(r, /singleton/reagent/nutriment))
			req += reagents.reagent_volumes[r] * 0.2
		else
			req += reagents.reagent_volumes[r] * 0.1

	req += w_class*0.5

	if (!req)
		//the food has no reagents left, it's probably getting deleted soon
		return FALSE

	if (holder.reagent_volumes[applied_coating] < req)
		to_chat(user, SPAN_WARNING("There's not enough [applied_coating_reagent.name] to coat [src]!"))
		return FALSE

	//First make sure there's space for our batter
	if (REAGENTS_FREE_SPACE(reagents) < req+5)
		var/extra = req+5 - REAGENTS_FREE_SPACE(reagents)
		reagents.maximum_volume += extra

	//Suck the coating out of the holder
	holder.trans_to_holder(reagents, req)

	if (!REAGENT_VOLUME(reagents, applied_coating))
		return

	coating = applied_coating
	//Now we have to do the witchcraft with masking images
	//var/icon/I = new /icon(icon, icon_state)

	if (!flat_icon)
		flat_icon = getFlatIcon(src)
	var/icon/I = flat_icon
	color = "#FFFFFF" //Some fruits use the color var. Reset this so it doesnt tint the batter
	I.Blend(new /icon('icons/obj/item/reagent_containers/food/custom.dmi', rgb(255,255,255)),ICON_ADD)
	I.Blend(new /icon('icons/obj/item/reagent_containers/food/custom.dmi', applied_coating_reagent.icon_raw),ICON_MULTIPLY)
	var/image/J = image(I)
	J.alpha = 200
	J.blend_mode = BLEND_OVERLAY
	J.tag = "coating"
	AddOverlays(J)

	if (user)
		user.visible_message(SPAN_NOTICE("[user] dips [src] into \the [applied_coating_reagent.name]"), SPAN_NOTICE("You dip [src] into \the [applied_coating_reagent.name]"))

	return TRUE

//Called by cooking machines. This is mainly intended to set properties on the food that differ between raw/cooked
/obj/item/reagent_containers/food/snacks/proc/cook()
	if (coating)
		var/singleton/reagent/nutriment/coating/our_coating = GET_SINGLETON(coating)
		var/list/temp = overlays.Copy()
		for (var/i in temp)
			if (istype(i, /image))
				var/image/I = i
				if (I.tag == "coating")
					temp.Remove(I)
					break

		overlays = temp
		//Carefully removing the old raw-batter overlay

		if (!flat_icon)
			flat_icon = getFlatIcon(src)
		var/icon/I = flat_icon
		color = "#FFFFFF" //Some fruits use the color var
		I.Blend(new /icon('icons/obj/item/reagent_containers/food/custom.dmi', rgb(255,255,255)),ICON_ADD)
		I.Blend(new /icon('icons/obj/item/reagent_containers/food/custom.dmi', our_coating.icon_cooked),ICON_MULTIPLY)
		var/image/J = image(I)
		J.alpha = 200
		J.tag = "coating"
		AddOverlays(J)

		if (do_coating_prefix == 1)
			name = "[our_coating.coated_adj] [name]"

	for (var/r in reagents.reagent_volumes)
		if (ispath(r, /singleton/reagent/nutriment/coating))
			var/singleton/reagent/nutriment/coating/C = GET_SINGLETON(r)
			LAZYINITLIST(reagents.reagent_data)
			LAZYSET(reagents.reagent_data[r], "cooked", TRUE)
			C.name = C.cooked_name

// A proc for setting various flavors of the same type of food instead of creating new foods with the only difference being a flavor
/obj/item/reagent_containers/food/snacks/proc/set_flavor()
	if(!flavor)
		flavor = pick("flavored") // Use flavor = pick("option 1", "option 2", "etc") to define possible flavors before using .=..()
	name = "[flavor] [name]"

////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/snacks/attack_generic(var/mob/living/user)
	if(!isanimal(user) && !isalien(user))
		return

	var/m_bitesize = bitesize
	if(isanimal(user))
		var/mob/living/simple_animal/SA = user
		m_bitesize = bitesize * SA.bite_factor	//Modified bitesize based on creature size
		if(!SA.can_eat())
			to_chat(user, SPAN_DANGER("You're too full to eat anymore!"))
			return

	if(reagents && user.reagents)
		m_bitesize = min(m_bitesize, reagents.total_volume)
		if(((user.reagents.maximum_volume - user.reagents.total_volume) < m_bitesize * 0.5)) //If the creature can't even stomach half a bite, then it eats nothing
			to_chat(user, SPAN_DANGER("You're too full to eat anymore!"))
			return

	reagents.trans_to_mob(user, m_bitesize, CHEM_INGEST)
	bitecount++
	shake_animation()
	playsound(loc, pick('sound/effects/creatures/nibble1.ogg','sound/effects/creatures/nibble2.ogg'), 30, 1)

	on_consume(user, user) //mob is both user and target for on_consume since it is feeding itself in this instance

/obj/item/reagent_containers/food/snacks/on_reagent_change()
	update_icon()
	return

//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/reagent_containers/food/snacks/burger/xeno			//Identification path for the object.
//	name = "xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//  reagents_to_add = list(/singleton/reagent/xenomicrobes = 10, /singleton/reagent/nutriment = 2) //This is what is in the food item.
//	bitesize = 3													//This is the amount each bite consumes
