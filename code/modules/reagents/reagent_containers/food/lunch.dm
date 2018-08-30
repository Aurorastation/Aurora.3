var/list/lunchables_lunches_ = list(
	/obj/item/weapon/reagent_containers/food/drinks/dry_ramen,
	/obj/item/weapon/reagent_containers/food/snacks/tastybread,
	/obj/item/weapon/reagent_containers/food/snacks/meatsnack,
	/obj/item/weapon/reagent_containers/food/snacks/maps,
	/obj/item/weapon/reagent_containers/food/snacks/nathisnack,
	/obj/item/weapon/reagent_containers/food/snacks/koisbar_clean
)

var/list/lunchables_snacks_ = list(
	/obj/item/weapon/reagent_containers/food/snacks/candy,
	/obj/item/weapon/reagent_containers/food/snacks/chips,
	/obj/item/weapon/reagent_containers/food/snacks/sosjerky,
	/obj/item/weapon/reagent_containers/food/snacks/no_raisin,
	/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie,
	/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers,
	/obj/item/weapon/reagent_containers/food/snacks/skrellsnacks,
)

var/list/lunchables_drinks_ = list(
	/obj/item/weapon/reagent_containers/food/drinks/cans/cola,
	/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle,
	/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind,
	/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb,
	/obj/item/weapon/reagent_containers/food/drinks/cans/starkist,
	/obj/item/weapon/reagent_containers/food/drinks/cans/space_up,
	/obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime,
	/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea,
	/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice,
	/obj/item/weapon/reagent_containers/food/drinks/cans/tonic,
	/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater,
	/obj/item/weapon/reagent_containers/food/drinks/cans/koispunch
)

// This default list is a bit different, it contains items we don't want
var/list/lunchables_drink_reagents_ = list(
	/datum/reagent/drink/nothing,
	/datum/reagent/drink/doctor_delight,
	/datum/reagent/drink/dry_ramen,
	/datum/reagent/drink/hell_ramen,
	/datum/reagent/drink/hot_ramen,
	/datum/reagent/drink/nuka_cola
)

// This default list is a bit different, it contains items we don't want
var/list/lunchables_alcohol_reagents_ = list(
	/datum/reagent/alcohol/ethanol,
	/datum/reagent/alcohol/butanol,
	/datum/reagent/alcohol/ethanol/acid_spit,
	/datum/reagent/alcohol/ethanol/atomicbomb,
	/datum/reagent/alcohol/ethanol/beepsky_smash,
	/datum/reagent/alcohol/ethanol/coffee,
	/datum/reagent/alcohol/ethanol/hippies_delight,
	/datum/reagent/alcohol/ethanol/hooch,
	/datum/reagent/alcohol/ethanol/thirteenloko,
	/datum/reagent/alcohol/ethanol/manhattan_proj,
	/datum/reagent/alcohol/ethanol/neurotoxin,
	/datum/reagent/alcohol/ethanol/pwine,
	/datum/reagent/alcohol/ethanol/threemileisland,
	/datum/reagent/alcohol/ethanol/toxins_special
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

/proc/lunchables_alcohol_reagents()
	if(!(lunchables_alcohol_reagents_[lunchables_alcohol_reagents_[1]]))
		lunchables_alcohol_reagents_ = init_lunchable_reagent_list(lunchables_alcohol_reagents_, /datum/reagent/alcohol)
	return lunchables_alcohol_reagents_

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
