/obj/item/clothing/suit/storage
	var/obj/item/storage/internal/pockets

/obj/item/clothing/suit/storage/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 2	//two slots
	pockets.max_w_class = ITEMSIZE_SMALL		//fit only pocket sized items
	pockets.max_storage_space = 4

/obj/item/clothing/suit/storage/Destroy()
	qdel(pockets)
	pockets = null
	return ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user as mob)
	if (pockets.handle_attack_hand(user))
		..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object as obj)
	if (pockets.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/suit/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/clothing/accessory))
		return
	pockets.attackby(W, user)

/obj/item/clothing/suit/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()

/obj/item/clothing/suit/storage/hear_talk(mob/M, var/msg, verb, datum/language/speaking)
	pockets.hear_talk(M, msg, verb, speaking)
	..()

//Jackets with buttons
/obj/item/clothing/suit/storage/toggle
	var/opened = FALSE

/obj/item/clothing/suit/storage/toggle/verb/toggle()
	set name = "Toggle Coat Buttons"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return 0

	toggle_open()

/obj/item/clothing/suit/storage/toggle/proc/toggle_open()
	opened = !opened
	to_chat(usr, SPAN_NOTICE("You [opened ? "unbutton" : "button up"] \the [src]."))
	playsound(src, /decl/sound_category/rustle_sound, EQUIP_SOUND_VOLUME, TRUE)
	icon_state = "[initial(icon_state)][opened ? "_open" : ""]"
	item_state = icon_state
	update_icon()
	update_clothing_icon()

/obj/item/clothing/suit/storage/toggle/Initialize()
	. = ..()
	if(opened) // for stuff that's supposed to spawn opened, like labcoats.
		icon_state = "[initial(icon_state)][opened ? "_open" : ""]"
		item_state = icon_state

/obj/item/clothing/suit/storage/vest/hos/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 4
	pockets.max_w_class = ITEMSIZE_SMALL
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/vest
	var/icon_badge
	var/icon_nobadge
	verb/toggle()
		set name ="Adjust Badge"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(icon_state == icon_badge)
			icon_state = icon_nobadge
			to_chat(usr, "You conceal \the [src]'s badge.")
		else if(icon_state == icon_nobadge)
			icon_state = icon_badge
			to_chat(usr, "You reveal \the [src]'s badge.")
		else
			to_chat(usr, "\The [src] does not have a vest badge.")
			return
		update_clothing_icon()

// Corporate Jackets

/obj/item/clothing/suit/storage/toggle/corp/idris
	name = "idris corporate jacket"
	desc = "A cozy jacket in Idris' colors, for those who need more merchandise in their life."
	icon_state = "idris_corp_jacket"

/obj/item/clothing/suit/storage/toggle/corp/idris/alt
	icon_state "idris_corp_jacket_alt"

/obj/item/clothing/suit/storage/toggle/corp/zavod
	name = "zavodskoi corporate jacket"
	desc = "A cozy jacket in Zavodskoi's colors, professional and intimidating."
	icon_state = "zavod_corp_jacket"

/obj/item/clothing/suit/storage/toggle/corp/zavod/alt
	icon_state "zavod_corp_jacket_alt"

/obj/item/clothing/suit/storage/toggle/corp/pmc
	name = "pmcg corporate jacket"
	desc = "A cozy jacket in PMCG's colors, made out of military grade material."
	icon_state = "pmc_corp_jacket"

/obj/item/clothing/suit/storage/toggle/corp/pmc/alt
	icon_state "epmc_corp_jacket"

/obj/item/clothing/suit/storage/toggle/corp/heph
	name = "hephaestus corporate jacket"
	desc = "A cozy jacket in Hepheastus' colors, as heavy duty as they come."
	icon_state = "heph_corp_jacket"

/obj/item/clothing/suit/storage/toggle/corp/nt
	name = "nanotrasen corporate jacket"
	desc = "A cozy jacket in NanoTrasen's colors, perfect if you live for a phoron company."
	icon_state = "nt_corp_jacket"

/obj/item/clothing/suit/storage/toggle/corp/zeng
	name = "zeng-hu corporate jacket"
	desc = "A cozy jacket in Zeng-Hu's colors, optional augmentations not included."
	icon_state = "zeng_corp_jacket"

/obj/item/clothing/suit/storage/toggle/corp/zeng/alt
	icon_state "zeng_corp_jacket_alt"

/obj/item/clothing/suit/storage/toggle/corp/orion
	name = "orion corporate jacket"
	desc = "A cozy jacket in Orion's colors, perfect for hauling freight day and night."
	icon_state = "orion_corp_jacket"

/obj/item/clothing/suit/storage/toggle/corp/orion/alt
	icon_state "orion_corp_jacket_alt"

/obj/item/clothing/suit/storage/toggle/corp/scc
	name = "scc corporate jacket"
	desc = "A cozy jacket in the SCC's colors, the finest jacket of them all."
	icon_state = "scc_corp_jacket"

/obj/item/clothing/suit/storage/toggle/corp/scc/alt
	icon_state "scc_corp_jacket_alt"