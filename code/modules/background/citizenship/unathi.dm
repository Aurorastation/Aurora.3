/datum/citizenship/izweski
	name = CITIZENSHIP_IZWESKI
	description = "RAMMING SPEED."
	consular_outfit = /datum/outfit/job/representative/consular/izweski

/datum/citizenship/izweski/get_objectives(mission_level)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Encourage [rand(1,2)] Unathi to become Zo'saa by signing up with the local Order",
							"Gather [rand(2,3)] evidences of any marginalization of Unathi beliefs")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Speak out against any violation of the Honor Code to or by Unathi on station",
							"Proselytize the Sk'akh or Tha'kh religions to the crew",
							"Encourage [rand(2,4)] Unathi to visit the Akhandi Order temples in Tau Ceti")
		else
			rep_objectives = pick("Ensure all Unathi on station are being respected in their beliefs and customs and traditions",
							"Discourage people from associating with Guwans, but convince [rand(2,3)] Guwan to redeem themselves by becoming Zo'saa or Ahkandi")

	return rep_objectives

/datum/outfit/job/representative/consular/izweski
	name = "Izweski Hegemony Consular Officer"

	uniform = /obj/item/clothing/under/unathi
	suit = /obj/item/clothing/suit/unathi/mantle
	backpack_contents = list(/obj/item/device/camera = 1)
	belt = /obj/item/weapon/material/sword/dao