/obj/machinery/acting/wardrobe
	name = "wardrobe dispenser"
	desc = "A machine that dispenses holo-clothing for those in need."
	icon = 'icons/obj/vending.dmi'
	icon_state = "cart"
	anchored = 1
	density = 1
	var/active = 1

/obj/machinery/acting/wardrobe/attack_hand(var/mob/user as mob)
	user.show_message("You push a button and watch patiently as the machine begins to hum.")
	if(active)
		active = 0
		spawn(30)
			new /obj/item/storage/box/syndie_kit/chameleon(src.loc)
			src.visible_message("\The [src] beeps, dispensing a small box onto the floor.", "You hear a beeping sound followed by a thumping noise of some kind.")
			active = 1

/obj/machinery/acting/changer
	name = "Quickee's Plastic Surgeon"
	desc = "For when you need to be someone else right now."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bioprinter"
	anchored = 1
	density = 1

/obj/machinery/acting/changer/attack_hand(var/mob/living/carbon/human/H)
	if(!istype(H))
		return

	H.change_appearance(APPEARANCE_ALL, H, TRUE, H.generate_valid_species(), null, default_state, src)
	var/getName = sanitizeName(sanitize_readd_odd_symbols(sanitize(input(H, "Would you like to change your name to something else?", "Name change") as null|text)))
	if(getName)
		H.real_name = getName
		H.name = getName
		H.dna.real_name = getName
		if(H.mind)
			H.mind.name = H.name
		var/obj/item/card/id/ID = H.GetIdCard()
		if(ID)
			ID.registered_name = H.real_name
			ID.update_name()
