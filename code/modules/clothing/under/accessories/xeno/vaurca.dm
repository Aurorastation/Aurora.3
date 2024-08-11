/obj/item/clothing/accessory/poncho/vaurca
	name = "vaurcan mantle"
	desc = "This mantle is commonly worn in dusty underground areas, its wide upper covering acting as a kind of dust umbrella."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "vacmantle"
	item_state = "vacmantle"
	contained_sprite = TRUE
	icon_override = null
	body_parts_covered = UPPER_TORSO
	build_from_parts = TRUE
	has_accents = TRUE

/obj/item/clothing/accessory/vaurca_breeder
	name = "vaurca breeder parent accessory"
	desc = "You shouldn't be seeing this."
	icon = 'icons/mob/species/breeder/accessories.dmi'
	icon_override = null
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_VAURCA_BREEDER)

/obj/item/clothing/accessory/vaurca_breeder/rockstone_cape
	name = "k'lax rockstone cape"
	desc = "A cape seen exclusively on nobility. The chain is adorned with precious, multi-color stones, hence its name. This one is fitted to a K'lax Vaurca Gyne's arm."
	desc_extended = "A simple drape over the shoulder is done easily; the distinguishing part between the commoners and \
	nobility is the sheer elegance of the rockstone cape. Vibrant stones adorn the heavy collar, and the cape itself \
	is embroidered with gold."
	icon_state = "gynerockstone"
	item_state = "gynerockstone"
	build_from_parts = TRUE
	worn_overlay =  "chain"
	has_accents = TRUE

/obj/item/clothing/accessory/vaurca_breeder/star_cape
	name = "c'thur star cape"
	desc = "A decorated cape. Starry patterns have been woven into the fabric. This one is fitted to a C'thur Vaurca Gyne's arm."
	icon_state = "gynestarcape"
	item_state = "gynestarcape"

/obj/item/clothing/accessory/vaurca_breeder/cthur_llc_cape
	name = "c'thur llc cape"
	desc = "A cape fitted to a C'thur Vaurca Gyne's arm. This one contains the logo of C'thur, LLC."
	desc_extended = "C'thur, LLC, officially The C'thuric Hive Holdings, LLC, is an Eridanian company headquartered in Sector V, Kianda. \
	It is noted for its long-term labor agreements with megacorporations and its proprietary scientific developments. C'thur, LLC is majorly owned by \
	High Queen C'thur and operates in a similar structure as the Hive itself. While distinctions between the C'thur Hive and the company are legally upheld within \
	the Nralakk Federation, this separation becomes less clear in human space. Lesser queens hold membership within the company, granting them ownership rights and a \
	stake in its profits."
	icon_state = "cthurllc"
	item_state = "cthurllc"
