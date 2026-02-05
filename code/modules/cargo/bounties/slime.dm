/datum/bounty/item/slime
	reward_low = 400
	reward_high = 1000

/datum/bounty/item/slime/New()
	..()
	description = "One of our science leads is hunting for a sample of [name]. A bounty has been offered for finding it."
	reward += rand(0, 4) * 50

/datum/bounty/item/slime/green
	name = "Green Slime Extract"
	wanted_types = list(/obj/item/slime_extract/green)

/datum/bounty/item/slime/pink
	name = "Pink Slime Extract"
	wanted_types = list(/obj/item/slime_extract/pink)

/datum/bounty/item/slime/gold
	name = "Gold Slime Extract"
	wanted_types = list(/obj/item/slime_extract/gold)

/datum/bounty/item/slime/oil
	name = "Oil Slime Extract"
	wanted_types = list(/obj/item/slime_extract/oil)

/datum/bounty/item/slime/black
	name = "Black Slime Extract"
	wanted_types = list(/obj/item/slime_extract/black)

/datum/bounty/item/slime/lightpink
	name = "Light Pink Slime Extract"
	wanted_types = list(/obj/item/slime_extract/lightpink)

/datum/bounty/item/slime/adamantine
	name = "Adamantine Slime Extract"
	wanted_types = list(/obj/item/slime_extract/adamantine)
