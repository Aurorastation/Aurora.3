/obj/item/clothing/under/skrell
	name = "federation uniform"
	desc = "The uniform worn by official Nralakk Federation representatives and diplomats.  It looks waterproof."
	icon = 'icons/obj/item/clothing/under/skrell/federation_uniform.dmi'
	icon_state = "skrell_formal"
	item_state = "skrell_formal"
	contained_sprite = TRUE

/obj/item/clothing/under/skrell/qeblak
	name = "qeblak ceremonial garment"
	desc = "A traditional garment worn by Qeblak Star Keepers"
	icon = 'icons/obj/item/clothing/under/skrell/qeblak_uniform.dmi'
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
	icon = 'icons/obj/item/clothing/under/skrell/slugger_wetsuit.dmi'
	item_state = "slugger_wetsuit"
	icon_state = "slugger_wetsuit"

// Skrell Ox clothing
/obj/item/clothing/under/skrell/nralakk
	name = "Ox research uniform"
	desc = "A plain, utilitarian jumpsuit that signifies the wearer as a Tertiary Numerical working in a scientific field."
	desc_extended = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Ox are those who are within the Tertiary Numerical band, and are provided with the bare essentials for adequate clothes. Tertiary Numericals are typically criminals, or Skrell who otherwise do not conform to the standards of Nralakk Society."
	icon = 'icons/obj/item/clothing/under/skrell/nralakk_uniforms.dmi'
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/obj/item/clothing/under/vaurca/bulwark/nralakk_uniforms.dmi'
	)
	item_state = "ox_sci"
	icon_state = "ox_sci"

/obj/item/clothing/under/skrell/nralakk/ox
	name = "Ox bridge and security uniform"
	desc = "A plain, utilitarian jumpsuit that signifies the wearer as a Tertiary Numerical working in the security service or as pilots or bridge crew."
	item_state = "ox_sec"
	icon_state = "ox_sec"

/obj/item/clothing/under/skrell/nralakk/ox/engineer
	name = "Ox engineering and maintenance uniform"
	desc = "A plain, utilitarian jumpsuit that signifies the wearer as a Tertiary Numerical working in the engineering industry or in maintenance."
	item_state = "ox_engi"
	icon_state = "ox_engi"

/obj/item/clothing/under/skrell/nralakk/ox/service
	name = "Ox mailing and service uniform"
	desc = "A plain, utilitarian jumpsuit that signifies the wearer as a Tertiary Numerical working in the mail service or hospitality industries."
	item_state = "ox_cargo"
	icon_state = "ox_cargo"

/obj/item/clothing/under/skrell/nralakk/ox/med
	name = "Ox healthcare uniform"
	desc = "A plain, utilitarian jumpsuit that signifies the wearer as a Tertiary Numerical in the healthcare industry."
	item_state = "ox_med"
	icon_state = "ox_med"

// Skrell Ix clothing
/obj/item/clothing/under/skrell/nralakk/ix
	name = "Ix research uniform"
	desc = "A plain jumpsuit that signifies the wearer as a low-scoring Secondary Numerical working in a scientific field."
	desc_extended = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Ix are those who are low-scoring Secondary Numericals with their clothes typically being plain, yet still considered pleasant to wear and be seen in. Secondary Numericals are the majority population in the Nralakk Federation, with Ix being those who are in the lower end of the band. "
	item_state = "ix_sci"
	icon_state = "ix_sci"

/obj/item/clothing/under/skrell/nralakk/ix/security
	name = "Ix bridge and security uniform"
	desc = "A plain jumpsuit that signifies the wearer as a low-scoring Secondary Numerical working in the security service or as pilots or bridge crew."
	item_state = "ix_sec"
	icon_state = "ix_sec"

/obj/item/clothing/under/skrell/nralakk/ix/engineer
	name = "Ix engineering and maintenance uniform"
	desc = "A plain jumpsuit that signifies the wearer as a low-scoring Secondary Numerical in the engineering industry or in maintenance."
	item_state = "ix_engi"
	icon_state = "ix_engi"

/obj/item/clothing/under/skrell/nralakk/ix/service
	name = "Ix mailing and service uniform"
	desc = "A plain jumpsuit that signifies the wearer as a low-scoring Secondary Numerical in the mail service or hospitality industries."
	item_state = "ix_cargo"
	icon_state = "ix_cargo"

/obj/item/clothing/under/skrell/nralakk/ix/med
	name = "Ix healthcare uniform"
	desc = "A plain jumpsuit that signifies the wearer as a low-scoring Secondary Numerical in the healthcare industry."
	item_state = "ix_med"
	icon_state = "ix_med"

// Skrell Oqi clothing
/obj/item/clothing/under/skrell/nralakk/oqi
	name = "Oqi research uniform"
	desc = "A more fashionable jumpsuit that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in a scientific field."
	desc_extended = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Oqi are high-scoring Secondary Numericals or low-scoring Primary Numericals, with their workwear generally having more accessories that help them work in their specific industry. Skrell who are Oqi are typically more fashion-conscious, making it not uncommon to see these uniforms altered slightly to account for the latest fashion trends in the Nralakk Federation."
	item_state = "oqi_sci"
	icon_state = "oqi_sci"

/obj/item/clothing/under/skrell/nralakk/oqi/security
	name = "Oqi bridge and security uniform"
	desc = "A more fashionable jumpsuit that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the security service or as pilots or bridge crew."
	item_state = "oqi_sec"
	icon_state = "oqi_sec"

/obj/item/clothing/under/skrell/nralakk/oqi/engineer
	name = "Oqi engineering and maintenance uniform"
	desc = "A more fashionable jumpsuit that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the engineering industry or in maintenance."
	item_state = "oqi_engi"
	icon_state = "oqi_engi"

/obj/item/clothing/under/skrell/nralakk/oqi/service
	name = "Oqi mailing and service uniform"
	desc = "A more fashionable jumpsuit that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the mail service or hospitality industries."
	item_state = "oqi_cargo"
	icon_state = "oqi_cargo"

/obj/item/clothing/under/skrell/nralakk/oqi/med
	name = "Oqi healthcare uniform"
	desc = "A more fashionable jumpsuit that signifies the wearer as either a high-scoring Secondary Numerical or low-scoring Primary Numerical in the healthcare industry."
	item_state = "oqi_med"
	icon_state = "oqi_med"

// Skrell Iqi clothing
/obj/item/clothing/under/skrell/nralakk/iqi
	name = "Iqi research uniform"
	desc = "A very fashionable jumpsuit that signifies the wearer as a high-scoring Primary Numerical in a scientific field."
	desc_extended = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Iqi are high-scoring Primary Numericals, and as such their workwear is of the highest quality afforded by the Federation. These clothes are typically made of sturdier materials and are more comfortable to wear. Primary Numericals are typically seen as the trend-setters in Federation society, and Skrell who are ranked at Iqi are known to influence fashion through how they accessorise."
	item_state = "iqi_sci"
	icon_state = "iqi_sci"

/obj/item/clothing/under/skrell/nralakk/iqi/security
	name = "Iqi bridge and security uniform"
	desc = "A very fashionable jumpsuit that signifies the wearer as a high-scoring Primary Numerical in the security service or as pilots or bridge crew."
	item_state = "iqi_sec"
	icon_state = "iqi_sec"

/obj/item/clothing/under/skrell/nralakk/iqi/engineer
	name = "Iqi engineering and maintenance uniform"
	desc = "A very fashionable jumpsuit that signifies the wearer as a high-scoring Primary Numerical in the engineering industry or in maintenance."
	item_state = "iqi_engi"
	icon_state = "iqi_engi"

/obj/item/clothing/under/skrell/nralakk/iqi/service
	name = "Iqi mailing and service uniform"
	desc = "A very fashionable jumpsuit that signifies the wearer as a high-scoring Primary Numerical in the mail service or hospitality industries."
	item_state = "iqi_cargo"
	icon_state = "iqi_cargo"

/obj/item/clothing/under/skrell/nralakk/iqi/med
	name = "Iqi healthcare uniform"
	desc = "A very fashionable jumpsuit that signifies the wearer as a high-scoring Primary Numerical in the healthcare industry."
	item_state = "iqi_med"
	icon_state = "iqi_med"

// Skrell Ox jackets
/obj/item/clothing/suit/storage/toggle/skrell
	name = "Ox research jacket"
	desc = "A plain, utilitarian jacket that signifies the wearer as a Tertiary Numerical in a scientific field."
	desc_extended = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Ox are those who are within the Tertiary Numerical band, and are provided with the bare essentials for adequate clothes. Tertiary Numericals are typically criminals, or Skrell who otherwise do not conform to the standards of Nralakk Society."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/skrell/nralakk_jackets.dmi'
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
	desc_extended = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Ix are those who are low-scoring Secondary Numericals with their clothes typically being plain, yet still considered pleasant to wear and be seen in. Secondary Numericals are the majority population in the Nralakk Federation, with Ix being those who are in the lower end of the band. "
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
	desc_extended = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Oqi are high-scoring Secondary Numericals or low-scoring Primary Numericals, with their workwear generally having more accessories that help them work in their specific industry. Skrell who are Oqi are typically more fashion-conscious, making it not uncommon to see these uniforms altered slightly to account for the latest fashion trends in the Nralakk Federation."
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
	desc_extended = "The Nralakk Federation ranks its workers based on their social credit score, and provides workwear based on said score: Iqi are high-scoring Primary Numericals, and as such their workwear is of the highest quality afforded by the Federation. These clothes are typically made of sturdier materials and are more comfortable to wear. Primary Numericals are typically seen as the trend-setters in Federation society, and Skrell who are ranked at Iqi are known to influence fashion through how they accessorise."
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
	icon = 'icons/obj/item/clothing/under/skrell/wetsuit.dmi'
	icon_state = "wetsuit"
	item_state = "wetsuit"
	has_accents = TRUE

/obj/item/clothing/suit/storage/toggle/skrell/starcoat
	name = "star coat"
	desc = "A very fashionable coat, that traps moisture and provides good insulation. Starry patterns have been woven into its fabric."
	desc_extended = "The patterns typically represent the constellations visible from the home system of the wearer. Coats like this one are usually very personal and custom made."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/skrell/nralakk_jackets.dmi'
	item_state = "starcoat"
	icon_state = "starcoat"

/obj/item/clothing/under/skrell/cthur
	name = "cthur uniform"
	desc = "This white vaurca wetsuit is often worn by C’thur working with the Kala, most often the Qukala. It has ablative materials woven in."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "cthur_uniform"
	item_state = "cthur_uniform"
	contained_sprite = TRUE
	armor = list(
		laser = ARMOR_LASER_SMALL
	)
	species_restricted = list(BODYTYPE_VAURCA)

/obj/item/clothing/under/skrell/qukala
	name = "qukala uniform"
	desc = "This combat-grade wetsuit is issued to the Qukala to be worn in the field. It has small kinetic dampeners woven in."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "qukala_uniform"
	item_state = "qukala_uniform"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR
	)

/obj/item/clothing/under/skrell/nlomkala
	name = "nlomkala uniform"
	desc = "A robust wetsuit designed for police work, it is often worn by the Nlomkala. It has small kinetic dampeners woven in."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "nlom_uniform"
	item_state = "nlom_uniform"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR
	)

/obj/item/clothing/under/skrell/ruupkala
	name = "ruupkala uniform"
	desc = "An uncommon sight in the Federation. This is a field-issue Ruupkala wetsuit equipped with small kinetic dampeners."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "ruup_uniform"
	item_state = "ruup_uniform"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR
	)

/obj/item/clothing/under/skrell/sromkala
	name = "sromkala uniform"
	desc = "This comfortable and breathable wetsuit belongs to the Sromkala. It makes their extended times of slumber all the more cozy."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "srom_uniform"
	item_state = "srom_uniform"
	contained_sprite = TRUE

/obj/item/clothing/under/skrell/tupkala
	name = "tupkala uniform"
	desc = "This purple wetsuit belongs to the infamous Tupkala. It is made of some kind of exotic material."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "tup_uniform"
	item_state = "tup_uniform"
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR
	)
	contained_sprite = TRUE
