	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	storage_slots = 14

	..()
	for(var/i=0;i<storage_slots,i++) // Fill 'er up.

	name = "microscope slide box"
	icon_state = "solution_trays"
	storage_slots = 7

	..()
	for(var/i=0;i<storage_slots,i++)

	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	storage_slots = 6

	..()
	for(var/i=0;i<storage_slots,i++)

	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	storage_slots = 14

	..()
	for(var/i=0;i<storage_slots,i++)
