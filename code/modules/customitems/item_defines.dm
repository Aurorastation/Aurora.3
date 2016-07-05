/// Aurora custom items ///
// Add custom items to this file, their sprites into their own dmi. in the icons/obj/custom_items
// Clothing items will probably require contained sprites

/obj/item/clothing/accessory/fluff/antique_pocket_watch //Antique Pocket Watch - Eric Derringer - xelnagahunter - Done
	name = "antique pocket watch"
	icon = 'icons/obj/custom_items/pocket_watch.dmi'
	icon_state = "pocket_watch_close"
	item_state = "gold"
	desc = "The design of this pocket watch signals its age, however it seems to retain its pristine quality. The cover is gold, and there appears to be an elegant crest on the outside of the lid."
	w_class = 2

/obj/item/clothing/accessory/fluff/antique_pocket_watch/attack_self(mob/user as mob)
	switch(icon_state)
		if("pocket_watch_open")
			icon_state = "pocket_watch_close"
			usr << "You close the [src]."
			desc = "The design of this pocket watch signals its age, however it seems to retain its pristine quality. The cover is gold, and there appears to be an elegant crest on the outside of the lid."
		if("pocket_watch_close")
			icon_state = "pocket_watch_open"
			usr << "You open the [src]."
			desc = "Inside the pocket watch, there is a collection of numbers, displaying '[worldtime2text()]'. On the inside of the lid, there is another sequence of numbers etched into the lid itself."


/obj/item/clothing/head/soft/sec/corp/fluff/mendoza_cap //Mendoza's cap - Chance Mendoza - loow - DONE
	name = "Mendoza's corporate security cap"
	desc = "A baseball hat in corporate colors.'C. Mendoza' is embroidered in fine print on the bill. On the underside of the cap, in dark ink, the phrase 'Gamble till you're Lucky!' is written in loopy cursive handwriting."


/obj/item/clothing/head/fluff/ziva_bandana //Ziva's Bandana - Ziva Ta'Kim - sierrakomodo - DONE
	name = "old bandana"
	desc = "An old orange-ish-yellow bandana. It has a few stains from engine grease, and the color has been dulled."
	icon = 'icons/obj/custom_items/motaki_bandana.dmi'
	icon_state = "motaki_bandana"
	contained_sprite = 1


/obj/item/clothing/suit/armor/vest/fluff/zubari_jacket //Fancy Jacket - Zubari Akenzua - filthyfrankster - DONE
	name = "fancy jacket"
	desc = "A well tailored unathi styled armored jacket, fitted for one too."
	icon = 'icons/obj/custom_items/zubari_jacket.dmi'
	icon_state = "zubari_jacket"
	contained_sprite = 1


/obj/item/clothing/suit/unathi/mantle/fluff/yinzr_mantle //Heirloom Unathi Mantle - Sslazhir Yinzr - alberyk - DONE
	name = "heirloom unathi mantle"
	desc = "A withered mantle sewn from threshbeast's hides, the pauldrons that holds it on the shoulders seems to be the remains of some kind of old armor."
	icon = 'icons/obj/custom_items/yinzr_mantle.dmi'
	icon_state = "yinzr_mantle" //special thanks to Araskael
	species_restricted = list("Unathi") //forged for lizardmen
	contained_sprite = 1


/obj/item/clothing/glasses/fluff/nebula_glasses	//chich eyewear - Roxy Wallace - nebulaflare - DONE
	name = "chic eyewear"
	desc = "A stylish pair of glasses. They look custom made."
	icon = 'icons/obj/custom_items/nebula_glasses.dmi'
	icon_state = "nebula_glasses"
	contained_sprite = 1

/obj/item/clothing/glasses/fluff/nebula_glasses/var/chip
	/obj/item/clothing/glasses/fluff/nebula_glasses/New()
		chip = new /obj/item/weapon/disk/fluff/nebula_chip()
		..()

/obj/item/clothing/glasses/fluff/nebula_glasses/attack_self(mob/user as mob)
	if(chip)
		user.put_in_hands(chip)
		user << "\blue You eject a small, concealed data chip from a small slot in the frames of the [src]."
		chip = null

/obj/item/clothing/glasses/fluff/nebula_glasses/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/disk/fluff/nebula_chip) && !chip)
		user.u_equip(W)
		W.loc = src
		chip = W
		W.dropped(user)
		W.add_fingerprint(user)
		add_fingerprint(user)
		user << "You slot the [W] back into its place in the frames of the [src]."

/obj/item/weapon/disk/fluff/nebula_chip //data chip - Roxy Wallace - nebulaflare - DONE
	name = "data chip"
	desc = "A small green chip."
	icon = 'icons/obj/custom_items/nebula_chip.dmi'
	icon_state = "nebula_chip"
	w_class = 1


/obj/item/clothing/gloves/swat/fluff/hawk_gloves //Sharpshooter gloves - Hawk Silverstone - nebulaflare - DONE
	name = "\improper sharpshooter gloves"
	desc = "These tactical gloves are tailor made for a marksman."
	icon = 'icons/obj/custom_items/hawk_gloves.dmi'
	icon_state = "hawk_gloves"
	item_state = "swat_gl"


/obj/item/clothing/accessory/fluff/karima_datadrive //Data Drive Pendant -  Kyyir'ry'avii Mo'Taki - nebulaflare - DONE
	name = "Data drive"
	desc = "A small necklace, the pendant flips open to reveal a data drive."
	icon = 'icons/obj/custom_items/motaki_datadrive.dmi'
	icon_state = "motaki_datadrive"
	item_state = "holobadge-cord"
	slot_flags = SLOT_MASK


/obj/item/clothing/ears/skrell/fluff/doompesh_cloth // Skrell Purple Head Cloth - Shkor-Dyet Dom'Pesh - mofo1995 - DONE
	name = "male skrell purple head cloth"
	desc = "A purple cloth band worn by male skrell around their head tails."
	icon = 'icons/obj/custom_items/doompesh_cloth.dmi'
	icon_state = "dompesh_cloth"
	contained_sprite = 1
	

/obj/item/weapons/fluff/kiara_altar // Pocket Altar - Kiara Branwen - nursiekitty - DONE
	name = "pocket altar"
	desc = "A black tin box with a symbol painted over it. It shimmers in the light."
	icon = 'icons/obj/custom_items/kiara_altar.dmi'
	icon_state = "kiara_altar1"
	w_class = 2

/obj/item/weapons/fluff/kiara_altar/attack_self(mob/user as mob)
	if(src.icon_state == "kiara_altar1")
		src.icon_state = "kiara_altar2"
		user << "You open the pocket altar, revealing its contents."
		desc = "A black tin box, you can see inside; a vial of herbs, a little bag of salt, some epoxy clay runes, a candle with match, a permanent marker and a tiny besom."
	else
		src.icon_state = "kiara_altar1"
		user << "You close the pocket altar."
		desc = "A black tin box with a symbol painted over it. It shimmers in the light."

/obj/item/clothing/head/det_hat/fluff/leo_hat //Tagged brown hat - Leo Wyatt - keinto/serveris6 - DONE
	name = "tagged brown hat"
	desc = "A worn mid 20th century brown hat. If you look closely at the back, you can see a an embedded tag from the 'Museum of Terran Culture and Technology'."
	icon = 'icons/obj/custom_items/leo_hat.dmi'
	icon_state = "leo_hat"
	contained_sprite = 1
	
	
/obj/item/clothing/suit/storage/det_suit/fluff/leo_coat //Tagged brown coat - Leo Wyatt - keinto/serveris6 - DONE
	name = "tagged brown coat"
	desc = "A worn mid 20th century brown trenchcoat. If you look closely at bottom of the back, you can see an embedded tag from the 'Museum of Terran Culture and Technology'."
	icon = 'icons/obj/custom_items/leo_coat.dmi'
	icon_state = "leo_coat"
	contained_sprite = 1
