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
	protects_against_weather = TRUE

/obj/item/clothing/accessory/sinta_hood/get_ear_examine_text(var/mob/user, var/ear_text = "left")
	return "on [user.get_pronoun("his")] head"

/obj/item/clothing/accessory/sinta_hood/attack_self()
	toggle()

/obj/item/clothing/accessory/sinta_hood/verb/toggle()
	set category = "Object.Equipped"
	set name = "Toggle Hood"
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
	protects_against_weather = FALSE

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

/obj/item/clothing/accessory/poncho/unathimantle/jungle
	name = "jungle hide mantle"
	desc = "A mantle made to mimic the original Moghesian ones with the resources found on Ouerea, which can be seen \
	on the backs of both the destitute and the more powerful Sinta. Made from awth'una hide, its bright colors made it quite \
	fashionable, and some have even been exported to Unathi abroad."
	desc_extended = "The jungle mantle was originally made to replace the traditional mantles of Moghes a few years after the first Unathi \
	colonists landed on Ouerea, a way for them to preserve their tradition and fashion, and to stand out from those on the home world. These \
	mantles are made from awth'una hide, the largest one requiring the hide of multiple ones to be made, proving to be surprisingly light yet tough. \
	The jungle mantle is more of a fashion statement than a sign of status, and thus, Unathi from various backgrounds can be seen wearing it. \
	The bright green colors of the awth'una have made these mantles quite popular among Sinta abroad, and though they are still a very rare sight \
	on Moghes, Sinta from across the Spur have imported some of these mantles, namely on Mictlan."
	worn_overlay = "jungle"

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
	desc_extended = "The Merchants' Guild was one of the largest guilds in the Hegemony, until the phoron scarcity brought about an economic depression in Izweski space, leading to the guild's \
	bankruptcy and dissolution. Now, these mantles are seen rarely, usually kept by former members who continue to try and work as merchants."
	worn_overlay = "merchantsguild"

/obj/item/clothing/accessory/poncho/unathimantle/miner
	name = "miners' guild mantle"
	desc = "The cured hide and skin of a large beast, dyed in the burnt orange of the Miners' Guild. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "The Miners' Guild is a powerful one still, though the expansion of Hephaestus mining operations into the Hegemony broke up its monopoly. While the two competed for a time, \
	Hephaestus finally won, absorbing the Miners' Guild alongside several others as a subsidiary corporation."
	worn_overlay = "minersguild"

/obj/item/clothing/accessory/poncho/unathimantle/junzi
	name = "junzi electric guild mantle"
	desc = "The cured hide and skin of a large beast, dyed in the electric blue of the Junzi Electric Guild. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "For centuries, Junzi Electric has been responsible for the Hegemony's power industry. It is the oldest guild in existence within the Hegemony, with origins dating back \
	to the Unathi discovery of electricity. In the modern age, a vast majority of the Hegemony's power generation is still maintained by guildsmen of Junzi Electric. In 2465, Junzi Electric \
	grew close to bankruptcy, and was bought out by Hephaestus Industries, continuing to operate as a subsidiary of the human megacorporation."
	worn_overlay = "junzielectric"

/obj/item/clothing/accessory/poncho/unathimantle/bard
	name = "bards' guild mantle"
	desc = "The cured hide and skin of a large beast, dyed in the vibrant green of the Bards' Guild, also known as the Keepers of Heirlooms. \
	These mantles are reserved for full-fledged guildsmen as a sign of their position in the guild."
	desc_extended = "The Keepers of Heirlooms operate a majority of the Hegemony's entertainment industry - nearly all news, television and film across the Hegemony can be traced back \
	to this ancient and illustrious guild. Outside of the Hegemony, they are mainly known for their operation of Sinta Articles, the largest news outlet of the Hegemony. The Keepers of Heirlooms \
	were one of many guilds transformed into Hephaestus subsidiaries in 2465, though their operations have largely continued unchanged, with the megacorporation content to leave the Bards alone save for \
	Sinta Articles, which now prints exactly what Hephaestus wants it to."
	worn_overlay = "bardsguild"

/obj/item/clothing/accessory/poncho/unathimantle/med
	name = "house of medicine mantle"
	desc = "The cured hide and skin of a large beast, dyed in the clean white of the House of Medicine. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "The House of Medicine oversees the Skalamar University of Medicine, one of the oldest educational institutions on Moghes. To be a guildsman of the House is equivalent \
	to a medical doctorate within human nations. In recent years, the House has come into conflict with the K'lax Hive, as their gene-clinics pose a threat to the guild's monopoly over \
	the medical industry. This guild was bought out by Hephaestus in 2465, and now provides Hephaestus employees with medical care, as well as continuing to operate most of the Hegemony's medical \
	industry."
	worn_overlay = "houseofmedicine"

/obj/item/clothing/accessory/poncho/unathimantle/construction
	name = "construction coalition mantle"
	desc = "The cured hide and skin of a large beast, dyed in the warm yellow of the Construction Coalition. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "The Construction Coalition is a unique guild, operating far more democratically than others. It originated as a loose federation of local construction guilds, and \
	this new and unique model was only recently approved by Hegemon Not'zar. Many of the castles of the nobility and the great cities of Moghes were constructed and are still maintained by \
	guildsmen of the Coalition's constituents. In 2465, the bankruptcy of the Construction Coalition led to their acquisition as a subsidiary of Hephaestus Industries."
	worn_overlay = "constructioncoalition"

/obj/item/clothing/accessory/poncho/unathimantle/union
	name = "hearts of industry mantle"
	desc = "The cured hide and skin of a large beast, dyed in the tan colors of the Hearts of Industry. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "A new movement, and one rapidly gaining influence in the Southlands of Moghes, the Hearts of Industry resemble a workers' union more than a traditional guild. \
	Their membership has grown in the factories and docks of Jaz'zirt, and they have often clashed with the local nobility on matters of workers' rights. While membership in the Hearts \
	is not illegal, the organisation's growing power threatens the status quo, and their meetings have often been brutally struck down by Overlord Miazso. Following the Ouerean riots of \
	2465, and the mass expansion of Hephaestus Industries, the Hearts of Industry have been suppressed, and have lost a great deal of the power they were beginning to grasp. While membership is not \
	illegal, it is prohibited by Hephaestus regulations, and open members of the Hearts cannot find employment with the megacorporation - which now disqualifies them from almost every guild in the Hegemony."
	worn_overlay = "heartofindustry"

/obj/item/clothing/accessory/poncho/unathimantle/fighter
	name = "fighters' lodge mantle"
	desc = "The cured hide and skin of a large beast, dyed in the blood red of the Fighters' Lodge. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "The Fighters' Lodge was created in the years following the Contact War, inspired by human private military contractors. As such, it has an unusual structure for an Unathi guild, \
	resembling a human corporation more than the traditional guilds of Moghes. The Fighters' Lodge mainly takes jobs as security for merchants, with their charter preventing them from \
	taking sides in the power struggles of the nobility. Following the recession of 2465, the Lodge became a Hephaestus subsidiary corporation, and now largely provides security to the corporation's operations in the Hegemony and beyond."
	worn_overlay = "fighterslodge"

/obj/item/clothing/accessory/poncho/unathimantle/fisher
	name = "fishing league mantle"
	desc = "The cured hide and skin of a large beast, dyed in the grey-brown of the Fishing League. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "Once the largest guild within the Hegemony, the Fishing League is a behemoth of food production, churning out tons of foodstuffs a day. While local \
	villages and nobles have their own food production centers, mainly aquaculture farms which run outside of the aegis of the Fishing League, the vast majority of food produced within the Hegemony \
	was produced by the Fishing League, whether it be on Ouerea or Moghes. Following Hephaestus's acquisition of the guild as a subsidiary, the guildsmen and facilities of the Fishing League have played a major role in the \
	megacorporation's aquacultural expansions on Ouerea - bringing an end to the famine, though some say at the price of the guild's soul."
	worn_overlay = "fishingleague"

/obj/item/clothing/accessory/poncho/unathimantle/tretian
	name = "tretian guild mantle"
	desc = "The cured hide and skin of a large beast, dyed in the acidic yellow of the Tretian Guild. These mantles are reserved for full-fledged guildsmen, as a sign of \
	their position in the guild."
	desc_extended = "The Tretian Guild is the only Unathi guild with a K'lax majority. \
	Established in Tret, the guild specializes in operating and maintaining the large-scale manufacturing operations of the factory-planet. \
	In a controversial move, the Tretian Guild expanded its operations beyond Tret in mid-2466, acting as strikebreakers and supplemental workers \
	for operations where workers of other guilds may be unwilling or unable to fulfill their duties."
	worn_overlay = "tretianguild"
	sprite_sheets = list(
		BODYTYPE_VAURCA = 'icons/mob/species/vaurca/suit.dmi',
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/suit.dmi'
	)

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
	build_from_parts = TRUE
	worn_overlay =  "chain"
	has_accents = TRUE
	protects_against_weather = FALSE

/obj/item/clothing/accessory/poncho/scaleshield
	name = "scaleshield"
	desc = "A reinforced canvas and fabric made by Dominian Unathi, for Dominian Unathi, to face the cold weather of Moroz and look good doing it."
	desc_extended = "A thick, warm piece of reinforced canvas and fabric made by Dominian Unathi to keep themselves warm in Moroz's \
	frigid climate. Nowadays, its also become a fashion statement for those that wear it."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "scaleshield"
	item_state = "scaleshield"
	icon_override = null
	contained_sprite = TRUE
	build_from_parts = TRUE
	worn_overlay = "scaleshield"

/obj/item/clothing/accessory/poncho/scaleshield/LSscaleshield
	name = "Landsite Scaleshield"
	desc = "A reinforced canvas and fabric made by Dominian Unathi, for Dominian Unathi, to face the cold weather of Moroz and look good doing it."
	desc_extended = "A thick, warm piece of reinforced canvas and fabric made by Dominian Unathi to keep themselves warm in Moroz's \
	frigid climate. This one bears a pattern commonly seen in the New Hope Unathi District, also known as Landsite."
	icon = 'icons/obj/unathi_items.dmi'
	worn_overlay = "LSscaleshield"

/obj/item/clothing/accessory/poncho/scaleshield/ATscaleshield
	name = "Anvil Towers Scaleshield"
	desc = "A reinforced canvas and fabric made by Dominian Unathi, for Dominian Unathi, to face the cold weather of Moroz and look good doing it."
	desc_extended = "A thick, warm piece of reinforced canvas and fabric made by Dominian Unathi to keep themselves warm in Moroz's \
	frigid climate. This one bears a pattern commonly seen in the Anvil Unathi District, also known as Anvil Towers."
	icon = 'icons/obj/unathi_items.dmi'
	worn_overlay = "ATscaleshield"

/obj/item/clothing/accessory/poncho/scaleshield/WTscaleshield
	name = "Widowtown Scaleshield"
	desc = "A reinforced canvas and fabric made by Dominian Unathi, for Dominian Unathi, to face the cold weather of Moroz and look good doing it."
	desc_extended = "A thick, warm piece of reinforced canvas and fabric made by Dominian Unathi to keep themselves warm in Moroz's \
	frigid climate. This one bears a pattern commonly seen in Hunter’s District, also known as Widowtown."
	icon = 'icons/obj/unathi_items.dmi'
	worn_overlay = "WTscaleshield"
