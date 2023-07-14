/obj/item/clothing/accessory/sinta_hood
	name = "clan hood"
	desc = "A hood worn commonly by unathi away from home. No better way of both representing your clan to \
	foreigners and keeping the sun out of your eyes in style!"
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "sinta_hood"
	item_state = "sinta_hood_up"
	slot_flags = SLOT_TIE|SLOT_HEAD|SLOT_EARS
	flags_inv = BLOCKHAIR|BLOCKHEADHAIR
	contained_sprite = TRUE
	action_button_name = "Adjust Hood"
	var/up = TRUE

/obj/item/clothing/accessory/sinta_hood/get_ear_examine_text(var/mob/user, var/ear_text = "left")
	return "on [user.get_pronoun("his")] head"

/obj/item/clothing/accessory/sinta_hood/attack_self()
	toggle()

/obj/item/clothing/accessory/sinta_hood/verb/toggle()
	set category = "Object"
	set name = "Adjust Hood"
	set src in usr

	if(use_check_and_message(usr))
		return
	up = !up
	if(up)
		flags_inv = BLOCKHAIR|BLOCKHEADHAIR
		body_parts_covered = HEAD
		item_state = "sinta_hood_up"
		to_chat(usr, SPAN_NOTICE("You flip \the [src] up."))
	else
		flags_inv = 0
		body_parts_covered = 0
		item_state = "sinta_hood"
		to_chat(usr, SPAN_NOTICE("You flip \the [src] down."))
	update_worn_icon()
	update_clothing_icon()
	update_icon()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.update_hair()

/obj/item/clothing/accessory/unathi
	name = "gyazo belt"
	desc = "A simple belt fashioned from cloth, the gyazo belt is an adornment that can be paired with practically \
	any Unathite outfit and is a staple for any Sinta. Fashionable and comes in a variety of colors!"
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "sash"
	item_state = "sash"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/maxtlatl
	name = "Th'akhist maxtlatl"
	desc = "A traditional garment worn by Th'akh shamans. Popular adornments include dried and pressed grass and \
	flowers, in addition to colorful stones placed into and hanging off of the mantle."
	desc_extended = "The term \" maxtlatl\" was given by humanity upon seeing this due to its resemblance to ancient \
	human cultures. However, it is more appropriately called a zlukti, or 'spirit garb'. Each adornment, whether \
	feathers, stones, or metals, is made by another shaman who has passed away: the more colorful the attire, the \
	older it is."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "maxtlatl"
	item_state = "maxtlatl"
	icon_override = null
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/unathimantle
	name = "desert hide mantle"
	desc = "The cured hide and skin of a large beast, tapered off with a colorful collar. This one is a popular \
	trophy among Wastelanders: someone's been hunting!"
	desc_extended = "With the expansion of the Touched Lands, the normal beasts that prowl and stalk the dunes have \
	proliferated at unprecedented rates. Those stranded outside of the greenery of the Izweski take up arms to cull \
	the herdes of klazd, and their skins make valuable mantles to protect wearers from the sun."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "mantle-unathi"
	item_state = "mantle-unathi"
	icon_override = null
	contained_sprite = TRUE
	build_from_parts = TRUE
	worn_overlay = "desert"

/obj/item/clothing/accessory/poncho/unathimantle/forest
	name = "forest hide mantle"
	desc = "The cured hide and skin of a large beast, tapered off with a colorful collar. These are seen exclusively \
	by warriors, nobles, and those with credits to spare."
	desc_extended = "After the Contact War, the prized horns of the tul quickly vanished from the market. Nobles and \
	wealthy guildsmen were swift to monopolize and purchase all the remaining cloaks; a peasant seen with one of \
	these is likely enough a death sentence."
	worn_overlay = "forest"

/obj/item/clothing/accessory/poncho/unathimantle/mountain
	name = "mountain hide mantle"
	desc = "The cured hide and skin of a large beast, tapered off with a colorful collar. Mountainous arbek, massive \
	snakes longer than a bus, have a long enough hide for multiple mantles."
	desc_extended = "Hunting an arbek is no easy task. Brave Zo'saa looking to prove themselves in battle and be \
	promoted to Saa rarely understand the gravity of these trials. Serpents large enough to swallow Unathi whole, \
	they can live up to half a millenia- should enough foolish adventurers try to slay it, that is."
	worn_overlay = "mountain"

/obj/item/clothing/accessory/poncho/unathimantle/hephaestus
	name = "hephaestus guild mantle"
	desc = "The cured hide and skin of a large beast, dyed in the deep green of Hephaestus Industries. These mantles are reserved for guildsmen of Haphaestus Industries, \
	a sign of their employment with the human megacorporation."
	desc_extended = "Hephaestus alone of all the megacorporations has integrated itself into the guild system of the Unathi people - they employ thousands of Sinta seeking \
	greater prosperity than the older guilds can provide, and for many, especially of the younger generation, the Hephaestus mantle is a badge of pride. To more traditional \
	Unathi, however, this mantle is a badge of betrayal - a sign of alien influence and infiltration."
	worn_overlay = "hephguild"

/obj/item/clothing/accessory/poncho/unathimantle/merchant
	name = "merchants' guild mantle"
	desc = "The cured hide and skin of a large beast, dyed in the purple colors of the Merchants' Guild. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "In the modern day, the Merchants' Guild is one of the largest guilds in the Hegemony - access to new and alien markets has produced great wealth for the guild, \
	and its guildsmen can be seen trading all across the Orion Spur."
	worn_overlay = "merchantsguild"

/obj/item/clothing/accessory/poncho/unathimantle/miner
	name = "miners' guild mantle"
	desc = "The cured hide and skin of a large beast, dyed in the burnt orange of the Miners' Guild. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "The Miners' Guild is a powerful one still, though the expansion of Hephaestus mining operations into the Hegemony has harmed the monopoly they once held over their \
	industry. For now, however, the Unathi guild and the alien megacorporation have managed to coexist."
	worn_overlay = "minersguild"

/obj/item/clothing/accessory/poncho/unathimantle/junzi
	name = "junzi electric guild mantle"
	desc = "The cured hide and skin of a large beast, dyed in the electric blue of the Junzi Electric Guild. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "For centuries, Junzi Electric has been responsible for the Hegemony's power industry. It is the oldest guild in existence within the Hegemony, with origins dating back \
	to the Unathi discovery of electricity. In the modern age, a vast majority of the Hegemony's power generation is still maintained by guildsmen of Junzi Electric."
	worn_overlay = "junzielectric"

/obj/item/clothing/accessory/poncho/unathimantle/bard
	name = "bards' guild mantle"
	desc = "The cured hide and skin of a large beast, dyed in the vibrant green of the Bards' Guild, also known as the Keepers of Heirlooms. \
	These mantles are reserved for full-fledged guildsmen as a sign of their position in the guild."
	desc_extended = "The Keepers of Heirlooms operate a majority of the Hegemony's entertainment industry - nearly all news, television and film across the Hegemony can be traced back \
	to this ancient and illustrious guild. Outside of the Hegemony, they are mainly known for their operation of Sinta Articles, the largest news outlet of the Hegemony."
	worn_overlay = "bardsguild"

/obj/item/clothing/accessory/poncho/unathimantle/med
	name = "house of medicine mantle"
	desc = "The cured hide and skin of a large beast, dyed in the clean white of the House of Medicine. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "The House of Medicine oversees the Skalamar University of Medicine, one of the oldest educational institutions on Moghes. To be a guildsman of the House is equivalent \
	to a medical doctorate within human nations. In recent years, the House has come into conflict with the K'lax Hive, as their gene-clinics pose a threat to the guild's monopoly over \
	the medical industry."
	worn_overlay = "houseofmedicine"

/obj/item/clothing/accessory/poncho/unathimantle/construction
	name = "construction coalition mantle"
	desc = "The cured hide and skin of a large beast, dyed in the warm yellow of the Construction Coalition. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "The Construction Coalition is a unique guild, operating far more democratically than others. It originated as a loose federation of local construction guilds, and \
	this new and unique model was only recently approved by Hegemon Not'zar. Many of the castles of the nobility and the great cities of Moghes were constructed and are still maintained by \
	guildsmen of the Coalition's constituents."
	worn_overlay = "constructioncoalition"

/obj/item/clothing/accessory/poncho/unathimantle/union
	name = "hearts of industry mantle"
	desc = "The cured hide and skin of a large beast, dyed in the tan colors of the Hearts of Industry. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "A new movement, and one rapidly gaining influence in the Southlands of Moghes, the Hearts of Industry resemble a workers' union more than a traditional guild. \
	Their membership has grown in the factories and docks of Jaz'zirt, and they have often clashed with the local nobility on matters of workers' rights. While membership in the Hearts \
	is not illegal, the organisation's growing power threatens the status quo, and their meetings have often been brutally struck down by Overlord Miazso."
	worn_overlay = "heartofindustry"

/obj/item/clothing/accessory/poncho/unathimantle/fighter
	name = "fighters' lodge mantle"
	desc = "The cured hide and skin of a large beast, dyed in the blood red of the Fighters' Lodge. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "The Fighters' Lodge was created in the years following the Contact War, inspired by human private military contractors. As such, it has an unusual structure for an Unathi guild, \
	resembling a human corporation more than the traditional guilds of Moghes. The Fighters' Lodge mainly takes jobs as security for merchants, with their charter preventing them from \
	taking sides in the power struggles of the nobility."
	worn_overlay = "fighterslodge"

/obj/item/clothing/accessory/poncho/unathimantle/fisher
	name = "fishing league mantle"
	desc = "The cured hide and skin of a large beast, dyed in the grey-brown of the Fishing League. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "The largest guild within the Hegemony, the Fishing League is a behemoth of food production, churning out tons of foodstuffs a day. While local villages and nobles have their own food production centers, mainly aquaculture farms which run outside of the aegis of the Fishing League, the vast majority of food produced within the Hegemony is produced by the Fishing League, whether it be on Ouerea or Moghes. However, due to the post-contact war environment of Moghes, no matter how much the fishing league produces, it will never be enough to feed the remaining population."
	worn_overlay = "fishingleague"

/obj/item/clothing/accessory/poncho/rockstone
	name = "rockstone cape"
	desc = "A cape seen exclusively on nobility. The chain is adorned with precious, multi-color stones, hence its name."
	desc_extended = "A simple drape over the shoulder is done easily; the distinguishing part between the commoners and \
	nobility is the sheer elegance of the rockstone cape. Vibrant stones adorn the heavy collar, and the cape itself \
	is embroidered with gold."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "rockstone"
	item_state = "rockstone"
	icon_override = null
	contained_sprite = TRUE
	var/additional_color = COLOR_GRAY

/obj/item/clothing/accessory/poncho/rockstone/update_icon()
	cut_overlays()
	var/image/gem = image(icon, null, "rockstone_gem")
	gem.appearance_flags = RESET_COLOR
	gem.color = additional_color
	add_overlay(gem)
	var/image/chain = image(icon, null, "rockstone_chain")
	chain.appearance_flags = RESET_COLOR
	add_overlay(chain)

/obj/item/clothing/accessory/poncho/rockstone/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_wear_suit_str)
		var/image/gem = image(mob_icon, null, "rockstone_un_gem")
		gem.appearance_flags = RESET_COLOR
		gem.color = additional_color
		I.add_overlay(gem)
		var/image/chain = image(mob_icon, null, "rockstone_un_chain")
		chain.appearance_flags = RESET_COLOR
		I.add_overlay(chain)
	return I

/obj/item/clothing/accessory/poncho/rockstone/get_accessory_mob_overlay(mob/living/carbon/human/H, force)
	var/image/base = ..()
	var/image/gem = image(icon, null, "rockstone_un_gem")
	gem.appearance_flags = RESET_COLOR
	gem.color = additional_color
	base.add_overlay(gem)
	var/image/chain = image(icon, null, "rockstone_un_chain")
	chain.appearance_flags = RESET_COLOR
	base.add_overlay(chain)
	return base
