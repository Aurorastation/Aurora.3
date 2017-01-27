/datum/gear/cane
	display_name = "cane"
	path = /obj/item/weapon/cane

/datum/gear/dice
	display_name = "d20"
	path = /obj/item/weapon/dice/d20

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/weapon/deck/cards

/datum/gear/tarot
	display_name = "deck of tarot cards"
	path = /obj/item/weapon/deck/tarot

/datum/gear/holder
	display_name = "card holder"
	path = /obj/item/weapon/deck/holder

/datum/gear/cardemon_pack
	display_name = "cardemon booster pack"
	path = /obj/item/weapon/pack/cardemon

/datum/gear/spaceball_pack
	display_name = "spaceball booster pack"
	path = /obj/item/weapon/pack/spaceball

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_ethanol_reagents())

/datum/gear/vacflask
	display_name = "vacuum-flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/boot_knife
	display_name = "boot knife"
	path = /obj/item/weapon/material/kitchen/utensil/knife/boot
	cost = 3

/datum/gear/cape
	display_name = "tunnel cloak"
	path = /obj/item/weapon/storage/backpack/cloak
	cost = 1

/datum/gear/lunchbox
	display_name = "lunchbox"
	description = "A little lunchbox."
	cost = 2
	path = /obj/item/weapon/storage/toolbox/lunchbox

/datum/gear/lunchbox/New()
	..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/weapon/storage/toolbox/lunchbox))
		var/obj/item/weapon/storage/toolbox/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(lunchboxes))
	gear_tweaks += new/datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())