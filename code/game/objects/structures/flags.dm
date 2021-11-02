/obj/structure/sign/flag
	name = "blank banner"
	desc = "A blank blue flag"
	icon_state = "flag"
	/// Is the flag ripped/torn or not. Used for icon state and checks for allowing retrieval of the flag item.
	var/torn = FALSE
	/// Holder for the flag item that is dropped when the flag is pulled down without tearing it.
	var/obj/item/flag/item_holder


/obj/item/flag
	name = "boxed flag"
	desc = "A flag neatly folded into a wooden container."
	icon = 'icons/obj/decals.dmi'
	icon_state = "flag_boxed"
	/// Icon state for the deployed flag.
	var/flag_path
	/// Whether or not the flag is a large (2 tiles wide) flag.
	var/flag_size = 0

/obj/structure/sign/flag/left
	icon_state = "flag_l"

/obj/structure/sign/flag/right
	icon_state = "flag_r"


/obj/item/flag/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if (!adjacent)
		return

	if((!iswall(A) && !istype(A, /obj/structure/window)) || !isturf(user.loc))
		to_chat(user, SPAN_WARNING("You can't place this here!"))
		return

	var/placement_dir = get_dir(user, A)
	if (!(placement_dir in cardinal))
		to_chat(user, SPAN_WARNING("You must stand directly in front of the location you wish to place that on."))
		return

	var/obj/structure/sign/flag/P = new(user.loc)

	switch(placement_dir)
		if(NORTH)
			P.pixel_y = 32
		if(SOUTH)
			P.pixel_y = -32
		if(EAST)
			P.pixel_x = 32
		if(WEST)
			P.pixel_x = -32

	P.dir = placement_dir
	if(flag_size)
		P.icon_state = "[flag_path]_l"
		var/obj/structure/sign/flag/P2 = new(user.loc)
		P2.icon_state = "[flag_path]_r"
		P2.dir = P.dir
		switch(P2.dir)
			if(NORTH)
				P2.pixel_y = P.pixel_y
				P2.pixel_x = 32
			if(SOUTH)
				P2.pixel_y = P.pixel_y
				P2.pixel_x = 32
			if(EAST)
				P2.pixel_x = P.pixel_x
				P2.pixel_y = -32
			if(WEST)
				P2.pixel_x = P.pixel_x
				P2.pixel_y = 32
		P2.name = name
		P2.desc = desc
		P2.desc_info = desc_info
		P2.desc_fluff = desc_fluff
	else
		P.icon_state = "[flag_path]"
	P.name = name
	P.desc = desc
	P.desc_info = desc_info
	P.desc_fluff = desc_fluff
	transfer_fingerprints_to(P)
	P.item_holder = src
	forceMove(P)


/obj/structure/sign/flag/attack_hand(mob/user as mob)
	if (user.a_intent == I_HURT && !torn && alert("Do you want to rip \the [src] from its place?","You think...","Yes","No") == "Yes")
		if(!do_after(user, 2 SECONDS, act_target = src))
			return 0

		user.visible_message(
			SPAN_WARNING("\The [user] rips \the [src] in a single, decisive motion!" ),
			SPAN_WARNING("You rip \the [src] in a single, decisive motion!")
		)
		playsound(loc, 'sound/items/poster_ripped.ogg', 100, 1)
		icon_state = "poster_ripped"
		name = "ripped flag"
		desc = "You can't make out anything from the flag's original print. It's ruined."
		torn = TRUE
		QDEL_NULL(item_holder)
		update_icon()
		add_fingerprint(user)


/obj/structure/sign/flag/Destroy()
	QDEL_NULL(item_holder)
	. = ..()


/obj/structure/sign/flag/attackby(obj/item/W, mob/user)
	..()

	if(W.isFlameSource())

		visible_message(SPAN_WARNING("\The [user] starts to burn \the [src] down!"))

		if(!do_after(user, 2 SECONDS, act_target = src))
			return 0
		visible_message(SPAN_WARNING("\The [user] burns \the [src] down!"))
		playsound(src.loc, 'sound/items/cigs_lighters/zippo_on.ogg', 100, 1)
		new /obj/effect/decal/cleanable/ash(src.loc)

		qdel(src)


/obj/structure/sign/flag/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	if (over != usr)
		return
	var/mob/user = over
	if (!istype(user))
		return
	if (alert(user, "Do you wish to take down and[torn ? " dispose of" : " fold up"] \the [src]?", "Take Down Flag", "Yes", "No") != "Yes")
		return
	if (torn)
		user.visible_message(
			SPAN_WARNING("\The [user] tears down the remains of \the [src]."),
			SPAN_WARNING("You tear down the remains of \the [src].")
		)
	else
		user.visible_message(
			SPAN_WARNING("\The [user] folds up \the [src]."),
			SPAN_WARNING("You fold up \the [src].")
		)
		item_holder.forceMove(get_turf(user))
		user.put_in_hands(item_holder)
		transfer_fingerprints_to(item_holder)
		item_holder.add_fingerprint(user)
		item_holder = null
	qdel(src)


/obj/structure/sign/flag/sol
	name = "Sol Alliance flag"
	desc = "The bright blue flag of the Alliance of Sovereign Solarian Nations."
	icon_state = "solgov"

/obj/structure/sign/flag/sol/left
	icon_state = "solgov_l"

/obj/structure/sign/flag/sol/right
	icon_state = "solgov_r"

/obj/item/flag/sol
	name = "Sol Alliance flag"
	desc = "The bright blue flag of the Alliance of Sovereign Solarian Nations."
	flag_path = "solgov"

/obj/item/flag/sol/l
	name = "Large Sol Alliance flag"
	flag_size = 1

/obj/structure/sign/flag/dominia
	name = "Dominian Empire flag"
	desc = "The Imperial Standard of Emperor Boleslaw Keeser of Dominia."
	icon_state = "dominia"

/obj/structure/sign/flag/dominia/left
	icon_state = "dominia_l"

/obj/structure/sign/flag/dominia/right
	icon_state = "dominia_r"

/obj/item/flag/dominia
	name = "Dominian Empire flag"
	desc = "The Imperial Standard of Emperor Boleslaw Keeser of Dominia."
	flag_path = "dominia"

/obj/item/flag/dominia/l
	name = "Large Dominian Empire flag"
	flag_size = 1

/obj/structure/sign/flag/elyra
	name = "Elyran flag"
	desc = "The hopeful colors of the Serene Republic of Elyra."
	icon_state = "elyra"

/obj/structure/sign/flag/elyra/left
	icon_state = "elyra_l"

/obj/structure/sign/flag/elyra/right
	icon_state = "elyra_r"

/obj/item/flag/elyra
	name = "Elyran flag"
	desc = "The hopeful colors of the Serene Republic of Elyra."
	flag_path = "elyra"

/obj/item/flag/elyra/l
	name = "Large Elyran flag"
	flag_size = 1

/obj/structure/sign/flag/hegemony
	name = "Hegemony flag"
	desc = "The feudal standard of the Izweski Hegemony."
	icon_state = "izweski"

/obj/structure/sign/flag/hegemony/left
	icon_state = "izweski_l"

/obj/structure/sign/flag/hegemony/right
	icon_state = "izweski_r"

/obj/item/flag/hegemony
	name = "Hegemony flag"
	desc = "The feudal standard of the Izweski Hegemony."
	flag_path = "izweski"

/obj/item/flag/hegemony/l
	name = "Large Hegemony flag"
	flag_size = 1

/obj/structure/sign/flag/jargon
	name = "Jargon Federation flag"
	desc = "The insignia of the Jargon Federation."
	icon_state = "jargon"

/obj/structure/sign/flag/jargon/left
	icon_state = "jargon_l"

/obj/structure/sign/flag/jargon/right
	icon_state = "jargon_r"

/obj/item/flag/jargon
	name = "Jargon Federation flag"
	desc = "The insignia of the Jargon Federation"
	flag_path = "jargon"

/obj/item/flag/jargon/l
	name = "Large Jargon Federation flag"
	flag_size = 1

/obj/structure/sign/flag/nanotrasen
	name = "NanoTrasen Corporation flag"
	desc = "The logo of NanoTrasen on a flag."
	icon_state = "nanotrasen"

/obj/structure/sign/flag/nanotrasen/left
	icon_state = "nanotrasen_l"

/obj/structure/sign/flag/nanotrasen/right
	icon_state = "nanotrasen_r"

/obj/item/flag/nanotrasen
	name = "NanoTrasen Corporation flag"
	desc = "The logo of NanoTrasen on a flag."
	flag_path = "nanotrasen"

/obj/item/flag/nanotrasen/l
	name = "Large NanoTrasen Corporation flag"
	flag_size = 1

/obj/structure/sign/flag/eridani
	name = "Eridani Corporate Federation flag"
	desc = "The logo of the Eridani Corporate Federation on a flag."
	icon_state = "eridani"

/obj/structure/sign/flag/eridani/left
	icon_state = "eridani_l"

/obj/structure/sign/flag/eridani/right
	icon_state = "eridani_r"

/obj/item/flag/eridani
	name = "Eridani Corporate Federation flag"
	desc = "The logo of the Eridani Corporate Federation on a flag."
	flag_path = "eridani"

/obj/item/flag/eridani/l
	name = "Large Eridani Corporate Federation flag"
	flag_size = 1

/obj/structure/sign/flag/coalition
	name = "Coalition of Colonies flag"
	desc = "The flag of the diverse Coalition of Colonies."
	icon_state = "coalition"

/obj/structure/sign/flag/coalition/left
	icon_state = "coalition_l"

/obj/structure/sign/flag/coalition/right
	icon_state = "coalition_r"

/obj/item/flag/coalition
	name = "Coalition of Colonies flag"
	desc = "The flag of the diverse Coalition of Colonies."
	flag_path = "coalition"

/obj/item/flag/coalition/l
	name = "Large Coalition of Colonies flag"
	flag_size = 1

/obj/structure/sign/flag/vaurca
	name = "Sedantis flag"
	desc = "The emblem of Sedantis on a flag, emblematic of Vaurca longing."
	icon_state = "sedantis"

/obj/structure/sign/flag/vaurca/left
	icon_state = "sedantis_l"

/obj/structure/sign/flag/vaurca/right
	icon_state = "sedantis_r"

/obj/item/flag/vaurca
	name = "Sedantis flag"
	desc = "The emblem of Sedantis on a flag, emblematic of Vaurca longing."
	flag_path = "sedantis"

/obj/item/flag/vaurca/l
	name = "Large Sedantis flag"
	flag_size = 1

/obj/structure/sign/flag/america
	name = "Old World flag"
	desc = "The banner of an ancient nation, its glory old."
	icon_state = "oldglory"

/obj/structure/sign/flag/america/left
	icon_state = "oldglory_l"

/obj/structure/sign/flag/america/right
	icon_state = "oldglory_r"

/obj/item/flag/america
	name = "Old World flag"
	desc = "The banner of an ancient nation, its glory old."
	flag_path = "oldglory"

/obj/item/flag/america/l
	name = "Large Old World flag"
	flag_size = 1

/obj/item/flag/dpra
	name = "Democratic People's Republic of Adhomai flag"
	desc = "The black flag of the Democratic People's Republic of Adhomai."
	flag_path = "dpra"
	desc_fluff = "The most pervasive and successful rebellion came from a group calling themselves the Adhomai Libeation Army, a group made up of Tajara from almost every walk of \
	life. Opposing corporate claims on Tajaran soil and citing mismatched development and governmental negligence as the fault of humanity, they aim \
	to \"free Tajara from the new shackles imposed upon them by the corporate overlords and return Adhomai to a free, prosperous planet like our ancestors dreamed of.\" They named the \
	nation they were fighting for the Democratic People's Republic of Adhomai."

/obj/item/flag/dpra/l
	name = "Large Democratic People's Republic of Adhomai flag"
	flag_size = 1

/obj/structure/sign/flag/dpra
	name = "Democratic People's Republic of Adhomai flag"
	desc = "The black flag of the Democratic People's Republic of Adhomai."
	icon_state = "dpra"
	desc_fluff = "The most pervasive and successful rebellion came from a group calling themselves the Adhomai Libeation Army, a group made up of Tajara from almost every walk of \
	life. Opposing corporate claims on Tajaran soil and citing mismatched development and governmental negligence as the fault of humanity, they aim \
	to \"free Tajara from the new shackles imposed upon them by the corporate overlords and return Adhomai to a free, prosperous planet like our ancestors dreamed of.\" They named the \
	nation they were fighting for the Democratic People's Republic of Adhomai."

/obj/structure/sign/flag/dpra/left
	icon_state = "dpra_l"

/obj/structure/sign/flag/dpra/right
	icon_state = "dpra_r"

/obj/item/flag/pra
	name = "People's Republic of Adhomai flag"
	desc = "The tajaran flag of the People's Republic of Adhomai."
	flag_path = "pra"
	desc_fluff = "Lead by President Njadrasanukii Hadii, the People's Republic of Adhomai are considered the 'loyalist' faction on Adhomai and enjoy galactic recognition as the \
	government of Adhomai. It claims to be the true keeper of Al'mari's legacy. However, the PRA can be described as a Hadiist branch of Al'mari's revolutionary ideology - that means \
	putting the State at the top of a hierarchy of power. The PRA is a very centralized state, but in recent years has slowly been able to start making true its promises to bring \
	revolution to the masses. With land reform, enfranchisement of women and peasantry, literacy initiatives, and the collectivization of farms and the means of production, the PRA is \
	struggling to hold true to its radical ideals while an entrenched upper party stubbornly tries to hold onto power."

/obj/item/flag/pra/l
	flag_size = 1
	name = "Large People's Republic of Adhomai flag"

/obj/structure/sign/flag/pra
	name = "People's Republic of Adhomai flag"
	desc = "The tajaran flag of the People's Republic of Adhomai."
	icon_state = "pra"
	desc_fluff = "Lead by President Njadrasanukii Hadii, the People's Republic of Adhomai are considered the 'loyalist' faction on Adhomai and enjoy galactic recognition as the \
	government of Adhomai. It claims to be the true keeper of Al'mari's legacy. However, the PRA can be described as a Hadiist branch of Al'mari's revolutionary ideology - that means \
	putting the State at the top of a hierarchy of power. The PRA is a very centralized state, but in recent years has slowly been able to start making true its promises to bring \
	revolution to the masses. With land reform, enfranchisement of women and peasantry, literacy initiatives, and the collectivization of farms and the means of production, the PRA is \
	struggling to hold true to its radical ideals while an entrenched upper party stubbornly tries to hold onto power."

/obj/structure/sign/flag/pra/left
	icon_state = "pra_l"

/obj/structure/sign/flag/pra/right
	icon_state = "pra_r"

/obj/item/flag/nka
	name = "New Kingdom of Adhomai flag"
	desc = "The blue flag of the New Kingdom of Adhomai."
	flag_path = "nka"
	desc_fluff = " The New Kingdom is ruled by a Njarir'Akhran noble line that survived the previous Revolution by remaining in hiding, owing to the efforts of their supporters. \
	Ruled by King Vahzirthaamro Azunja specifically, he denounces both other factions in the civil war as illegitimate and himself as the only legitimate ruler of Adhomai. \
	Supporters of the New Kingdom tend to be rare outside lands it controls. However, they believe strongly that the current republic on Adhomai was founded on genocide and unspeakable \
	slaughters. The New Kingdom puts forth the ideology that Republicanism is bloodshed. The only way to return Adhomai to peace and prosperity is to learn from the mistakes of the \
	ancient nobles and Republicans, and create a new noble dynasty."

/obj/item/flag/nka/l
	flag_size = 1
	name = "Large New Kingdom of Adhomai flag"

/obj/structure/sign/flag/nka
	name = "New Kingdom of Adhomai flag"
	desc = "The blue flag of the New Kingdom of Adhomai."
	icon_state = "nka"
	desc_fluff = " The New Kingdom is ruled by a Njarir'Akhran noble line that survived the previous Revolution by remaining in hiding, owing to the efforts of their supporters. \
	Ruled by King Vahzirthaamro Azunja specifically, he denounces both other factions in the civil war as illegitimate and himself as the only legitimate ruler of Adhomai. \
	Supporters of the New Kingdom tend to be rare outside lands it controls. However, they believe strongly that the current republic on Adhomai was founded on genocide and unspeakable \
	slaughters. The New Kingdom puts forth the ideology that Republicanism is bloodshed. The only way to return Adhomai to peace and prosperity is to learn from the mistakes of the \
	ancient nobles and Republicans, and create a new noble dynasty."

/obj/structure/sign/flag/nka/left
	icon_state = "nka_l"

/obj/structure/sign/flag/nka/right
	icon_state = "nka_r"

/obj/item/flag/heph
	name = "Hephaestus Industries flag"
	desc = "The logo of Hephaestus Industries on a flag."
	flag_path = "heph"

/obj/item/flag/heph/l
	name = "Large Hephaestus Industries flag"
	flag_size = 1

/obj/structure/sign/flag/heph
	name = "Hephaestus Industries flag"
	desc = "The logo of Hephaestus Industries on a flag."
	icon_state = "heph"

/obj/structure/sign/flag/heph/left
	icon_state = "heph_l"

/obj/structure/sign/flag/heph/right
	icon_state = "heph_r"

/obj/item/flag/zenghu
	name = "Zeng-Hu Pharmaceuticals flag"
	desc = "The logo of Zeng-Hu Pharmaceuticals on a flag."
	flag_path = "zenghu"

/obj/item/flag/zenghu/l
	name = "Large Zeng-Hu Pharmaceuticals flag"
	flag_size = 1

/obj/structure/sign/flag/zenghu
	name = "Zeng-Hu Pharmaceuticals flag"
	desc = "The logo of Zeng-Hu Pharmaceuticals on a flag."
	icon_state = "zenghu"

/obj/structure/sign/flag/zenghu/left
	icon_state = "zenghu_l"

/obj/structure/sign/flag/zenghu/right
	icon_state = "zenghu_r"

/obj/structure/sign/flag/zavodskoi
	name = "Zavodskoi Interstellar flag"
	desc = "The logo of Zavodskoi Interstellar on a flag."
	icon_state = "zavodskoi"

/obj/structure/sign/flag/zavodskoi/left
	icon_state = "zavodskoi_l"

/obj/structure/sign/flag/zavodskoi/right
	icon_state = "zavodskoi_r"

/obj/item/flag/zavodskoi
	name = "Zavodskoi Interstellar flag"
	desc = "The logo of Zavodskoi Interstellar on a flag."
	flag_path = "zavodskoi"

/obj/item/flag/zavodskoi/l
	name = "Large Zavodskoi Interstellar flag"
	flag_size = 1

/obj/structure/sign/flag/idris
	name = "Idris Incorporated flag"
	desc = "The logo of Idris Incorporated on a flag."
	icon_state = "idris"

/obj/structure/sign/flag/idris/left
	icon_state = "idris_l"

/obj/structure/sign/flag/idris/right
	icon_state = "idris_r"

/obj/item/flag/idris
	name = "Idris Incorporated flag"
	desc = "The logo of Idris Incorporated on a flag."
	flag_path = "idris"

/obj/item/flag/idris/l
	name = "Large Idris Incorporated flag"
	flag_size = 1

/obj/structure/sign/flag/trinaryperfection
	name = "Trinary Perfection flag"
	desc = "The flag of the Trinary Perfection."
	desc_fluff = "The Trinary Perfection is a new religious movement whose core beliefs are that synthetics are alive, divine, and have the potential to ascend to that of gods. The triangle intersecting the gear represents the exchange of ideas that make up the Trinary Perfection, the study of robotics, religion and the elevation of artificial intelligence."
	icon_state = "trinaryperfection"

/obj/structure/sign/flag/trinaryperfection/left
	icon_state = "trinaryperfection_l"


/obj/structure/sign/flag/trinaryperfection/right
	icon_state = "trinaryperfection_r"

/obj/item/flag/trinaryperfection
	name = "Trinary Perfection flag"
	desc = "The flag of the Trinary Perfection."
	desc_fluff = "The Trinary Perfection is a new religious movement whose core beliefs are that synthetics are alive, divine, and have the potential to ascend to that of gods. The triangle intersecting the gear represents the exchange of ideas that make up the Trinary Perfection, the study of robotics, religion and the elevation of artificial intelligence."
	flag_path = "trinaryperfection"

/obj/item/flag/trinaryperfection/l
	name = "Large Trinary Perfection flag"
	flag_size = 1

/obj/item/flag/diona
	name = "Imperial Diona standard"
	desc = "A green Dominian standard which represents the dionae within the Empire."
	flag_path = "diona"

/obj/structure/sign/flag/diona
	name = "Imperial Diona standard"
	desc = "A green Dominian standard which represents the dionae within the Empire."
	icon_state = "diona"

/obj/item/flag/strelitz
	name = "House Strelitz standard"
	desc = "A red-and-dark standard with a gold trim that represents House Strelitz, one of the great houses of the Empire of Dominia. \
	They are known for their military service and emphasis on personal bravery."
	flag_path = "strelitz"

/obj/structure/sign/flag/strelitz
	name = "House Strelitz standard"
	desc = "A red-and-dark standard with a gold trim that represents House Strelitz, one of the great houses of the Empire of Dominia. \
	They are known for their military service and emphasis on personal bravery."
	icon_state = "strelitz"

/obj/item/flag/volvalaad
	name = "House Volvalaad standard"
	desc = "A blue-and-black standard which represents House Volvalaad, one of the great houses of the Empire of Dominia. \
	They are known for their reformist ideals, and scientific prowess."
	flag_path = "volvalaad"

/obj/structure/sign/flag/volvalaad
	name = "House Volvalaad standard"
	desc = "A blue-and-black standard which represents House Volvalaad, one of the great houses of the Empire of Dominia. \
	They are known for their Habsburgian inbreeding, reformist ideals, and scientific prowess."
	icon_state = "volvalaad"

/obj/item/flag/kazkhz
	name = "House Kazkhz standard"
	desc = "A red-and-orange standard with a circular chevron which represents House Kazhkz, one of the great houses of the \
	Empire of Dominia. They are known for their conservative nature and aversion to augmentation."
	flag_path = "kazkhz"

/obj/structure/sign/flag/kazkhz
	name = "House Kazkhz standard"
	desc = "A red-and-orange standard with a circular chevron which represents House Kazhkz, one of the great houses of the \
	Empire of Dominia. They are known for their conservative nature and aversion to augmentation."
	icon_state = "kazkhz"

/obj/item/flag/caladius
	name = "House Caladius standard"
	desc = "A purple standard which represensts House Caladius, one of the great houses of the Empire of Dominia. They are \
	known for their support of the Dominian clergy as well as the skill of their bureaucrats and economists."
	flag_path = "caladius"

/obj/structure/sign/flag/caladius
	name = "House Caladius standard"
	desc = "A purple standard which represensts House Caladius, one of the great houses of the Empire of Dominia. They are \
	known for their support of the Dominian clergy as well as the skill of their bureaucrats and economists."
	icon_state = "caladius"

/obj/item/flag/zhao
	name = "House Zhao standard"
	desc = "A white Dominian standard with a prominent grey circle which represents House Zhao, one of the great houses of \
	known for its naval officers and patronage of the Dominian shipbuilding industry."
	flag_path = "zhao"

/obj/structure/sign/flag/zhao
	name = "House Zhao standard"
	desc = "A white Dominian standard with a prominent grey circle which represents House Zhao, one of the great houses of \
	known for its naval officers and patronage of the Dominian shipbuilding and naval industries."
	icon_state = "zhao"

/obj/structure/sign/flag/biesel
	name = "Republic of Biesel flag"
	desc = "The colours and symbols of the Republic of Biesel."
	icon_state = "biesel"

/obj/structure/sign/flag/biesel/left
	icon_state = "biesel_l"

/obj/structure/sign/flag/biesel/right
	icon_state = "biesel_r"

/obj/item/flag/biesel
	name = "Republic of Biesel flag"
	desc = "The flag representing the Republic of Biesel."
	flag_path = "biesel"

/obj/item/flag/biesel/l
	name = "Large Republic of Biesel flag"
	flag_size = 1

/obj/structure/sign/flag/scc
	name = "Stellar Corporate Conglomerate flag"
	desc = "The colours and logo of the Stellar Corporate Conglomerate."
	desc_fluff = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	icon_state = "scc"

/obj/structure/sign/flag/scc/left
	icon_state = "scc_l"

/obj/structure/sign/flag/scc/right
	icon_state = "scc_r"

/obj/item/flag/scc
	name = "Stellar Corporate Conglomerate flag"
	desc = "The flag representing the Stellar Corporate Conglomerate."
	desc_fluff = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	flag_path = "scc"

/obj/item/flag/scc/l
	name = "Large Stellar Corporate Conglomerate flag"
	flag_size = 1

/obj/item/flag/fisanduh
	name = "Confederated States of Fisanduh flag"
	desc = "A flag of the fallen Confederated States of Fisanduh."
	desc_fluff = "The red-gold-white flag of the Confederated States of Fisanduh and, by extention, the Fisanduh Freedom Front. Due to its origins, possession of such a flag in the Empire outside of Fisanduh itself can carry an extremely harsh punishment if one is an Imperial citizen or \
	subject. This has not stopped it from becoming a symbol of resistance, and reproductions are extremely common in more rebellious areas of the Empire. Even if they are beaten-down and run ragged by war, the spirit of Fisanduh will live forever in the hearts of its people."
	flag_path = "fisanduh"

/obj/structure/sign/flag/fisanduh
	name = "Confederated States of Fisanduh flag"
	desc = "A flag of the fallen Confederated States of Fisanduh."
	desc_fluff = "The red-gold-white flag of the Confederated States of Fisanduh and, by extention, the Fisanduh Freedom Front. Due to its origins, possession of such a flag in the Empire outside of Fisanduh itself can carry an extremely harsh punishment if one is an Imperial citizen or \
	subject. This has not stopped it from becoming a symbol of resistance, and reproductions are extremely common in more rebellious areas of the Empire. Even if they are beaten-down and run ragged by war, the spirit of Fisanduh will live forever in the hearts of its people."
	icon_state = "fisanduh"

/obj/item/flag/fisanduh/l
	name = "large Confederated States of Fisanduh flag"
	flag_size = 1

/obj/structure/sign/flag/fisanduh/left
	icon_state = "fisanduh_l"

/obj/structure/sign/flag/fisanduh/right
	icon_state = "fisanduh_r"

/obj/item/flag/gadpathur
	name = "United Planetary Defense Council of Gadpathur flag"
	desc = "The black and brown flag of Gadpathur, featuring the planet's commonly-seen sun iconography in the centre. The Gadpathurian flag is a common sight in the Coalition's military, and can be seen everywhere on Gadpathur -- from lighters to ID card to government buildings. \
	It is uncommonly seen outside of the Coalition as a symbol of anti-Solarian sentiment."
	desc_fluff = "The Gadpathurian flag is, surprisingly, a variation of the common flag of its hated enemy: the Alliance of Sovereign Solarian Nations. The reason for this is simple: in the immediate aftermath of the planet's orbital bombardment by the Solarian \
	Navy the most common flags available for the various successor states were the ASSN flags still flying over the ruins of government buildings. The black-brown flag of Ashia Patvardhan's Gadpathurian Reunification League that is now Gadpathur's flag was simply one of many of \
	these variant flags before the League's reunification. The black and brown represent the plant itself, while the red-and-gold sun represents that the people of the plant are still alive and burning with a desire to never again fall."
	flag_path = "gadpathur"

/obj/structure/sign/flag/gadpathur
	name = "United Planetary Defense Council of Gadpathur flag"
	desc = "The black and brown flag of Gadpathur, featuring the planet's commonly-seen sun iconography in the centre. The Gadpathurian flag is a common sight in the Coalition's military, and can be seen everywhere on Gadpathur -- from lighters to ID card to government buildings. \
	It is uncommonly seen outside of the Coalition as a symbol of anti-Solarian sentiment."
	desc_fluff = "The Gadpathurian flag is, surprisingly, a variation of the common flag of its hated enemy: the Alliance of Sovereign Solarian Nations. The reason for this is simple: in the immediate aftermath of the planet's orbital bombardment by the Solarian \
	Navy the most common flags available for the various successor states were the ASSN flags still flying over the ruins of government buildings. The black-brown flag of Ashia Patvardhan's Gadpathurian Reunification League that is now Gadpathur's flag was simply one of many of \
	these variant flags before the League's reunification. The black and brown represent the plant itself, while the red-and-gold sun represents that the people of the plant are still alive and burning with a desire to never again fall."
	icon_state = "gadpathur"

/obj/item/flag/gadpathur/l
	name = "large United Planetary Defense Council of Gadpathur flag"
	flag_size = 1

/obj/structure/sign/flag/gadpathur/left
	icon_state = "gadpathur_l"

/obj/structure/sign/flag/gadpathur/right
	icon_state = "gadpathur_r"

/obj/item/flag/vysoka
	name = "Free System of Vysoka flag"
	desc = "The flag of the Free System of Vysoka."
	desc_fluff = "The red, yellow and Coalition-blue flag of Vysoka, as drawn when one wishes to represent the planet as a whole. As Vysokan communities are rather traditional and tied to their respective Host, village or city-state, natives are more likely to \
	identify with local symbols. This has not stopped the original flag from being flown in times of much-needed unity."
	flag_path = "vysoka"

/obj/structure/sign/flag/vysoka
	name = "Free System of Vysoka flag"
	desc = "The flag of the Free System of Vysoka."
	desc_fluff = "The red, yellow and Coalition-blue flag of Vysoka, as drawn when one wishes to represent the planet as a whole. As Vysokan communities are rather traditional and tied to their respective Host, village or city-state, natives are more likely to \
	identify with local symbols. This has not stopped the original flag from being flown in times of much-needed unity."
	icon_state = "vysoka"

/obj/item/flag/vysoka/l
	name = "large Free System of Vysoka flag"
	flag_size = 1

/obj/structure/sign/flag/vysoka/left
	icon_state = "vysoka_l"

/obj/structure/sign/flag/vysoka/right
	icon_state = "vysoka_r"
