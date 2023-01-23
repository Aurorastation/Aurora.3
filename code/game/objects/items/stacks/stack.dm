/* Stack type objects!
 * Contains:
 * 		Stacks
 * 		Recipe datum
 * 		Recipe list datum
 */

/*
 * Stacks
 */

/obj/item/stack
	gender = PLURAL
	origin_tech = list(TECH_MATERIAL = 1)
	flags = HELDMAPTEXT
	var/list/datum/stack_recipe/recipes
	var/singular_name
	var/amount = 1
	var/max_amount //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount
	var/stacktype //determines whether different stack types can merge
	var/build_type = null //used when directly applied to a turf
	var/uses_charge = 0
	var/list/charge_costs = null
	var/list/datum/matter_synth/synths = null
	var/icon_has_variants = FALSE
	icon = 'icons/obj/stacks/materials.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/stacks/lefthand_materials.dmi',
		slot_r_hand_str = 'icons/mob/items/stacks/righthand_materials.dmi',
		)

/obj/item/stack/Initialize(mapload, amount)
	. = ..()
	if (!stacktype)
		stacktype = type
	if (amount)
		src.amount = amount
		if(amount > max_amount)
			var/amount_overdue = max_amount - amount
			new type(get_turf(src), amount_overdue)
			amount -= amount_overdue

	if (icon_has_variants && !item_state)
		item_state = icon_state

	update_icon()
	return INITIALIZE_HINT_LATELOAD

/obj/item/stack/LateInitialize()
	check_maptext(SMALL_FONTS(7, get_amount()))

/obj/item/stack/Destroy()
	if (src && usr && usr.machine == src)
		usr << browse(null, "window=stack")
	return ..()

/obj/item/stack/update_icon()
	check_maptext(SMALL_FONTS(7, get_amount()))

	if (!icon_has_variants)
		return ..()

	if (amount <= (max_amount * (1/3)))
		icon_state = initial(icon_state)
	else if (amount <= (max_amount * (2/3)))
		icon_state = "[initial(icon_state)]_2"
	else
		icon_state = "[initial(icon_state)]_3"

/obj/item/stack/examine(mob/user)
	if(..(user, 1))
		if(!iscoil())
			if(!uses_charge)
				to_chat(user, "There [src.amount == 1 ? "is" : "are"] <b>[src.amount]</b> [src.singular_name]\s in the stack.")
			else
				to_chat(user, "You have enough charge to produce <b>[get_amount()]</b>.")

/obj/item/stack/attack_self(mob/user)
	list_recipes(user, recipes)

/obj/item/stack/proc/list_recipes(mob/user, recipes_sublist, var/datum/stack_recipe/sublist)
	if(!recipes)
		return
	if(!src || get_amount() <= 0)
		user << browse(null, "window=stack")
	user.set_machine(src) //for correct work of onclose

	var/t1 = "<html><head><title>Constructions from [capitalize_first_letters(src.name)]</title></head><body><tt>Amount Left: [src.get_amount()]<br>"

	if(sublist)
		t1 += "<a href='?src=\ref[src];go_back=1'>Back</a><br>"
	if(locate(/datum/stack_recipe_list) in recipes_sublist)
		t1 += "<h2>Recipe Categories</h2>"
	for(var/datum/stack_recipe_list/srl in recipes_sublist)
		t1 += "<a href='?src=\ref[src];sublist=\ref[srl]'>[capitalize_first_letters(srl.title)]</a><br>"

	if(locate(/datum/stack_recipe) in recipes_sublist)
		var/sublist_title = sublist ? " ([capitalize_first_letters(sublist.title)])" : ""
		t1 += "<h2>Recipes[sublist_title]</h2>"
	for(var/datum/stack_recipe/R in recipes_sublist)
		var/max_multiplier = round(src.get_amount() / R.req_amount)
		var/title = ""
		var/can_build = TRUE
		can_build = (max_multiplier > 0)

		if(R.res_amount > 1)
			title += "[R.res_amount]x [R.title]\s"
		else
			title += "[capitalize_first_letters(R.title)]"

		title += " ([R.req_amount] [src.singular_name]\s)"

		if(can_build)
			var/sublist_var = sublist ? "\ref[sublist]" : ""
			t1 += "<a href='?src=\ref[src];make=\ref[R];sublist=[sublist_var];multiplier=1'>[title]</a>"
		else
			t1 += "<div class='no-build inline'>[title]</div><br>"
			continue

		if(R.max_res_amount > 1 && max_multiplier > 1)
			max_multiplier = min(max_multiplier, round(R.max_res_amount / R.res_amount))
			t1 += " |"
			var/list/multipliers = list(5, 10, 25)
			for(var/n in multipliers)
				if(max_multiplier >= n)
					var/sublist_var = sublist ? "\ref[sublist]" : ""
					t1 += " <a href='?src=\ref[src];make=\ref[R];sublist=[sublist_var];multiplier=[n]'>[n * R.res_amount]x</a>"
			if(!(max_multiplier in multipliers))
				var/sublist_var = sublist ? "\ref[sublist]" : ""
				t1 += " <a href='?src=\ref[src];make=\ref[R];sublist=[sublist_var];multiplier=[max_multiplier]'>[max_multiplier * R.res_amount]x</a>"
		t1 += "<br>"

	t1 += "</tt></body></html>"

	var/datum/browser/stack_win = new(user, "stack", capitalize_first_letters(name))
	stack_win.set_content(t1)
	stack_win.add_stylesheet("misc", 'html/browser/misc.css')
	stack_win.open()

/obj/item/stack/proc/produce_recipe(datum/stack_recipe/recipe, var/quantity, mob/user)
	var/required = quantity*recipe.req_amount
	var/produced = min(quantity*recipe.res_amount, recipe.max_res_amount)

	if (!can_use(required))
		if (produced>1)
			to_chat(user, SPAN_WARNING("You haven't got enough [src] to build \the [produced] [recipe.title]\s!"))
		else
			to_chat(user, SPAN_WARNING("You haven't got enough [src] to build \the [recipe.title]!"))
		return

	if (recipe.one_per_turf && (locate(recipe.result_type) in user.loc))
		to_chat(user, SPAN_WARNING("There is another [recipe.title] here!"))
		return

	if (recipe.on_floor && !isfloor(user.loc))
		to_chat(user, SPAN_WARNING("\The [recipe.title] must be constructed on the floor!"))
		return

	to_chat(user, SPAN_NOTICE("Building [recipe.title]..."))
	if (recipe.time)
		if (!do_after(user, recipe.time))
			return

	if (use(required))
		recipe.Produce(produced, user.loc, user.dir, user)

/obj/item/stack/Topic(href, href_list)
	..()
	if((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return

	if(href_list["go_back"])
		list_recipes(usr, recipes)
		return

	if(href_list["sublist"] && !href_list["make"])
		var/datum/stack_recipe_list/recipe_list = locate(href_list["sublist"]) in recipes
		list_recipes(usr, recipe_list.recipes, recipe_list)

	if(href_list["make"])
		if(src.get_amount() < 1)
			qdel(src) //Never should happen

		var/datum/stack_recipe/R = locate(href_list["make"]) in recipes
		if(href_list["sublist"])
			var/datum/stack_recipe_list/recipe_list = locate(href_list["sublist"]) in recipes
			R = locate(href_list["make"]) in recipe_list.recipes
		var/multiplier = text2num(href_list["multiplier"])
		if(!multiplier || (multiplier <= 0)) //href exploit protection
			return

		produce_recipe(R, multiplier, usr)
		updateUsrDialog()

//Return 1 if an immediate subsequent call to use() would succeed.
//Ensures that code dealing with stacks uses the same logic
/obj/item/stack/proc/can_use(var/used, var/mob/user=null)
	if (get_amount() < used)
		if(user && isrobot(user))
			to_chat(user, SPAN_WARNING("You don't have enough charge left in your synthesizer!"))
		return 0
	return 1

/obj/item/stack/use(var/used)
	if (!can_use(used))
		return 0
	if(!uses_charge)
		amount -= used
		if (amount <= 0)
			if(usr)
				usr.remove_from_mob(src)
			qdel(src) //should be safe to qdel immediately since if someone is still using this stack it will persist for a little while longer
		update_icon()
		return 1
	else
		for(var/i = 1 to charge_costs.len)
			var/datum/matter_synth/S = synths[i]
			if(!S.use_charge(charge_costs[i] * used)) // Doesn't need to be deleted
				return 0
		check_maptext(SMALL_FONTS(7, get_amount()))
		return 1

/obj/item/stack/proc/add(var/extra)
	if(!uses_charge)
		if(amount + extra > get_max_amount())
			return 0
		else
			amount += extra
		update_icon()
		return 1
	else if(!synths || synths.len < uses_charge)
		return 0
	else
		for(var/i = 1 to uses_charge)
			var/datum/matter_synth/S = synths[i]
			S.add_charge(charge_costs[i] * extra)
		check_maptext(SMALL_FONTS(7, get_amount()))

/*
	The transfer and split procs work differently than use() and add().
	Whereas those procs take no action if the desired amount cannot be added or removed these procs will try to transfer whatever they can.
	They also remove an equal amount from the source stack.
*/

//attempts to transfer amount to S, and returns the amount actually transferred
/obj/item/stack/proc/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	if (!get_amount())
		return 0
	if ((stacktype != S.stacktype) && !type_verified)
		return 0
	if (isnull(tamount))
		tamount = src.get_amount()

	var/transfer = max(min(tamount, src.get_amount(), (S.get_max_amount() - S.get_amount())), 0)

	var/orig_amount = src.get_amount()
	if (transfer && src.use(transfer))
		S.add(transfer)
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(S)
			if(blood_DNA)
				S.blood_DNA |= blood_DNA
		return transfer
	return 0

//creates a new stack with the specified amount
/obj/item/stack/proc/split(var/tamount)
	if (!get_amount())
		return null

	var/transfer = max(min(tamount, src.amount, initial(max_amount)), 0)

	var/orig_amount = src.get_amount()
	if (transfer && src.use(transfer))
		var/obj/item/stack/newstack = new src.stacktype(loc, transfer)
		newstack.color = color
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(newstack)
			if(blood_DNA)
				newstack.blood_DNA |= blood_DNA
		return newstack
	return null

/obj/item/stack/proc/get_amount()
	if(uses_charge)
		if(!synths || synths.len < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.get_charge() / charge_costs[1])
		if(charge_costs.len > 1)
			for(var/i = 2 to charge_costs.len)
				S = synths[i]
				. = min(., round(S.get_charge() / charge_costs[i]))
		return
	return amount

/obj/item/stack/proc/get_max_amount()
	if(uses_charge)
		if(!synths || synths.len < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.max_energy / charge_costs[1])
		if(uses_charge > 1)
			for(var/i = 2 to uses_charge)
				S = synths[i]
				. = min(., round(S.max_energy / charge_costs[i]))
		return
	return max_amount

/obj/item/stack/proc/add_to_stacks(mob/user as mob)
	for (var/obj/item/stack/item in user.loc)
		if (item==src)
			continue
		var/transfer = src.transfer_to(item)
		if (transfer)
			to_chat(user, SPAN_NOTICE("You add a new [item.singular_name] to the stack. It now contains [item.amount] [item.singular_name]\s."))
		item.update_icon()
		if(!amount)
			break

/obj/item/stack/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/obj/item/stack/F = src.split(1)
		if (F)
			if (!user.can_use_hand())
				return
			user.put_in_hands(F)
			src.add_fingerprint(user)
			F.add_fingerprint(user)
			spawn(0)
				if (src && usr.machine==src)
					src.interact(usr)
	else
		..()
	return

/obj/item/stack/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/S = W
		if (user.get_inactive_hand()==src)
			src.transfer_to(S, 1)
		else
			src.transfer_to(S)

		spawn(0) //give the stacks a chance to delete themselves if necessary
			if (S && usr.machine==S)
				S.interact(usr)
			if (src && usr.machine==src)
				src.interact(usr)
	else
		return ..()

/*
 * Recipe datum
 */
/datum/stack_recipe
	var/title = "ERROR"
	var/result_type
	var/req_amount = 1 //amount of material needed for this recipe
	var/res_amount = 1 //amount of stuff that is produced in one batch (e.g. 4 for floor tiles)
	var/max_res_amount = 1
	var/time = 0
	var/one_per_turf = 0
	var/on_floor = 0
	var/use_material

/datum/stack_recipe/New(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1, time = 0, one_per_turf = 0, on_floor = 0, supplied_material = null)
	src.title = title
	src.result_type = result_type
	if(ispath(result_type, /obj/structure))
		var/obj/structure/S = result_type
		src.req_amount = initial(S.build_amt) ? initial(S.build_amt) : req_amount
	else
		src.req_amount = req_amount
	src.res_amount = res_amount
	src.max_res_amount = max_res_amount
	src.time = time
	src.one_per_turf = one_per_turf
	src.on_floor = on_floor
	src.use_material = supplied_material

/datum/stack_recipe/proc/Produce(var/amount = 1, var/loc = null, var/dir = NORTH, var/user = null)
	if(amount < 1)
		return null

	var/atom/O
	if(use_material)
		O = new result_type(loc, use_material)
	else
		O = new result_type(loc)
	O.set_dir(dir)
	O.add_fingerprint(user)

	if (istype(O, /obj/item/stack))
		var/obj/item/stack/S = O
		S.amount = amount
		S.update_icon()
		if(user)
			S.add_to_stacks(user)

	if (istype(O, /obj/item/storage)) //BubbleWrap - so newly formed boxes are empty
		for (var/obj/item/I in O)
			qdel(I)
	return O

/*
 * Recipe list datum
 */
/datum/stack_recipe_list
	var/title = "ERROR"
	var/list/recipes = null

/datum/stack_recipe_list/New(new_title, new_recipes)
	src.title = new_title
	src.recipes = new_recipes
