/obj/item/clothing/under/skrell
	name = "federation uniform"
	desc = "The uniform worn by Official Jagon Federation Representatives and Diplomats.  It looks pretty waterproof."
	icon = 'icons/obj/contained_items/skrell/federation_uniform.dmi'
	icon_state = "skrell_formal"
	item_state = "skrell_formal"
	contained_sprite = TRUE

/obj/item/clothing/under/skrell/qeblak
	name = "qeblak ceremonial garment"
	desc = "A traditional garment worn by Qeblak Star Keepers"
	icon = 'icons/obj/contained_items/skrell/qeblak_uniform.dmi'
	icon_state = "qeblak_uniform"
	item_state = "qeblak_uniform"
	action_button_name = "Toggle Ceremonial Garment Lights"
	var/lights = FALSE

/obj/item/clothing/under/skrell/qeblak/update_icon()
	..()
	if(lights)
		item_state = "[initial(icon_state)]_on"
	else
		item_state = initial(item_state)

/obj/item/clothing/under/skrell/qeblak/attack_self(mob/user)
	toggle_lights()

/obj/item/clothing/under/skrell/qeblak/verb/toggle_lights()
	set name = "Toggle Ceremonial Garment Lights"
	set category = "Object"
	set src in usr

	if (use_check_and_message(usr))
		return

	lights = !lights

	if(lights)
		set_light(2)
	else
		set_light(0)

	update_icon()
	usr.update_inv_w_uniform()

/obj/item/clothing/under/skrell/slugger
	name = "prescient republic of the qar wetsuit"
	desc = "A wetsuit worn by members of Prescient Republic of the Qar generational fleet."
	icon = 'icons/obj/contained_items/skrell/slugger_wetsuit.dmi'
	item_state = "slugger_wetsuit"
	icon_state = "slugger_wetsuit"

// Skrell Ox clothing
/obj/item/clothing/under/skrell/jargon
	name = "Ox research uniform"
	desc = "A plain, utilitarian jumpsuit that signifies the wearer as a Tertiary Numerical working in a scientific field."
	desc_fluff = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Ox are those who are within the Tertiary Numerical band, and are provided with the bare essentials for adequate clothes. Tertiary Numericals are typically criminals, or Skrell who otherwise do not conform to the standards of Nralakk Society."
	icon = 'icons/obj/contained_items/skrell/jargon_uniforms.dmi'
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/obj/contained_items/vaurca/bulwark/jargon_uniforms.dmi'
	)
	item_state = "ox_sci"
	icon_state = "ox_sci"

/obj/item/clothing/under/skrell/jargon/ox
	name = "Ox bridge and security uniform"
	desc = "A plain, utilitarian jumpsuit that signifies the wearer as a Tertiary Numerical working in the security service or as pilots or bridge crew."
	item_state = "ox_sec"
	icon_state = "ox_sec"

/obj/item/clothing/under/skrell/jargon/ox/engineer
	name = "Ox engineering and maintenance uniform"
	desc = "A plain, utilitarian jumpsuit that signifies the wearer as a Tertiary Numerical working in the engineering industry or in maintenance."
	item_state = "ox_engi"
	icon_state = "ox_engi"

/obj/item/clothing/under/skrell/jargon/ox/service
	name = "Ox mailing and service uniform"
	desc = "A plain, utilitarian jumpsuit that signifies the wearer as a Tertiary Numerical working in the mail service or hospitality industries."
	item_state = "ox_cargo"
	icon_state = "ox_cargo"

/obj/item/clothing/under/skrell/jargon/ox/med
	name = "Ox healthcare uniform"
	desc = "A plain, utilitarian jumpsuit that signifies the wearer as a Tertiary Numerical in the healthcare industry."
	item_state = "ox_med"
	icon_state = "ox_med"

// Skrell Ix clothing
/obj/item/clothing/under/skrell/jargon/ix
	name = "Ix research uniform"
	desc = "A plain jumpsuit that signifies the wearer as a low-scoring Secondary Numerical working in a scientific field."
	desc_fluff = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Ix are those who are low-scoring Secondary Numericals with their clothes typically being plain, yet still considered pleasant to wear and be seen in. Secondary Numericals are the majority population in the Nralakk Federation, with Ix being those who are in the lower end of the band. "
	item_state = "ix_sci"
	icon_state = "ix_sci"

/obj/item/clothing/under/skrell/jargon/ix/security
	name = "Ix bridge and security uniform"
	desc = "A plain jumpsuit that signifies the wearer as a low-scoring Secondary Numerical working in the security service or as pilots or bridge crew."
	item_state = "ix_sec"
	icon_state = "ix_sec"

/obj/item/clothing/under/skrell/jargon/ix/engineer
	name = "Ix engineering and maintenance uniform"
	desc = "A plain jumpsuit that signifies the wearer as a low-scoring Secondary Numerical in the engineering industry or in maintenance."
	item_state = "ix_engi"
	icon_state = "ix_engi"

/obj/item/clothing/under/skrell/jargon/ix/service
	name = "Ix mailing and service uniform"
	desc = "A plain jumpsuit that signifies the wearer as a low-scoring Secondary Numerical in the mail service or hospitality industries."
	item_state = "ix_cargo"
	icon_state = "ix_cargo"

/obj/item/clothing/under/skrell/jargon/ix/med
	name = "Ix healthcare uniform"
	desc = "A plain jumpsuit that signifies the wearer as a low-scoring Secondary Numerical in the healthcare industry."
	item_state = "ix_med"
	icon_state = "ix_med"

// Skrell Oqi clothing
/obj/item/clothing/under/skrell/jargon/oqi
	name = "Oqi research uniform"
	desc = "A more fashionable jumpsuit that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in a scientific field."
	desc_fluff = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Oqi are high-scoring Secondary Numericals or low-scoring Primary Numericals, with their workwear generally having more accessories that help them work in their specific industry. Skrell who are Oqi are typically more fashion-conscious, making it not uncommon to see these uniforms altered slightly to account for the latest fashion trends in the Nralakk Federation."
	item_state = "oqi_sci"
	icon_state = "oqi_sci"

/obj/item/clothing/under/skrell/jargon/oqi/security
	name = "Oqi bridge and security uniform"
	desc = "A more fashionable jumpsuit that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the security service or as pilots or bridge crew."
	item_state = "oqi_sec"
	icon_state = "oqi_sec"

/obj/item/clothing/under/skrell/jargon/oqi/engineer
	name = "Oqi engineering and maintenance uniform"
	desc = "A more fashionable jumpsuit that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the engineering industry or in maintenance."
	item_state = "oqi_engi"
	icon_state = "oqi_engi"

/obj/item/clothing/under/skrell/jargon/oqi/service
	name = "Oqi mailing and service uniform"
	desc = "A more fashionable jumpsuit that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the mail service or hospitality industries."
	item_state = "oqi_cargo"
	icon_state = "oqi_cargo"

/obj/item/clothing/under/skrell/jargon/oqi/med
	name = "Oqi healthcare uniform"
	desc = "A more fashionable jumpsuit that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the healthcare industry."
	item_state = "oqi_med"
	icon_state = "oqi_med"

// Skrell Iqi clothing
/obj/item/clothing/under/skrell/jargon/iqi
	name = "Iqi research uniform"
	desc = "A very fashionable jumpsuit that signifies the wearer as a high-scoring Primary Numerical in a scientific field."
	desc_fluff = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Iqi are high-scoring Primary Numericals, and as such their workwear is of the highest quality afforded by the Federation. These clothes are typically made of sturdier materials and are more comfortable to wear. Primary Numericals are typically seen as the trend-setters in Federation society, and Skrell who are ranked at Iqi are known to influence fashion through how they accessorise."
	item_state = "iqi_sci"
	icon_state = "iqi_sci"

/obj/item/clothing/under/skrell/jargon/iqi/security
	name = "Iqi bridge and security uniform"
	desc = "A very fashionable jumpsuit that signifies the wearer as a high-scoring Primary Numerical in the security service or as pilots or bridge crew."
	item_state = "iqi_sec"
	icon_state = "iqi_sec"

/obj/item/clothing/under/skrell/jargon/iqi/engineer
	name = "Iqi engineering and maintenance uniform"
	desc = "A very fashionable jumpsuit that signifies the wearer as a high-scoring Primary Numerical in the engineering industry or in maintenance."
	item_state = "iqi_engi"
	icon_state = "iqi_engi"

/obj/item/clothing/under/skrell/jargon/iqi/service
	name = "Iqi mailing and service uniform"
	desc = "A very fashionable jumpsuit that signifies the wearer as a high-scoring Primary Numerical in the mail service or hospitality industries."
	item_state = "iqi_cargo"
	icon_state = "iqi_cargo"

/obj/item/clothing/under/skrell/jargon/iqi/med
	name = "Iqi healthcare uniform"
	desc = "A very fashionable jumpsuit that signifies the wearer as a high-scoring Primary Numerical in the healthcare industry."
	item_state = "iqi_med"
	icon_state = "iqi_med"

// Skrell Ox jackets
/obj/item/clothing/suit/storage/toggle/skrell
	name = "Ox research jacket"
	desc = "A plain, utilitarian jacket that signifies the wearer as a Tertiary Numerical in a scientific field."
	desc_fluff = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Ox are those who are within the Tertiary Numerical band, and are provided with the bare essentials for adequate clothes. Tertiary Numericals are typically criminals, or Skrell who otherwise do not conform to the standards of Nralakk Society."
	icon = 'icons/obj/contained_items/skrell/jargon_jackets.dmi'
	item_state = "ox_sci_jacket"
	icon_state = "ox_sci_jacket"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/skrell/ox/security
	name = "Ox bridge and security jacket"
	desc = "A plain, utilitarian jacket that signifies the wearer as a Tertiary Numerical in the security service or as pilots or bridge crew."
	item_state = "ox_sec_jacket"
	icon_state = "ox_sec_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/ox/engineer
	name = "Ox engineering and maintenance jacket"
	desc = "A plain, utilitarian jacket that signifies the wearer as a Tertiary Numerical in the engineering industry or in maintenance."
	item_state = "ox_engi_jacket"
	icon_state = "ox_engi_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/ox/service
	name = "Ox mailing and service jacket"
	desc = "A plain, utilitarian jacket that signifies the wearer as a Tertiary Numerical in the mail service or hospitality industries."
	item_state = "ox_cargo_jacket"
	icon_state = "ox_cargo_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/ox/med
	name = "Ox healthcare jacket"
	desc = "A plain, utilitarian jacket that signifies the wearer as a Tertiary Numerical in the healthcare industry."
	item_state = "ox_med_jacket"
	icon_state = "ox_med_jacket"

// Skrell Ix jackets
/obj/item/clothing/suit/storage/toggle/skrell/ix
	name = "Ix research jacket"
	desc = "A plain jacket that signifies the wearer as a low-scoring Secondary Numerical in a scientific field."
	desc_fluff = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Ix are those who are low-scoring Secondary Numericals with their clothes typically being plain, yet still considered pleasant to wear and be seen in. Secondary Numericals are the majority population in the Nralakk Federation, with Ix being those who are in the lower end of the band. "
	item_state = "ix_sci_jacket"
	icon_state = "ix_sci_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/ix/security
	name = "Ix bridge and security jacket"
	desc = "A plain jacket that signifies the wearer as a low-scoring Secondary Numerical in the security service or as pilots or bridge crew."
	item_state = "ix_sec_jacket"
	icon_state = "ix_sec_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/ix/engineer
	name = "Ix engineering and maintenance jacket"
	desc = "A plain jacket that signifies the wearer as a low-scoring Secondary Numerical in the engineering industry or in maintenance."
	item_state = "ix_engi_jacket"
	icon_state = "ix_engi_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/ix/service
	name = "Ix mailing and service jacket"
	desc = "A plain jacket that signifies the wearer as a low-scoring Secondary Numerical in the mail service or hospitality industries."
	item_state = "ix_cargo_jacket"
	icon_state = "ix_cargo_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/ix/med
	name = "Ix healthcare jacket"
	desc = "A plain jacket that signifies the wearer as a low-scoring Secondary Numerical in the healthcare industry."
	item_state = "ix_med_jacket"
	icon_state = "ix_med_jacket"

// Skrell Oqi jackets
/obj/item/clothing/suit/storage/toggle/skrell/oqi
	name = "Oqi research jacket"
	desc = "A more fashionable jacket that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in a scientific field."
	desc_fluff = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Oqi are high-scoring Secondary Numericals or low-scoring Primary Numericals, with their workwear generally having more accessories that help them work in their specific industry. Skrell who are Oqi are typically more fashion-conscious, making it not uncommon to see these uniforms altered slightly to account for the latest fashion trends in the Nralakk Federation."
	item_state = "oqi_sci_jacket"
	icon_state = "oqi_sci_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/oqi/security
	name = "Oqi bridge and security jacket"
	desc = "A more fashionable jacket that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the security service or as pilots or bridge crew."
	item_state = "oqi_sec_jacket"
	icon_state = "oqi_sec_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/oqi/engineer
	name = "Oqi engineering and maintenance jacket"
	desc = "A more fashionable jacket that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the engineering industry or in maintenance."
	item_state = "oqi_engi_jacket"
	icon_state = "oqi_engi_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/oqi/service
	name = "Oqi mailing and service jacket"
	desc = "A more fashionable jacket that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the mail service or hospitality industries."
	item_state = "oqi_cargo_jacket"
	icon_state = "oqi_cargo_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/oqi/med
	name = "Oqi healthcare jacket"
	desc = "A more fashionable jacket that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the healthcare industry."
	item_state = "oqi_med_jacket"
	icon_state = "oqi_med_jacket"

// Skrell Iqi jackets
/obj/item/clothing/suit/storage/toggle/skrell/iqi
	name = "Iqi research jacket"
	desc = "A very fashionable jacket that signifies the wearer as a high-scoring Primary Numerical in a scientific field."
	desc_fluff = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Iqi are high-scoring Primary Numericals, and as such their workwear is of the highest quality afforded by the Federation. These clothes are typically made of sturdier materials and are more comfortable to wear. Primary Numericals are typically seen as the trend-setters in Federation society, and Skrell who are ranked at Iqi are known to influence fashion through how they accessorise."
	item_state = "iqi_sci_jacket"
	icon_state = "iqi_sci_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/iqi/security
	name = "Iqi bridge and security jacket"
	desc = "A very fashionable jacket that signifies the wearer as a high-scoring Primary Numerical in the security service or as pilots or bridge crew."
	item_state = "iqi_sec_jacket"
	icon_state = "iqi_sec_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/iqi/engineer
	name = "Iqi engineering and maintenance jacket"
	desc = "A very fashionable jacket that signifies the wearer as a high-scoring Primary Numerical in the engineering industry or in maintenance."
	item_state = "iqi_engi_jacket"
	icon_state = "iqi_engi_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/iqi/service
	name = "Iqi mailing and service jacket"
	desc = "A very fashionable jacket that signifies the wearer as a high-scoring Primary Numerical in the mail service or hospitality industries."
	item_state = "iqi_cargo_jacket"
	icon_state = "iqi_cargo_jacket"

/obj/item/clothing/suit/storage/toggle/skrell/iqi/med
	name = "Iqi healthcare jacket"
	desc = "A very fashionable jacket that signifies the wearer as a high-scoring Primary Numerical in the healthcare industry."
	item_state = "iqi_med_jacket"
	icon_state = "iqi_med_jacket"

/obj/item/clothing/under/skrell/wetsuit
	name = "casual wetsuit"
	desc = "A wetsuit intended as casualwear for Skrell. Can be worn on its own or under additional clothes."
	icon = 'icons/obj/contained_items/skrell/wetsuit.dmi'
	icon_state = "wetsuit"
	item_state = "wetsuit"
	var/additional_color = COLOR_GRAY

/obj/item/clothing/under/skrell/wetsuit/update_icon()
	cut_overlays()
	var/image/accent = image(icon, null, "wetsuit_un_accent")
	accent.appearance_flags = RESET_COLOR
	accent.color = additional_color
	add_overlay(accent)

/obj/item/clothing/under/skrell/wetsuit/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_w_uniform_str)
		var/image/accent = image(mob_icon, null, "wetsuit_un_accent")
		accent.appearance_flags = RESET_COLOR
		accent.color = additional_color
		I.add_overlay(accent)
	return I

/obj/item/clothing/suit/storage/toggle/skrell/starcoat
	name = "star coat"
	desc = "A very fashionable coat, that traps moisture and provides good insulation. Starry patterns have been woven into its fabric."
	desc_fluff = "The patterns typically represent the constellations visible from the home system of the wearer. Coats like this one are usually very personal and custom made."
	icon = 'icons/obj/contained_items/skrell/jargon_jackets.dmi'
	item_state = "starcoat"
	icon_state = "starcoat"
	contained_sprite = TRUE
