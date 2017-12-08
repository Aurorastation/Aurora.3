var/list/lunchables_lunches_ = list(
)

var/list/lunchables_snacks_ = list(
)

var/list/lunchables_drinks_ = list(
)

// This default list is a bit different, it contains items we don't want
var/list/lunchables_drink_reagents_ = list(
	/datum/reagent/drink/nothing,
	/datum/reagent/drink/doctor_delight,
	/datum/reagent/drink/dry_ramen,
	/datum/reagent/drink/hell_ramen,
	/datum/reagent/drink/hot_ramen,
	/datum/reagent/drink/nuka_cola,
	/datum/reagent/drink/black_coffee,
	/datum/reagent/drink/white_coffee,
	/datum/reagent/drink/cafe_melange
)

// This default list is a bit different, it contains items we don't want
var/list/lunchables_ethanol_reagents_ = list(
	/datum/reagent/ethanol/acid_spit,
	/datum/reagent/ethanol/atomicbomb,
	/datum/reagent/ethanol/beepsky_smash,
	/datum/reagent/ethanol/coffee,
	/datum/reagent/ethanol/hippies_delight,
	/datum/reagent/ethanol/hooch,
	/datum/reagent/ethanol/thirteenloko,
	/datum/reagent/ethanol/manhattan_proj,
	/datum/reagent/ethanol/neurotoxin,
	/datum/reagent/ethanol/pwine,
	/datum/reagent/ethanol/threemileisland,
	/datum/reagent/ethanol/toxins_special
)

/proc/lunchables_lunches()
	if(!(lunchables_lunches_[lunchables_lunches_[1]]))
		lunchables_lunches_ = init_lunchable_list(lunchables_lunches_)
	return lunchables_lunches_

/proc/lunchables_snacks()
	if(!(lunchables_snacks_[lunchables_snacks_[1]]))
		lunchables_snacks_ = init_lunchable_list(lunchables_snacks_)
	return lunchables_snacks_

/proc/lunchables_drinks()
	if(!(lunchables_drinks_[lunchables_drinks_[1]]))
		lunchables_drinks_ = init_lunchable_list(lunchables_drinks_)
	return lunchables_drinks_

/proc/lunchables_drink_reagents()
	if(!(lunchables_drink_reagents_[lunchables_drink_reagents_[1]]))
		lunchables_drink_reagents_ = init_lunchable_reagent_list(lunchables_drink_reagents_, /datum/reagent/drink)
	return lunchables_drink_reagents_

/proc/lunchables_ethanol_reagents()
	if(!(lunchables_ethanol_reagents_[lunchables_ethanol_reagents_[1]]))
		lunchables_ethanol_reagents_ = init_lunchable_reagent_list(lunchables_ethanol_reagents_, /datum/reagent/ethanol)
	return lunchables_ethanol_reagents_

/proc/init_lunchable_list(var/list/lunches)
	. = list()
	for(var/lunch in lunches)
		var/obj/O = lunch
		.[initial(O.name)] = lunch

	sortTim(., /proc/cmp_text_asc)

/proc/init_lunchable_reagent_list(var/list/banned_reagents, var/reagent_types)
	. = list()
	for(var/reagent_type in subtypesof(reagent_types))
		if(reagent_type in banned_reagents)
			continue
		var/datum/reagent/reagent = reagent_type
		.[initial(reagent.name)] = initial(reagent.id)

	sortTim(., /proc/cmp_text_asc)
