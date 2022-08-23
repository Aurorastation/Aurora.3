/obj/machinery/appliance/cooker/fryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon_state = "fryer_off"
	can_cook_mobs = 1
	cook_type = "deep fried"
	on_icon = "fryer_on"
	off_icon = "fryer_off"
	food_color = "#ffad33"
	appliancetype = FRYER
	active_power_usage = 12 KILOWATTS
	heating_power = 12000
	optimal_power = 1.35
	idle_power_usage = 3.6 KILOWATTS
	//Power used to maintain temperature once it's heated.
	//Going with 25% of the active power. This is a somewhat arbitrary value
	resistance = 10000	// Approx. 4 minutes.
	max_contents = 2
	stat = NOPOWER//Starts turned off
	starts_with = list(
		/obj/item/reagent_containers/cooking_container/fryer,
		/obj/item/reagent_containers/cooking_container/fryer
	)

	var/datum/reagents/oil
	var/optimal_oil = 9000//90 litres of cooking oil
	var/datum/looping_sound/deep_fryer/fry_loop

/obj/machinery/appliance/cooker/fryer/examine(var/mob/user)
	. = ..()
	if (.)//no need to duplicate adjacency check
		to_chat(user, "Oil Level: [oil.total_volume]/[optimal_oil]")

/obj/machinery/appliance/cooker/fryer/Initialize()
	. = ..()
	oil = new/datum/reagents(optimal_oil * 1.25, src)
	var/variance = rand()*0.15
	//Fryer is always a little below full, but its usually negligible

	if (prob(20))
		//Sometimes the fryer will start with much less than full oil, significantly impacting efficiency until filled
		variance = rand()*0.5
	oil.add_reagent(/decl/reagent/nutriment/triglyceride/oil/corn, optimal_oil*(1 - variance))
	fry_loop = new(list(src), FALSE)

/obj/machinery/appliance/cooker/fryer/Destroy()
	QDEL_NULL(fry_loop)
	QDEL_NULL(oil)
	return ..()

/obj/machinery/appliance/cooker/fryer/heat_up()
	if (..())
		//Set temperature of oil
		oil.set_temperature(temperature)

/obj/machinery/appliance/cooker/fryer/process()
	. = ..()
	//Set temperature of oil
	oil.set_temperature(temperature)

/obj/machinery/appliance/cooker/fryer/update_cooking_power()
	..()//In addition to parent temperature calculation
	//Fryer efficiency also drops when oil levels arent optimal
	var/oil_level = 0
	var/decl/reagent/nutriment/triglyceride/oil/OL = oil.get_primary_reagent_decl()
	if (OL && istype(OL))
		oil_level = oil.reagent_volumes[OL.type]

	var/oil_efficiency = 0
	if (oil_level)
		oil_efficiency = oil_level / optimal_oil

		if (oil_efficiency > 1)
			//We're above optimal, efficiency goes down as we pass too much over it
			oil_efficiency = 1 - (oil_efficiency - 1)

	cooking_power *= oil_efficiency

/obj/machinery/appliance/cooker/fryer/update_icon()
	if (cooking)
		icon_state = on_icon
		fry_loop.start(src)
	else
		icon_state = off_icon
		fry_loop.stop(src)
	..()

//Fryer gradually infuses any cooked food with oil. Moar calories
//This causes a slow drop in oil levels, encouraging refill after extended use
/obj/machinery/appliance/cooker/fryer/do_cooking_tick(var/datum/cooking_item/CI)
	if(..() && (CI.oil < CI.max_oil) && prob(20))
		var/datum/reagents/buffer = new /datum/reagents(2)
		oil.trans_to_holder(buffer, min(0.5, CI.max_oil - CI.oil))
		CI.oil += buffer.total_volume
		CI.container.soak_reagent(buffer)

//To solve any odd logic problems with results having oil as part of their compiletime ingredients.
//Upon finishing a recipe the fryer will analyse any oils in the result, and replace them with our oil
//As well as capping the total to the max oil
/obj/machinery/appliance/cooker/fryer/finish_cooking(var/datum/cooking_item/CI)
	..()
	var/total_oil = 0
	var/total_our_oil = 0
	var/total_removed = 0
	var/decl/reagent/our_oil = oil.get_primary_reagent_decl()

	for (var/obj/item/I in CI.container)
		if (I.reagents && I.reagents.total_volume)
			for (var/_R in I.reagents.reagent_volumes)
				if (ispath(_R, /decl/reagent/nutriment/triglyceride/oil))
					total_oil += I.reagents.reagent_volumes[_R]
					if (_R != our_oil.type)
						total_removed += I.reagents.reagent_volumes[_R]
						I.reagents.remove_reagent(_R, I.reagents.reagent_volumes[_R])
					else
						total_our_oil += I.reagents.reagent_volumes[_R]

	if (total_removed > 0 || total_oil != CI.max_oil)
		total_oil = min(total_oil, CI.max_oil)

		if (total_our_oil < total_oil)
			//If we have less than the combined total, then top up from our reservoir
			var/datum/reagents/buffer = new /datum/reagents(INFINITY)
			oil.trans_to_holder(buffer, total_oil - total_our_oil)
			CI.container.soak_reagent(buffer)
		else if (total_our_oil > total_oil)
			//If we have more than the maximum allowed then we delete some.
			//This could only happen if one of the objects spawns with the same type of oil as ours
			var/portion = 1 - (total_oil / total_our_oil) //find the percentage to remove
			for (var/thing in CI.container)
				var/obj/item/I = thing
				if (I.reagents && I.reagents.total_volume)
					for (var/_R in I.reagents.reagent_volumes)
						if (_R == our_oil.type)
							I.reagents.remove_reagent(_R, I.reagents.reagent_volumes[_R]*portion)
					I.reagents.set_temperature(T0C + 40 + rand(-5, 5)) // warm, but not hot; avoiding aftereffects of the hot oil

/obj/machinery/appliance/cooker/fryer/cook_mob(var/mob/living/victim, var/mob/user)

	if(!istype(victim))
		return

	//Removed delay on this action in favour of a cooldown after it
	//If you can lure someone close to the fryer and grab them then you deserve success.
	//And a delay on this kind of niche action just ensures it never happens
	//Cooldown ensures it can't be spammed to instakill someone
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*3)

	if(!victim || !victim.Adjacent(user))
		to_chat(user, SPAN_DANGER("Your victim slipped free!"))
		return

	var/damage = rand(7,13)
	//Though this damage seems reduced, some hot oil is transferred to the victim and will burn them for a while after

	var/decl/reagent/nutriment/triglyceride/oil/OL = oil.get_primary_reagent_decl()
	if(istype(OL))
		damage *= OL.heatdamage(victim, oil)

	var/obj/item/organ/external/E
	var/nopain
	if(ishuman(victim) && user.zone_sel.selecting != BP_GROIN && user.zone_sel.selecting != BP_CHEST)
		var/mob/living/carbon/human/H = victim
		E = H.get_organ(user.zone_sel.selecting)
		if(!E || !H.can_feel_pain())
			nopain = 2
		else if(BP_IS_ROBOTIC(E))
			nopain = 1

	var/part = E ? "'s [E.name]" : ""
	user.visible_message(SPAN_DANGER("[user] shoves [victim][part] into [src]!"))
	if (damage > 0)
		if(E)

			if(LAZYLEN(E.children))
				for(var/C in E.children)
					var/obj/item/organ/external/child = C
					if(nopain && nopain < 2 && !BP_IS_ROBOTIC(child))
						nopain = 0
					child.take_damage(0, damage, used_weapon = "hot oil")
					damage -= (damage*0.5)//IF someone's arm is plunged in, the hand should take most of it

			E.take_damage(0, damage, used_weapon = "hot oil")
		else
			victim.apply_damage(damage, BURN, user.zone_sel.selecting)

		if(!nopain)
			var/arrows_var1 = E ? E.name : "flesh"
			to_chat(victim, SPAN_DANGER("Agony consumes you as searing hot oil scorches your [arrows_var1] horribly!"))
			victim.emote("scream")
		else
			var/arrows_var2 = E ? E.name : "flesh"
			to_chat(victim, SPAN_DANGER("Searing hot oil scorches your [arrows_var2]!"))

		admin_attack_log(user, victim, "[cook_type]", "Was [cook_type]", cook_type)

	//Coat the victim in some oil
	oil.trans_to(victim, 40)

/obj/machinery/appliance/cooker/fryer/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass) && I.reagents)
		if (I.reagents.total_volume <= 0 && oil)
			//Its empty, handle scooping some hot oil out of the fryer
			oil.trans_to(I, I.reagents.maximum_volume)
			user.visible_message("[user] scoops some oil out of [src].", SPAN_NOTICE("You scoop some oil out of [src]."))
			return TRUE
	//It contains stuff, handle pouring any oil into the fryer
	//Possibly in future allow pouring non-oil reagents in, in  order to sabotage it and poison food.
	//That would really require coding some sort of filter or better replacement mechanism first
	//So for now, restrict to oil only
		var/amount = 0
		for (var/_R in I.reagents.reagent_volumes)
			if (ispath(_R, /decl/reagent/nutriment/triglyceride/oil))
				var/delta = REAGENTS_FREE_SPACE(oil)
				delta = min(delta, I.reagents.reagent_volumes[_R])
				oil.add_reagent(_R, delta)
				I.reagents.remove_reagent(_R, delta)
				amount += delta
		if (amount > 0)
			user.visible_message("[user] pours some oil into [src].", SPAN_NOTICE("You pour [amount]u of oil into [src]."), SPAN_NOTICE("You hear something viscous being poured into a metal container."))
			return TRUE
	//If neither of the above returned, then call parent as normal
	..()
