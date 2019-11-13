/obj/item/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/forensics/swab)
	storage_slots = 14

/obj/item/storage/box/swabs/fill()
	..()
	for(var/i=0;i<storage_slots,i++) // Fill 'er up.
		new /obj/item/forensics/swab(src)

/obj/item/storage/box/slides
	name = "microscope slide box"
	icon_state = "solution_trays"
	storage_slots = 7

/obj/item/storage/box/slides/fill()
	..()
	for(var/i=0;i<storage_slots,i++)
		new /obj/item/forensics/slide(src)

/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	storage_slots = 6

/obj/item/storage/box/evidence/fill()
	..()
	for(var/i=0;i<storage_slots,i++)
		new /obj/item/evidencebag(src)

/obj/item/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/sample/print)
	storage_slots = 14

/obj/item/storage/box/fingerprints/fill()
	..()
	for(var/i=0;i<storage_slots,i++)
		new /obj/item/sample/print(src)
