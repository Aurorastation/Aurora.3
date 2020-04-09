#define NUTRIMENT_GOOD "nutriment"
#define NUTRIMENT_BAD  "synnutriment"

//Food items that are eaten normally and don't leave anything behind.
/obj/item/reagent_containers/food/snacks
	name = "snack"
	desc = "Yummy!"
	icon = 'icons/obj/food.dmi'
	icon_state = null
	center_of_mass = list("x"=16, "y"=16)
	w_class = 2
	is_liquid = FALSE
	var/bitesize = 1
	var/bitecount = 0
	var/slice_path
	var/slices_num
	var/dried_type = null
	var/dry = 0
	var/nutriment_amt = 0
	var/nutriment_type = NUTRIMENT_GOOD
	var/list/nutriment_desc = list("food" = 1)
	var/datum/reagent/nutriment/coating/coating = null
	var/icon/flat_icon = null //Used to cache a flat icon generated from dipping in batter. This is used again to make the cooked-batter-overlay
	var/do_coating_prefix = 1
	//If 0, we wont do "battered thing" or similar prefixes. Mainly for recipes that include batter but have a special name

	var/cooked_icon = null
	//Used for foods that are "cooked" without being made into a specific recipe or combination.
	//Generally applied during modification cooking with oven/fryer
	//Used to stop deepfried meat from looking like slightly tanned raw meat, and make it actually look cooked

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
	var/flavor = null // set_flavor()

/obj/item/reagent_containers/food/snacks/Initialize()
	. = ..()
	if (nutriment_amt)
		reagents.add_reagent(nutriment_type, nutriment_amt, nutriment_desc)

/obj/item/reagent_containers/food/snacks/standard_splash_mob(var/mob/user, var/mob/target)
	return 1 //Returning 1 will cancel everything else in a long line of things it should do.

/obj/item/reagent_containers/food/snacks/on_consume(mob/user, mob/target)
	if(!reagents.total_volume && !trash)
		target.visible_message(SPAN_NOTICE("[target] finishes [is_liquid ? "drinking" : "eating"] \the [src]."),
					 SPAN_NOTICE("You finish [is_liquid ? "drinking" : "eating"] \the [src]."))
		qdel(src)
	else
		..()

/obj/item/reagent_containers/food/snacks/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/food/snacks/standard_feed_mob(var/mob/user, var/mob/target)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(!istype(target))
		return

	if (isanimal(target))
		var/mob/living/simple_animal/SA = target
		if(!(reagents && SA.reagents))
			return

		var/m_bitesize = bitesize * SA.bite_factor//Modified bitesize based on creature size
		var/amount_eaten = m_bitesize
		m_bitesize = min(m_bitesize, reagents.total_volume)

		if (!SA.can_eat() || ((user.reagents.maximum_volume - user.reagents.total_volume) < m_bitesize * 0.5))
			to_chat(user,span("danger","\The [target.name] can't stomach anymore food!"))
			return

		amount_eaten = reagents.trans_to_mob(SA, min(reagents.total_volume,m_bitesize), CHEM_INGEST)

		if (amount_eaten)
			bitecount++
			if (amount_eaten >= m_bitesize)
				user.visible_message(span("notice","\The [user] feeds \the [target] \the [src]."))
				if (!istype(target.loc, /turf))//held mobs don't see visible messages
					to_chat(target,span("notice","\The [user] feeds you \the [src]."))
			else
				user.visible_message(span("notice","\The [user] feeds \the [target] a tiny bit of \the [src]. <b>It looks full.</b>"))
				if (!istype(target.loc, /turf))
					to_chat(target,span("notice","\The [user] feeds you a tiny bit of \the [src]. <b>You feel pretty full!</b>"))
			return 1
	else
		var/fullness = 0
		if(!istype(user, /mob/living/carbon))
			fullness = user.max_nutrition > 0 ? (user.nutrition + (user.reagents.get_reagent_amount("nutriment") * 25)) / user.max_nutrition : CREW_NUTRITION_OVEREATEN + 0.01
		else
			var/mob/living/carbon/eater = user
			fullness = eater.get_fullness()
		fullness += (user.overeatduration/600)*0.5

		var/is_full = (fullness >= user.max_nutrition)

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
				to_chat(user,span("danger",feedback_message))
				return
			reagents.trans_to_mob(target, min(reagents.total_volume,bitesize), CHEM_INGEST)
		else
			if(!target.can_force_feed(user, src))
				return
			if(is_full)
				to_chat(user,span("warning","\The [target] can't stomach any more food!"))
				return

			other_feed_message_start(user,target)
			if(!do_mob(user, target))
				return
			other_feed_message_finish(user,target)

			var/contained = reagentlist()
			target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [name] by [key_name(user)] Reagents: [contained]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [name] to [key_name(target)] Reagents: [contained]</font>")
			msg_admin_attack("[key_name_admin(user)] fed [key_name_admin(target)] with [name] Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))
			reagents.trans_to_mob(target, min(reagents.total_volume,bitesize), CHEM_INGEST)

	feed_sound(target)
	bitecount++
	on_consume(user, target)

	return 1

/obj/item/reagent_containers/food/snacks/examine(mob/user)
	if(!..(user, 1))
		return
	if(name != initial(name))
		to_chat(user, span("notice", "You know the item as [initial(name)], however a little piece of propped up paper indicates it's \a [name]."))
	if (coating)
		to_chat(user, span("notice", "It's coated in [coating.name]!"))
	if (bitecount==0)
		return
	else if (bitecount==1)
		to_chat(user, span("notice", "\The [src] was bitten by someone!"))
	else if (bitecount<=3)
		to_chat(user, span("notice", "\The [src] was bitten [bitecount] time\s!"))
	else
		to_chat(user, span("notice", "\The [src] was bitten multiple times!"))

/obj/item/reagent_containers/food/snacks/attackby(obj/item/W, mob/living/user)

	if(istype(W,/obj/item/pen))

		var/selection = alert(user,"Which attribute do you wish to edit?","Food Editor","Name","Description","Cancel")
		if(selection == "Name")
			var/input_clean_name = sanitize(input(user,"What is the name of this food?", "Set Food Name") as text|null, MAX_LNAME_LEN)
			if(input_clean_name)
				user.visible_message(span("notice", "\The [user] labels \the [name] as \"[input_clean_name]\"."))
				name = input_clean_name
			else
				name = initial(name)
		else if(selection == "Description")
			var/input_clean_desc = sanitize(input(user,"What is the description of this food?", "Set Food Description") as text|null, MAX_MESSAGE_LEN)
			if(input_clean_desc)
				user.visible_message(span("notice", "\The [user] adds a note to \the [name]."))
				desc = input_clean_desc
			else
				desc = initial(desc)
		return

	if(istype(W,/obj/item/storage))
		..() // -> item/attackby()
		return

	// Eating with forks
	if(istype(W,/obj/item/material/kitchen/utensil))
		var/obj/item/material/kitchen/utensil/U = W
		if(istype(W,/obj/item/material/kitchen/utensil/fork)&&(is_liquid))
			to_chat(user, span("notice", "You uselessly pass \the [U] through \the [src]."))
			playsound(user.loc, 'sound/effects/pour.ogg', 10, 1)
			return
		else
			if(U.scoop_food)
				if(!U.reagents)
					U.create_reagents(5)

				if (U.reagents.total_volume > 0)
					to_chat(user, span("warning", "You already have \the [src] on \the [U]."))
					return

				user.visible_message( \
					"\The [user] scoops up some of \the [src] with \the [U]!", \
					span("notice", "You scoop up some of \the [src] with \the [U]!") \
				)

				bitecount++
				U.cut_overlays()
				U.loaded = src.name
				var/image/I = new(U.icon, "loadedfood")
				I.color = src.filling_color
				U.add_overlay(I)

				reagents.trans_to_obj(U, min(reagents.total_volume,5))
				if(is_liquid)
					U.is_liquid = TRUE
				if (reagents.total_volume <= 0)
					if(trash)
						var/obj/item/TrashItem = new trash(user)
						user.put_in_hands(TrashItem)
					qdel(src)
				return

	if(is_sliceable())
		//these are used to allow hiding edge items in food that is not on a table/tray
		var/can_slice_here = isturf(src.loc) && ((locate(/obj/structure/table) in src.loc) || (locate(/obj/machinery/optable) in src.loc) || (locate(/obj/item/tray) in src.loc))
		var/hide_item = !has_edge(W) || !can_slice_here

		if(hide_item && user.a_intent == I_HURT)
			if (W.w_class >= src.w_class || is_robot_module(W))
				return

			to_chat(user, span("warning", "You slip \the [W] inside \the [src]."))
			user.remove_from_mob(W)
			W.dropped(user)
			add_fingerprint(user)
			contents += W
			return

		if(has_edge(W))
			if (!can_slice_here)
				to_chat(user, span("warning", "You cannot slice \the [src] here! You need a table or at least a tray to do it."))
				return

			var/slices_lost = 0
			if(W.w_class > 3)
				user.visible_message(span("notice", "\The [user] crudely slices \the [src] with [W]!"), span("notice", "You crudely slice \the [src] with your [W]!"))
				slices_lost = rand(1,min(1,round(slices_num/2)))
			else
				user.visible_message(span("notice", "\The [user] slices \the [src]!"), span("notice", "You slice \the [src]!"))

			var/reagents_per_slice = reagents.total_volume/slices_num
			for(var/i=1 to (slices_num-slices_lost))
				var/obj/slice = new slice_path (src.loc)
				reagents.trans_to_obj(slice, reagents_per_slice)
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
/obj/item/reagent_containers/food/snacks/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(O.is_open_container() && O.reagents && !(istype(O, /obj/item/reagent_containers/food)) && proximity)
		for (var/r in O.reagents.reagent_list)

			var/datum/reagent/R = r
			if (istype(R, /datum/reagent/nutriment/coating))
				if (apply_coating(R, user))
					return 1

	return ..()

//This proc handles drawing coatings out of a container when this food is dipped into it
/obj/item/reagent_containers/food/snacks/proc/apply_coating(var/datum/reagent/nutriment/coating/C, var/mob/user)
	if (coating)
		to_chat(user, "The [src] is already coated in [coating.name]!")
		return 0

	//Calculate the reagents of the coating needed
	var/req = 0
	for (var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if (istype(R, /datum/reagent/nutriment))
			req += R.volume * 0.2
		else
			req += R.volume * 0.1

	req += w_class*0.5

	if (!req)
		//the food has no reagents left, its probably getting deleted soon
		return 0

	if (C.volume < req)
		to_chat(user, span("warning", "There's not enough [C.name] to coat the [src]!"))
		return 0

	var/id = C.id

	//First make sure there's space for our batter
	if (reagents.get_free_space() < req+5)
		var/extra = req+5 - reagents.get_free_space()
		reagents.maximum_volume += extra

	//Suck the coating out of the holder
	C.holder.trans_to_holder(reagents, req)

	//We're done with C now, repurpose the var to hold a reference to our local instance of it
	C = reagents.get_reagent(id)
	if (!C)
		return

	coating = C
	//Now we have to do the witchcraft with masking images
	//var/icon/I = new /icon(icon, icon_state)

	if (!flat_icon)
		flat_icon = getFlatIcon(src)
	var/icon/I = flat_icon
	color = "#FFFFFF" //Some fruits use the color var. Reset this so it doesnt tint the batter
	I.Blend(new /icon('icons/obj/food_custom.dmi', rgb(255,255,255)),ICON_ADD)
	I.Blend(new /icon('icons/obj/food_custom.dmi', coating.icon_raw),ICON_MULTIPLY)
	var/image/J = image(I)
	J.alpha = 200
	J.blend_mode = BLEND_OVERLAY
	J.tag = "coating"
	add_overlay(J)

	if (user)
		user.visible_message(span("notice", "[user] dips \the [src] into \the [coating.name]"), span("notice", "You dip \the [src] into \the [coating.name]"))

	return 1


//Called by cooking machines. This is mainly intended to set properties on the food that differ between raw/cooked
/obj/item/reagent_containers/food/snacks/proc/cook()
	if (coating)
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
		I.Blend(new /icon('icons/obj/food_custom.dmi', rgb(255,255,255)),ICON_ADD)
		I.Blend(new /icon('icons/obj/food_custom.dmi', coating.icon_cooked),ICON_MULTIPLY)
		var/image/J = image(I)
		J.alpha = 200
		J.tag = "coating"
		add_overlay(J)


		if (do_coating_prefix == 1)
			name = "[coating.coated_adj] [name]"

	for (var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if (istype(R, /datum/reagent/nutriment/coating))
			var/datum/reagent/nutriment/coating/C = R
			C.data["cooked"] = 1
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
			to_chat(user, span("danger", "You're too full to eat anymore!"))
			return

	if(reagents && user.reagents)
		m_bitesize = min(m_bitesize, reagents.total_volume)
		if(((user.reagents.maximum_volume - user.reagents.total_volume) < m_bitesize * 0.5)) //If the creature can't even stomach half a bite, then it eats nothing
			to_chat(user, span("danger", "You're too full to eat anymore!"))
			return

	reagents.trans_to_mob(user, m_bitesize, CHEM_INGEST)
	bitecount++
	animate_shake()
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
//obj/item/reagent_containers/food/snacks/burger/xeno/Initialize()		//Don't mess with this. And always use Full Path Structure
//	. = ..()															//Same here.
//	reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//	reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//	bitesize = 3													//This is the amount each bite consumes.

/obj/item/reagent_containers/food/snacks/koisbar_clean
	name = "k'ois bar"
	desc = "Bland NanoTrasen produced K'ois bars, rich in syrup and injected with extra phoron; it has a label on it warning that it is unsafe for human consumption."
	icon_state = "koisbar"
	trash = /obj/item/trash/koisbar
	filling_color = "#dcd9cd"
	bitesize = 5

/obj/item/reagent_containers/food/snacks/koisbar_clean/Initialize()
	. = ..()
	reagents.add_reagent("koispasteclean", 10)
	reagents.add_reagent("phoron", 15)

/obj/item/reagent_containers/food/snacks/koisbar
	name = "organic k'ois bar"
	desc = "100% certified organic NanoTrasen produced K'ois bars, rich in REAL unfiltered kois. No preservatives added!"
	icon_state = "koisbar"
	trash = /obj/item/trash/koisbar
	filling_color = "#dcd9cd"
	bitesize = 5

/obj/item/reagent_containers/food/snacks/koisbar/Initialize()
	. = ..()
	reagents.add_reagent("koispaste", 10)
	reagents.add_reagent("phoron", 15)
	reagents.add_reagent("hfcs", 2)

/obj/item/reagent_containers/food/snacks/salad/aesirsalad
	name = "aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468C00"
	nutriment_amt = 8
	nutriment_desc = list("apples" = 3,"salad" = 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/salad/aesirsalad/Initialize()
	. = ..()
	reagents.add_reagent("doctorsdelight", 8)
	reagents.add_reagent("tricordrazine", 8)

/obj/item/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat, love it or hate it. Made with real sugar, and no artificial preservatives!"
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7D5F46"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 2, "nougat" = 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/candy/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_containers/food/snacks/candy/koko
	name = "\improper koko bar"
	desc = "A sweet and gritty candy bar cultivated exclusively on the Compact ruled world of Ha'zana. A good pick-me-up for Unathi, but has no effect on other species."
	icon_state = "kokobar"
	trash = /obj/item/trash/kokobar
	filling_color = "#7D5F46"
	nutriment_amt = 4
	nutriment_desc = list("koko reed" = 2, "fibers" = 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/candy/koko/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 3)
	reagents.add_reagent("kokoreed", 7)

/obj/item/reagent_containers/food/snacks/candy/donor
	name = "donor candy"
	icon_state = "candy"
	desc = "A little treat for blood donors. Made with real sugar!"
	trash = /obj/item/trash/candy
	nutriment_desc = list("candy" = 10)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/candy/donor/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_containers/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Cannot be stored in a detective's hat, alas."
	icon_state = "candy_corn"
	filling_color = "#FFFCB0"
	nutriment_amt = 4
	nutriment_desc = list("candy corn" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/candy_corn/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps."
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#E8C31E"
	nutriment_amt = 3
	nutriment_type = NUTRIMENT_BAD
	nutriment_desc = list("chips" = 3)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cookie
	name = "cookie"
	desc = "COOKIE!!!"
	icon_state = "COOKIE!!!"
	filling_color = "#DBC94F"
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 3, "cookie" = 2)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cookiesnack
	name = "Carps Ahoy! miniature cookies"
	desc = "Cap'n Carpie's miniature cookies! Now 100% carpotoxin free!"
	icon_state = "cookiesnack"
	trash = /obj/item/trash/cookiesnack
	filling_color = "#DBC94F"
	nutriment_amt = 3
	nutriment_type = NUTRIMENT_BAD
	nutriment_desc = list("sweetness" = 1, "stale cookie" = 2)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/chocolatebar
	name = "chocolate bar"
	desc = "Such sweet, fattening food."
	icon_state = "chocolatebar"
	filling_color = "#7D5F46"
	nutriment_amt = 2
	nutriment_desc = list("chocolate" = 5)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chocolateegg
	name = "chocolate egg"
	desc = "Eggcellent."
	icon_state = "chocolateegg"
	filling_color = "#7D5F46"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 5)
	bitesize = 2

//a random egg that can spawn only on easter. It has really good food values because it's rare
/obj/item/reagent_containers/food/snacks/goldenegg
	name = "golden egg"
	desc = "It's the golden egg!"
	icon_state = "egg-yellow"
	filling_color = "#7D5F46"
	nutriment_amt = 12
	nutriment_desc = list("chocolate" = 5)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	filling_color = "#D9C386"
	overlay_state = "box-donut1"
	nutriment_desc = list("sweetness" = 1, "donut" = 2)

/obj/item/reagent_containers/food/snacks/donut/normal
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	nutriment_desc = list("sweetness" = 1, "donut" = 2)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/donut/normal/psdonut
	name = "pumpkin spice donut"
	desc = "A limited edition seasonal pastry."
	icon_state = "donut_ps"
	nutriment_desc = list("pumpkin spice" = 1, "donut" = 2)

/obj/item/reagent_containers/food/snacks/donut/normal/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.name = "frosted donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/donut/chaos
	name = "chaos donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	filling_color = "#ED11E6"
	nutriment_desc = list("sweetness" = 1, "donut" = 2)
	nutriment_amt = 3
	bitesize = 10

/obj/item/reagent_containers/food/snacks/donut/chaos/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	reagents.add_reagent("sprinkles", 1)
	var/chaosselect = pick(1,2,3,4,5,6,7,8,9,10)
	switch(chaosselect)
		if(1)
			reagents.add_reagent("nutriment", 3)
		if(2)
			reagents.add_reagent("capsaicin", 3)
		if(3)
			reagents.add_reagent("frostoil", 3)
		if(4)
			reagents.add_reagent("sprinkles", 3)
		if(5)
			reagents.add_reagent("phoron", 3)
		if(6)
			reagents.add_reagent("coco", 3)
		if(7)
			reagents.add_reagent("slimejelly", 3)
		if(8)
			reagents.add_reagent("banana", 3)
		if(9)
			reagents.add_reagent("berryjuice", 3)
		if(10)
			reagents.add_reagent("tricordrazine", 3)
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Chaos Donut"
		reagents.add_reagent("sprinkles", 2)


/obj/item/reagent_containers/food/snacks/donut/jelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"
	nutriment_desc = list("sweetness" = 1, "donut" = 2)
	nutriment_amt = 3
	bitesize = 5

/obj/item/reagent_containers/food/snacks/donut/jelly/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("berryjuice", 5)
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/donut/slimejelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"
	nutriment_desc = list("sweetness" = 1, "donut" = 2)
	nutriment_amt = 3
	bitesize = 5

/obj/item/reagent_containers/food/snacks/donut/slimejelly/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("slimejelly", 5)
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/donut/cherryjelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"
	nutriment_desc = list("sweetness" = 1, "donut" = 2)
	nutriment_amt = 3
	bitesize = 5

/obj/item/reagent_containers/food/snacks/donut/cherryjelly/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 3)
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("cherryjelly", 5)
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/funnelcake
	name = "funnel cake"
	desc = "Funnel cakes rule!"
	icon_state = "funnelcake"
	filling_color = "#Ef1479"
	do_coating_prefix = 0
	bitesize = 2

/obj/item/reagent_containers/food/snacks/funnelcake/Initialize()
	. = ..()
	reagents.add_reagent("batter", 10)
	reagents.add_reagent("sugar", 5)

/obj/item/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "Can I offer you a nice egg in this trying time?"
	icon_state = "egg"
	filling_color = "#FDFFD1"
	volume = 10

/obj/item/reagent_containers/food/snacks/egg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 3)

/obj/item/reagent_containers/food/snacks/egg/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(!(proximity && O.is_open_container()))
		return ..()
	to_chat(user, "You crack \the [src] into \the [O].")
	reagents.trans_to(O, reagents.total_volume)
	qdel(src)

/obj/item/reagent_containers/food/snacks/egg/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/egg_smudge(src.loc)
	src.reagents.splash(hit_atom, reagents.total_volume)
	src.visible_message(span("warning", "\The [src] has been squashed!"),span("warning", "You hear a smack."))
	qdel(src)

/obj/item/reagent_containers/food/snacks/egg/attackby(obj/item/W as obj, mob/user as mob)
	if(istype( W, /obj/item/pen/crayon ))
		var/obj/item/pen/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, span("notice", "The egg refuses to take on this color!"))
			return

		to_chat(usr, span("notice", "You color \the [src] [clr]"))
		icon_state = "egg-[clr]"
	else
		..()

/obj/item/reagent_containers/food/snacks/egg/blue
	icon_state = "egg-blue"

/obj/item/reagent_containers/food/snacks/egg/green
	icon_state = "egg-green"

/obj/item/reagent_containers/food/snacks/egg/mime
	icon_state = "egg-mime"

/obj/item/reagent_containers/food/snacks/egg/orange
	icon_state = "egg-orange"

/obj/item/reagent_containers/food/snacks/egg/purple
	icon_state = "egg-purple"

/obj/item/reagent_containers/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"

/obj/item/reagent_containers/food/snacks/egg/red
	icon_state = "egg-red"

/obj/item/reagent_containers/food/snacks/egg/yellow
	icon_state = "egg-yellow"

/obj/item/reagent_containers/food/snacks/friedegg
	name = "fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#FFDF78"
	bitesize = 1

/obj/item/reagent_containers/food/snacks/friedegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 3)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_containers/food/snacks/boiledegg
	name = "boiled egg"
	desc = "Hard to beat, aren't they?"
	icon_state = "egg"
	filling_color = "#FFFFFF"

/obj/item/reagent_containers/food/snacks/boiledegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)

/obj/item/reagent_containers/food/snacks/organ
	name = "organ"
	desc = "Sorry, this isn't the instrument."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/organ/Initialize()
	. = ..()
	reagents.add_reagent("protein", rand(3,5))
	reagents.add_reagent("toxin", rand(1,3))

/obj/item/reagent_containers/food/snacks/tofu
	name = "tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=17, "y"=10)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/tofu/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 3)

/obj/item/reagent_containers/food/snacks/tofurkey
	name = "tofurkey"
	desc = "A fake turkey made from tofu."
	icon_state = "tofurkey"
	filling_color = "#FFFEE0"
	nutriment_amt = 6
	nutriment_desc = list("turkey" = 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/tofurkey/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 6)
	reagents.add_reagent("stoxin", 3)

/obj/item/reagent_containers/food/snacks/stuffing
	name = "stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#C9AC83"
	nutriment_amt = 3
	nutriment_desc = list("dryness" = 2, "bread" = 2)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat."
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	bitesize = 6

/obj/item/reagent_containers/food/snacks/carpmeat/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 3)
	reagents.add_reagent("carpotoxin", 3)

/obj/item/reagent_containers/food/snacks/dwellermeat
	name = "worm fillet"
	desc = "A fillet of electrifying cavern meat."
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	bitesize = 6

/obj/item/reagent_containers/food/snacks/dwellermeat/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 6)
	reagents.add_reagent("hyperzine", 15)
	reagents.add_reagent("pacid",6)

/obj/item/reagent_containers/food/snacks/fishfingers
	name = "fish fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	filling_color = "#FFDEFE"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fishfingers/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 4)
	reagents.add_reagent("carpotoxin", 3)

/obj/item/reagent_containers/food/snacks/hugemushroomslice
	name = "huge mushroom slice"
	desc = "There wasn't much room for that mushroom."
	icon_state = "hugemushroomslice"
	filling_color = "#E0D7C5"
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "mushroom" = 2)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/hugemushroomslice/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 3)

/obj/item/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato."
	icon_state = "tomatomeat"
	filling_color = "#DB0000"
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "tomato" = 3)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/bearmeat
	name = "bear meat"
	desc = "I can bearly control myself."
	icon_state = "bearmeat"
	filling_color = "#DB0000"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/bearmeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 12)
	reagents.add_reagent("hyperzine", 5)

/obj/item/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	bitesize = 6

/obj/item/reagent_containers/food/snacks/xenomeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("pacid",6)

/obj/item/reagent_containers/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#DB0000"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	filling_color = "#DB0000"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sausage/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/sausage/battered
	name = "battered sausage"
	desc = "A piece of mixed, long meat, battered and then deepfried"
	icon_state = "batteredsausage"
	filling_color = "#DB0000"
	do_coating_prefix = 0
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sausage/battered/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("batter", 1.7)
	reagents.add_reagent("oil", 1.5)

/obj/item/reagent_containers/food/snacks/jalapeno_poppers
	name = "jalapeno popper"
	desc = "A battered, deep-fried chilli pepper"
	icon_state = "popper"
	filling_color = "#00AA00"
	do_coating_prefix = 0
	nutriment_amt = 2
	nutriment_desc = list("chilli pepper" = 2)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/jalapeno_poppers/Initialize()
	. = ..()
	reagents.add_reagent("batter", 2)
	reagents.add_reagent("oil", 2)

/obj/item/reagent_containers/food/snacks/donkpocket
	name = "Donk-pocket"
	desc = "The cold, reheatable food of choice for the seasoned spaceman."
	icon_state = "donkpocket"
	filling_color = "#DEDEAB"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("heartiness" = 1, "dough" = 2)
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/donkpocket/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/donkpocket/warm
	name = "cooked Donk-pocket"
	desc = "The cooked, reheatable food of choice for the seasoned spaceman."
	nutriment_desc = list("warm heartiness" = 1, "dough" = 2)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/donkpocket/warm/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("tricordrazine", 5)

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket
	name = "\improper Sin-pocket"
	desc = "The food of choice for the veteran. Do <B>NOT</B> overconsume. Use it in hand to heat and release chemicals."
	nutriment_desc = list("delicious cruelty" = 1, "dough" = 2)
	filling_color = "#6D6D00"
	nutriment_amt = 3
	var/has_been_heated = FALSE

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket/attack_self(mob/user)
	if(has_been_heated)
		to_chat(user, span("notice", "The heating chemicals have already been spent."))
		return
	has_been_heated = TRUE
	user.visible_message(span("notice", "[user] crushes \the [src] package."), "You crush \the [src] package and feel it rapidly heat up.")
	name = "cooked Sin-pocket"
	desc = "The food of choice for the veteran. Do <B>NOT</B> overconsume."
	reagents.add_reagent("doctorsdelight", 5)
	reagents.add_reagent("hyperzine", 1.5)
	reagents.add_reagent("synaptizine", 1.25)

/obj/item/reagent_containers/food/snacks/burger/brain
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	filling_color = "#F2B6EA"
	center_of_mass = list("x"=15, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/brain/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("alkysine", 6)

/obj/item/reagent_containers/food/snacks/burger/ghost
	name = "ghost burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#FFF2FF"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("buns" = 3, "spookiness" = 3)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/human
	var/hname = ""
	var/job = null
	filling_color = "#D63C3C"

/obj/item/reagent_containers/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/human/burger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/burger/cheese
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "cheeseburger"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/burger/cheese/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	reagents.add_reagent("cheese", 2)

/obj/item/reagent_containers/food/snacks/burger/monkey
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#D63C3C"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/monkey/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 3)

/obj/item/reagent_containers/food/snacks/burger/fish
	name = "fillet -o- carp sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/burger/fish/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 6)
	reagents.add_reagent("carpotoxin", 3)

/obj/item/reagent_containers/food/snacks/burger/tofu
	name = "tofu burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/tofu/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 3)

/obj/item/reagent_containers/food/snacks/burger/robo
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("bun" = 2, "metal" = 3)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/robo/Initialize()
	. = ..()
	if(prob(5))
		reagents.add_reagent("nanites", 2)

/obj/item/reagent_containers/food/snacks/burger/robobig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"
	volume = 100
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 0.1

/obj/item/reagent_containers/food/snacks/burger/robobig/Initialize()
	. = ..()
	reagents.add_reagent("nanites", 100)

/obj/item/reagent_containers/food/snacks/burger/xeno
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	filling_color = "#43DE18"
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/xeno/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)

/obj/item/reagent_containers/food/snacks/burger/clown
	name = "clown burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	filling_color = "#FF00FF"
	center_of_mass = list("x"=17, "y"=12)
	nutriment_desc = list("bun" = 2, "crayons" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/mime
	name = "mime burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	filling_color = "#FFFFFF"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("bun" = 2, "paint" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/mouse
	name = "rat burger"
	desc = "Squeaky and a little furry. Do you see any cows around here, Detective?"
	icon_state = "ratburger"
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/mouse/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)

/obj/item/reagent_containers/food/snacks/omelette
	name = "omelette du fromage"
	desc = "That's all you can say!"
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#FFF9A8"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/omelette/Initialize()
	. = ..()
	reagents.add_reagent("egg", 8)

/obj/item/reagent_containers/food/snacks/muffin
	name = "muffin"
	desc = "A delicious and spongy little cake."
	icon_state = "muffin"
	filling_color = "#E0CF9B"
	center_of_mass = list("x"=17, "y"=4)
	nutriment_desc = list("sweetness" = 3, "muffin" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pie
	name = "banana cream pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#FBFFB8"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_desc = list("pie" = 3, "cream" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/pie/Initialize()
	. = ..()
	reagents.add_reagent("banana",5)

/obj/item/reagent_containers/food/snacks/pie/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message(span("danger", "\The [src.name] splats."),span("danger", "You hear a splat."))
	qdel(src)

/obj/item/reagent_containers/food/snacks/berryclafoutis
	name = "berry clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=16, "y"=13)
	nutriment_desc = list("sweetness" = 2, "pie" = 3)
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/berryclafoutis/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles."
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	drop_sound = 'sound/items/trayhit1.ogg'
	filling_color = "#E6DEB5"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_desc = list("waffle" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/eggplantparm
	name = "eggplant parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4D2F5E"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("eggplant" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/eggplantparm/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 5)

/obj/item/reagent_containers/food/snacks/soywafers
	name = "Soy Wafers"
	desc = "Simple pressed soy wafers."
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	drop_sound = 'sound/items/trayhit1.ogg'
	filling_color = "#E6FA61"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_desc = list("bland dry soy" = 5)
	nutriment_amt = 10
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatpie
	name = "meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	trash = /obj/item/trash/plate
	filling_color = "#948051"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatpie/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)

/obj/item/reagent_containers/food/snacks/tofupie
	name = "tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	trash = /obj/item/trash/plate
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_desc = list("pie" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tofupie/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 3)

/obj/item/reagent_containers/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	filling_color = "#FFCCCC"
	center_of_mass = list("x"=17, "y"=9)
	nutriment_desc = list("sweetness" = 3, "mushroom" = 3, "pie" = 2)
	nutriment_amt = 5
	bitesize = 3

/obj/item/reagent_containers/food/snacks/amanita_pie/Initialize()
	. = ..()
	reagents.add_reagent("amatoxin", 3)
	reagents.add_reagent("psilocybin", 1)

/obj/item/reagent_containers/food/snacks/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	filling_color = "#B8279B"
	center_of_mass = list("x"=17, "y"=9)
	nutriment_desc = list("heartiness" = 2, "mushroom" = 3, "pie" = 3)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/plump_pie/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		reagents.add_reagent("tricordrazine", 5)

/obj/item/reagent_containers/food/snacks/xemeatpie
	name = "xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	trash = /obj/item/trash/plate
	filling_color = "#43DE18"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/xemeatpie/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)

/obj/item/reagent_containers/food/snacks/wingfangchu
	name = "wing fang chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#43DE18"
	center_of_mass = list("x"=17, "y"=9)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/wingfangchu/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/human/kabob
	name = "-kabob"
	icon_state = "kabob"
	desc = "A human meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/human/kabob/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)

/obj/item/reagent_containers/food/snacks/monkeykabob
	name = "meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/monkeykabob/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)

/obj/item/reagent_containers/food/snacks/tofukabob
	name = "tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tofukabob/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 8)

/obj/item/reagent_containers/food/snacks/cubancarp
	name = "cuban carp"
	desc = "A sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"
	center_of_mass = list("x"=12, "y"=5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cubancarp/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 3)
	reagents.add_reagent("nutriment", 3)
	reagents.add_reagent("carpotoxin", 3)
	reagents.add_reagent("capsaicin", 3)

/obj/item/reagent_containers/food/snacks/chickenkatsu
	name = "chicken katsu"
	desc = "A terran delicacy consisting of chicken fried in a light beer batter"
	icon_state = "katsu"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"
	center_of_mass = list("x"=16, "y"=16)
	do_coating_prefix = 0
	bitesize = 1.5

/obj/item/reagent_containers/food/snacks/chickenkatsu/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("beerbatter", 2)
	reagents.add_reagent("oil", 1)

/obj/item/reagent_containers/food/snacks/popcorn
	name = "popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	var/unpopped = 0
	filling_color = "#FFFAD4"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_desc = list("popcorn" = 3)
	nutriment_amt = 2
	bitesize = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0

/obj/item/reagent_containers/food/snacks/popcorn/Initialize()
	..()
	unpopped = rand(1,10)

/obj/item/reagent_containers/food/snacks/popcorn/on_consume()
	if(prob(unpopped))	//lol ...what's the point? // IMPLEMENT DENTISTRY WHEN?
		to_chat(usr, span("warning", "You bite down on an un-popped kernel!"))
		unpopped = max(0, unpopped-1)
	..()

/obj/item/reagent_containers/food/snacks/sosjerky
	name = "Scaredy's Private Reserve beef jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_type = NUTRIMENT_BAD
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sosjerky/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("sodiumchloride",3)

/obj/item/reagent_containers/food/snacks/no_raisin
	name = "4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"
	center_of_mass = list("x"=15, "y"=4)
	nutriment_desc = list("dried raisins" = 6)
	nutriment_type = NUTRIMENT_BAD
	nutriment_amt = 6
	bitesize = 3

/obj/item/reagent_containers/food/snacks/spacetwinkie
	name = "space twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	trash = /obj/item/trash/space_twinkie
	filling_color = "#FFE591"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_desc = list("cake" = 3, "cream filling" = 1)
	nutriment_type = NUTRIMENT_BAD
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spacetwinkie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)

/obj/item/reagent_containers/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth"
	trash = /obj/item/trash/cheesie
	filling_color = "#FFA305"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("chips" = 2)
	nutriment_type = NUTRIMENT_BAD
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesiehonkers/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)
	reagents.add_reagent("sodiumchloride",6)

/obj/item/reagent_containers/food/snacks/syndicake
	name = "Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	filling_color = "#FF5D05"
	center_of_mass = list("x"=16, "y"=10)
	trash = /obj/item/trash/syndi_cakes
	nutriment_desc = list("cake" = 1,"cream filling" = 3, )
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/syndicake/Initialize()
	. = ..()
	reagents.add_reagent("doctorsdelight", 5)

/obj/item/reagent_containers/food/snacks/loadedbakedpotato
	name = "loaded baked potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	filling_color = "#9C7A68"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("baked potato" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/loadedbakedpotato/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/fries
	name = "space fries"
	desc = "AKA: French Fries, Freedom Fries, etc."
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("fresh fries" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fries/Initialize()
	. = ..()
	reagents.add_reagent("oil", 1.2)//This is mainly for the benefit of adminspawning

/obj/item/reagent_containers/food/snacks/microchips
	name = "micro chips"
	desc = "Soft and rubbery. should have fried them"
	icon_state = "microchips"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("fresh fries" = 4)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ovenchips
	name = "oven chips"
	desc = "Dark and crispy, but a bit dry"
	icon_state = "ovenchips"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("fresh fries" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soydope
	name = "soy dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	trash = /obj/item/trash/plate
	filling_color = "#C4BF76"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("soy" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spagetti
	name = "spaghetti"
	desc = "A bundle of raw spaghetti."
	icon_state = "spagetti"
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 1
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cheesyfries
	name = "cheesy fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("fresh fries" = 3)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesyfries/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)

/obj/item/reagent_containers/food/snacks/fortunecookie
	name = "fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon_state = "fortune_cookie"
	filling_color = "#E8E79E"
	center_of_mass = list("x"=15, "y"=14)
	nutriment_desc = list("fortune cookie" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/badrecipe
	name = "burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	filling_color = "#211F02"
	center_of_mass = list("x"=16, "y"=12)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/badrecipe/Initialize()
	. = ..()
	reagents.add_reagent("toxin", 1)
	reagents.add_reagent("carbon", 3)

/obj/item/reagent_containers/food/snacks/meatsteak
	name = "meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "steak"
	trash = /obj/item/trash/plate/steak
	filling_color = "#7A3D11"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatsteak/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_containers/food/snacks/meatsteak/update_icon()
	var/percent = round((reagents.total_volume / 10) * 100)
	switch(percent)
		if(0 to 10)
			icon_state = "steak_10"
		if(11 to 25)
			icon_state = "steak_25"
		if(26 to 40)
			icon_state = "steak_40"
		if(41 to 60)
			icon_state = "steak_60"
		if(61 to 75)
			icon_state = "steak_75"
		if(76 to INFINITY)
			icon_state = "steak"

/obj/item/reagent_containers/food/snacks/spacylibertyduff
	name = "spacy liberty duff"
	desc = "Jello gelatin, from Alfred Hubbard's cookbook."
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42B873"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_desc = list("mushroom" = 6)
	nutriment_amt = 6
	bitesize = 3

/obj/item/reagent_containers/food/snacks/spacylibertyduff/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 6)

/obj/item/reagent_containers/food/snacks/amanitajelly
	name = "amanita jelly"
	desc = "Looks curiously toxic."
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ED0758"
	center_of_mass = list("x"=16, "y"=5)
	nutriment_desc = list("jelly" = 3, "mushroom" = 3)
	nutriment_amt = 6
	bitesize = 3

/obj/item/reagent_containers/food/snacks/amanitajelly/Initialize()
	. = ..()
	reagents.add_reagent("amatoxin", 6)
	reagents.add_reagent("psilocybin", 3)

/obj/item/reagent_containers/food/snacks/poppypretzel
	name = "poppy pretzel"
	desc = "It's all twisted up!"
	icon_state = "poppypretzel"
	bitesize = 2
	filling_color = "#916E36"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("poppy seeds" = 2, "pretzel" = 3)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soup
	name = "water soup"
	desc = "Water. And it tastes...fuck all."
	icon_state = "wishsoup"
	nutriment_desc = list("soup" = 5)
	trash = /obj/item/trash/snack_bowl
	center_of_mass = list("x"=16, "y"=8)
	bitesize = 5
	is_liquid = TRUE

/obj/item/reagent_containers/food/snacks/soup/meatball
	name = "meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	filling_color = "#785210"

/obj/item/reagent_containers/food/snacks/soup/meatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)
	reagents.add_reagent("water", 5)

/obj/item/reagent_containers/food/snacks/soup/slime
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	filling_color = "#C4DBA0"

/obj/item/reagent_containers/food/snacks/soup/slime/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)
	reagents.add_reagent("water", 10)

/obj/item/reagent_containers/food/snacks/soup/blood
	name = "tomato soup"
	desc = "Smells like copper."
	icon_state = "tomatosoup"
	filling_color = "#FF0000"

/obj/item/reagent_containers/food/snacks/soup/blood/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	reagents.add_reagent("blood", 10)
	reagents.add_reagent("water", 5)

/obj/item/reagent_containers/food/snacks/clownstears
	name = "clown's tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	filling_color = "#C4FBFF"
	nutriment_desc = list("salt" = 1, "the worst joke" = 3)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/clownstears/Initialize()
	. = ..()
	reagents.add_reagent("banana", 5)
	reagents.add_reagent("water", 10)

/obj/item/reagent_containers/food/snacks/soup/vegetable
	name = "vegetable soup"
	desc = "A true vegan meal" //TODO
	icon_state = "vegetablesoup"
	filling_color = "#AFC4B5"
	nutriment_desc = list("carrot" = 2, "corn" = 2, "eggplant" = 2, "potato" = 2)
	nutriment_amt = 8

/obj/item/reagent_containers/food/snacks/soup/vegetable/Initialize()
	. = ..()
	reagents.add_reagent("water", 5)

/obj/item/reagent_containers/food/snacks/soup/nettle
	name = "nettle soup"
	desc = "To think, the botanist would've beat you to death with one of these."
	icon_state = "nettlesoup"
	filling_color = "#AFC4B5"
	nutriment_desc = list("salad" = 4, "egg" = 2, "potato" = 2)
	nutriment_amt = 8

/obj/item/reagent_containers/food/snacks/soup/nettle/Initialize()
	. = ..()
	reagents.add_reagent("water", 5)
	reagents.add_reagent("tricordrazine", 5)

/obj/item/reagent_containers/food/snacks/soup/mystery
	name = "mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	filling_color = "#F082FF"
	nutriment_desc = list("backwash" = 1)
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/soup/mystery/Initialize()
	. = ..()
	switch(rand(1,10))
		if(1)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("capsaicin", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(2)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("frostoil", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(3)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("water", 5)
			reagents.add_reagent("tricordrazine", 5)
		if(4)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("water", 10)
		if(5)
			reagents.add_reagent("nutriment", 2)
			reagents.add_reagent("banana", 10)
		if(6)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("blood", 10)
		if(7)
			reagents.add_reagent("slimejelly", 10)
			reagents.add_reagent("water", 10)
		if(8)
			reagents.add_reagent("carbon", 10)
			reagents.add_reagent("toxin", 10)
		if(9)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("tomatojuice", 10)
		if(10)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("tomatojuice", 5)
			reagents.add_reagent("imidazoline", 5)

/obj/item/reagent_containers/food/snacks/soup/wish
	name = "wish soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	filling_color = "#D1F4FF"

/obj/item/reagent_containers/food/snacks/soup/wish/Initialize()
	. = ..()
	reagents.add_reagent("water", 10)
	if(prob(25))
		src.desc = "A wish come true!"
		reagents.add_reagent("nutriment", 8, list("something good" = 8))

/obj/item/reagent_containers/food/snacks/hotchili
	name = "hot chili"
	desc = "A five alarm Texan Chili!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FF3C00"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("chilli peppers" = 3)
	nutriment_amt = 3
	bitesize = 5

/obj/item/reagent_containers/food/snacks/hotchili/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 3)
	reagents.add_reagent("capsaicin", 3)
	reagents.add_reagent("tomatojuice", 2)

/obj/item/reagent_containers/food/snacks/coldchili
	name = "cold chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	filling_color = "#2B00FF"
	center_of_mass = list("x"=15, "y"=9)
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("ice peppers" = 3)
	nutriment_amt = 3
	bitesize = 5

/obj/item/reagent_containers/food/snacks/coldchili/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 3)
	reagents.add_reagent("frostoil", 3)
	reagents.add_reagent("tomatojuice", 2)

/obj/item/reagent_containers/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	flags = 0
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#ADAC7F"
	center_of_mass = list("x"=16, "y"=14)

	var/wrapped = 0
	var/monkey_type = "Monkey"

/obj/item/reagent_containers/food/snacks/monkeycube/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)

/obj/item/reagent_containers/food/snacks/monkeycube/afterattack(obj/O as obj, var/mob/living/carbon/human/user as mob, proximity)
	if(!proximity) return
	if(( istype(O, /obj/structure/reagent_dispensers/watertank) || istype(O,/obj/structure/sink) ) && !wrapped)
		to_chat(user, "You place \the [name] under a stream of water...")
		if(istype(user))
			user.unEquip(src)
		src.forceMove(get_turf(src))
		return Expand()
	..()

/obj/item/reagent_containers/food/snacks/monkeycube/attack_self(mob/user as mob)
	if(wrapped)
		Unwrap(user)

/obj/item/reagent_containers/food/snacks/monkeycube/proc/Expand()
	src.visible_message(span("notice", "\The [src] expands!"))
	if(istype(loc, /obj/item/gripper)) // fixes ghost cube when using syringe
		var/obj/item/gripper/G = loc
		G.drop_item()
	var/mob/living/carbon/human/H = new(src.loc)
	H.set_species(monkey_type)
	H.real_name = H.species.get_random_name()
	H.name = H.real_name
	src.forceMove(null)
	qdel(src)
	return 1

/obj/item/reagent_containers/food/snacks/monkeycube/proc/Unwrap(mob/user as mob)
	icon_state = "monkeycube"
	desc = "Just add water!"
	to_chat(user, "You unwrap the cube.")
	wrapped = 0
	return

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	wrapped = 1

/obj/item/reagent_containers/food/snacks/monkeycube/farwacube
	name = "farwa cube"
	monkey_type = "Farwa"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube
	name = "farwa cube"
	monkey_type = "Farwa"

/obj/item/reagent_containers/food/snacks/monkeycube/stokcube
	name = "stok cube"
	monkey_type = "Stok"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube
	name = "stok cube"
	monkey_type = "Stok"

/obj/item/reagent_containers/food/snacks/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type = "Neaera"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube
	name = "neaera cube"
	monkey_type = "Neaera"

/obj/item/reagent_containers/food/snacks/monkeycube/vkrexicube
	name = "v'krexi cube"
	monkey_type = "V'krexi"

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/vkrexicube
	name = "v'krexi cube"
	monkey_type = "V'krexi"


/obj/item/reagent_containers/food/snacks/burger/spell
	name = "spell burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	filling_color = "#D505FF"
	nutriment_desc = list("magic" = 3, "buns" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/bigbite
	name = "big bite burger"
	desc = "Forget the Big Mac. THIS is the future!"
	icon_state = "bigbiteburger"
	filling_color = "#E3D681"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("buns" = 4)
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/burger/bigbite/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)

/obj/item/reagent_containers/food/snacks/enchiladas
	name = "enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#A36A1F"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_desc = list("tortilla" = 3, "corn" = 3)
	nutriment_amt = 2
	bitesize = 4

/obj/item/reagent_containers/food/snacks/enchiladas/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("capsaicin", 6)

/obj/item/reagent_containers/food/snacks/monkeysdelight
	name = "monkey's delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5C3C11"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/monkeysdelight/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	reagents.add_reagent("banana", 5)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_containers/food/snacks/baguette
	name = "baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
	filling_color = "#E3D796"
	center_of_mass = list("x"=18, "y"=12)
	nutriment_desc = list("french bread" = 6)
	nutriment_amt = 6
	bitesize = 3

/obj/item/reagent_containers/food/snacks/baguette/Initialize()
	. = ..()
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_containers/food/snacks/fishandchips
	name = "fish and chips"
	desc = "I do say so myself chap."
	icon_state = "fishandchips"
	filling_color = "#E3D796"
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("salt" = 1, "chips" = 3)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fishandchips/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 3)
	reagents.add_reagent("carpotoxin", 3)

/obj/item/reagent_containers/food/snacks/sandwich
	name = "sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	center_of_mass = list("x"=16, "y"=4)
	nutriment_desc = list("bread" = 3, "cheese" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sandwich/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/toastedsandwich
	name = "toasted sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	center_of_mass = list("x"=16, "y"=4)
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/toastedsandwich/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("carbon", 2)

/obj/item/reagent_containers/food/snacks/grilledcheese
	name = "grilled cheese sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/grilledcheese/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/soup/tomato
	name = "tomato soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	filling_color = "#D92929"
	nutriment_amt = 5
	bitesize = 3

/obj/item/reagent_containers/food/snacks/soup/tomato/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 10)

/obj/item/reagent_containers/food/snacks/soup/bluespace
	name = "bluespace tomato soup"
	desc = "A scientific experiment turned into a possibly unsafe meal."
	icon_state = "spiral_soup"
	filling_color = "#0066FF"
	nutriment_amt = 5
	bitesize = 3

/obj/item/reagent_containers/food/snacks/soup/bluespace/Initialize()
	. = ..()
	reagents.add_reagent("bluespace_dust", 5)

/obj/item/reagent_containers/food/snacks/rofflewaffles
	name = "roffle waffles"
	desc = "Waffles from Roffle. Co."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	drop_sound = 'sound/items/trayhit1.ogg'
	filling_color = "#FF00F7"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_desc = list("waffle" = 7, "sweetness" = 1)
	nutriment_amt = 8
	bitesize = 4

/obj/item/reagent_containers/food/snacks/rofflewaffles/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 8)

/obj/item/reagent_containers/food/snacks/stew
	name = "stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	trash = /obj/item/trash/stew
	drop_sound = 'sound/items/drop/shovel.ogg'
	filling_color = "#9E673A"
	center_of_mass = list("x"=16, "y"=5)
	nutriment_desc = list("potato" = 2, "carrot" = 2, "eggplant" = 2, "mushroom" = 2)
	nutriment_amt = 6
	bitesize = 10
	is_liquid = TRUE

/obj/item/reagent_containers/food/snacks/stew/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("imidazoline", 5)
	reagents.add_reagent("water", 5)

/obj/item/reagent_containers/food/snacks/jelliedtoast
	name = "jellied toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "jellytoast"
	trash = /obj/item/trash/plate
	filling_color = "#B572AB"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_desc = list("toasted bread" = 2)
	nutriment_amt = 1
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jelliedtoast/cherry

/obj/item/reagent_containers/food/snacks/jelliedtoast/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/jelliedtoast/slime

/obj/item/reagent_containers/food/snacks/jelliedtoast/slime/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/burger/jelly
	name = "jelly burger"
	desc = "Culinary delight..?"
	icon_state = "jellyburger"
	filling_color = "#B572AB"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("buns" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/jelly/slime

/obj/item/reagent_containers/food/snacks/burger/jelly/slime/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/burger/jelly/cherry

/obj/item/reagent_containers/food/snacks/burger/jelly/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/soup/milo
	name = "milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	nutriment_desc = list("soy" = 8)
	nutriment_amt = 8
	bitesize = 4

/obj/item/reagent_containers/food/snacks/soup/milo/Initialize()
	. = ..()
	reagents.add_reagent("water", 5)

/obj/item/reagent_containers/food/snacks/stewedsoymeat
	name = "stewed soy meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("soy" = 4, "tomato" = 4)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledspagetti
	name = "boiled spaghetti"
	desc = "A plain dish of noodles, this sucks."
	icon_state = "spagettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledrice
	name = "boiled rice"
	desc = "A boring dish of boring rice."
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_desc = list("rice" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ricepudding
	name = "rice pudding"
	desc = "Where's the jam?"
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_desc = list("rice" = 2)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pudding
	name = "figgy pudding"
	icon_state = "pudding"
	desc = "Bring it to me."
	trash = /obj/item/trash/plate
	filling_color = "#FFFEE0"
	nutriment_desc = list("fruit cake" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pastatomato
	name = "spaghetti"
	desc = "Spaghetti and crushed tomatoes. Just like your abusive father used to make!"
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("tomato" = 3, "noodles" = 3)
	nutriment_amt = 6
	bitesize = 4

/obj/item/reagent_containers/food/snacks/pastatomato/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 10)

/obj/item/reagent_containers/food/snacks/meatballspagetti
	name = "spaghetti and meatballs"
	desc = "Now thats a nic'e meatball!"
	icon_state = "meatballspagetti"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("noodles" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatballspagetti/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/spesslaw
	name = "spesslaw"
	desc = "A lawyers favourite."
	icon_state = "spesslaw"
	filling_color = "#DE4545"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("noodles" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spesslaw/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/carrotfries
	name = "carrot fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#FAA005"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("carrot" = 3, "salt" = 1)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/carrotfries/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 3)

/obj/item/reagent_containers/food/snacks/burger/superbite
	name = "super bite burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	filling_color = "#CCA26A"
	center_of_mass = list("x"=16, "y"=3)
	nutriment_desc = list("buns" = 25)
	nutriment_amt = 25
	bitesize = 10

/obj/item/reagent_containers/food/snacks/burger/superbite/Initialize()
	. = ..()
	reagents.add_reagent("protein", 25)

/obj/item/reagent_containers/food/snacks/candiedapple
	name = "candied apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	filling_color = "#F21873"
	center_of_mass = list("x"=15, "y"=13)
	nutriment_desc = list("apple" = 3, "caramel" = 3, "sweetness" = 2)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/applepie
	name = "apple pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon_state = "applepie"
	filling_color = "#E0EDC5"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_desc = list("sweetness" = 2, "apple" = 2, "pie" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cherrypie
	name = "cherry pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	filling_color = "#FF525A"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("sweetness" = 2, "cherry" = 2, "pie" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/twobread
	name = "two bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	filling_color = "#DBCC9A"
	center_of_mass = list("x"=15, "y"=12)
	nutriment_desc = list("sourness" = 2, "bread" = 2)
	nutriment_amt = 2
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jellysandwich
	name = "jelly sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9E3A78"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_desc = list("bread" = 2)
	nutriment_amt = 2
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jellysandwich/slime

/obj/item/reagent_containers/food/snacks/jellysandwich/slime/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/jellysandwich/cherry

/obj/item/reagent_containers/food/snacks/jellysandwich/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/mint
	name = "mint"
	desc = "It is only wafer thin."
	icon_state = "mint"
	filling_color = "#F2F2F2"
	center_of_mass = list("x"=16, "y"=14)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/mint/Initialize()
	. = ..()
	reagents.add_reagent("mint", 1)

/obj/item/reagent_containers/food/snacks/mint/admints
	desc = "Spearmint, peppermint's non-festive cousin."
	icon_state = "admint"

/obj/item/storage/box/admints
	name = "Ad-mints"
	desc = "A pack of air fresheners for your mouth."
	icon = 'icons/obj/food.dmi'
	icon_state = "admint_pack"
	item_state = "candy"
	slot_flags = SLOT_EARS
	w_class = 1
	starts_with = list(/obj/item/reagent_containers/food/snacks/mint/admints = 6)
	can_hold = list(/obj/item/reagent_containers/food/snacks/mint/admints)
	use_sound = 'sound/items/drop/paper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	max_storage_space = 6
	foldable = null

/obj/item/reagent_containers/food/snacks/soup/mushroom
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	filling_color = "#E386BF"
	nutriment_desc = list("mushroom" = 8, "milk" = 2)
	nutriment_amt = 8
	bitesize = 3

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced dwarven wheat flour."
	icon_state = "phelmbiscuit"
	filling_color = "#CFB4C4"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_desc = list("mushroom" = 4)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump helmet biscuit"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("tricordrazine", 5)

/obj/item/reagent_containers/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F0F2E4"
	center_of_mass = list("x"=17, "y"=10)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/chawanmushi/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)

/obj/item/reagent_containers/food/snacks/soup/beet
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	filling_color = "#FAC9FF"
	nutriment_desc = list("tomato" = 4, "beet" = 4)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soup/beet/Initialize()
	. = ..()
	name = pick(list("borsch","bortsch","borstch","borsh","borshch","borscht"))

/obj/item/reagent_containers/food/snacks/salad/tossedsalad
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_desc = list("salad" = 2, "tomato" = 2, "carrot" = 2, "apple" = 2)
	nutriment_amt = 8
	bitesize = 3

/obj/item/reagent_containers/food/snacks/salad/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_desc = list("potato" = 4, "herbs" = 4)
	nutriment_amt = 6
	bitesize = 3

/obj/item/reagent_containers/food/snacks/salad/validsalad/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = "#FFFF00"
	center_of_mass = list("x"=16, "y"=18)
	nutriment_desc = list("apple" = 8)
	nutriment_amt = 8
	bitesize = 3

/obj/item/reagent_containers/food/snacks/appletart/Initialize()
	. = ..()
	reagents.add_reagent("gold", 5)

/obj/item/reagent_containers/food/snacks/redcurry
	name = "red curry"
	gender = PLURAL
	desc = "A bowl of creamy red curry with meat and rice. This one looks savory."
	icon_state = "redcurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f73333"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_desc = list("rice" = 4, "curry" = 4)
	nutriment_amt = 8
	bitesize = 3

/obj/item/reagent_containers/food/snacks/redcurry/Initialize()
	. = ..()
	reagents.add_reagent("protein", 7)
	reagents.add_reagent("spacespice", 2)

/obj/item/reagent_containers/food/snacks/greencurry
	name = "green curry"
	gender = PLURAL
	desc = "A bowl of creamy green curry with tofu, hot peppers and rice. This one looks spicy!"
	icon_state = "greencurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#58b76c"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_desc = list("rice" = 2, "curry" = 4, "tofu" = 4)
	nutriment_amt = 8
	bitesize = 3

/obj/item/reagent_containers/food/snacks/greencurry/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 5)
	reagents.add_reagent("spacespice", 2)
	reagents.add_reagent("capsaicin", 2)

/obj/item/reagent_containers/food/snacks/yellowcurry
	name = "yellow curry"
	gender = PLURAL
	desc = "A bowl of creamy yellow curry with potatoes, peanuts and rice. This one looks mild."
	icon_state = "yellowcurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#bc9509"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_desc = list("rice" = 2, "curry" = 2, "potato" = 2, "peanut" = 2)
	nutriment_amt = 8
	bitesize = 3

/obj/item/reagent_containers/food/snacks/yellowcurry/Initialize()
	. = ..()
	reagents.add_reagent("spacespice", 2)

/obj/item/reagent_containers/food/snacks/burger/bear
	name = "bearburger"
	desc = "The solution to your unbearable hunger."
	icon_state = "bearburger"
	filling_color = "#5d5260"
	center_of_mass = list("x"=15, "y"=11)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/burger/bear/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	reagents.add_reagent("hyperzine", 5)

/obj/item/reagent_containers/food/snacks/bearchili
	name = "bear chili"
	gender = PLURAL
	desc = "A dark, hearty chili. Can you bear the heat?"
	icon_state = "bearchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#702708"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("chilli peppers" = 3)
	nutriment_amt = 3
	bitesize = 5

/obj/item/reagent_containers/food/snacks/bearchili/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("capsaicin", 3)
	reagents.add_reagent("tomatojuice", 2)
	reagents.add_reagent("hyperzine", 5)

/obj/item/reagent_containers/food/snacks/stew/bear
	name = "bear stew"
	gender = PLURAL
	desc = "A thick, dark stew of bear meat and vegetables."
	icon_state = "bearstew"
	nutriment_desc = list("mushroom" = 2, "potato" = 2, "carrot" = 2)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/stew/bear/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("hyperzine", 5)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("imidazoline", 5)
	reagents.add_reagent("water", 5)

/obj/item/reagent_containers/food/snacks/bibimbap
	name = "bibimbap bowl"
	desc = "A traditional Korean meal of meat and mixed vegetables. It's served on a bed of rice, and topped with a fried egg."
	icon_state = "bibimbap"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#4f2100"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("rice" = 2, "mushroom" = 2, "carrot" = 2)
	nutriment_amt = 6
	bitesize = 4

/obj/item/reagent_containers/food/snacks/bibimbap/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("imidazoline", 3)
	reagents.add_reagent("spacespice", 2)
	reagents.add_reagent("egg", 3)

/obj/item/reagent_containers/food/snacks/lomein
	name = "lo mein"
	gender = PLURAL
	desc = "A popular Chinese noodle dish. Chopsticks optional."
	icon_state = "lomein"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("rice" = 2, "mushroom" = 2, "cabbage" = 2)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/lomein/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	reagents.add_reagent("carrotjuice", 3)
	reagents.add_reagent("imidazoline", 1)

/obj/item/reagent_containers/food/snacks/friedrice
	name = "fried rice"
	gender = PLURAL
	desc = "A less-boring dish of less-boring rice!"
	icon_state = "friedrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_desc = list("soy" = 2,)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/friedrice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 5)
	reagents.add_reagent("carrotjuice", 3)
	reagents.add_reagent("imidazoline", 1)

/obj/item/reagent_containers/food/snacks/chickenfillet
	name = "chicken fillet sandwich"
	desc = "Fried chicken, in sandwich format. Beauty is simplicity."
	icon_state = "chickenfillet"
	filling_color = "#E9ADFF"
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("buns" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/chickenfillet/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)

/obj/item/reagent_containers/food/snacks/chilicheesefries
	name = "chili cheese fries"
	gender = PLURAL
	desc = "A mighty plate of fries, drowned in hot chili and cheese sauce. Because your arteries are overrated."
	icon_state = "chilicheesefries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("fresh fries" = 4, "cheese" = 2, "chilli peppers" = 2)
	nutriment_amt = 8
	bitesize = 4

/obj/item/reagent_containers/food/snacks/chilicheesefries/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)
	reagents.add_reagent("capsaicin", 2)

/obj/item/reagent_containers/food/snacks/friedmushroom
	name = "fried mushroom"
	desc = "A tender, beer-battered plump helmet, fried to crispy perfection."
	icon_state = "friedmushroom"
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("fried mushroom" = 4)
	nutriment_amt = 4
	bitesize = 5

/obj/item/reagent_containers/food/snacks/friedmushroom/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/pisanggoreng
	name = "pisang goreng"
	gender = PLURAL
	desc = "Crispy, starchy, sweet banana fritters. Popular street food in parts of Sol."
	icon_state = "pisanggoreng"
	trash = /obj/item/trash/plate
	filling_color = "#301301"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("fried bananas" = 4)
	nutriment_amt = 8
	bitesize = 3

/obj/item/reagent_containers/food/snacks/meatbun
	name = "meat bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with a spiced meat filling."
	icon_state = "meatbun"
	filling_color = "#edd7d7"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("buns" = 2, "spices" = 2)
	nutriment_amt = 5
	bitesize = 5

/obj/item/reagent_containers/food/snacks/meatbun/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/custardbun
	name = "custard bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with an egg custard."
	icon_state = "meatbun"
	filling_color = "#ebedc2"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("buns" = 2, "spices" = 2)
	nutriment_amt = 6
	bitesize = 6

/obj/item/reagent_containers/food/snacks/custardbun/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/chickenmomo
	name = "chicken momo"
	gender = PLURAL
	desc = "A plate of spiced and steamed chicken dumplings. The style originates from south Asia."
	icon_state = "momo"
	trash = /obj/item/trash/snacktray
	filling_color = "#edd7d7"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("buns" = 4)
	nutriment_amt = 9
	bitesize = 3

/obj/item/reagent_containers/food/snacks/chickenmomo/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("spacespice", 2)

/obj/item/reagent_containers/food/snacks/veggiemomo
	name = "veggie momo"
	gender = PLURAL
	desc = "A plate of spiced and steamed vegetable dumplings. The style originates from south Asia."
	icon_state = "momo"
	trash = /obj/item/trash/snacktray
	filling_color = "#edd7d7"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("buns" = 2, "cabbage" = 4)
	nutriment_amt = 13
	bitesize = 3

/obj/item/reagent_containers/food/snacks/veggiemomo/Initialize()
	. = ..()
	reagents.add_reagent("spacespice", 4)
	reagents.add_reagent("carrotjuice", 3)
	reagents.add_reagent("imidazoline", 1)

/obj/item/reagent_containers/food/snacks/risotto
	name = "risotto"
	gender = PLURAL
	desc = "A creamy, savory rice dish from southern Europe, typically cooked slowly with wine and broth. This one has bits of mushroom."
	icon_state = "risotto"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#edd7d7"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("rich" = 2, "spices" = 2, "mushroom" = 4)
	nutriment_amt = 9
	bitesize = 2

/obj/item/reagent_containers/food/snacks/risotto/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)

/obj/item/reagent_containers/food/snacks/risottoballs
	name = "risotto balls"
	gender = PLURAL
	desc = "Mushroom risotto that has been battered and deep fried. The best use of leftovers!"
	icon_state = "risottoballs"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#edd7d7"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("spices" = 2, "mushroom" = 2)
	nutriment_amt = 2
	bitesize = 3

/obj/item/reagent_containers/food/snacks/risottoballs/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchlorid", 1)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("rice", 4)

/obj/item/reagent_containers/food/snacks/honeytoast
	name = "piece of honeyed toast"
	desc = "For those who like their breakfast sweet."
	icon_state = "honeytoast"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 3)
	nutriment_amt = 1
	bitesize = 4

/obj/item/reagent_containers/food/snacks/honeytoast/Initialize()
	. = ..()
	reagents.add_reagent("honey", 2)

/obj/item/reagent_containers/food/snacks/poachedegg
	name = "poached egg"
	desc = "A delicately poached egg with a runny yolk. Healthier than its fried counterpart."
	icon_state = "poachedegg"
	trash = /obj/item/trash/plate
	filling_color = "#FFDF78"
	center_of_mass = list("x"=16, "y"=14)
	nutriment_desc = list("egg" = 3)
	nutriment_amt = 1
	bitesize = 2

/obj/item/reagent_containers/food/snacks/poachedegg/Initialize()
	. = ..()
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_containers/food/snacks/ribplate
	name = "plate of ribs"
	desc = "A half-rack of ribs, brushed with some sort of honey-glaze. Why are there no napkins on board?"
	icon_state = "ribplate"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/ribplate/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("honey", 5)


/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/reagent_containers/food/snacks/sliceable
	w_class = 3 //Whole pizzas and cakes shouldn't fit in a pocket, you can slice them if you want to do that.

/obj/item/reagent_containers/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman."
	icon_state = "meatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/meatbreadslice
	slices_num = 5
	filling_color = "#FF7575"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/meatbread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 20)

/obj/item/reagent_containers/food/snacks/meatbreadslice
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FF7575"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/snacks/meatbreadslice/filled
	nutriment_desc = list("bread" = 5)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatbreadslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("nutriment", 2)

/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/xenomeatbreadslice
	slices_num = 5
	filling_color = "#8AFF75"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 20)

/obj/item/reagent_containers/food/snacks/xenomeatbreadslice
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8AFF75"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/snacks/xenomeatbreadslice/filled
	nutriment_desc = list("bread" = 5)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/xenomeatbreadslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/sliceable/bananabread
	name = "banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/reagent_containers/food/snacks/bananabreadslice
	slices_num = 5
	filling_color = "#EDE5AD"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 20
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/bananabread/Initialize()
	. = ..()
	reagents.add_reagent("banana", 20)

/obj/item/reagent_containers/food/snacks/bananabreadslice
	name = "banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/snacks/bananabreadslice/filled
	nutriment_desc = list("bread" = 5)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bananabreadslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("banana", 4)

/obj/item/reagent_containers/food/snacks/sliceable/tofubread
	name = "tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/reagent_containers/food/snacks/tofubreadslice
	slices_num = 5
	filling_color = "#F7FFE0"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("tofu" = 10)
	nutriment_amt = 30
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tofubreadslice
	name = "tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#F7FFE0"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/snacks/tofubreadslice/filled
	nutriment_desc = list("tofu" = 5)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/cake/carrot
	name = "carrot cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/carrot
	slices_num = 5
	filling_color = "#FFD675"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "carrot" = 15)
	nutriment_amt = 25
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/cake/carrot/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 10)

/obj/item/reagent_containers/food/snacks/cakeslice/carrot
	name = "carrot cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD675"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/carrot/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "carrot" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cakeslice/carrot/filled/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 1)

/obj/item/reagent_containers/food/snacks/sliceable/cake/brain
	name = "brain cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/brain
	slices_num = 5
	filling_color = "#E6AEDB"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "slime" = 15)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/cake/brain/Initialize()
	. = ..()
	reagents.add_reagent("protein", 25)
	reagents.add_reagent("alkysine", 10)

/obj/item/reagent_containers/food/snacks/cakeslice/brain
	name = "brain cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#E6AEDB"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/cakeslice/brain/filled
	nutriment_desc = list("cake" = 2, "sweetness" = 2, "slime" = 3)
	nutriment_amt = 1
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cakeslice/brain/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	reagents.add_reagent("alkysine", 2)

/obj/item/reagent_containers/food/snacks/sliceable/cake/cheese
	name = "cheese cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/cheese
	slices_num = 5
	filling_color = "#FAF7AF"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "cream" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/cake/cheese/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 15)

/obj/item/reagent_containers/food/snacks/cakeslice/cheese
	name = "cheese cake slice"
	desc = "Slice of pure cheestisfaction"
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAF7AF"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/cheese/filled
	nutriment_desc = list("cake" = 5, "cream" = 5)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cakeslice/cheese/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)

/obj/item/reagent_containers/food/snacks/sliceable/cake/plain
	name = "vanilla cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/plain
	slices_num = 5
	filling_color = "#F7EDD5"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "vanilla" = 15)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/sliceable/cake/plain/Initialize()
	. = ..()

/obj/item/reagent_containers/food/snacks/cakeslice/plain
	name = "vanilla cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#F7EDD5"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/plain/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "vanilla" = 5)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/sliceable/cake/orange
	name = "orange cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/orange
	slices_num = 5
	filling_color = "#FADA8E"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "orange" = 15)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/cakeslice/orange
	name = "orange cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FADA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/orange/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "orange" = 5)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/sliceable/cake/lime
	name = "lime cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/lime
	slices_num = 5
	filling_color = "#CBFA8E"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lime" = 15)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/cakeslice/lime
	name = "lime cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#CBFA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/lime/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "lime" = 5)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/sliceable/cake/lemon
	name = "lemon cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/lemon
	slices_num = 5
	filling_color = "#FAFA8E"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lemon" = 15)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/cakeslice/lemon
	name = "lemon cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAFA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/lemon/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "lemon" = 5)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/sliceable/cake/chocolate
	name = "chocolate cake"
	desc = "A cake with added chocolate."
	icon_state = "chocolatecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/chocolate
	slices_num = 5
	filling_color = "#805930"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "chocolate" = 15)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/cakeslice/chocolate
	name = "chocolate cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/chocolate/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "chocolate" = 5)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	name = "cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge
	slices_num = 8
	filling_color = "#FFF700"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 20)

/obj/item/reagent_containers/food/snacks/cheesewedge
	name = "cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	filling_color = "#FFF700"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/snacks/cheesewedge/filled

/obj/item/reagent_containers/food/snacks/cheesewedge/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)

/obj/item/reagent_containers/food/snacks/sliceable/cake/birthday
	name = "birthday cake"
	desc = "Happy Birthday..."
	icon_state = "birthdaycake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/birthday
	slices_num = 5
	filling_color = "#FFD6D6"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10)
	nutriment_amt = 20
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sliceable/cake/birthday/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 10)

/obj/item/reagent_containers/food/snacks/cakeslice/birthday
	name = "birthday cake slice"
	desc = "A slice of your birthday."
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD6D6"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/birthdaye/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5)
	nutriment_amt = 4
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cakeslice/birthday/filled/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/sliceable/bread
	name = "bread"
	icon_state = "Some plain old Earthen bread."
	icon_state = "bread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice
	slices_num = 8
	filling_color = "#FFE396"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 6)
	nutriment_amt = 15
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/bread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)

/obj/item/reagent_containers/food/snacks/breadslice
	name = "bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#D27332"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/snacks/breadslice/filled
	nutriment_desc = list("bread" = 2)
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread
	name = "cream cheese bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/reagent_containers/food/snacks/creamcheesebreadslice
	slices_num = 5
	filling_color = "#FFF896"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 6, "cream" = 3)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 15)

/obj/item/reagent_containers/food/snacks/creamcheesebreadslice
	name = "cream cheese bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFF896"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/snacks/creamcheesebreadslice/filled
	nutriment_desc = list("bread" = 3, "cream" = 2)
	nutriment_amt = 1
	bitesize = 2

/obj/item/reagent_containers/food/snacks/creamcheesebreadslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)

/obj/item/reagent_containers/food/snacks/watermelonslice
	name = "watermelon slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	filling_color = "#FF3867"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/snacks/watermelonslice/filled
	nutriment_desc = list("watermelon" = 2)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/sliceable/cake/apple
	name = "apple cake"
	desc = "A cake centred with apples."
	icon_state = "applecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/apple
	slices_num = 5
	filling_color = "#EBF5B8"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "apple" = 15)
	nutriment_amt = 15

/obj/item/reagent_containers/food/snacks/cakeslice/apple
	name = "apple cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#EBF5B8"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/apple/filled
	nutriment_desc = list("cake" = 5, "sweetness" = 5, "apple" = 5)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	name = "pumpkin pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/reagent_containers/food/snacks/pumpkinpieslice
	slices_num = 5
	filling_color = "#F5B951"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("pie" = 5, "cream" = 5, "pumpkin" = 5)
	nutriment_amt = 15

/obj/item/reagent_containers/food/snacks/pumpkinpieslice
	name = "pumpkin pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/pumpkinpieslice/filled
	nutriment_desc = list("pie" = 2, "cream" = 2, "pumpkin" = 2)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/cracker
	name = "cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	filling_color = "#F5DEB8"
	center_of_mass = list("x"=17, "y"=6)
	nutriment_desc = list("salt" = 1, "cracker" = 2)
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	name = "key lime pie"
	desc = "A tart, sweet dessert. What's a key lime, anyway?"
	icon_state = "keylimepie"
	slice_path = /obj/item/reagent_containers/food/snacks/keylimepieslice
	slices_num = 5
	filling_color = "#F5B951"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("pie" = 10, "cream" = 10, "lime" = 15)
	nutriment_amt = 16

/obj/item/reagent_containers/food/snacks/keylimepieslice
	name = "slice of key lime pie"
	desc = "A slice of tart pie, with whipped cream on top."
	icon_state = "keylimepieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/keylimepieslice/filled
	nutriment_desc = list("pie" = 5, "cream" = 5, "lime" = 5)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/sliceable/quiche
	name = "quiche"
	desc = "Real men eat this, contrary to popular belief."
	icon_state = "quiche"
	slice_path = /obj/item/reagent_containers/food/snacks/quicheslice
	slices_num = 5
	filling_color = "#F5B951"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("pie" = 5, "cheese" = 5)
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/sliceable/quiche/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 10)

/obj/item/reagent_containers/food/snacks/quicheslice
	name = "slice of quiche"
	desc = "A slice of delicious quiche. Eggy, cheesy goodness."
	icon_state = "quicheslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/quicheslice/filled
	nutriment_desc = list("pie" = 2)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/quicheslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)

/obj/item/reagent_containers/food/snacks/sliceable/brownies
	name = "brownies"
	gender = PLURAL
	desc = "Halfway to fudge, or halfway to cake? Who cares!"
	icon_state = "brownies"
	slice_path = /obj/item/reagent_containers/food/snacks/browniesslice
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#301301"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("brownies" = 5)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/brownies/Initialize()
	. = ..()
	reagents.add_reagent("browniemix", 2)

/obj/item/reagent_containers/food/snacks/browniesslice
	name = "brownie"
	desc = "a dense, decadent chocolate brownie."
	icon_state = "browniesslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/browniesslice/filled
	nutriment_desc = list("brownies" = 2)
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/browniesslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("browniemix", 1)

/obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies
	name = "cosmic brownies"
	gender = PLURAL
	desc = "Like, ultra-trippy. Brownies HAVE no gender, man." //Except I had to add one!
	icon_state = "cosmicbrownies"
	slice_path = /obj/item/reagent_containers/food/snacks/cosmicbrowniesslice
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#301301"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("brownies" = 5)
	nutriment_amt = 8
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies/Initialize()
	. = ..()
	reagents.add_reagent("browniemix", 4)
	reagents.add_reagent("space_drugs", 4)
	reagents.add_reagent("bicaridine", 2)
	reagents.add_reagent("kelotane", 2)
	reagents.add_reagent("toxin", 2)

/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice
	name = "cosmic brownie slice"
	desc = "A dense, decadent and fun-looking chocolate brownie."
	icon_state = "cosmicbrowniesslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice/filled
	nutriment_desc = list("brownies" = 2)
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("browniemix", 1)
	reagents.add_reagent("space_drugs", 1)
	reagents.add_reagent("bicaridine", 1)
	reagents.add_reagent("kelotane", 1)
	reagents.add_reagent("toxin", 1)

/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/sliceable/pizza
	slices_num = 6
	filling_color = "#BAA14C"

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "margherita"
	desc = "The golden standard of pizzas."
	icon_state = "pizzamargherita"
	slice_path = /obj/item/reagent_containers/food/snacks/margheritaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10)
	nutriment_amt = 35
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 5)
	reagents.add_reagent("tomatojuice", 6)

/obj/item/reagent_containers/food/snacks/margheritaslice
	name = "margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/margheritaslice/filled
	nutriment_desc = list("pizza crust" = 5, "tomato" = 5)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/margheritaslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 1)
	reagents.add_reagent("tomatojuice", 2)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "meatpizza"
	desc = "A pizza with meat topping."
	icon_state = "meatpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/meatpizzaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza/Initialize()
	. = ..()
	reagents.add_reagent("protein", 44)
	reagents.add_reagent("cheese", 10)
	reagents.add_reagent("tomatojuice", 6)

/obj/item/reagent_containers/food/snacks/meatpizzaslice
	name = "meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/meatpizzaslice/filled
	nutriment_desc = list("pizza crust" = 5, "tomato" = 5)
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/meatpizzaslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 7)
	reagents.add_reagent("cheese", 2)
	reagents.add_reagent("tomatojuice", 2)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	name = "mushroompizza"
	desc = "Very special pizza."
	icon_state = "mushroompizza"
	slice_path = /obj/item/reagent_containers/food/snacks/mushroompizzaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "mushroom" = 10)
	nutriment_amt = 35
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 5)

/obj/item/reagent_containers/food/snacks/mushroompizzaslice
	name = "mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/mushroompizzaslice/filled
	nutriment_desc = list("pizza crust" = 5, "tomato" = 5, "mushroom" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/mushroompizzaslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 1)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "vegetable pizza"
	desc = "No one of Tomato Sapiens were harmed during making this pizza."
	icon_state = "vegetablepizza"
	slice_path = /obj/item/reagent_containers/food/snacks/vegetablepizzaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "eggplant" = 5, "carrot" = 5, "corn" = 5)
	nutriment_amt = 25
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 6)
	reagents.add_reagent("imidazoline", 12)

/obj/item/reagent_containers/food/snacks/vegetablepizzaslice
	name = "vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon_state = "vegetablepizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/vegetablepizzaslice/filled
	nutriment_desc = list("pizza crust" = 5, "eggplant" = 5, "carrot" = 5, "corn" = 5)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/vegetablepizzaslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 2)
	reagents.add_reagent("imidazoline", 2)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	name = "pizza crunch"
	desc = "This was once a normal pizza, but it has been coated in batter and deep-fried. Whatever toppings it once had are a mystery, but they're still under there, somewhere..."
	icon_state = "pizzacrunch"
	slice_path = /obj/item/reagent_containers/food/snacks/pizzacrunchslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 15)
	nutriment_amt = 25
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch/Initialize()
	. = ..()
	reagents.add_reagent("batter", 6)
	coating = reagents.get_reagent("batter")
	reagents.add_reagent("oil", 4)

/obj/item/reagent_containers/food/snacks/pizzacrunchslice
	name = "pizza crunch"
	desc = "A little piece of a heart attack. It's toppings are a mystery, hidden under batter"
	icon_state = "pizzacrunchslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)
	nutriment_desc = list("pizza crust" = 5)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/pizzacrunchslice/Initialize()
	. = ..()
	reagents.add_reagent("batter", 2)
	coating = reagents.get_reagent("batter")
	reagents.add_reagent("oil", 1)

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food.dmi'
	icon_state = "pizzabox1"
	drop_sound = 'sound/items/drop/box.ogg'
	center_of_mass = list("x" = 16,"y" = 6)

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/reagent_containers/food/snacks/sliceable/pizza/pizza // Content pizza
	var/list/boxes = list() // If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/update_icon()
	cut_overlays()

	// Set appropriate description
	if( open && pizza )
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if( boxes.len > 0 )
		desc = "A pile of boxes suited for pizzas. There appears to be [boxes.len + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if( boxtag != "" )
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/image/pizzaimg = image(icon, icon_state = pizza.icon_state)
			pizzaimg.pixel_y = -3
			add_overlay(pizzaimg)

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( boxes.len > 0 )
			var/obj/item/pizzabox/topbox = boxes[boxes.len]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			var/image/tagimg = image(icon, icon_state = "pizzabox_tag")
			tagimg.pixel_y = boxes.len * 3
			add_overlay(tagimg)

	icon_state = "pizzabox[boxes.len+1]"

/obj/item/pizzabox/attack_hand( mob/user as mob )

	if( open && pizza )
		user.put_in_hands( pizza )

		to_chat(user, span("warning", "You take \the [src.pizza] out of \the [src]."))
		src.pizza = null
		update_icon()
		return

	if( boxes.len > 0 )
		if( user.get_inactive_hand() != src )
			..()
			return

		var/obj/item/pizzabox/box = boxes[boxes.len]
		boxes -= box

		user.put_in_hands( box )
		to_chat(user, span("warning", "You remove the topmost [src] from your hand."))
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self( mob/user as mob )

	if( boxes.len > 0 )
		return

	open = !open

	if( open && pizza )
		ismessy = 1

	update_icon()

/obj/item/pizzabox/attackby( obj/item/I as obj, mob/user as mob )
	if( istype(I, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = I

		if( !box.open && !src.open )
			// Make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if( (boxes.len+1) + boxestoadd.len <= 5 )
				user.drop_from_inventory(box,src)
				box.boxes = list() // Clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				to_chat(user, span("warning", "You put \the [box] ontop of \the [src]!"))
			else
				to_chat(user, span("warning", "The stack is too high!"))
		else
			to_chat(user, span("warning", "Close \the [box] first!"))

		return

	if( istype(I, /obj/item/reagent_containers/food/snacks/sliceable/pizza/) ) // Long ass fucking object name

		if( src.open )
			user.drop_from_inventory(I,src)
			src.pizza = I

			update_icon()

			to_chat(user, span("warning", "You put \the [I] in \the [src]!"))
		else
			to_chat(user, span("warning", "You try to push \the [I] through the lid but it doesn't work!"))
		return

	if( I.ispen() )

		if( src.open )
			return

		var/t = sanitize(input("Enter what you want to add to the tag:", "Write", null, null) as text, 30)

		var/obj/item/pizzabox/boxtotagto = src
		if( boxes.len > 0 )
			boxtotagto = boxes[boxes.len]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return
	..()

/obj/item/pizzabox/margherita/New()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/vegetable/New()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom/New()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat/New()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "Meatlover's Supreme"

/obj/item/reagent_containers/food/snacks/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon_state = "dionaroast"
	trash = /obj/item/trash/plate
	filling_color = "#75754B"
	center_of_mass = list("x"=16, "y"=7)
	nutriment_desc = list("salad" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/reagent_containers/food/snacks/dionaroast/Initialize()
	. = ..()

///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////
/obj/item/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	nutriment_desc = list("uncooked dough" = 3)
	nutriment_amt = 3

// Dough + rolling pin = flat dough
/obj/item/reagent_containers/food/snacks/dough/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/kitchen/rollingpin))
		new /obj/item/reagent_containers/food/snacks/sliceable/flatdough(src)
		to_chat(user, "You flatten the dough.")
		qdel(src)

// slicable into 3xdoughslices
/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/reagent_containers/food/snacks/doughslice
	slices_num = 3
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("uncooked dough" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "doughslice"
	slice_path = /obj/item/reagent_containers/food/snacks/spagetti
	slices_num = 1
	bitesize = 2
	center_of_mass = list("x"=17, "y"=19)
	nutriment_desc = list("uncooked dough" = 1)
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)
	nutriment_desc = list("bun" = 3)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/reagent_containers/food/snacks/result = null
	// Bun + meatball = burger
	if(istype(W,/obj/item/reagent_containers/food/snacks/meatball))
		result = new /obj/item/reagent_containers/food/snacks/burger/monkey(src)
		to_chat(user, "You make a burger.")

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/cutlet))
		result = new /obj/item/reagent_containers/food/snacks/burger/monkey(src)
		to_chat(user, "You make a burger.")

	//Bun + katsu = chickenfillet
	else if(istype(W,/obj/item/reagent_containers/food/snacks/chickenkatsu))
		result = new /obj/item/reagent_containers/food/snacks/chickenfillet(src)
		to_chat(user, "You make a chicken fillet sandwich.")

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/reagent_containers/food/snacks/sausage))
		result = new /obj/item/reagent_containers/food/snacks/hotdog(src)
		to_chat(user, "You make a hotdog.")

	else if(istype(W,/obj/item/reagent_containers/food/snacks/variable/mob))
		var/obj/item/reagent_containers/food/snacks/variable/mob/MF = W

		switch (MF.kitchen_tag)
			if ("rodent")
				result = new /obj/item/reagent_containers/food/snacks/burger/mouse(src)
				to_chat(user, "You make a ratburger!")

	if (result)
		if (W.reagents)
			//Reagents of reuslt objects will be the sum total of both.  Except in special cases where nonfood items are used
			//Eg robot head
			result.reagents.clear_reagents()
			W.reagents.trans_to(result, W.reagents.total_volume)
			reagents.trans_to(result, reagents.total_volume)

		//If the bun was in your hands, the result will be too
		if (loc == user)
			user.drop_from_inventory(src) //This has to be here in order to put the pun in the proper place
			user.put_in_hands(result)

		qdel(W)
		qdel(src)

// Burger + cheese wedge = cheeseburger
/obj/item/reagent_containers/food/snacks/burger/monkey/attackby(obj/item/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))// && !istype(src,/obj/item/reagent_containers/food/snacks/cheesewedge))
		new /obj/item/reagent_containers/food/snacks/burger/cheese(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Human Burger + cheese wedge = cheeseburger
/obj/item/reagent_containers/food/snacks/human/burger/attackby(obj/item/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))
		new /obj/item/reagent_containers/food/snacks/burger/cheese(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

/obj/item/reagent_containers/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	bitesize = 3
	center_of_mass = list("x"=21, "y"=12)
	nutriment_desc = list("taco shell with cheese")
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/taco/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1
	center_of_mass = list("x"=17, "y"=20)
	slice_path = /obj/item/reagent_containers/food/snacks/rawbacon
	slices_num = 2


/obj/item/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "cutlet"
	bitesize = 2
	center_of_mass = list("x"=17, "y"=20)

/obj/item/reagent_containers/food/snacks/cutlet/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawmeatball"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=15)

/obj/item/reagent_containers/food/snacks/rawmeatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Hot dog, you say? Commoners have resorted to eating dog now, how dreadful."
	icon_state = "hotdog"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=17)

/obj/item/reagent_containers/food/snacks/hotdog/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flatbread"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("bread" = 3)
	nutriment_amt = 3

// potato + knife = raw sticks
/obj/item/reagent_containers/food/snacks/grown/potato/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/kitchen/utensil/knife))
		new /obj/item/reagent_containers/food/snacks/rawsticks(src)
		to_chat(user, "You cut the potato.")
		qdel(src)
	else
		..()

/obj/item/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)
	nutriment_desc = list("uncooked potatos" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/liquidfood
	name = "LiquidFood ration"
	desc = "A prepackaged grey slurry of all the essential nutrients for a spacefarer on the go. Should this be crunchy? Now with artificial flavoring!"
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#A8A8A8"
	center_of_mass = list("x"=16, "y"=15)
	bitesize = 4
	is_liquid = TRUE

/obj/item/reagent_containers/food/snacks/liquidfood/Initialize()
	. = ..()
	set_flavor()
	reagents.add_reagent("nutriment", 9, list("[flavor]" = 9))
	reagents.add_reagent("nutriment", 1, list("chalk" = 1))
	reagents.add_reagent("iron", 3)

/obj/item/reagent_containers/food/snacks/liquidfood/set_flavor()
	flavor = pick("chocolate", "peanut butter cookie", "scrambled eggs", "beef taco", "tofu", "pizza", "spaghetti", "cheesy potatoes", "hamburger", "baked beans", "maple sausage", "chili macaroni", "veggie burger")
	. = ..()

/obj/item/reagent_containers/food/snacks/tastybread
	name = "bread tube"
	desc = "Bread in a tube. Chewy."
	icon_state = "tastybread"
	trash = /obj/item/trash/tastybread
	filling_color = "#A66829"
	center_of_mass = list("x"=17, "y"=16)
	nutriment_desc = list("stale bread" = 4)
	nutriment_type = NUTRIMENT_BAD
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/tastybread/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride",3)

/obj/item/reagent_containers/food/snacks/skrellsnacks
	name = "\improper SkrellSnax"
	desc = "Cured fungus shipped all the way from Jargon 4, almost like jerky! Almost."
	icon_state = "skrellsnacks"
	trash = /obj/item/trash/skrellsnacks
	filling_color = "#A66829"
	center_of_mass = list("x"=15, "y"=12)
	nutriment_desc = list("alien fungus" = 10)
	nutriment_type = NUTRIMENT_BAD
	nutriment_amt = 10
	bitesize = 3

/obj/item/reagent_containers/food/snacks/friedkois
	name = "fried k'ois"
	desc = "K'ois, freshly bathed in the radiation of a microwave."
	icon_state = "friedkois"
	filling_color = "#E6E600"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/friedkois/Initialize()
	. = ..()
	reagents.add_reagent("koispaste", 6)
	reagents.add_reagent("phoron", 9)

/obj/item/reagent_containers/food/snacks/friedkois/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/rods))
		new /obj/item/reagent_containers/food/snacks/koiskebab1(src)
		to_chat(user, "You skewer the fried k'ois.")
		qdel(src)
		qdel(W)
	if(istype(W,/obj/item/material/kitchen/rollingpin))
		new /obj/item/reagent_containers/food/snacks/soup/kois(src)
		to_chat(user, "You crush the fried K'ois into a paste, and pour it into a bowl.")
		qdel(src)

/obj/item/reagent_containers/food/snacks/koiskebab1
	name = "k'ois on a stick"
	desc = "It's K'ois. On a stick. It looks like you could fit more."
	icon_state = "koisbab1"
	trash = /obj/item/stack/rods
	filling_color = "#E6E600"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/koiskebab1/Initialize()
	. = ..()
	reagents.add_reagent("koispaste", 8)
	reagents.add_reagent("phoron", 12)

/obj/item/reagent_containers/food/snacks/koiskebab1/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks/friedkois))
		new /obj/item/reagent_containers/food/snacks/koiskebab2(src)
		to_chat(user, "You add fried K'ois to the kebab.")
		qdel(src)
		qdel(W)

/obj/item/reagent_containers/food/snacks/koiskebab2
	name = "k'ois on a stick"
	desc = "It's K'ois. On a stick. It looks like you could fit more."
	icon_state = "koisbab2"
	trash = /obj/item/stack/rods
	filling_color = "#E6E600"
	bitesize = 6

/obj/item/reagent_containers/food/snacks/koiskebab2/Initialize()
	. = ..()
	reagents.add_reagent("koispaste", 12)
	reagents.add_reagent("phoron", 16)

/obj/item/reagent_containers/food/snacks/koiskebab2/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_containers/food/snacks/friedkois))
		new /obj/item/reagent_containers/food/snacks/koiskebab3(src)
		to_chat(user, "You add fried K'ois to the kebab.")
		qdel(src)
		qdel(W)

/obj/item/reagent_containers/food/snacks/koiskebab3
	name = "k'ois on a stick"
	desc = "It's K'ois. On a stick. It doesn't look like you can fit anymore."
	icon_state = "koisbab3"
	trash = /obj/item/stack/rods
	filling_color = "#E6E600"
	bitesize = 9

/obj/item/reagent_containers/food/snacks/koiskebab3/Initialize()
	. = ..()
	reagents.add_reagent("koispaste", 16)
	reagents.add_reagent("phoron", 20)

/obj/item/reagent_containers/food/snacks/soup/kois
	name = "k'ois paste"
	desc = "A thick K'ois goop, piled into a bowl."
	icon_state = "koissoup"
	filling_color = "#4E6E600"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soup/kois/Initialize()
	. = ..()
	reagents.add_reagent("koispaste", 15)
	reagents.add_reagent("phoron", 15)

/obj/item/reagent_containers/food/snacks/koiswaffles
	name = "k'ois waffles"
	desc = "Rock-hard 'waffles' composed entirely of microwaved K'ois goop."
	icon_state = "koiswaffles"
	trash = /obj/item/trash/waffles
	drop_sound = 'sound/items/trayhit1.ogg'
	filling_color = "#E6E600"
	bitesize = 5

/obj/item/reagent_containers/food/snacks/koiswaffles/Initialize()
	. = ..()
	reagents.add_reagent("koispaste", 25)
	reagents.add_reagent("phoron", 15)

/obj/item/reagent_containers/food/snacks/koisjelly
	name = "k'ois jelly"
	desc = "Enriched K'ois paste, filled to the brim with the good stuff."
	icon_state = "koisjelly"
	filling_color = "#E6E600"
	bitesize = 5

/obj/item/reagent_containers/food/snacks/koisjelly/Initialize()
	. = ..()
	reagents.add_reagent("koispaste", 25)
	reagents.add_reagent("imidazoline", 20)
	reagents.add_reagent("phoron", 25)

//unathi snacks - sprites by Araskael

/obj/item/reagent_containers/food/snacks/meatsnack
	name = "mo'gunz meat pie"
	icon_state = "meatsnack"
	desc = "Made from stok meat, packed into a crispy crust."
	trash = /obj/item/trash/meatsnack
	filling_color = "#631212"
	nutriment_desc = list("pie crust" = 2)
	nutriment_type = NUTRIMENT_BAD
	nutriment_amt = 2
	bitesize = 5

/obj/item/reagent_containers/food/snacks/meatsnack/Initialize()
	. = ..()
	reagents.add_reagent("protein", 12)
	reagents.add_reagent("sodiumchloride",4)

/obj/item/reagent_containers/food/snacks/maps
	name = "maps salty ham"
	icon_state = "maps"
	desc = "Various processed meat from Moghes with 600% the amount of recommended daily sodium per can."
	trash = /obj/item/trash/maps
	filling_color = "#631212"
	nutriment_type = NUTRIMENT_BAD
	bitesize = 3

/obj/item/reagent_containers/food/snacks/maps/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("sodiumchloride", 6)

/obj/item/reagent_containers/food/snacks/nathisnack
	name = "razi-snack corned beef"
	icon_state = "cbeef"
	desc = "Delicious corned beef and preservatives. Imported from Earth, canned on Ourea."
	trash = /obj/item/trash/nathisnack
	nutriment_type = NUTRIMENT_BAD
	filling_color = "#631212"
	bitesize = 4

/obj/item/reagent_containers/food/snacks/nathisnack/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	reagents.add_reagent("iron", 3)
	reagents.add_reagent("sodiumchloride",6)

/obj/item/reagent_containers/food/snacks/pancakes
	name = "pancakes"
	desc = "Pancakes with berries, delicious."
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	center_of_mass = "x=15;y=11"
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/classichotdog
	name = "classic hotdog"
	desc = "Going literal."
	icon_state = "hotcorgi"
	center_of_mass = "x=16;y=17"
	bitesize = 6

/obj/item/reagent_containers/food/snacks/classichotdog/Initialize()
	. = ..()
	reagents.add_reagent("protein", 16)

/obj/item/reagent_containers/food/snacks/lasagna
	name = "lasagna"
	desc = "Favorite of cats."
	icon_state = "lasagna"
	trash = /obj/item/trash/grease
	drop_sound = 'sound/items/trayhit1.ogg'
	center_of_mass = list("x"=16, "y"=17)
	nutriment_amt = 12
	nutriment_desc = list("pasta" = 4, "tomato" = 2)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/lasagna/Initialize()
	. = ..()
	reagents.add_reagent("protein", 12)

/obj/item/reagent_containers/food/snacks/donerkebab
	name = "doner kebab"
	desc = "A delicious sandwich-like food from ancient Earth. The meat is typically cooked on a vertical rotisserie."
	icon_state = "doner_kebab"
	nutriment_amt = 5
	nutriment_desc = list("dough" = 4, "cabbage" = 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/donerkebab/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/sashimi
	name = "carp sashimi"
	desc = "A traditional human dish, recreated using space carp."
	icon_state = "sashimi"
	trash = /obj/item/trash/grease
	drop_sound = 'sound/items/trayhit1.ogg'
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/sashimi/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 3)
	reagents.add_reagent("carpotoxin", 3)

/obj/item/reagent_containers/food/snacks/nugget
	name = "chicken nugget"
	icon_state = "nugget_lump"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/nugget/Initialize()
	. = ..()
	var/shape = pick("lump", "star", "lizard", "corgi")
	desc = "A chicken nugget vaguely shaped like a [shape]."
	icon_state = "nugget_[shape]"
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/icecreamsandwich
	name = "ice cream sandwich"
	desc = "Portable ice cream in its own packaging."
	icon_state = "icecreamsandwich"
	filling_color = "#343834"
	center_of_mass = list("x"=15, "y"=4)
	nutriment_desc = list("ice cream" = 4)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/honeybun
	name = "honey bun"
	desc = "A sticky pastry bun glazed with honey."
	icon_state = "honeybun"
	nutriment_desc = list("pastry" = 1)
	nutriment_amt = 3
	bitesize = 3

/obj/item/reagent_containers/food/snacks/honeybun/Initialize()
	. = ..()
	reagents.add_reagent("honey", 3)

// Chip update.
/obj/item/reagent_containers/food/snacks/tortilla
	name = "tortilla"
	desc = "A thin, flour-based tortilla that can be used in a variety of dishes, or can be served as is."
	icon_state = "tortilla"
	bitesize = 3
	nutriment_desc = list("tortilla" = 1)
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 6

//chips
/obj/item/reagent_containers/food/snacks/chip
	name = "chip"
	desc = "A portion sized chip good for dipping."
	icon_state = "chip"
	var/bitten_state = "chip_half"
	bitesize = 1
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("nacho chips" = 1)
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/chip/on_consume(mob/M as mob)
	if(reagents && reagents.total_volume)
		icon_state = bitten_state
	. = ..()

/obj/item/reagent_containers/food/snacks/chip/salsa
	name = "salsa chip"
	desc = "A portion sized chip good for dipping. This one has salsa on it."
	icon_state = "chip_salsa"
	bitten_state = "chip_half"

/obj/item/reagent_containers/food/snacks/chip/guac
	name = "guac chip"
	desc = "A portion sized chip good for dipping. This one has guac on it."
	icon_state = "chip_guac"
	bitten_state = "chip_half"

/obj/item/reagent_containers/food/snacks/chip/cheese
	name = "cheese chip"
	desc = "A portion sized chip good for dipping. This one has cheese sauce on it."
	icon_state = "chip_cheese"
	bitten_state = "chip_half"

/obj/item/reagent_containers/food/snacks/chip/nacho
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos."
	icon_state = "chip_nacho"
	bitten_state = "chip_half"

/obj/item/reagent_containers/food/snacks/chip/nacho/salsa
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has salsa on it."
	icon_state = "chip_nacho_salsa"
	bitten_state = "chip_half"

/obj/item/reagent_containers/food/snacks/chip/nacho/guac
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has guac on it."
	icon_state = "chip_nacho_guac"
	bitten_state = "chip_half"

/obj/item/reagent_containers/food/snacks/chip/nacho/cheese
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has extra cheese on it."
	icon_state = "chip_nacho_cheese"
	bitten_state = "chip_half"

// chip plates
/obj/item/reagent_containers/food/snacks/chipplate
	name = "basket of chips"
	desc = "A plate of chips intended for dipping."
	icon_state = "chip_basket"
	trash = /obj/item/trash/chipbasket
	var/vendingobject = /obj/item/reagent_containers/food/snacks/chip
	nutriment_desc = list("tortilla chips" = 10)
	bitesize = 1
	nutriment_amt = 10
	var/unitname = "chip"

/obj/item/reagent_containers/food/snacks/chipplate/attack_hand(mob/user as mob)
	var/obj/item/reagent_containers/food/snacks/returningitem = new vendingobject(loc)
	returningitem.reagents.clear_reagents()
	reagents.trans_to(returningitem, bitesize)
	returningitem.bitesize = bitesize/2
	user.put_in_hands(returningitem)
	if (reagents && reagents.total_volume)
		to_chat(user, "You take a [unitname] from the plate.")
	else
		to_chat(user, "You take the last [unitname] from the plate.")
		var/obj/waste = new trash(loc)
		if (loc == user)
			user.put_in_hands(waste)
		qdel(src)

/obj/item/reagent_containers/food/snacks/chipplate/MouseDrop(mob/user) //Dropping the chip onto the user
	if(istype(user) && user == usr)
		user.put_in_active_hand(src)
		src.pickup(user)
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/chipplate/nachos
	name = "plate of nachos"
	desc = "A very cheesy nacho plate."
	icon_state = "nachos"
	trash = /obj/item/trash/plate
	vendingobject = /obj/item/reagent_containers/food/snacks/chip/nacho
	nutriment_desc = list("tortilla chips" = 10)
	bitesize = 1
	nutriment_amt = 10

//dips
/obj/item/reagent_containers/food/snacks/dip
	name = "queso dip"
	desc = "A simple, cheesy dip consisting of tomatos, cheese, and spices."
	var/nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/cheese
	var/chiptrans = /obj/item/reagent_containers/food/snacks/chip/cheese
	icon_state = "dip_cheese"
	trash = /obj/item/trash/dipbowl
	bitesize = 1
	nutriment_desc = list("queso" = 20)
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/dip/attackby(obj/item/reagent_containers/food/snacks/item as obj, mob/user as mob)
	. = ..()
	var/obj/item/reagent_containers/food/snacks/returningitem
	if(istype(item,/obj/item/reagent_containers/food/snacks/chip/nacho) && item.icon_state == "chip_nacho")
		returningitem = new nachotrans(src)
	else if (istype(item,/obj/item/reagent_containers/food/snacks/chip) && (item.icon_state == "chip" || item.icon_state == "chip_half"))
		returningitem = new chiptrans(src)
	if(returningitem)
		returningitem.reagents.clear_reagents() //Clear the new chip
		var/memed = 0
		item.reagents.trans_to(returningitem, item.reagents.total_volume) //Old chip to new chip
		if(item.icon_state == "chip_half")
			returningitem.icon_state = "[returningitem.icon_state]_half"
			returningitem.bitesize = Clamp(returningitem.reagents.total_volume,1,10)
		else if(prob(1))
			memed = 1
			to_chat(user, "You scoop up some dip with the chip, but mid-scop, the chip breaks off into the dreadful abyss of dip, never to be seen again...")
			returningitem.icon_state = "[returningitem.icon_state]_half"
			returningitem.bitesize = Clamp(returningitem.reagents.total_volume,1,10)
		else
			returningitem.bitesize = Clamp(returningitem.reagents.total_volume*0.5,1,10)
		qdel(item)
		reagents.trans_to(returningitem, bitesize) //Dip to new chip
		user.put_in_hands(returningitem)

		if (reagents && reagents.total_volume)
			if(!memed)
				to_chat(user, "You scoop up some dip with the chip.")
		else
			if(!memed)
				to_chat(user, "You scoop up the remaining dip with the chip.")
			var/obj/waste = new trash(loc)
			if (loc == user)
				user.put_in_hands(waste)
			qdel(src)

/obj/item/reagent_containers/food/snacks/dip/salsa
	name = "salsa dip"
	desc = "Traditional Sol chunky salsa dip containing tomatos, peppers, and spices."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/salsa
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/salsa
	icon_state = "dip_salsa"
	nutriment_desc = list("salsa" = 20)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/dip/guac
	name = "guac dip"
	desc = "A recreation of the ancient Sol 'Guacamole' dip using tofu, limes, and spices. This recreation obviously leaves out mole meat."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/guac
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/guac
	icon_state = "dip_guac"
	nutriment_desc = list("guacmole" = 20)
	nutriment_amt = 20

//burritos
/obj/item/reagent_containers/food/snacks/burrito
	name = "meat burrito"
	desc = "Meat wrapped in a flour tortilla. It's a burrito by definition."
	icon_state = "burrito"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)


/obj/item/reagent_containers/food/snacks/burrito_vegan
	name = "vegan burrito"
	desc = "Tofu wrapped in a flour tortilla. Those seen with this food object are Valid."
	icon_state = "burrito_vegan"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito_vegan/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 6)

/obj/item/reagent_containers/food/snacks/burrito_spicy
	name = "spicy meat burrito"
	desc = "Meat and chilis wrapped in a flour tortilla. Washrooms are north of the kitchen."
	icon_state = "burrito_spicy"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito_spicy/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/burrito_cheese
	name = "meat cheese burrito"
	desc = "Meat and melted cheese wrapped in a flour tortilla."
	icon_state = "burrito_cheese"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito_cheese/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/burrito_cheese_spicy
	name = "spicy cheese meat burrito"
	desc = "Meat, melted cheese, and chilis wrapped in a flour tortilla. Medical is north of the washrooms."
	icon_state = "burrito_cheese_spicy"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito_cheese_spicy/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/burrito_hell
	name = "el diablo"
	desc = "Meat and an insane amount of chilis packed in a flour tortilla. The chaplain's office is west of the kitchen."
	icon_state = "burrito_hell"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("hellfire" = 6)
	nutriment_amt = 24// 10 Chilis is a lot.

/obj/item/reagent_containers/food/snacks/breakfast_wrap
	name = "breakfast wrap"
	desc = "Bacon, eggs, cheese, and tortilla grilled to perfection."
	icon_state = "breakfast_wrap"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/reagent_containers/food/snacks/burrito_hell/Initialize()
	. = ..()
	reagents.add_reagent("protein", 9)
	reagents.add_reagent("condensedcapsaicin", 20) //what could possibly go wrong

/obj/item/reagent_containers/food/snacks/burrito_mystery
	name = "mystery meat burrito"
	desc = "The mystery is, why aren't you BSAing it?"
	icon_state = "burrito_mystery"
	bitesize = 5
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("regret" = 6)
	nutriment_amt = 6

// Ligger food and also bacon
/obj/item/reagent_containers/food/snacks/rawbacon
	name = "raw bacon"
	desc = "A very thin piece of raw meat, cut from beef."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawbacon"
	bitesize = 1
	center_of_mass = list("x"=16, "y"=16)


/obj/item/reagent_containers/food/snacks/bacon
	name = "bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bacon"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)

/obj/item/reagent_containers/food/snacks/bacon/microwave
	name = "microwaved bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bacon"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)

/obj/item/reagent_containers/food/snacks/bacon/oven
	name = "oven-cooked bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bacon"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)

/obj/item/reagent_containers/food/snacks/bacon/Initialize()
	. = ..()
	reagents.add_reagent("protein", 0.33)
	reagents.add_reagent("triglyceride", 1)

/obj/item/reagent_containers/food/snacks/chilied_eggs
	name = "chilied eggs"
	desc = "Three deviled eggs floating in a bowl of meat chili. A popular lunchtime meal for Unathi in Ouerea."
	icon_state = "chilied_eggs"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/chilied_eggs/Initialize()
	. = ..()
	reagents.add_reagent("egg", 6)
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/hatchling_suprise
	name = "hatchling suprise"
	desc = "A poached egg on top of three slices of bacon. A typical breakfast for hungry Unathi children."
	icon_state = "hatchling_suprise"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/hatchling_suprise/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/red_sun_special
	name = "red sun special"
	desc = "One lousey piece of sausage sitting on melted cheese curds. A cheap meal for the Unathi peasants of Moghes."
	icon_state = "red_sun_special"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/red_sun_special/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/riztizkzi_sea
	name = "moghresian sea delight"
	desc = "Three raw eggs floating in a sea of blood. An authentic replication of an ancient Unathi delicacy."
	icon_state = "riztizkzi_sea"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/riztizkzi_sea/Initialize()
	. = ..()
	reagents.add_reagent("egg", 4)

/obj/item/reagent_containers/food/snacks/father_breakfast
	name = "breakfast of champions"
	desc = "A sausage and an omelette on top of a grilled steak."
	icon_state = "father_breakfast"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/father_breakfast/Initialize()
	. = ..()
	reagents.add_reagent("egg", 4)
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/stuffed_meatball
	name = "stuffed meatball" //YES
	desc = "A meatball loaded with cheese."
	icon_state = "stuffed_meatball"

/obj/item/reagent_containers/food/snacks/stuffed_meatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/egg_pancake
	name = "meat pancake"
	desc = "An omelette baked on top of a giant meat patty. This monstrousity is typically shared between four people during a dinnertime meal."
	icon_state = "egg_pancake"
	trash = /obj/item/trash/tray

/obj/item/reagent_containers/food/snacks/stuffed_meatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("egg", 2)

/obj/item/reagent_containers/food/snacks/sliceable/grilled_carp
	name = "korlaaskak"
	desc = "A well-dressed carp, seared to perfection and adorned with herbs and spices. Can be sliced into proper serving sizes."
	icon_state = "grilled_carp"
	slice_path = /obj/item/reagent_containers/food/snacks/grilled_carp_slice
	slices_num = 6
	trash = /obj/item/trash/snacktray

/obj/item/reagent_containers/food/snacks/sliceable/grilled_carp/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 12)

/obj/item/reagent_containers/food/snacks/grilled_carp_slice
	name = "korlaaskak slice"
	desc = "A well-dressed fillet of carp, seared to perfection and adorned with herbs and spices."
	icon_state = "grilled_carp_slice"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/sliceable/sushi_roll
	name = "ouerean carp log"
	desc = "A giant carp roll wrapped in special grass that combines unathi and human cooking techniques. Can be sliced into proper serving sizes."
	icon_state = "sushi_roll"
	slice_path = /obj/item/reagent_containers/food/snacks/sushi_serve
	slices_num = 3

/obj/item/reagent_containers/food/snacks/sliceable/sushi_roll/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 6)

/obj/item/reagent_containers/food/snacks/sushi_serve
	name = "ouerean carp cake"
	desc = "A serving of carp roll wrapped in special grass that combines unathi and human cooking techniques."
	icon_state = "sushi_serve"

/obj/item/reagent_containers/food/snacks/spreads
	name = "nutri-spread"
	desc = "A stick of plant-based nutriments in a semi-solid form. I can't believe it's not margarine!"
	icon_state = "marge"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("margarine" = 1)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/spreads/butter
	name = "butter"
	desc = "A stick of pure butterfat made from milk products."
	icon_state = "marge"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("butter" = 1)
	nutriment_amt = 0

/obj/item/reagent_containers/food/snacks/spreads/Initialize()
	. = ..()
	reagents.add_reagent("triglyceride", 20)
	reagents.add_reagent("sodiumchloride",1)

/obj/item/reagent_containers/food/snacks/bacon_stick
	name = "eggpop"
	desc = "A bacon wrapped boiled egg, conviently skewered on a wooden stick."
	icon_state = "bacon_stick"

/obj/item/reagent_containers/food/snacks/bacon_stick/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_containers/food/snacks/cheese_cracker
	name = "supreme cheese toast"
	desc = "A piece of toast lathered with butter, cheese, spices, and herbs."
	icon_state = "cheese_cracker"
	nutriment_desc = list("cheese toast" = 8)
	nutriment_amt = 8

/obj/item/reagent_containers/food/snacks/bacon_and_eggs
	name = "bacon and eggs"
	desc = "A piece of bacon and two fried eggs."
	icon_state = "bacon_and_eggs"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/bacon_and_eggs/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_containers/food/snacks/sweet_and_sour
	name = "sweet and sour pork"
	desc = "A traditional ancient sol recipie with a few liberties taken with meat selection."
	icon_state = "sweet_and_sour"
	nutriment_desc = list("sweet and sour" = 6)
	nutriment_amt = 6
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/sweet_and_sour/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/corn_dog
	name = "corn dog"
	desc = "A cornbread covered sausage deepfried in oil."
	icon_state = "corndog"
	nutriment_desc = list("corn batter" = 4)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/corn_dog/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/truffle
	name = "chocolate truffle"
	desc = "Rich bite-sized chocolate."
	icon_state = "truffle"
	nutriment_amt = 0
	bitesize = 4

/obj/item/reagent_containers/food/snacks/truffle/Initialize()
	. = ..()
	reagents.add_reagent("coco", 6)

/obj/item/reagent_containers/food/snacks/truffle/random
	name = "mystery chocolate truffle"
	desc = "Rich bite-sized chocolate with a mystery filling!"

/obj/item/reagent_containers/food/snacks/truffle/random/Initialize()
	. = ..()
	var/reagent_string = pick(list("cream","cherryjelly","mint","frostoil","capsaicin","cream","coffee","milkshake"))
	reagents.add_reagent(reagent_string, 4)

/obj/item/reagent_containers/food/snacks/bacon_flatbread
	name = "bacon cheese flatbread"
	desc = "Not a pizza."
	icon_state = "bacon_pizza"
	nutriment_desc = list("flatbread" = 5)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/bacon_flatbread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)

/obj/item/reagent_containers/food/snacks/meat_pocket
	name = "meat pocket"
	desc = "Meat and cheese stuffed in a flatbread pocket, grilled to perfection."
	icon_state = "meat_pocket"
	nutriment_desc = list("flatbread" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/meat_pocket/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/fish_taco
	name = "carp taco"
	desc = "A questionably cooked fish taco decorated with herbs, spices, and special sauce."
	icon_state = "fish_taco"
	nutriment_desc = list("flatbread" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/fish_taco/Initialize()
	. = ..()
	reagents.add_reagent("seafood",3)

/obj/item/reagent_containers/food/snacks/nt_muffin
	name = "\improper NtMuffin"
	desc = "A NanoTrasen sponsered biscuit with egg, cheese, and sausage."
	icon_state = "nt_muffin"
	nutriment_desc = list("biscuit" = 3)
	nutriment_amt = 3

/obj/item/reagent_containers/food/snacks/nt_muffin/Initialize()
	. = ..()
	reagents.add_reagent("protein",5)

/obj/item/reagent_containers/food/snacks/pineapple_ring
	name = "pineapple ring"
	desc = "What the hell is this?"
	icon_state = "pineapple_ring"
	nutriment_desc = list("sweetness" = 2)
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/pineapple_ring/Initialize()
	. = ..()
	reagents.add_reagent("pineapplejuice",3)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple
	name = "ham & pineapple pizza"
	desc = "One of the most debated pizzas in existence."
	icon_state = "pineapple_pizza"
	slice_path = /obj/item/reagent_containers/food/snacks/pineappleslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "ham" = 10)
	nutriment_amt = 30
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("cheese", 5)
	reagents.add_reagent("tomatojuice", 6)

/obj/item/reagent_containers/food/snacks/pineappleslice
	name = "ham & pineapple pizza slice"
	desc = "A slice of contraband."
	icon_state = "pineapple_pizza_slice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/pineappleslice/filled
	nutriment_desc = list("pizza crust" = 5, "tomato" = 5)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/burger/bacon
	name = "bacon burger"
	desc = "The cornerstone of every nutritious breakfast, now with bacon!"
	icon_state = "hburger"
	filling_color = "#D63C3C"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burger/bacon/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/blt
	name = "BLT"
	desc = "Bacon, lettuce, tomatoes. The perfect lunch."
	icon_state = "blt"
	filling_color = "#D63C3C"
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("bread" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/reagent_containers/food/snacks/blt/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/clam
	name = "Ras'val clam"
	desc = "An adhomian clam, native from the sea of Ras'val."
	icon_state = "clam"
	bitesize = 2
	description_fluff = "Fishing and shellfish has a part in the diet of the population at the coastal areas, even if the ice can be an obstacle to most experienced fisherman. \
	Spicy Ras'val clams, named after the sea, are a famous treat, being appreciated in other system besides S'rand'marr."

/obj/item/reagent_containers/food/snacks/clam/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 2)

/obj/item/reagent_containers/food/snacks/spicy_clams
	name = "spicy Ras'val clams"
	desc = "A famous adhomian clam dish, named after the Ras'val sea."
	icon_state = "spicy_clams"
	bitesize = 2
	trash = /obj/item/trash/snack_bowl
	description_fluff = "Fishing and shellfish has a part in the diet of the population at the coastal areas, even if the ice can be an obstacle to most experienced fisherman. \
	Spicy Ras'val clams, named after the sea, are a famous treat, being appreciated in other system besides S'rand'marr."

/obj/item/reagent_containers/food/snacks/spicy_clams/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 4)
	reagents.add_reagent("capsaicin", 1)

/obj/item/reagent_containers/food/snacks/tajaran_bread
	name = "adhomian bread"
	desc = "A traditional tajaran bread, usually baked with blizzard ears' flour."
	icon_state = "tajaran_bread"
	bitesize = 2
	nutriment_amt = 5
	nutriment_desc = list("bread" = 2)
	description_fluff = "While the People's republic territory includes several different regional cultures, it is possible to find common culinary traditions among its population. \
	Bread, baked with flour produced from a variation of the Blizzard Ears, is considered an essential part of a worker's breakfast."

/obj/item/reagent_containers/food/snacks/soup/earthenroot
	name = "earthen-root soup"
	desc = "A soup made with earthen-root, a traditional dish from Northern Harr'masir."
	icon_state = "tajaran_soup"
	bitesize = 2
	nutriment_amt = 4
	description_fluff = "The Earth-Root soup is a common sight on the tables, of all social sectors, in the Northern Harr'masir. Prepared traditionally with water, Earth-Root and \
	other plants, such as the Nif-Berries."

/obj/item/reagent_containers/food/snacks/stew/tajaran
	name = "adhomian stew"
	desc = "An adhomian stew, made with nav'twir meat and native plants."
	icon_state = "tajaran_stew"
	bitesize = 2
	nutriment_amt = 4
	nutriment_desc = list("sweetness" = 2)
	description_fluff = "Traditional adhomian stews are made with diced vegetables, such as Nif-Berries, and meat, Snow Strider is commonly used by the rural population, while \
	industrialized Fatshouters's beef is prefered by the city's inhabitants."

/obj/item/reagent_containers/food/snacks/stew/tajaran/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("water", 4)

/obj/item/reagent_containers/food/snacks/adhomian_can
	name = "canned fatshouters meat"
	desc = "A piece of salted fatshouter's meat stored inside a metal can."
	icon_state = "canned"
	bitesize = 2
	trash = /obj/item/trash/can
	description_fluff = "While the People's republic territory includes several different regional cultures, it is possible to find common culinary traditions among its population. \
	Salt-cured Fatshouters's meat also has been introduced widely, facilitated by the recent advances in the livestock husbandry techniques."

/obj/item/reagent_containers/food/snacks/adhomian_can/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_containers/food/snacks/onionrings
	name = "onion rings"
	desc = "Like circular fries but better."
	icon_state = "onionrings"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("fried onions" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/berrymuffin
	name = "berry muffin"
	desc = "A delicious and spongy little cake, with berries."
	icon_state = "berrymuffin"
	filling_color = "#E0CF9B"
	center_of_mass = list("x"=17, "y"=4)
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 1, "muffin" = 2, "berries" = 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soup/onion
	name = "onion soup"
	desc = "A soup with layers."
	icon_state = "onionsoup"
	filling_color = "#E0C367"
	nutriment_amt = 5
	nutriment_desc = list("onion" = 2, "soup" = 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/porkbowl
	name = "pork bowl"
	desc = "A bowl of fried rice with cuts of meat."
	icon_state = "porkbowl"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/porkbowl/Initialize()
	..()
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/mashedpotato
	name = "mashed potato"
	desc = "Pillowy mounds of mashed potato."
	icon_state = "mashedpotato"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list("mashed potatoes" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/croissant
	name = "croissant"
	desc = "True french cuisine."
	filling_color = "#E3D796"
	icon_state = "croissant"
	nutriment_amt = 4
	nutriment_desc = list("french bread" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/crabmeat
	name = "crab legs"
	desc = "... Coffee? Is that you?"
	icon_state = "crabmeat"
	bitesize = 1

/obj/item/reagent_containers/food/snacks/crabmeat/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 2)

/obj/item/reagent_containers/food/snacks/crab_legs
	name = "steamed crab legs"
	desc = "Crab legs steamed and buttered to perfection. One day when the boss gets hungry..."
	icon_state = "crablegs"
	nutriment_amt = 2
	nutriment_desc = list("savory butter" = 2)
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/crab_legs/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 6)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_containers/food/snacks/banana_split
	name = "banana split"
	desc = "A dessert made with icecream and a banana."
	icon_state = "banana_split"
	nutriment_amt = 5
	nutriment_desc = list("icecream" = 2)
	bitesize = 2
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/banana_split/Initialize()
	. = ..()
	reagents.add_reagent("banana", 3)

/obj/item/reagent_containers/food/snacks/tuna
	name = "\improper Tuna Snax"
	desc = "A packaged fish snack. Guaranteed to not contain space carp."
	icon_state = "tuna"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)
	bitesize = 2
	nutriment_type = NUTRIMENT_BAD
	trash = /obj/item/trash/tuna

/obj/item/reagent_containers/food/snacks/tuna/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 4)

/obj/item/reagent_containers/food/snacks/cb01
	name = "tau ceti bar"
	desc = "A dark chocolate caramel and nougat bar made famous in Biesel."
	filling_color = "#552200"
	icon_state = "cb01"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 2, "nougat" = 1, "caramel" = 1)
	bitesize = 2
	nutriment_type = NUTRIMENT_BAD
	w_class = 1

/obj/item/reagent_containers/food/snacks/cb01/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb02
	name = "hundred thousand credit bar"
	desc = "An ironically cheap puffed rice caramel milk chocolate bar."
	filling_color = "#552200"
	icon_state = "cb02"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 2, "caramel" = 1, "puffed rice" = 1)
	bitesize = 2
	nutriment_type = NUTRIMENT_BAD
	w_class = 1

/obj/item/reagent_containers/food/snacks/cb02/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb03
	name = "spacewind bar"
	desc = "Bubbly milk chocolate."
	filling_color = "#552200"
	icon_state = "cb03"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 4)
	bitesize = 2
	nutriment_type = NUTRIMENT_BAD
	w_class = 1

/obj/item/reagent_containers/food/snacks/cb03/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb04
	name = "crunchy crisp"
	desc = "An almond flake bar covered in milk chocolate."
	filling_color = "#552200"
	icon_state = "cb04"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 3, "almonds" = 1)
	bitesize = 2
	nutriment_type = NUTRIMENT_BAD
	w_class = 1

/obj/item/reagent_containers/food/snacks/cb04/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb05
	name = "hearsay bar"
	desc = "A cheap milk chocolate bar loaded with sugar."
	filling_color = "#552200"
	icon_state = "cb05"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 2, "vomit" = 1)
	bitesize = 3
	nutriment_type = NUTRIMENT_BAD
	w_class = 1

/obj/item/reagent_containers/food/snacks/cb05/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_containers/food/snacks/cb06
	name = "latte crunch"
	desc = "A large latte flavored wafer chocolate bar."
	filling_color = "#552200"
	icon_state = "cb06"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 2, "coffee" = 1, "vanilla wafer" = 1)
	bitesize = 3
	nutriment_type = NUTRIMENT_BAD
	w_class = 1

/obj/item/reagent_containers/food/snacks/cb06/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb07
	name = "martian bar"
	desc = "Dark chocolate with a nougat and caramel center. Known as the first chocolate bar grown and produced on Mars."
	filling_color = "#552200"
	icon_state = "cb07"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 2, "caramel" = 1, "nougat" = 1)
	bitesize = 3
	nutriment_type = NUTRIMENT_BAD
	w_class = 1

/obj/item/reagent_containers/food/snacks/cb07/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb08
	name = "crisp bar"
	desc = "A large puffed rice milk chocolate bar."
	filling_color = "#552200"
	icon_state = "cb08"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 2, "puffed rice" = 1)
	bitesize = 3
	nutriment_type = NUTRIMENT_BAD
	w_class = 1

/obj/item/reagent_containers/food/snacks/cb08/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_containers/food/snacks/cb09
	name = "oh daddy bar"
	desc = "A massive cluster of peanuts covered in caramel and chocolate."
	filling_color = "#552200"
	icon_state = "cb09"
	nutriment_amt = 6
	nutriment_desc = list("chocolate" = 3, "caramel" = 1, "peanuts" = 2)
	bitesize = 3
	nutriment_type = NUTRIMENT_BAD
	w_class = 1

/obj/item/reagent_containers/food/snacks/cb09/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb10
	name = "laughter bar"
	desc = "Nuts, nougat, peanuts, and caramel covered in chocolate."
	filling_color = "#552200"
	icon_state = "cb10"
	nutriment_amt = 5
	nutriment_desc = list("chocolate" = 2, "caramel" = 1, "peanuts" = 1, "nougat" = 1)
	bitesize = 3
	nutriment_type = NUTRIMENT_BAD
	w_class = 1

/obj/item/reagent_containers/food/snacks/cb10/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/hardbread
	name = "adhomian hard bread"
	desc = "A long-lasting tajaran bread. It is usually prepared for long journeys, hard winters or military campaigns."
	icon_state = "loaf"
	bitesize = 1
	nutriment_desc = list("crusty bread" = 2)
	nutriment_amt = 15
	throw_range = 5
	throwforce = 10
	w_class = 3
	description_fluff = "The adhomian hard bread is type of tajaran bread, made from Blizzard Ears's flour, water and spice, usually basked in the shape of a loaf. \
	It is known for its hard crust, bland taste and for being long lasting. The hard bread was usually prepared for long journeys, hard winters or military campaigns, \
	due to its shelf life. Certain folk stories and jokes claim that such food could also be used as an artillery ammunition or thrown at besieging armies during sieges."

/obj/item/reagent_containers/food/snacks/spreads/lard
	name = "lard"
	desc = "A stick of animal fat."
	icon_state = "lard"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("fat" = 3)
	nutriment_amt = 5

/obj/item/reagent_containers/food/snacks/chipplate/tajcandy
	name = "plate of sugar tree candy"
	desc = "A plate full of adhomian candy made from sugar tree, a plant native to Adhomai."
	icon_state = "cubes26"
	trash = /obj/item/trash/candybowl
	vendingobject = /obj/item/reagent_containers/food/snacks/tajcandy
	nutriment_desc = list("candy" = 1)
	bitesize = 1
	nutriment_amt = 26
	unitname = "candy"

/obj/item/reagent_containers/food/snacks/chipplate/tajcandy/update_icon()
	switch(reagents.total_volume)
		if(1)
			icon_state = "cubes1"
		if(2 to 5)
			icon_state = "cubes5"
		if(6 to 10)
			icon_state = "cubes10"
		if(11 to 15)
			icon_state = "cubes15"
		if(16 to 20)
			icon_state = "cubes20"
		if(21 to 25)
			icon_state = "cubes25"
		if(26 to INFINITY)
			icon_state = "cubes26"

/obj/item/reagent_containers/food/snacks/tajcandy
	name = "sugar tree candy"
	desc = "An adhomian candy made from the sugar tree fruit."
	icon_state = "tajcandy"
	nutriment_desc = list("candy" = 3)
	nutriment_amt = 1
	bitesize = 1

/obj/item/reagent_containers/food/snacks/tajcandy/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 3)

#undef NUTRIMENT_GOOD
#undef NUTRIMENT_BAD