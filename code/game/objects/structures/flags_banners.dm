//
// Flags
//

// Flag Item
/obj/item/flag
	name = "boxed flag"
	desc = "A flag neatly folded into a wooden container."
	icon = 'icons/obj/structure/flags.dmi'
	icon_state = "flag_boxed"
	var/flag_path
	var/flag_size = FALSE // true if big flag

// Flag on Wall
/obj/structure/sign/flag
	name = "blank flag"
	desc = "Nothing to see here."
	icon = 'icons/obj/structure/flags.dmi'
	icon_state = "flag"
	var/obj/structure/sign/flag/linked_flag //For double flags
	var/obj/item/flag/flagtype //For returning your flag
	var/ripped = FALSE //If we've been torn down
	var/ripped_outline_state = "flag_ripped"
	var/icon/flag_icon
	var/icon/shading_icon
	var/icon/banner_icon
	var/icon/rolled_outline
	var/unmovable = FALSE

/obj/structure/sign/flag/Initialize()
	. = ..()
	flag_icon = new(icon, icon_state)
	shading_icon = new('icons/obj/structure/flags.dmi', "flag")
	flag_icon.Blend(shading_icon, ICON_MULTIPLY)
	var/turf/T = get_step(loc, dir)
	if(!iswall(T))
		banner_icon = new('icons/obj/structure/flags.dmi', "banner_stand")
		flag_icon.Blend(banner_icon, ICON_UNDERLAY)
	icon = flag_icon

/obj/structure/sign/flag/blank
	name = "blank banner"
	desc = "A blank flag."
	icon_state = "flag"

/obj/item/flag/attack_self(mob/user)
	if(flag_size)
		return

	if(use_check_and_message(user))
		return

	if(isfloor(user.loc))
		user.visible_message(SPAN_NOTICE("\The [user] deploys \the [src] on \the [get_turf(loc)]."), SPAN_NOTICE("You deploy \the [src] on \the [get_turf(loc)]."))
		place(src.loc, user)

/obj/item/flag/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if(!adjacent)
		return

	if(use_check_and_message(user))
		return

	if((!iswall(A) && !istype(A, /obj/structure/window)) || !isturf(user.loc))
		to_chat(user, SPAN_WARNING("You can't place this here!"))
		return

	var/placement_dir = get_dir(user, A)
	if (!(placement_dir in cardinal))
		to_chat(user, SPAN_WARNING("You must stand directly in front of the location you wish to place that on."))
		return

	user.visible_message(SPAN_NOTICE("\The [user] fastens \the [src] to \the [A]."), SPAN_NOTICE("You fasten \the [src] to \the [A]."))
	place(A, user, clickparams)

/obj/item/flag/proc/place(var/atom/A, var/mob/user, var/clickparams)
	var/obj/structure/sign/flag/P = new(user.loc)

	var/placement_dir = get_dir(user, A)
	if(placement_dir)
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
		P.icon_state = "[flag_path]_l" // Just adding to the flag spaghetti.
		P.ripped_outline_state = "flag_ripped_l"
		P.flag_icon = new(icon, P.icon_state, P.dir)
		P.shading_icon = new('icons/obj/structure/flags.dmi', "flag_l", P.dir)
		P.flag_icon.Blend(P.shading_icon, ICON_MULTIPLY)
		P.icon = P.flag_icon
		var/obj/structure/sign/flag/P2 = new(user.loc)
		P.linked_flag = P2
		P2.dir = P.dir
		P2.linked_flag = P
		P2.icon_state = "[flag_path]_r"
		P2.ripped_outline_state = "flag_ripped_r"
		P2.flag_icon = new(icon, P2.icon_state, P2.dir)
		P2.shading_icon = new('icons/obj/structure/flags.dmi', "flag_r", P2.dir)
		P2.flag_icon.Blend(P2.shading_icon, ICON_MULTIPLY)
		P2.icon = P2.flag_icon
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
		P2.desc_extended = desc_extended
		P2.flagtype = type
	else
		P.icon_state = "[flag_path]"
		P.flag_icon = new(P.icon, P.icon_state)
		P.shading_icon = new('icons/obj/structure/flags.dmi', "flag")
		P.flag_icon.Blend(P.shading_icon, ICON_MULTIPLY)
		var/turf/T = get_step(P.loc, P.dir)
		if(!iswall(T))
			P.banner_icon = new('icons/obj/structure/flags.dmi', "banner_stand")
			P.flag_icon.Blend(P.banner_icon, ICON_UNDERLAY)
			P.verbs += /obj/structure/sign/flag/proc/toggle
		P.icon = P.flag_icon
	P.name = name
	P.desc = desc
	P.desc_info = desc_info
	P.desc_extended = desc_extended
	P.flagtype = type
	qdel(src)

/obj/structure/sign/flag/Destroy()
	if(linked_flag?.linked_flag == src) // Catches other instances where one half might be destroyed, say by a broken wall, to avoid runtimes.
		linked_flag.linked_flag = null // linked_flag
	. = ..()

/obj/structure/sign/flag/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)
			else
				rip()
		if(3)
			rip()

/obj/structure/sign/flag/unfasten(mob/user)
	if(unmovable)
		return
	if(!ripped)
		if(banner_icon)
			user.visible_message(SPAN_NOTICE("\The [user] collapses \the [src] and folds it back up."), SPAN_NOTICE("You collapse \the [src] and fold it back up."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] unfastens \the [src] and folds it back up."), SPAN_NOTICE("You unfasten \the [src] and fold it back up."))
		var/obj/item/flag/F = new flagtype(get_turf(user))
		user.put_in_hands(F)
	else
		user.visible_message(SPAN_NOTICE("\The [user] unfastens the tattered remnants of \the [src]."), SPAN_NOTICE("You unfasten the tattered remains of \the [src]."))
	if(linked_flag)
		qdel(linked_flag) // Otherwise you're going to get weird duping nonsense.
	qdel(src)

/obj/structure/sign/flag/attack_hand(mob/user)
	if(unmovable)
		return
	if(ripped)
		return
	if(alert("Do you want to rip \the [src] from its place?","You think...","Yes","No") == "Yes")
		if(!Adjacent(user)) // Cannot bring up dialogue and walk away.
			return FALSE
		visible_message(SPAN_WARNING("\The [user] starts to grab hold of \the [src] with destructive intent!" ))
		if(!do_after(user, 5 SECONDS, act_target = src))
			return FALSE
		visible_message(SPAN_WARNING("\The [user] rips \the [src] in a single, decisive motion!" ))
		playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
		add_fingerprint(user)
		rip(user)

/obj/structure/sign/flag/proc/rip(mob/user, var/rip_linked = TRUE)
	var/icon/ripped_outline = new('icons/obj/structure/flags.dmi', ripped_outline_state, dir)
	if(!flag_icon)
		flag_icon = new(icon, icon_state)
	flag_icon.AddAlphaMask(ripped_outline)
	if(banner_icon)
		flag_icon.Blend(banner_icon, ICON_UNDERLAY)
	icon = flag_icon
	name = "ripped flag"
	desc = "You can't make out anything from the flag's original print. It's ruined."
	ripped = TRUE
	if(rip_linked)
		new /obj/item/stack/material/cloth(src.loc, 2)
	if(rip_linked && linked_flag)
		linked_flag.rip(user, FALSE) // Prevents an infinite ripping loop.

/obj/structure/sign/flag/attackby(obj/item/W, mob/user)
	..()
	if(W.isFlameSource())
		visible_message(SPAN_WARNING("\The [user] starts to burn \the [src] down!"))
		if(!do_after(user, 2 SECONDS, act_target = src))
			return FALSE
		visible_message(SPAN_WARNING("\The [user] burns \the [src] down!"))
		playsound(src.loc, 'sound/items/cigs_lighters/zippo_on.ogg', 100, 1)
		new /obj/effect/decal/cleanable/ash(src.loc)
		if(linked_flag)
			qdel(linked_flag)
		qdel(src)
		return TRUE

/obj/structure/sign/flag/proc/toggle()
	set name = "Toggle Banner"
	set category = "Object"
	set src in oview(1)

	if(use_check_and_message(usr))
		return 0

	icon = initial(icon)
	flag_icon = new(icon, icon_state)

	if(!rolled_outline)
		shading_icon = new('icons/obj/structure/flags.dmi', "flag_rolled")
		rolled_outline = new('icons/obj/structure/flags.dmi', "banner_rolled")
		flag_icon.AddAlphaMask(rolled_outline)
	else
		rolled_outline = null
		shading_icon = new('icons/obj/structure/flags.dmi', "flag")

	flag_icon.Blend(shading_icon, ICON_MULTIPLY)
	banner_icon = new('icons/obj/structure/flags.dmi', "banner_stand")
	flag_icon.Blend(banner_icon, ICON_UNDERLAY)
	icon = flag_icon

/obj/structure/sign/flag/blank/left
	icon_state = "flag_l"

/obj/structure/sign/flag/blank/right
	icon_state = "flag_r"

/obj/structure/sign/flag/sol
	name = "\improper Sol Alliance flag"
	desc = "The bright blue flag of the Alliance of Sovereign Solarian Nations."
	icon_state = "sol"
	flagtype = /obj/item/flag/sol

/obj/structure/sign/flag/sol/left
	icon_state = "sol_l"

/obj/structure/sign/flag/sol/right
	icon_state = "sol_r"

/obj/item/flag/sol
	name = "\improper Sol Alliance flag"
	desc = "The bright blue flag of the Alliance of Sovereign Solarian Nations."
	flag_path = "sol"

/obj/item/flag/sol/l
	name = "large Sol Alliance flag"
	flag_size = TRUE

/obj/structure/sign/flag/dominia
	name = "\improper Dominian Empire flag"
	desc = "The Imperial Standard of Emperor Boleslaw Keeser of Dominia."
	icon_state = "dominia"
	flagtype = /obj/item/flag/dominia

/obj/structure/sign/flag/dominia/left
	icon_state = "dominia_l"

/obj/structure/sign/flag/dominia/right
	icon_state = "dominia_r"

/obj/item/flag/dominia
	name = "\improper Dominian Empire flag"
	desc = "The Imperial Standard of Emperor Boleslaw Keeser of Dominia."
	flag_path = "dominia"

/obj/item/flag/dominia/l
	name = "large Dominian Empire flag"
	flag_size = TRUE

/obj/structure/sign/flag/elyra
	name = "\improper Elyran flag"
	desc = "The hopeful colors of the Serene Republic of Elyra."
	icon_state = "elyra"
	flagtype = /obj/item/flag/elyra

/obj/structure/sign/flag/elyra/left
	icon_state = "elyra_l"

/obj/structure/sign/flag/elyra/right
	icon_state = "elyra_r"

/obj/item/flag/elyra
	name = "\improper Elyran flag"
	desc = "The hopeful colors of the Serene Republic of Elyra."
	flag_path = "elyra"

/obj/item/flag/elyra/l
	name = "large Elyran flag"
	flag_size = TRUE

/obj/structure/sign/flag/hegemony
	name = "\improper Hegemony flag"
	desc = "The feudal standard of the Izweski Hegemony."
	icon_state = "izweski"
	flagtype = /obj/item/flag/hegemony

/obj/structure/sign/flag/hegemony/left
	icon_state = "izweski_l"

/obj/structure/sign/flag/hegemony/right
	icon_state = "izweski_r"

/obj/item/flag/hegemony
	name = "\improper Hegemony flag"
	desc = "The feudal standard of the Izweski Hegemony."
	flag_path = "izweski"

/obj/item/flag/hegemony/l
	name = "large Hegemony flag"
	flag_size = TRUE

/obj/structure/sign/flag/nralakk
	name = "\improper Nralakk Federation flag"
	desc = "The insignia of the Nralakk Federation."
	icon_state = "nralakk"
	flagtype = /obj/item/flag/nralakk

/obj/structure/sign/flag/nralakk/left
	icon_state = "nralakk_l"

/obj/structure/sign/flag/nralakk/right
	icon_state = "nralakk_r"

/obj/item/flag/nralakk
	name = "\improper Nralakk Federation flag"
	desc = "The insignia of the Nralakk Federation."
	flag_path = "nralakk"

/obj/item/flag/nralakk/l
	name = "large Nralakk Federation flag"
	flag_size = TRUE

/obj/structure/sign/flag/traverse
	name = "\improper Free Traverser flag"
	desc = "The insignia of the Free Traversers."
	icon_state = "traverse"
	flagtype = /obj/item/flag/traverse

/obj/structure/sign/flag/traverse/left
	icon_state = "traverse_l"

/obj/structure/sign/flag/traverse/right
	icon_state = "traverse_r"

/obj/item/flag/traverse
	name = "\improper Free Traverser flag"
	desc = "The insignia of the Free Traversers."
	flag_path = "traverse"

/obj/item/flag/traverse/l
	name = "large Free Traverser flag"
	flag_size = TRUE

/obj/item/flag/cteum
	name = "\improper Co-operative Territories of Epsilon Ursae Minoris Flag"
	desc = "The flag of the CT-EUM."
	flag_path = "cteum"

/obj/structure/sign/flag/cteum
	name = "\improper Co-operative Territories of Epsilon Ursae Minoris Flag"
	desc = "The flag of the CT-EUM."
	icon_state = "cteum"
	flagtype = /obj/item/flag/cteum

/obj/structure/sign/flag/nanotrasen
	name = "\improper NanoTrasen Corporation flag"
	desc = "The logo of NanoTrasen on a flag."
	icon_state = "nanotrasen"
	flagtype = /obj/item/flag/nanotrasen

/obj/structure/sign/flag/nanotrasen/unmovable
	unmovable = TRUE

/obj/structure/sign/flag/nanotrasen/left
	icon_state = "nanotrasen_l"

/obj/structure/sign/flag/nanotrasen/right
	icon_state = "nanotrasen_r"

/obj/item/flag/nanotrasen
	name = "\improper NanoTrasen Corporation flag"
	desc = "The logo of NanoTrasen on a flag."
	flag_path = "nanotrasen"

/obj/item/flag/nanotrasen/l
	name = "large NanoTrasen Corporation flag"
	flag_size = TRUE

/obj/structure/sign/flag/eridani
	name = "\improper Eridani Corporate Federation flag"
	desc = "The logo of the Eridani Corporate Federation on a flag."
	icon_state = "eridani"
	flagtype = /obj/item/flag/eridani

/obj/structure/sign/flag/eridani/left
	icon_state = "eridani_l"

/obj/structure/sign/flag/eridani/right
	icon_state = "eridani_r"

/obj/item/flag/eridani
	name = "\improper Eridani Corporate Federation flag"
	desc = "The logo of the Eridani Corporate Federation on a flag."
	flag_path = "eridani"

/obj/item/flag/eridani/l
	name = "large Eridani Corporate Federation flag"
	flag_size = TRUE

/obj/structure/sign/flag/coalition
	name = "\improper Coalition of Colonies flag"
	desc = "The flag of the diverse Coalition of Colonies."
	icon_state = "coalition"
	flagtype = /obj/item/flag/coalition

/obj/structure/sign/flag/coalition/left
	icon_state = "coalition_l"

/obj/structure/sign/flag/coalition/right
	icon_state = "coalition_r"

/obj/item/flag/coalition
	name = "\improper Coalition of Colonies flag"
	desc = "The flag of the diverse Coalition of Colonies."
	flag_path = "coalition"

/obj/item/flag/coalition/l
	name = "large Coalition of Colonies flag"
	flag_size = TRUE

/obj/structure/sign/flag/vaurca
	name = "\improper Sedantis flag"
	desc = "The emblem of Sedantis on a flag, emblematic of Vaurca longing."
	icon_state = "sedantis"
	flagtype = /obj/item/flag/vaurca

/obj/structure/sign/flag/vaurca/left
	icon_state = "sedantis_l"

/obj/structure/sign/flag/vaurca/right
	icon_state = "sedantis_r"

/obj/item/flag/vaurca
	name = "\improper Sedantis flag"
	desc = "The emblem of Sedantis on a flag, emblematic of Vaurca longing."
	flag_path = "sedantis"

/obj/item/flag/vaurca/l
	name = "large Sedantis flag"
	flag_size = TRUE

/obj/item/flag/red_coalition
	name = "\improper Red Coalition flag"
	desc = "A high quality copy of an original Red Coalition banner. This variant on the standard was flown by the Zelazny arcology during the Martian World War, Zelazny's origins as a \
	mining colony represented in the center by the alchemical symbol for iron."
	icon_state = "coalition_flag_boxed"
	flag_path = "redcoalition"

/obj/item/flag/red_coalition/l
	name = "large Red Coalition flag"
	flag_size = TRUE

/obj/structure/sign/flag/red_coalition
	name = "\improper Red Coalition flag"
	desc = "A high quality copy of an original Red Coalition banner. This variant on the standard was flown by the Zelazny arcology during the Martian World War, Zelazny's origins as a \
	mining colony represented in the center by the alchemical symbol for iron."
	icon_state = "redcoalition"
	flagtype = /obj/item/flag/red_coalition

/obj/structure/sign/flag/red_coalition/left
	icon_state = "redcoalition_l"

/obj/structure/sign/flag/red_coalition/right
	icon_state = "redcoalition_r"

/obj/item/flag/dpra
	name = "\improper Democratic People's Republic of Adhomai flag"
	desc = "The black flag of the Democratic People's Republic of Adhomai."
	flag_path = "dpra"
	desc_extended = "The most pervasive and successful rebellion came from a group calling themselves the Adhomai Libeation Army, a group made up of Tajara from almost every walk of \
	life. Opposing corporate claims on Tajaran soil and citing mismatched development and governmental negligence as the fault of humanity, they aim \
	to \"free Tajara from the new shackles imposed upon them by the corporate overlords and return Adhomai to a free, prosperous planet like our ancestors dreamed of.\" They named the \
	nation they were fighting for the Democratic People's Republic of Adhomai."

/obj/item/flag/dpra/l
	name = "large Democratic People's Republic of Adhomai flag"
	flag_size = TRUE

/obj/structure/sign/flag/dpra
	name = "\improper Democratic People's Republic of Adhomai flag"
	desc = "The black flag of the Democratic People's Republic of Adhomai."
	icon_state = "dpra"
	desc_extended = "The most pervasive and successful rebellion came from a group calling themselves the Adhomai Libeation Army, a group made up of Tajara from almost every walk of \
	life. Opposing corporate claims on Tajaran soil and citing mismatched development and governmental negligence as the fault of humanity, they aim \
	to \"free Tajara from the new shackles imposed upon them by the corporate overlords and return Adhomai to a free, prosperous planet like our ancestors dreamed of.\" They named the \
	nation they were fighting for the Democratic People's Republic of Adhomai."
	flagtype = /obj/item/flag/dpra

/obj/structure/sign/flag/dpra/left
	icon_state = "dpra_l"

/obj/structure/sign/flag/dpra/right
	icon_state = "dpra_r"

/obj/item/flag/pra
	name = "\improper People's Republic of Adhomai flag"
	desc = "The tajaran flag of the People's Republic of Adhomai."
	flag_path = "pra"
	desc_extended = "Lead by President Njadrasanukii Hadii, the People's Republic of Adhomai are considered the 'loyalist' faction on Adhomai and enjoy galactic recognition as the \
	government of Adhomai. It claims to be the true keeper of Al'mari's legacy. However, the PRA can be described as a Hadiist branch of Al'mari's revolutionary ideology - that means \
	putting the State at the top of a hierarchy of power. The PRA is a very centralized state, but in recent years has slowly been able to start making true its promises to bring \
	revolution to the masses. With land reform, enfranchisement of women and peasantry, literacy initiatives, and the collectivization of farms and the means of production, the PRA is \
	struggling to hold true to its radical ideals while an entrenched upper party stubbornly tries to hold onto power."

/obj/item/flag/pra/l
	flag_size = TRUE
	name = "large People's Republic of Adhomai flag"

/obj/structure/sign/flag/pra
	name = "\improper People's Republic of Adhomai flag"
	desc = "The tajaran flag of the People's Republic of Adhomai."
	icon_state = "pra"
	desc_extended = "Lead by President Njadrasanukii Hadii, the People's Republic of Adhomai are considered the 'loyalist' faction on Adhomai and enjoy galactic recognition as the \
	government of Adhomai. It claims to be the true keeper of Al'mari's legacy. However, the PRA can be described as a Hadiist branch of Al'mari's revolutionary ideology - that means \
	putting the State at the top of a hierarchy of power. The PRA is a very centralized state, but in recent years has slowly been able to start making true its promises to bring \
	revolution to the masses. With land reform, enfranchisement of women and peasantry, literacy initiatives, and the collectivization of farms and the means of production, the PRA is \
	struggling to hold true to its radical ideals while an entrenched upper party stubbornly tries to hold onto power."
	flagtype = /obj/item/flag/pra

/obj/structure/sign/flag/pra/left
	icon_state = "pra_l"

/obj/structure/sign/flag/pra/right
	icon_state = "pra_r"

/obj/item/flag/nka
	name = "\improper New Kingdom of Adhomai flag"
	desc = "The blue flag of the New Kingdom of Adhomai."
	flag_path = "nka"
	desc_extended = " The New Kingdom is ruled by a Njarir'Akhran noble line that survived the previous Revolution by remaining in hiding, owing to the efforts of their supporters. \
	Ruled by King Vahzirthaamro Azunja specifically, he denounces both other factions in the civil war as illegitimate and himself as the only legitimate ruler of Adhomai. \
	Supporters of the New Kingdom tend to be rare outside lands it controls. However, they believe strongly that the current republic on Adhomai was founded on genocide and unspeakable \
	slaughters. The New Kingdom puts forth the ideology that Republicanism is bloodshed. The only way to return Adhomai to peace and prosperity is to learn from the mistakes of the \
	ancient nobles and Republicans, and create a new noble dynasty."

/obj/item/flag/nka/l
	flag_size = TRUE
	name = "large New Kingdom of Adhomai flag"

/obj/structure/sign/flag/nka
	name = "\improper New Kingdom of Adhomai flag"
	desc = "The blue flag of the New Kingdom of Adhomai."
	icon_state = "nka"
	desc_extended = " The New Kingdom is ruled by a Njarir'Akhran noble line that survived the previous Revolution by remaining in hiding, owing to the efforts of their supporters. \
	Ruled by King Vahzirthaamro Azunja specifically, he denounces both other factions in the civil war as illegitimate and himself as the only legitimate ruler of Adhomai. \
	Supporters of the New Kingdom tend to be rare outside lands it controls. However, they believe strongly that the current republic on Adhomai was founded on genocide and unspeakable \
	slaughters. The New Kingdom puts forth the ideology that Republicanism is bloodshed. The only way to return Adhomai to peace and prosperity is to learn from the mistakes of the \
	ancient nobles and Republicans, and create a new noble dynasty."
	flagtype = /obj/item/flag/nka

/obj/structure/sign/flag/nka/left
	icon_state = "nka_l"

/obj/structure/sign/flag/nka/right
	icon_state = "nka_r"

/obj/item/flag/heph
	name = "\improper Hephaestus Industries flag"
	desc = "The logo of Hephaestus Industries on a flag."
	flag_path = "heph"

/obj/item/flag/heph/l
	name = "large Hephaestus Industries flag"
	flag_size = TRUE

/obj/structure/sign/flag/heph
	name = "\improper Hephaestus Industries flag"
	desc = "The logo of Hephaestus Industries on a flag."
	icon_state = "heph"
	flagtype = /obj/item/flag/heph

/obj/structure/sign/flag/heph/left
	icon_state = "heph_l"

/obj/structure/sign/flag/heph/right
	icon_state = "heph_r"

/obj/item/flag/zenghu
	name = "\improper Zeng-Hu Pharmaceuticals flag"
	desc = "The logo of Zeng-Hu Pharmaceuticals on a flag."
	flag_path = "zenghu"

/obj/item/flag/zenghu/l
	name = "large Zeng-Hu Pharmaceuticals flag"
	flag_size = TRUE

/obj/structure/sign/flag/zenghu
	name = "\improper Zeng-Hu Pharmaceuticals flag"
	desc = "The logo of Zeng-Hu Pharmaceuticals on a flag."
	icon_state = "zenghu"
	flagtype = /obj/item/flag/zenghu

/obj/structure/sign/flag/zenghu/left
	icon_state = "zenghu_l"

/obj/structure/sign/flag/zenghu/right
	icon_state = "zenghu_r"

/obj/structure/sign/flag/zavodskoi
	name = "\improper Zavodskoi Interstellar flag"
	desc = "The logo of Zavodskoi Interstellar on a flag."
	icon_state = "zavodskoi"
	flagtype = /obj/item/flag/zavodskoi

/obj/structure/sign/flag/zavodskoi/left
	icon_state = "zavodskoi_l"

/obj/structure/sign/flag/zavodskoi/right
	icon_state = "zavodskoi_r"

/obj/item/flag/zavodskoi
	name = "\improper Zavodskoi Interstellar flag"
	desc = "The logo of Zavodskoi Interstellar on a flag."
	flag_path = "zavodskoi"

/obj/item/flag/zavodskoi/l
	name = "large Zavodskoi Interstellar flag"
	flag_size = TRUE

/obj/structure/sign/flag/idris
	name = "\improper Idris Incorporated flag"
	desc = "The logo of Idris Incorporated on a flag."
	icon_state = "idris"
	flagtype = /obj/item/flag/idris

/obj/structure/sign/flag/idris/left
	icon_state = "idris_l"

/obj/structure/sign/flag/idris/right
	icon_state = "idris_r"

/obj/item/flag/idris
	name = "\improper Idris Incorporated flag"
	desc = "The logo of Idris Incorporated on a flag."
	flag_path = "idris"

/obj/item/flag/idris/l
	name = "large Idris Incorporated flag"
	flag_size = TRUE

/obj/structure/sign/flag/trinaryperfection
	name = "\improper Trinary Perfection flag"
	desc = "The flag of the Trinary Perfection."
	desc_extended = "The Trinary Perfection is a new religious movement whose core beliefs are that synthetics are alive, divine, and have the potential to ascend to that of gods. The triangle intersecting the gear represents the exchange of ideas that make up the Trinary Perfection, the study of robotics, religion and the elevation of artificial intelligence."
	icon_state = "trinaryperfection"
	flagtype = /obj/item/flag/trinaryperfection

/obj/structure/sign/flag/trinaryperfection/left
	icon_state = "trinaryperfection_l"


/obj/structure/sign/flag/trinaryperfection/right
	icon_state = "trinaryperfection_r"

/obj/item/flag/trinaryperfection
	name = "\improper Trinary Perfection flag"
	desc = "The flag of the Trinary Perfection."
	desc_extended = "The Trinary Perfection is a new religious movement whose core beliefs are that synthetics are alive, divine, and have the potential to ascend to that of gods. The triangle intersecting the gear represents the exchange of ideas that make up the Trinary Perfection, the study of robotics, religion and the elevation of artificial intelligence."
	flag_path = "trinaryperfection"

/obj/item/flag/trinaryperfection/l
	name = "large Trinary Perfection flag"
	flag_size = TRUE

/obj/item/flag/diona
	name = "\improper Imperial Diona standard"
	desc = "A green Dominian standard which represents the Dionae within the Empire."
	flag_path = "diona"

/obj/structure/sign/flag/diona
	name = "\improper Imperial Diona standard"
	desc = "A green Dominian standard which represents the Dionae within the Empire."
	icon_state = "diona"
	flagtype = /obj/item/flag/diona

/obj/item/flag/strelitz
	name = "\improper House Strelitz standard"
	desc = "A red-and-dark standard with a gold trim that represents House Strelitz, one of the great houses of the Empire of Dominia. \
	They are known for their military service and emphasis on personal bravery."
	flag_path = "strelitz"

/obj/structure/sign/flag/strelitz
	name = "\improper House Strelitz standard"
	desc = "A red-and-dark standard with a gold trim that represents House Strelitz, one of the great houses of the Empire of Dominia. \
	They are known for their military service and emphasis on personal bravery."
	icon_state = "strelitz"
	flagtype = /obj/item/flag/strelitz

/obj/item/flag/volvalaad
	name = "\improper House Volvalaad standard"
	desc = "A blue-and-black standard which represents House Volvalaad, one of the great houses of the Empire of Dominia. \
	They are known for their reformist ideals, and scientific prowess."
	flag_path = "volvalaad"

/obj/structure/sign/flag/volvalaad
	name = "\improper House Volvalaad standard"
	desc = "A blue-and-black standard which represents House Volvalaad, one of the great houses of the Empire of Dominia. \
	They are known for their reformist ideals and scientific prowess."
	icon_state = "volvalaad"
	flagtype = /obj/item/flag/volvalaad

/obj/item/flag/kazhkz
	name = "\improper House Kazhkz standard"
	desc = "A red-and-orange standard with a circular chevron which represents House Kazhkz, one of the great houses of the \
	Empire of Dominia. They are known for their conservative nature and aversion to augmentation."
	flag_path = "kazhkz"

/obj/structure/sign/flag/kazhkz
	name = "\improper House Kazhkz standard"
	desc = "A red-and-orange standard with a circular chevron which represents House Kazhkz, one of the great houses of the \
	Empire of Dominia. They are known for their conservative nature and aversion to augmentation."
	icon_state = "kazkhz"
	flagtype = /obj/item/flag/kazhkz

/obj/item/flag/caladius
	name = "\improper House Caladius standard"
	desc = "A purple standard which represents House Caladius, one of the great houses of the Empire of Dominia. They are \
	known for their support of the Dominian clergy as well as the skill of their bureaucrats and economists."
	flag_path = "caladius"

/obj/structure/sign/flag/caladius
	name = "\improper House Caladius standard"
	desc = "A purple standard which represents House Caladius, one of the great houses of the Empire of Dominia. They are \
	known for their support of the Dominian clergy as well as the skill of their bureaucrats and economists."
	icon_state = "caladius"
	flagtype = /obj/item/flag/caladius

/obj/item/flag/zhao
	name = "\improper House Zhao standard"
	desc = "A white Dominian standard with a prominent grey circle which represents House Zhao, one of the great houses of the Empire of Dominia,\
	known for its naval officers and patronage of the Dominian shipbuilding industry."
	flag_path = "zhao"

/obj/structure/sign/flag/zhao
	name = "\improper House Zhao standard"
	desc = "A white Dominian standard with a prominent grey circle which represents House Zhao, one of the great houses of  the Empire of Dominia,\
	known for its naval officers and patronage of the Dominian shipbuilding and naval industries."
	icon_state = "zhao"
	flagtype = /obj/item/flag/zhao

/obj/structure/sign/flag/biesel
	name = "\improper Republic of Biesel flag"
	desc = "The colours and symbols of the Republic of Biesel."
	icon_state = "biesel"
	flagtype = /obj/item/flag/biesel

/obj/structure/sign/flag/biesel/left
	icon_state = "biesel_l"

/obj/structure/sign/flag/biesel/right
	icon_state = "biesel_r"

/obj/item/flag/biesel
	name = "\improper Republic of Biesel flag"
	desc = "The flag representing the Republic of Biesel."
	flag_path = "biesel"

/obj/item/flag/biesel/l
	name = "large Republic of Biesel flag"
	flag_size = TRUE

/obj/structure/sign/flag/scc
	name = "\improper Stellar Corporate Conglomerate flag"
	desc = "The colours and logo of the Stellar Corporate Conglomerate."
	desc_extended = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	icon_state = "scc"
	flagtype = /obj/item/flag/scc

/obj/structure/sign/flag/scc/left
	icon_state = "scc_l"

/obj/structure/sign/flag/scc/right
	icon_state = "scc_r"

/obj/item/flag/scc
	name = "\improper Stellar Corporate Conglomerate flag"
	desc = "The flag representing the Stellar Corporate Conglomerate."
	desc_extended = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	flag_path = "scc"

/obj/item/flag/scc/l
	name = "large Stellar Corporate Conglomerate flag"
	flag_size = TRUE

/obj/item/flag/fisanduh
	name = "\improper Confederated States of Fisanduh flag"
	desc = "A flag of the fallen Confederated States of Fisanduh."
	desc_extended = "The red-gold-white flag of the Confederated States of Fisanduh and, by extention, the Fisanduh Freedom Front. Due to its origins, possession of such a flag in the Empire outside of Fisanduh itself can carry an extremely harsh punishment if one is an Imperial citizen or \
	subject. This has not stopped it from becoming a symbol of resistance, and reproductions are extremely common in more rebellious areas of the Empire. Even if they are beaten-down and run ragged by war, the spirit of Fisanduh will live forever in the hearts of its people."
	flag_path = "fisanduh"

/obj/structure/sign/flag/fisanduh
	name = "\improper Confederated States of Fisanduh flag"
	desc = "A flag of the fallen Confederated States of Fisanduh."
	desc_extended = "The red-gold-white flag of the Confederated States of Fisanduh and, by extention, the Fisanduh Freedom Front. Due to its origins, possession of such a flag in the Empire outside of Fisanduh itself can carry an extremely harsh punishment if one is an Imperial citizen or \
	subject. This has not stopped it from becoming a symbol of resistance, and reproductions are extremely common in more rebellious areas of the Empire. Even if they are beaten-down and run ragged by war, the spirit of Fisanduh will live forever in the hearts of its people."
	icon_state = "fisanduh"
	flagtype = /obj/item/flag/fisanduh

/obj/item/flag/fisanduh/l
	name = "large Confederated States of Fisanduh flag"
	flag_size = TRUE

/obj/structure/sign/flag/fisanduh/left
	icon_state = "fisanduh_l"

/obj/structure/sign/flag/fisanduh/right
	icon_state = "fisanduh_r"

/obj/item/flag/gadpathur
	name = "\improper United Planetary Defense Council of Gadpathur flag"
	desc = "The black and brown flag of Gadpathur, featuring the planet's commonly-seen sun iconography in the centre. The Gadpathurian flag is a common sight in the Coalition's military, and can be seen everywhere on Gadpathur -- from lighters to ID card to government buildings. \
	It is uncommonly seen outside of the Coalition as a symbol of anti-Solarian sentiment."
	desc_extended = "The Gadpathurian flag is, surprisingly, a variation of the common flag of its hated enemy: the Alliance of Sovereign Solarian Nations. The reason for this is simple: in the immediate aftermath of the planet's orbital bombardment by the Solarian \
	Navy the most common flags available for the various successor states were the ASSN flags still flying over the ruins of government buildings. The black-brown flag of Ashia Patvardhan's Gadpathurian Reunification League that is now Gadpathur's flag was simply one of many of \
	these variant flags before the League's reunification. The black and brown represent the plant itself, while the red-and-gold sun represents that the people of the plant are still alive and burning with a desire to never again fall."
	flag_path = "gadpathur"

/obj/structure/sign/flag/gadpathur
	name = "\improper United Planetary Defense Council of Gadpathur flag"
	desc = "The black and brown flag of Gadpathur, featuring the planet's commonly-seen sun iconography in the centre. The Gadpathurian flag is a common sight in the Coalition's military, and can be seen everywhere on Gadpathur -- from lighters to ID card to government buildings. \
	It is uncommonly seen outside of the Coalition as a symbol of anti-Solarian sentiment."
	desc_extended = "The Gadpathurian flag is, surprisingly, a variation of the common flag of its hated enemy: the Alliance of Sovereign Solarian Nations. The reason for this is simple: in the immediate aftermath of the planet's orbital bombardment by the Solarian \
	Navy the most common flags available for the various successor states were the ASSN flags still flying over the ruins of government buildings. The black-brown flag of Ashia Patvardhan's Gadpathurian Reunification League that is now Gadpathur's flag was simply one of many of \
	these variant flags before the League's reunification. The black and brown represent the plant itself, while the red-and-gold sun represents that the people of the plant are still alive and burning with a desire to never again fall."
	icon_state = "gadpathur"
	flagtype = /obj/item/flag/gadpathur

/obj/item/flag/gadpathur/l
	name = "large United Planetary Defense Council of Gadpathur flag"
	flag_size = TRUE

/obj/structure/sign/flag/gadpathur/left
	icon_state = "gadpathur_l"

/obj/structure/sign/flag/gadpathur/right
	icon_state = "gadpathur_r"

/obj/item/flag/vysoka
	name = "\improper Free System of Vysoka flag"
	desc = "The flag of the Free System of Vysoka."
	desc_extended = "The red, yellow and Coalition-blue flag of Vysoka, as drawn when one wishes to represent the planet as a whole. As Vysokan communities are rather traditional and tied to their respective Host, village or city-state, natives are more likely to \
	identify with local symbols. This has not stopped the original flag from being flown in times of much-needed unity."
	flag_path = "vysoka"

/obj/structure/sign/flag/vysoka
	name = "\improper Free System of Vysoka flag"
	desc = "The flag of the Free System of Vysoka."
	desc_extended = "The red, yellow and Coalition-blue flag of Vysoka, as drawn when one wishes to represent the planet as a whole. As Vysokan communities are rather traditional and tied to their respective Host, village or city-state, natives are more likely to \
	identify with local symbols. This has not stopped the original flag from being flown in times of much-needed unity."
	icon_state = "vysoka"
	flagtype = /obj/item/flag/vysoka

/obj/item/flag/vysoka/l
	name = "large Free System of Vysoka flag"
	flag_size = TRUE

/obj/structure/sign/flag/vysoka/left
	icon_state = "vysoka_l"

/obj/structure/sign/flag/vysoka/right
	icon_state = "vysoka_r"

/obj/item/flag/konyang
	name = "\improper Konyang flag"
	desc = "The flag of Konyang."
	desc_extended = "The white, blue and yellow flag of Konyang was adopted in 2462, having unofficially been used by pro-autonomy circles long before the declaration of independence. The traditional taitju represents peace and harmony as the highest values of \
	the new state, with the color blue representing the waterways the planet is known for and yellow, their aim of prosperity. The white background represents Konyang's purity."
	flag_path = "konyang"

/obj/structure/sign/flag/konyang
	name = "\improper Konyang flag"
	desc = "The flag of Konyang."
	desc_extended = "The white, blue and yellow flag of Konyang was adopted in 2462, having unofficially been used by pro-autonomy circles long before the declaration of independence. The traditional taitju represents peace and harmony as the highest values of \
	the new state, with the color blue representing the waterways the planet is known for and yellow, their aim of prosperity. The white background represents Konyang's purity."
	icon_state = "konyang"
	flagtype = /obj/item/flag/konyang

/obj/item/flag/konyang/l
	name = "large Konyang flag"
	flag_size = TRUE

/obj/structure/sign/flag/konyang/left
	icon_state = "konyang_l"

/obj/structure/sign/flag/konyang/right
	icon_state = "konyang_r"

/obj/item/flag/izharshan
	name = "\improper Izharshan Flag"
	desc = "The tan and orange flag of Izharshan's Raiders, depicting a Unathi skull and a star above, surrounded by axes. Due to the sheer size of Izharshan's fleet, and the wide area in \
	which they operate has this specific flag be sighted far and wide, leading to the misconception for some that it is in fact used by all Unathi pirates."
	desc_extended = "Iconography is taken quite seriously among Unathi pirates. With much time to spare during lengthy flights, it's not rare for crew, especially officers, to indulge in arts, leading to fleets often finding skilled artists \
	in their ranks who, alongside their Fang Captains, create their flag. Though there are recurring elements in Unathi pirate flag designs, such as depictions of heads, skulls, stellar bodies \
	and weaponry, there are no proper rules in creating a flag for ones Unathi fleets... Still, the sheer popularity of Izharshan's flag, and the fact that it was one of the first flags created by a Unathi Pirate fleet made it a model to follow \
	for many others, with a Sinta (or their head or skull) taking a central place in the picture, and other elements complimenting it, generally in a symmetrical fashion."
	flag_path = "izharshan"

/obj/structure/sign/flag/izharshan
	name = "\improper Izharshan Flag"
	desc = "The tan and orange flag of Izharshan's Raiders, depicting a Unathi skull and a star above, surrounded by axes. Due to the sheer size of Izharshan's fleet, and the wide area in \
	which they operate has this specific flag be sighted far and wide, leading to the misconception for some that it is in fact used by all Unathi pirates."
	desc_extended = "Iconography is taken quite seriously among Unathi pirates. With much time to spare during lengthy flights, it's not rare for crew, especially officers, to indulge in arts, leading to fleets often finding skilled artists \
	in their ranks who, alongside their Fang Captains, create their flag. Though there are recurring elements in Unathi pirate flag designs, such as depictions of heads, skulls, stellar bodies \
	and weaponry, there are no proper rules in creating a flag for ones Unathi fleets... Still, the sheer popularity of Izharshan's flag, and the fact that it was one of the first flags created by a Unathi Pirate fleet made it a model to follow \
	for many others, with a Sinta (or their head or skull) taking a central place in the picture, and other elements complimenting it, generally in a symmetrical fashion."
	icon_state = "izharshan"
	flagtype = /obj/item/flag/izharshan

/obj/item/flag/visegrad
	name = "\improper Visegrad flag"
	desc = "The flag of Visegrad."
	desc_extended = "The blue, white, green and red flag of Visegrad was the original Warsaw Pact-created design for the planet's flag, and even after it acquired independence it was maintained, though with the removal of the socialist emblem and the addition of a Solarian ensign. \
	It is said that the green represents the forests of the planet, the white the stormclouds, and the blue the sky hidden above, while the red is supposed to represent shared national unity."
	flag_path = "visegrad"

/obj/structure/sign/flag/visegrad
	name = "\improper Visegrad flag"
	desc = "The flag of Visegrad."
	desc_extended = "The blue, white, green and red flag of Visegrad was the original Warsaw Pact-created design for the planet's flag, and even after it acquired independence it was maintained, though with the removal of the socialist emblem and the addition of a Solarian ensign. \
	It is said that the green represents the forests of the planet, the white the stormclouds, and the blue the sky hidden above, while the red is supposed to represent shared national unity."
	icon_state = "visegrad"
	flagtype = /obj/item/flag/visegrad

/obj/structure/sign/flag/pmcg
	name = "\improper Private Military Contracting Group flag"
	desc = "The flag representing the coalition of medical and security contractors in service to the Stellar Corporate Conglomerate."
	icon_state = "pmcg"
	flagtype = /obj/item/flag/pmcg

/obj/structure/sign/flag/pmcg/left
	icon_state = "pmcg_l"

/obj/structure/sign/flag/pmcg/right
	icon_state = "pmcg_r"

/obj/item/flag/pmcg
	name = "\improper Private Military Contracting Group flag"
	desc = "The flag representing the coalition of medical and security contractors in service to the Stellar Corporate Conglomerate."
	flag_path = "pmcg"

/obj/item/flag/pmcg/l
	name = "large Private Military Contracting Group flag"
	flag_size = TRUE

/obj/structure/sign/flag/himeo
	name = "\improper United Syndicates of Himeo flag"
	desc = "The flag of the United Syndicates of Himeo."
	icon_state = "himeo"
	flagtype = /obj/item/flag/himeo

/obj/structure/sign/flag/himeo/left
	icon_state = "himeo_l"

/obj/structure/sign/flag/himeo/right
	icon_state = "himeo_r"

/obj/item/flag/himeo
	name = "\improper United Syndicates of Himeo flag"
	desc = "The flag of the United Syndicates of Himeo."
	flag_path = "himeo"

/obj/item/flag/himeo/l
	name = "large United Syndicates of Himeo flag"
	flag_size = TRUE

/obj/structure/sign/flag/assunzione
	name = "\improper Republic of Assunzione flag"
	desc = "The flag of the Republic of Assunzione."
	icon_state = "assunzione"
	flagtype = /obj/item/flag/assunzione

/obj/structure/sign/flag/assunzione/left
	icon_state = "assunzione_l"

/obj/structure/sign/flag/assunzione/right
	icon_state = "assunzione_r"

/obj/item/flag/assunzione
	name = "\improper Republic of Assunzione flag"
	desc = "The flag of the Republic of Assunzione."
	flag_path = "assunzione"

/obj/item/flag/assunzione/l
	name = "large Republic of Assunzione flag"
	flag_size = TRUE

/obj/structure/sign/flag/newgibson
	name = "\improper New Gibson flag"
	desc = "The flag of the New Gibson."
	icon_state = "newgibson"
	flagtype = /obj/item/flag/newgibson

/obj/item/flag/newgibson
	name = "\improper New Gibson flag"
	desc = "The flag of New Gibson."
	flag_path = "newgibson"
