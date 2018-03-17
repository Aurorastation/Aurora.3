var/list/lunchables_lunches_ = list(
	/obj/item/weapon/reagent_containers/food/snacks/sandwich,
	/obj/item/weapon/reagent_containers/food/snacks/meatbreadslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/tofubreadslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/margheritaslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/tastybread,
	/obj/item/weapon/reagent_containers/food/snacks/liquidfood,
	/obj/item/weapon/reagent_containers/food/snacks/jellysandwich/cherry,
	/obj/item/weapon/reagent_containers/food/snacks/tossedsalad,
	/obj/item/weapon/reagent_containers/food/snacks/koiswaffles,
	/obj/item/weapon/reagent_containers/food/snacks/funnelcake,
	/obj/item/weapon/reagent_containers/food/snacks/hotdog
)

var/list/lunchables_snacks_ = list(
	/obj/item/weapon/reagent_containers/food/snacks/donut/jelly,
	/obj/item/weapon/reagent_containers/food/snacks/donut/cherryjelly,
	/obj/item/weapon/reagent_containers/food/snacks/muffin,
	/obj/item/weapon/reagent_containers/food/snacks/popcorn,
	/obj/item/weapon/reagent_containers/food/snacks/sosjerky,
	/obj/item/weapon/reagent_containers/food/snacks/no_raisin,
	/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie,
	/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers,
	/obj/item/weapon/reagent_containers/food/snacks/poppypretzel,
	/obj/item/weapon/reagent_containers/food/snacks/carrotfries,
	/obj/item/weapon/reagent_containers/food/snacks/candiedapple,
	/obj/item/weapon/reagent_containers/food/snacks/applepie,
	/obj/item/weapon/reagent_containers/food/snacks/cherrypie,
	/obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit,
	/obj/item/weapon/reagent_containers/food/snacks/appletart,
	/obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/plaincakeslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/orangecakeslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/limecakeslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/lemoncakeslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/chocolatecakeslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/birthdaycakeslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/watermelonslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/applecakeslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/pumpkinpieslice/filled,
	/obj/item/weapon/reagent_containers/food/snacks/skrellsnacks,
	/obj/item/weapon/reagent_containers/food/snacks/friedkois,
	/obj/item/weapon/reagent_containers/food/snacks/meatsnack,
	/obj/item/weapon/reagent_containers/food/snacks/maps,
	/obj/item/weapon/reagent_containers/food/snacks/nathisnack
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
	/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater
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

/proc/lunchables_ethanol_reagents()
	if(!(lunchables_ethanol_reagents_[lunchables_ethanol_reagents_[1]]))
		lunchables_ethanol_reagents_ = init_lunchable_reagent_list(lunchables_ethanol_reagents_, /datum/reagent/alcohol/ethanol)
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
