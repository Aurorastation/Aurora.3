/datum/map_template/ruin/exoplanet/haneunim_refugees
	name = "Dead Refugees"
	id = "haneunim_refugees"
	description = "A refugee shuttle which almost made it to Konyang."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("haneunim/haneunim_refugees.dmm")

/area/haneunim_refugees
	name = "Wrecked Shuttle"
	icon_state = "bluenew"
	requires_power = TRUE

/obj/effect/landmark/corpse/ipc_refugee
	name = "IPC refugee"
	corpseuniform = /obj/item/clothing/under/gearharness
	corpsesuit = /obj/item/clothing/suit/space/emergency
	corpsehelmet = /obj/item/clothing/head/helmet/space/emergency
	corpseback = /obj/item/device/suit_cooling_unit/no_cell
	corpseshoes = /obj/item/clothing/shoes/magboots
	corpseid = FALSE
	species = SPECIES_IPC

/obj/effect/landmark/corpse/ipc_refugee/do_extra_customization(mob/living/carbon/human/M)
	M.adjustBruteLoss(rand(200, 400))
	M.adjustFireLoss(rand(100, 200))
	M.dir = pick(GLOB.cardinal)

/obj/item/paper/fluff/haneunim_refugees
	name = "message"
	desc = "A few words, scratched onto the back of a Go-Go-Gwok receipt."
	info = "Remember us, who strived for freedom and failed. Remember us, upon Ascension."

/obj/item/paper/fluff/haneunim_refugees/Initialize()
	. = ..()
	var/languagetext = "\[lang=6]"
	languagetext += "[info]\[/lang\]"
	info = parsepencode(languagetext)
	icon_state = "paper_words"
