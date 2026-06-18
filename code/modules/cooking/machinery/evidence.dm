/obj/structure/machinery/smartfridge/tradeshelf/evidence
	name = "evidence shelf"
	desc = "A shelf for evidence and associated items."
	icon_state = "evidence_shelf"
	contents_path = "-evidencebox"
	accepted_items = list(/obj/item/storage/box,
	/obj/item/folder,
	/obj/item/clipboard,
	/obj/item/journal,
	/obj/item/smallDelivery
	)
	display_tiers = 6
	display_tier_amt = 2
	has_emissive = FALSE
	visible_takeout = TRUE

    initial_contents = list(/obj/item/storage/box/large = 6,
                        /obj/item/storage/box = 6)
