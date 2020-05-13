/mob/living/carbon/proc/ingest(var/datum/reagents/from, var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) //we kind of 'sneak' a proc in here for ingesting stuff so we can play with it.
	if(last_taste_time + 50 < world.time)
		var/datum/reagents/temp = new(amount) //temporary holder used to analyse what gets transfered.
		from.trans_to_holder(temp, amount, multiplier, 1)

		var/text_output = temp.generate_taste_message(src)
		if(text_output != last_taste_text || last_taste_time + 100 < world.time) //We dont want to spam the same message over and over again at the person. Give it a bit of a buffer.
			to_chat(src, "<span class='notice'>You can taste [text_output]</span>")//no taste means there are too many tastes and not enough flavor.
			last_taste_time = world.time
			last_taste_text = text_output
	return from.trans_to_holder(target,amount,multiplier,copy) //complete transfer

/* what this does:
catalogue the 'taste strength' of each one
calculate text size per text.
*/
/datum/reagents/proc/generate_taste_message(mob/living/carbon/taster = null)
	var/minimum_percent = 15
	if(ishuman(taster))
		var/mob/living/carbon/human/H = taster
		var/total_taste_sensitivity

		var/obj/item/organ/internal/augment/taste_booster/booster = H.internal_organs_by_name[BP_AUG_TASTE_BOOSTER]
		if(booster && !booster.is_broken())
			total_taste_sensitivity = booster.new_taste
		else
			total_taste_sensitivity = H.species.taste_sensitivity

		minimum_percent = round(15 / (H.isSynthetic() ? TASTE_DULL : total_taste_sensitivity))

	var/list/out = list()
	var/list/tastes = list() //descriptor = strength
	var/lukewarm = 0 // should we allow it to be lukewarm or not
	if(minimum_percent <= 100)
		for(var/datum/reagent/R in reagent_list)
			if(!R.taste_mult)
				continue
			if(R.id == "nutriment" || R.id == "synnutriment") //this is ugly but apparently only nutriment (not subtypes) has taste data TODO figure out why
				var/list/taste_data = R.get_data()
				for(var/taste in taste_data)
					if(taste in tastes)
						tastes[taste] += taste_data[taste]
					else
						tastes[taste] = taste_data[taste]
			else
				var/taste_desc = R.taste_description
				var/taste_amount = get_reagent_amount(R.id) * R.taste_mult
				if(R.taste_description in tastes)
					tastes[taste_desc] += taste_amount
				else
					tastes[taste_desc] = taste_amount
				if(R.default_temperature >= (T0C + 15) && R.default_temperature <= (T0C + 25))
					lukewarm = 1

		//deal with percentages
		var/total_taste = 0
		for(var/taste_desc in tastes)
			total_taste += tastes[taste_desc]
		for(var/taste_desc in tastes)
			var/percent = tastes[taste_desc]/total_taste * 100
			if(percent < minimum_percent)
				continue
			var/intensity_desc = "a hint of"
			if(percent > minimum_percent * 2 || percent == 100)
				intensity_desc = ""
			else if(percent > minimum_percent * 3)
				intensity_desc = "the strong flavor of"
			if(intensity_desc == "")
				out += "[taste_desc]"
			else
				out += "[intensity_desc] [taste_desc]"

	var/temp_text = ""
	switch(get_temperature())
		if(-INFINITY to T0C - 50)
			temp_text = "lethally freezing"
		if(T0C - 50 to T0C - 25)
			temp_text = "freezing"
		if(T0C - 25 to T0C - 10)
			temp_text = "very cold"
		if(T0C - 10 to T0C)
			temp_text = "cold"
		if(T0C to T0C + 15)
			temp_text = "cool"
		if(T0C + 15 to T0C + 25)
			if(lukewarm)
				temp_text = "lukewarm"
		if(T0C + 25 to T0C + 40)
			temp_text = "warm"
		if(T0C + 40 to T0C + 100)
			temp_text = "hot"
		if(T0C + 100 to T0C + 120)
			temp_text = "scalding hot"
		if(T0C + 120 to T0C + 200)
			temp_text = "molten hot"
		if(T0C + 200 to INFINITY)
			temp_text = "lethally hot"

	return "[temp_text][temp_text ? " " : ""][english_list(out, "something indescribable")]."

/mob/living/carbon/proc/get_fullness()
	return nutrition + (reagents.get_reagent_amount("nutriment") * 25)
