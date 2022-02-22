/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "bluetie"
	item_state = ""	//no inhands
	overlay_state = null
	slot_flags = SLOT_TIE
	w_class = ITEMSIZE_SMALL
	var/slot = ACCESSORY_SLOT_GENERIC
	var/obj/item/clothing/has_suit = null		//the suit the tie may be attached to
	var/image/inv_overlay = null	//overlay used when attached to clothing.
	var/image/accessory_mob_overlay = null
	var/flippable = 0 //whether it has an attack_self proc which causes the icon to flip horizontally
	var/flipped = 0
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/accessories.dmi'
	)

/obj/item/clothing/accessory/Destroy()
	on_removed()
	return ..()

/obj/item/clothing/accessory/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/accessory/proc/get_inv_overlay(var/mob/M, var/force = FALSE)
	if(!accessory_mob_overlay)
		get_accessory_mob_overlay(M, force)
	var/I = accessory_mob_overlay.icon
	if(!inv_overlay || force)
		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if(contained_sprite)
				tmp_icon_state = "[tmp_icon_state]_w"
			else if("[tmp_icon_state]_tie" in icon_states(icon_override))
				tmp_icon_state = "[tmp_icon_state]_tie"
		else if(contained_sprite)
			tmp_icon_state = "[tmp_icon_state]_w"
		inv_overlay = image(icon = I, icon_state = tmp_icon_state, dir = SOUTH)
	if(color)
		inv_overlay.color = color
	if(build_from_parts)
		inv_overlay.cut_overlays()
		inv_overlay.add_overlay(overlay_image(I, "[icon_state]_[worn_overlay]", flags=RESET_COLOR)) //add the overlay w/o coloration of the original sprite
	return inv_overlay

/obj/item/clothing/accessory/proc/get_accessory_mob_overlay(var/mob/living/carbon/human/M, var/force = FALSE)
	var/I
	if(icon_override)
		I = icon_override
	else if(istype(M) && (M.species.bodytype in sprite_sheets))
		I = sprite_sheets[M.species.bodytype]
		accessory_mob_overlay = null // reset the overlay
	else if(contained_sprite)
		I = icon
	else
		I = INV_ACCESSORIES_DEF_ICON
	if(!accessory_mob_overlay || force)
		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if(contained_sprite)
				tmp_icon_state = "[src.item_state][WORN_UNDER]"
			else if("[tmp_icon_state]_mob" in icon_states(I))
				tmp_icon_state = "[tmp_icon_state]_mob"
		else if(contained_sprite)
			tmp_icon_state = "[src.item_state][WORN_UNDER]"
		accessory_mob_overlay = image("icon" = I, "icon_state" = "[tmp_icon_state]")
		if(build_from_parts)
			accessory_mob_overlay.cut_overlays()
			accessory_mob_overlay.add_overlay(overlay_image(I, "[tmp_icon_state]_[worn_overlay]", flags=RESET_COLOR)) //add the overlay w/o coloration of the original sprite
	if(color)
		accessory_mob_overlay.color = color
	accessory_mob_overlay.appearance_flags = RESET_ALPHA|RESET_COLOR
	return accessory_mob_overlay

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	loc = has_suit
	has_suit.add_overlay(get_inv_overlay())
	if(user)
		to_chat(user, "<span class='notice'>You attach \the [src] to \the [has_suit].</span>")
		src.add_fingerprint(user)

/obj/item/clothing/accessory/proc/on_removed(var/mob/user)
	if(!has_suit)
		return
	has_suit.cut_overlay(get_inv_overlay())
	has_suit = null
	if(user)
		usr.put_in_hands(src)
		src.add_fingerprint(user)
	else
		src.forceMove(get_turf(src))

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(has_suit)
		return	//we aren't an object on the ground so don't call parent
	..()

//default attack_self behaviour
/obj/item/clothing/accessory/attack_self(mob/user as mob)
	if(flippable)
		if(!flipped)
			if(!overlay_state)
				icon_state = "[initial(icon_state)]_flip"
				item_state = "[initial(item_state)]_flip"
				flipped = 1
			else
				overlay_state = "[overlay_state]_flip"
				flipped = 1
		else
			if(!overlay_state)
				icon_state = initial(icon_state)
				item_state = initial(item_state)
				flipped = 0
			else
				overlay_state = initial(overlay_state)
				flipped = 0
		to_chat(usr, "You change \the [src] to be on your [src.flipped ? "right" : "left"] side.")
		update_clothing_icon()
		inv_overlay = null
		accessory_mob_overlay = null
		return
	..()

/obj/item/clothing/accessory/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/accessory/tie/red_clip
	name = "red tie with a clip"
	icon_state = "redcliptie"

/obj/item/clothing/accessory/tie/orange
	name = "orange tie"
	icon_state = "orangetie"

/obj/item/clothing/accessory/tie/yellow
	name = "yellow tie"
	icon_state = "yellowtie"

/obj/item/clothing/accessory/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/accessory/tie/green
	name = "green tie"
	icon_state = "greentie"

/obj/item/clothing/accessory/tie/darkgreen
	name = "dark green tie"
	icon_state = "dgreentie"

/obj/item/clothing/accessory/blue
	name = "blue tie"
	icon_state = "bluetie"

/obj/item/clothing/accessory/tie/blue_clip
	name = "blue tie with a clip"
	icon_state = "bluecliptie"

/obj/item/clothing/accessory/tie/navy
	name = "navy tie"
	icon_state = "navytie"

/obj/item/clothing/accessory/tie/purple
	name = "purple tie"
	icon_state = "purpletie"

/obj/item/clothing/accessory/tie/black
	name = "black tie"
	icon_state = "blacktie"

/obj/item/clothing/accessory/tie/white
	name = "white tie"
	icon_state = "whitetie"

/obj/item/clothing/accessory/tie/colourable
	name = "tie"
	icon_state = "whitetie"

/obj/item/clothing/accessory/tie/colourable/clip
	name = "tie with a gold clip"
	build_from_parts = TRUE
	worn_overlay = "clip"

/obj/item/clothing/accessory/tie/colourable/clip/silver
	name = "tie with a silver clip"
	worn_overlay = "sclip"

/obj/item/clothing/accessory/tie/bowtie
	name = "bowtie"
	desc = "Snazzy!"
	icon_state = "bowtie"
/obj/item/clothing/accessory/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
		)
	flippable = 1

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == I_HELP)
			var/obj/item/organ/organ = M.get_organ(user.zone_sel.selecting)
			if(organ)
				user.visible_message(SPAN_NOTICE("[user] places [src] against [M]'s [organ.name] and listens attentively."),
									 "You place [src] against [M]'s [organ.name]. You hear <b>[english_list(organ.listen())]</b>.")
				return
	return ..(M,user)

//Religious items
/obj/item/clothing/accessory/rosary
	name = "rosary"
	desc = "A form of prayer psalter used in the Catholic Church, with a string of beads attached to it."
	icon = 'icons/obj/clothing/chaplain.dmi'
	icon_state = "rosary"
	overlay_state = "rosary"
	flippable = 1

	slot_flags = SLOT_BELT | SLOT_TIE

	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/clothing/accessory/assunzione
	name = "luceian amulet"
	desc = "A common symbol of the Luceian faith abroad, this amulet featuring the religion's all-seeing eye and eight-pointed crest \
	seems to be made of real gold and gemstones. While not as critical to faithful abroad as a warding sphere, it is considered good form \
	to ensure one's amulet is well-maintained."
	icon = 'icons/clothing/accessories/assunzione_amulet.dmi'
	item_state = "assunzione_amulet"
	icon_state = "assunzione_amulet"
	contained_sprite = TRUE

/obj/item/clothing/accessory/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon_state = "suspenders"
	item_state = "suspenders"

/obj/item/clothing/accessory/scarf
	name = "scarf"
	desc = "A simple scarf, to protect your neck from the cold of space."
	icon_state = "scarf"
	item_state = "scarf"
	overlay_state = "scarf"
	flippable = 1

/obj/item/clothing/accessory/scarf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"
	item_state = "zebrascarf"
	overlay_state = "zebrascarf"

/obj/item/clothing/accessory/chaps
	name = "brown chaps"
	desc = "A pair of loose, brown leather chaps."
	icon_state = "chaps"
	item_state = "chaps"

/obj/item/clothing/accessory/chaps/black
	name = "black chaps"
	desc = "A pair of loose, black leather chaps."
	icon_state = "chaps_black"
	item_state = "chaps_black"

/*
* Poncho
*/

/obj/item/clothing/accessory/poncho
	name = "poncho"
	desc = "A simple, comfortable poncho."
	icon_state = "classicponcho"
	item_state = "classicponcho"
	icon_override = 'icons/mob/ties.dmi'
	allowed = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/bible,/obj/item/nullrod,/obj/item/reagent_containers/food/drinks/bottle/holywater)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_CAPE
	var/allow_tail_hiding = TRUE //in case if you want to allow someone to switch the HIDETAIL var or not

/obj/item/clothing/accessory/poncho/verb/toggle_hide_tail()
	set name = "Toggle Tail Coverage"
	set category = "Object"

	if(allow_tail_hiding)
		flags_inv ^= HIDETAIL
		to_chat(usr, "<span class='notice'>[src] will now [flags_inv & HIDETAIL ? "hide" : "show"] your tail.</span>")

/obj/item/clothing/accessory/poncho/big
	name = "large poncho"
	desc = "A simple, comfortable poncho. Noticibly larger around the shoulders."
	item_state = "classicponcho-big"
	icon_state = "classicponcho-big"

/obj/item/clothing/accessory/poncho/green
	name = "green poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is green."
	icon_state = "greenponcho"
	item_state = "greenponcho"

/obj/item/clothing/accessory/poncho/green/big
	name = "large green poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is green. Noticibly larger around the shoulders."
	icon_state = "greenponcho-big"
	item_state = "greenponcho-big"

/obj/item/clothing/accessory/poncho/red
	name = "red poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is red."
	icon_state = "redponcho"
	item_state = "redponcho"

/obj/item/clothing/accessory/poncho/red/big
	name = "large red poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is red. Noticibly larger around the shoulders."
	icon_state = "redponcho-big"
	item_state = "redponcho-big"

/obj/item/clothing/accessory/poncho/purple
	name = "purple poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is purple."
	icon_state = "purpleponcho"
	item_state = "purpleponcho"

/obj/item/clothing/accessory/poncho/blue
	name = "blue poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is blue."
	icon_state = "blueponcho"
	item_state = "blueponcho"

/obj/item/clothing/accessory/poncho/roles/medical
	name = "medical poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with a green tint, standard Medical colors."
	icon_state = "medponcho"
	item_state = "medponcho"

/obj/item/clothing/accessory/poncho/roles/iac
	name = "IAC poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with a blue tint, standard IAC colors."
	icon_state = "IACponcho"
	item_state = "IACponcho"

/obj/item/clothing/accessory/poncho/roles/engineering
	name = "engineering poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is yellow and orange, standard Engineering colors."
	icon_state = "engiponcho"
	item_state = "engiponcho"

/obj/item/clothing/accessory/poncho/roles/science
	name = "science poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with purple trim, standard NanoTrasen Science colors."
	icon_state = "sciponcho"
	item_state = "sciponcho"

/obj/item/clothing/accessory/poncho/roles/cargo
	name = "cargo poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is tan and grey, the colors of Cargo."
	icon_state = "cargoponcho"
	item_state = "cargoponcho"

/*
 * Sashes
 */

/obj/item/clothing/accessory/sash
	name = "yellow sash"
	desc = "A yellow sash, designed to be worn over one shoulder and come down to the opposing hip."
	desc_fluff = "Sashes such as this one are a common sight throughout the Empire of Dominia, though they are hardly as fashionable as the typical cape."
	icon = 'icons/clothing/accessories/sash.dmi'
	item_state = "sash"
	icon_state = "sash"
	contained_sprite = TRUE

/obj/item/clothing/accessory/sash/red
	name = "red sash"
	desc = "A red sash, designed to be worn over one shoulder and come down to the opposing hip."
	item_state = "red_sash"
	icon_state = "red_sash"

/obj/item/clothing/accessory/sash/blue
	name = "blue sash"
	desc = "A blue sash, designed to be worn over one shoulder and come down to the opposing hip."
	item_state = "blue_sash"
	icon_state = "blue_sash"

/obj/item/clothing/accessory/sash/orange
	name = "orange sash"
	desc = "An orange sash, designed to be worn over one shoulder and come down to the opposing hip."
	item_state = "orange_sash"
	icon_state = "orange_sash"

/obj/item/clothing/accessory/sash/purple
	name = "purple sash"
	desc = "A purple sash, designed to be worn over one shoulder and come down to the opposing hip."
	item_state = "purple_sash"
	icon_state = "purple_sash"

/obj/item/clothing/accessory/sash/white
	name = "white sash"
	desc = "A white sash, designed to be worn over one shoulder and come down to the opposing hip."
	item_state = "white_sash"
	icon_state = "white_sash"

/obj/item/clothing/accessory/sash/colourable
	name = "sash"
	desc = "A sash, designed to be worn over one shoulder and come down to the opposing hip."
	item_state = "sash_colourable"
	icon_state = "sash_colourable"

/*
 * Cloak
 */
/obj/item/clothing/accessory/poncho/roles/cloak
	name = "quartermaster's cloak"
	desc = "An elaborate brown and gold cloak."
	icon_state = "qmcloak"
	item_state = "qmcloak"
	body_parts_covered = null

/obj/item/clothing/accessory/poncho/roles/cloak/ce
	name = "chief engineer's cloak"
	desc = "An elaborate cloak worn by the chief engineer."
	icon_state = "cecloak"
	item_state = "cecloak"

/obj/item/clothing/accessory/poncho/roles/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "An elaborate cloak meant to be worn by the chief medical officer."
	icon_state = "cmocloak"
	item_state = "cmocloak"

/obj/item/clothing/accessory/poncho/roles/cloak/hop
	name = "head of personnel's cloak"
	desc = "An elaborate cloak meant to be worn by the head of personnel."
	icon_state = "hopcloak"
	item_state = "hopcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/rd
	name = "research director's cloak"
	desc = "An elaborate cloak meant to be worn by the research director."
	icon_state = "rdcloak"
	item_state = "rdcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/qm
	name = "quartermaster's cloak"
	desc = "An elaborate cloak meant to be worn by the quartermaster."
	icon_state = "qmcloak"
	item_state = "qmcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/captain
	name = "captain's cloak"
	desc = "An elaborate cloak meant to be worn by the Captain."
	icon_state = "capcloak"
	item_state = "capcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/hos
	name = "head of security's cloak"
	desc = "An elaborate cloak meant to be worn by the Head of Security."
	icon_state = "hoscloak"
	item_state = "hoscloak"

/obj/item/clothing/accessory/poncho/roles/cloak/cargo
	name = "brown cloak"
	desc = "A simple brown and black cloak worn by crate jockeys."
	icon_state = "cargocloak"
	item_state = "cargocloak"

/obj/item/clothing/accessory/poncho/roles/cloak/mining
	name = "trimmed purple cloak"
	desc = "A trimmed purple and brown cloak worn by dwarves."
	icon_state = "miningcloak"
	item_state = "miningcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/service
	name = "green cloak"
	desc = "A simple green and blue cloak worn by.. Who?"
	icon_state = "servicecloak"
	item_state = "servicecloak"

/obj/item/clothing/accessory/poncho/roles/cloak/engineer
	name = "gold cloak"
	desc = "A simple gold and brown cloak worn by grease monkeys."
	icon_state = "engicloak"
	item_state = "engicloak"

/obj/item/clothing/accessory/poncho/roles/cloak/atmos
	name = "yellow cloak"
	desc = "A trimmed yellow and blue cloak worn by airbenders."
	icon_state = "atmoscloak"
	item_state = "atmoscloak"

/obj/item/clothing/accessory/poncho/roles/cloak/research
	name = "purple cloak"
	desc = "A simple purple and white cloak worn by nerds."
	icon_state = "scicloak"
	item_state = "scicloak"

/obj/item/clothing/accessory/poncho/roles/cloak/medical
	name = "blue cloak"
	desc = "A simple blue and white cloak worn by suit sensor activists."
	icon_state = "medcloak"
	item_state = "medcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/security
	name = "dark blue cloak"
	desc = "A simple dark blue cloak awarded by NanoTrasen for failing the introductory literacy test."
	icon_state = "seccloak"
	item_state = "seccloak"

/obj/item/clothing/accessory/poncho/shouldercape
	name = "shoulder cape"
	desc = "A simple shoulder cape."
	desc_fluff = "In Skrellian tradition, the length of cape typically signifies experience in various fields."
	icon_state = "starcape"
	item_state = "starcape"
	flippable = 1

/obj/item/clothing/accessory/poncho/shouldercape/star
	name = "star cape"
	desc = "A simple looking cape with a couple of runes woven into the fabric."
	icon_state = "starcape"
	item_state = "starcape"
	overlay_state = "starcape"

/obj/item/clothing/accessory/poncho/shouldercape/nebula
	name = "nebula cape"
	desc = "A decorated cape. Starry patterns have been woven into the fabric."
	icon_state = "nebulacape"
	item_state = "nebulacape"
	overlay_state = "nebulacape"

/obj/item/clothing/accessory/poncho/shouldercape/nova
	name = "nova cape"
	desc = "A heavily decorated cape with emblems on the shoulders. An ornate starry design has been woven into the fabric of it"
	icon_state = "novacape"
	item_state = "novacape"
	overlay_state = "novacape"

/obj/item/clothing/accessory/poncho/shouldercape/galaxy
	name = "galaxy cape"
	desc = "An extremely decorated cape with an intricately made design has been woven into the fabric of this cape with great care."
	icon_state = "galaxycape"
	item_state = "galaxycape"
	overlay_state = "galaxycape"

/obj/item/clothing/accessory/poncho/shouldercape/qeblak
	name = "qeblak mantle"
	desc = "A mantle denoting the wearer as a member fo the Qeblak faith."
	desc_fluff = "This mantle denotes the wearer as a member of the Qeblak faith. \
	It is given to followers after they have completed their coming of age ceremony. \
	The symbol on the back is of a protostar as it transitions into a main sequence star, \
	representing the the wearer becoming an adult."
	icon_state = "qeblak_cape"
	item_state = "qeblak_cape"
	flippable = FALSE

/obj/item/clothing/accessory/poncho/shouldercape/qeblak/zeng
	name = "Jargon Division Zeng-Hu cloak"
	desc = "This cloak is given to Zeng-Hu employees who have assisted or worked in collaboration with the Jargon Federation."
	desc_fluff = "A cloak given to senior level doctors and researchers for Zeng-Hu who has \
	in the past been given the privilege of working within or in collaboration with the Jargon Federation\
	 as a show of goodwill between the corporation and federation."
	icon = 'icons/obj/contained_items/accessories/ZH_cape.dmi'
	icon_override = 'icons/obj/contained_items/accessories/ZH_cape.dmi'
	icon_state = "ZH_cape"
	item_state = "ZH_cape"
	flippable = FALSE
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/trinary
	name = "trinary perfection cape"
	desc = "A brilliant red and brown cape, commonly worn by those who serve the Trinary Perfection."
	icon_state = "trinary_cape"
	item_state = "trinary_cape"
	overlay_state = "trinary_cape"

/obj/item/clothing/accessory/poncho/trinary/pellegrina
	name = "trinary perfection pellegrina"
	desc = "A brilliant red and brown cape, commonly worn by those who serve the Trinary Perfection. This one is signifcantly shorter."
	icon_state = "trinary_pellegrina"
	item_state = "trinary_pellegrina"
	overlay_state = "trinary_pellegrina"

/obj/item/clothing/accessory/poncho/trinary/shouldercape
	name = "trinary perfection shoulder cape"
	desc = "A brilliant red and brown cape, commonly worn by those who serve the Trinary Perfection. This one is worn over one shoulder."
	icon_state = "trinary_shouldercape"
	item_state = "trinary_shouldercape"
	overlay_state = "trinary_shouldercape"

/obj/item/clothing/accessory/poncho/assunzione
	name = "assunzione robe"
	desc = "A simple purple robe commonly worn by adherents to Luceism, the predominant religion on Assunzione."
	icon = 'icons/clothing/suits/capes/assunzione_robe.dmi'
	icon_override = null
	icon_state = "assunzione_robe"
	item_state = "assunzione_robe"
	overlay_state = "assunzione_robe"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/assunzione/vine
	desc = "A simple purple robe commonly worn by adherents to Luceism, the predominant religion on Assunzione. This one features a lux vine \
	inlay that allows the symbol of the Luceian Square to be faintly seen, even in darkness."
	icon_state = "assunzione_robe_vine"
	item_state = "assunzione_robe_vine"
	overlay_state = "assunzione_robe_vine"

/obj/item/clothing/accessory/poncho/assunzione/gold
	desc = "A simple purple robe commonly worn by adherents to Luceism, the predominant religion on Assunzione. The Luceian Square, Luceism's \
	holy symbol is present on the back in gold fabric."
	icon_state = "assunzione_robe_gold"
	item_state = "assunzione_robe_gold"
	overlay_state = "assunzione_robe_gold"

//tau ceti legion ribbons
/obj/item/clothing/accessory/legion
	name = "seniority ribbons"
	desc = "A ribbon meant to attach to the chest and sling around the shoulder accompanied by two medallions, marking seniority in a Tau Ceti Foreign Legion."
	icon_state = "senior_ribbon"
	item_state = "senior_ribbon"
	overlay_state = "senior_ribbon"
	slot = ACCESSORY_SLOT_CAPE
	flippable = TRUE

/obj/item/clothing/accessory/legion/specialist
	name = "specialist medallion"
	desc = "Two small medallions, one worn on the shoulder and the other worn on the chest. Meant to display the rank of specialist troops in a Tau Ceti Foreign Legion."
	icon_state = "specialist_medallion"
	item_state = "specialist_medallion"
	overlay_state = "specialist_medallion"

/obj/item/clothing/accessory/offworlder
	name = "venter assembly"
	desc = "A series of complex tubing meant to dissipate heat from the skin passively."
	icon_state = "venter"
	item_state = "venter"
	slot = ACCESSORY_SLOT_CAPE

/obj/item/clothing/accessory/offworlder/bracer
	name = "legbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's legs upright comfortably."
	icon_state = "legbrace"
	item_state = "legbrace"
	drop_sound = 'sound/items/drop/gun.ogg'

/obj/item/clothing/accessory/offworlder/bracer/neckbrace
	name = "neckbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's neck upright comfortably."
	icon_state = "neckbrace"
	item_state = "neckbrace"

/obj/item/clothing/accessory/tc_pin
	name = "Tau Ceti pin"
	desc = "A small, Tau Ceti flag pin of the Republic of Tau Ceti."
	icon_state = "tc-pin"
	item_state = "tc-pin"
	overlay_state = "tc-pin"
	flippable = 1
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/accessory/sol_pin
	name = "Sol Alliance pin"
	desc = "A small pin of the Sol Alliance, shaped like a golden sun."
	icon_state = "sol-pin"
	item_state = "sol-pin"
	overlay_state = "sol-pin"
	flippable = 1
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/accessory/dogtags
	name = "dogtags"
	desc = "A pair of engraved metal identification tags."
	icon = 'icons/clothing/accessories/dogtags.dmi'
	icon_state = "dogtags"
	item_state = "dogtags"
	contained_sprite = TRUE
	slot_flags = SLOT_MASK | SLOT_TIE
	overlay_state = "tags"
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/clothing/accessory/dogtags/get_mask_examine_text(mob/user)
	return "around [user.get_pronoun("his")] neck"

/obj/item/clothing/accessory/badge/namepin
	name = "pin tag"
	desc = "A small strip of metal to label its wearer."
	icon_state = "namepintag"
	overlay_state = null
	badge_string = null
	slot_flags = SLOT_TIE
	w_class = ITEMSIZE_TINY

/obj/item/clothing/accessory/ribbon
	name = "ribbon"
	desc = "A small ribbon to commemorate or support a cause."
	icon_state = "ribbon"
	item_state = "ribbon"
	slot_flags = SLOT_TIE
	w_class = ITEMSIZE_TINY

/obj/item/clothing/accessory/sleevepatch
	name = "sleeve patch"
	desc = "An embroidered patch which can be attached to the shoulder sleeve of clothing."
	icon_state = "patch"
	overlay_state = "patch"
	flippable = 1
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/accessory/sleevepatch/scc
	name = "Stellar Corporate Conglomerate patch"
	desc = "An embroidered patch, adorned with the logo of the Stellar Corporate Conglomerate, which can be attached to the shoulder sleeve of clothing."
	desc_fluff = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	icon_state = "scc_patch"
	overlay_state = "scc_patch"

/obj/item/clothing/accessory/sleevepatch/zavodskoi
	name = "\improper Zavodskoi Interstellar sleeve patch"
	desc = "An embroidered patch which can be attached to the shoulder sleeve of clothing. This one bears the Zavodskoi Interstellar logo."
	icon_state = "necro_patch"
	overlay_state = "necro_patch"

/obj/item/clothing/accessory/sleevepatch/zavodskoisec
	name = "\improper Zavodskoi Interstellar Security sleeve patch"
	desc = "An embroidered patch which can be attached to the shoulder sleeve of clothing. This one bears the Zavodskoi Interstellar logo with an insignia."
	icon_state = "necrosec_patch"
	overlay_state = "necrosec_patch"

/obj/item/clothing/accessory/sleevepatch/erisec
	name = "\improper EPMC sleeve patch"
	desc = "A digital patch which can be attached to the shoulder sleeve of clothing. This one denotes the wearer as an Eridani Private Military Contractor."
	icon_state = "erisec_patch"
	overlay_state = "erisec_patch"

/obj/item/clothing/accessory/sleevepatch/idrissec
	name = "\improper Idris Incorporated sleeve patch"
	desc = "A digital patch which can be attached to the shoulder sleeve of clothing. This one shows the Idris Incorporated logo with a flashing chevron."
	icon_state = "idrissec_patch"
	overlay_state = "idrissec_patch"

/obj/item/clothing/accessory/kneepads
	name = "kneepads"
	desc = "A pair of synthetic kneepads. Doesn't provide protection from more than arthritis."
	icon = 'icons/clothing/accessories/kneepads.dmi'
	icon_state = "kneepads"
	item_state = "kneepads"
	contained_sprite = TRUE
	gender = PLURAL

/obj/item/clothing/accessory/blood_patch
	name = "O- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O NEGATIVE."
	icon = 'icons/clothing/accessories/blood_patch.dmi'
	icon_state = "onegtag"
	contained_sprite = TRUE

/obj/item/clothing/accessory/blood_patch/opos
	name = "O+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O POSITIVE."
	icon_state = "opostag"

/obj/item/clothing/accessory/blood_patch/apos
	name = "A+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A POSITIVE."
	icon_state = "apostag"

/obj/item/clothing/accessory/blood_patch/aneg
	name = "A- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A NEGATIVE."
	icon_state = "anegtag"

/obj/item/clothing/accessory/blood_patch/bpos
	name = "B+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B POSITIVE."
	icon_state = "bpostag"

/obj/item/clothing/accessory/blood_patch/bneg
	name = "B- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B NEGATIVE."
	icon_state = "bnegtag"

/obj/item/clothing/accessory/blood_patch/abpos
	name = "AB+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB POSITIVE."
	icon_state = "abpostag"

/obj/item/clothing/accessory/blood_patch/abneg
	name = "AB- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB NEGATIVE."
	icon_state = "abnegtag"
