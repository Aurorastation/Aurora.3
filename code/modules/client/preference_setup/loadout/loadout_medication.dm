// Mask
/datum/gear/medication
	display_name = "x7 Escitalopram Pills (5u)"
	path = /obj/item/weapon/storage/pill_bottle/escitalopram
	cost = 1

/datum/gear/medication/spawn_item(var/location, var/metadata, var/user)
	if(!..())
		return
	new /obj/item/weapon/paper/snowflake(location,display_name,user)
	for(var/obj/machinery/minifax/chem_fax in all_minifaxes)
		if(chem_fax.preset == "chemistry")
			new /obj/item/weapon/paper/snowflake(chem_fax.loc,display_name,user)

/datum/gear/medication/methylphenidate
	display_name = "x7 Methylphenidate Pills (5u)"
	path = /obj/item/weapon/storage/pill_bottle/methylphenidate

/datum/gear/medication/fluvoxamine
	display_name = "x7 Fluvoxamine Pills (5u)"
	path = /obj/item/weapon/storage/pill_bottle/fluvoxamine



