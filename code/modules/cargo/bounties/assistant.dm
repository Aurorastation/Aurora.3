/datum/bounty/item/assistant/briefcase
	name = "Briefcase"
	description = "%BOSSNAME will be holding a business convention this year. Ship a few briefcases in support."
	reward_low = 20
	reward_high = 30
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/storage/briefcase)
	exclude_types = list(/obj/item/storage/briefcase/crimekit)

/datum/bounty/item/assistant/lung
	name = "Lungs"
	description = "A recent explosion at %BOSSNAME has left multiple staff with punctured lungs. Ship spare lungs to be rewarded- and save some lives."
	reward_low = 520
	reward_high = 635
	wanted_types = list(/obj/item/organ/internal/lungs)

/datum/bounty/item/assistant/appendix
	name = "Appendix"
	description = "%PERSONNAME wants our chefs to prepare a strange meal using a very special delicacy: an appendix. If you ship one, they'll pay."
	reward_low = 425
	reward_high = 535
	wanted_types = list(/obj/item/organ/internal/appendix)

/datum/bounty/item/assistant/hand_tele
	name = "Hand Tele"
	description = "%BOSSNAME has come up with a genius idea: Why not teleport cargo rather than ship it? Send over a hand tele, receive payment, then wait 6-8 years while they deliberate."
	reward_low = 300
	reward_high = 550
	wanted_types = list(/obj/item/hand_tele)

/datum/bounty/item/assistant/monkey_cubes
	name = "Monkey Cubes"
	description = "Due to a recent genetics accident, %BOSSNAME is in serious need of monkeys. Your mission is to ship monkey cubes."
	reward_low = 180
	reward_high = 240
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/food/snacks/monkeycube)

/datum/bounty/item/assistant/curtains
	name = "Curtain"
	description = "Send us some curtains to help redecorate our offices!"
	reward_low = 250
	reward_high = 270
	required_count = 5
	random_count = 2
	wanted_types = list(/obj/structure/curtain)

/datum/bounty/item/assistant/action_figures
	name = "Action Figures"
	description = "%PERSONNAME wants a few action figures for their collection, and is willing to pay any station who provides."
	reward_low = 120
	reward_high = 130
	required_count = 5
	random_count = 3
	wanted_types = list(/obj/item/toy/figure)

/datum/bounty/item/assistant/water_tank
	name = "Water Tank"
	description = "Send us some water tanks that will be used for botany research, and definitely not for creating a slip 'n slide in %PERSONNAME's office."
	reward_low = 115
	reward_high = 135
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/structure/reagent_dispensers/watertank)

/datum/bounty/item/assistant/water_tank/applies_to(var/obj/structure/reagent_dispensers/watertank/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(REAGENT_VOLUME(O.reagents, /singleton/reagent/water) >= 750)
		return TRUE
	return FALSE

/datum/bounty/item/assistant/wheelchair
	name = "Wheelchairs"
	description = "The medical bay at the %DOCKSHORT has been busier than usual; we're requesting some spare wheelchairs for patient transport."
	reward_low = 123
	reward_high = 140
	required_count = 2
	wanted_types = list(/obj/structure/bed/stool/chair/office/wheelchair, /obj/item/material/stool/chair/wheelchair)

/datum/bounty/item/assistant/film
	name = "Camera Film"
	description = "We received a gift from a delegate on Adhomai- a group of some sort of small, fat xenofauna. Everyone thinks they're cute and we're low on film from all the pictures!"
	reward_low = 55
	reward_high = 80
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/device/camera_film)

/datum/bounty/item/assistant/trash
	name = "Trash"
	description = "It's time for the %COMPNAME cleanup initiative! Clean stations will receive a bonus; pick up the litter from around your station and send it to us as proof!"
	reward_low = 100
	reward_high = 150
	required_count = 15
	random_count = 5
	wanted_types = list(/obj/item/trash)

/datum/bounty/item/assistant/heart
	name = "Heart"
	description = "%PERSONNAME is in critical condition after suffering a heart attack. Doctors say they need a new heart, fast. Ship one, pronto! Organic or mechanical, just hurry up!"
	reward_low = 825
	reward_high = 840
	wanted_types = list(/obj/item/organ/internal/heart)

/datum/bounty/item/assistant/statue
	name = "Statue"
	description = "%BOSSNAME would like to commision an artsy statue for the lobby. Ship one out, when possible."
	reward_low = 750
	reward_high = 1250
	wanted_types = list(/obj/structure/sculpting_block)

/datum/bounty/item/assistant/statue/applies_to(var/obj/structure/sculpting_block/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(O.sculpted)
		return TRUE
	return FALSE

/datum/bounty/item/assistant/tajcard
	name = "Collectable Card"
	description = "%PERSONNAME is offering a bonus to any station that can help them expand their collection of collectable tajaran cards."
	reward_low = 180
	reward_high = 220
	required_count = 2
	wanted_types = list(/obj/item/tajcard)

/datum/bounty/item/assistant/jetpack
	name = "Jetpacks"
	description = "We're engaging in an EVA training initiative for new miners. Ship us a few jetpacks for a station bonus."
	reward_low = 300
	reward_high = 400
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/tank/jetpack)

/datum/bounty/item/assistant/cleaner
	name = "Space Cleaner"
	description = "The janitorial division of the ERT is requesting some actual supplies, to insist they aren't a joke. They're putting up for a bounty, so humor them if you want."
	reward_low = 55
	reward_high = 85
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/spray)

/datum/bounty/item/assistant/cleaner/applies_to(var/obj/item/reagent_containers/spray/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(REAGENT_VOLUME(O.reagents, /singleton/reagent/spacecleaner) >= 20)
		return TRUE
	return FALSE

//Can't wait to see people have fun with THIS one.
/datum/bounty/item/assistant/photograph
	name = "Photographs"
	description = "The %DOCKNAME is holding a morale project, and part of that is to display photographs from the various stations. Send us some for a participation bonus!"
	reward_low = 75
	reward_high = 250
	required_count = 8
	random_count = 2
	wanted_types = list(/obj/item/photo)
