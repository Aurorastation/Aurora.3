// Cloaks
/obj/item/clothing/accessory/poncho/shouldercape/cloak
	name = "Ox cloak"
	desc = "A plain cloak that denotes the wearer as being an Ox-class worker."
	desc_fluff = "The Jargon Federation ranks its workers based on their social credit score, and provides workwear based on said score: Ox are those who are within the Tertiary Numerical band, and are provided with the bare essentials for adequate clothes. Tertiary Numericals are typically criminals, or Skrell who otherwise do not conform to the standards of Jargon Society."
	icon = 'icons/obj/contained_items/skrell/nralakk_cloaks.dmi'
	icon_override = 'icons/obj/contained_items/skrell/nralakk_cloaks.dmi'
	item_state = "ox_cloak"
	icon_state = "cloak_item"
	flippable = FALSE
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/shouldercape/cloak/ix
	name = "Ix cloak"
	desc = "An average cloak that denotes the wearer as being an Ix-class worker."
	desc_fluff = "The Jargon Federation ranks its workers based on their social credit score, and provides workwear based on said score: Ix are those who are low-scoring Secondary Numericals with their clothes typically being plain, yet still considered pleasant to wear and be seen in. Secondary Numericals are the majority population in the Jargon Federation, with Ix being those who are in the lower end of the band. "
	item_state = "ix_cloak"

/obj/item/clothing/accessory/poncho/shouldercape/cloak/oqi
	name = "Oqi cloak"
	desc = "A fashionable cloak that denotes the wearer as being an Oqi-class worker."
	desc_fluff = "The Jargon Federation ranks its workers based on their social credit score, and provides workwear based on said score: Oqi are high-scoring Secondary Numericals or low-scoring Primary Numericals, with their workwear generally having more accessories that help them work in their specific industry. Skrell who are Oqi are typically more fashion-conscious, making it not uncommon to see these uniforms altered slightly to account for the latest fashion trends in the Jargon Federation."
	item_state = "oqi_cloak"

/obj/item/clothing/accessory/poncho/shouldercape/cloak/iqi
	name = "Iqi cloak"
	desc = "A very fashionable cloak that denotes the wearer as being an Iqi-class worker."
	desc_fluff = "The Jargon Federation ranks its workers based on their social credit score, and provides workwear based on said score: Iqi are high-scoring Primary Numericals, and as such their workwear is of the highest quality afforded by the Federation. These clothes are typically made of sturdier materials and are more comfortable to wear. Primary Numericals are typically seen as the trend-setters in Federation society, and Skrell who are ranked at Iqi are known to influence fashion through how they accessorise."
	item_state = "iqi_cloak"

// Ponchos
/obj/item/clothing/accessory/poncho/skrell
	name = "white skrell poncho"
	desc = "This cover is a design of the Jargon Federation. It is meant to keep moisture in and stop a Skrell's skin from baking in the hot sun. C'thur and Diona may also wear it as a fashion statement."
	icon = 'icons/obj/contained_items/skrell/skrell_ponchos.dmi'
	icon_state = "skr_poncho"
	item_state = "skr_poncho"
	overlay_state = "skr_poncho"
	contained_sprite = TRUE
	icon_override = null

/obj/item/clothing/accessory/poncho/skrell/gray
	name = "gray skrell poncho"
	icon_state = "skr_poncho_gry"
	item_state = "skr_poncho_gry"
	overlay_state = "skr_poncho_gry"

/obj/item/clothing/accessory/poncho/skrell/tan
	name = "tan skrell poncho"
	icon_state = "skr_poncho_tan"
	item_state = "skr_poncho_tan"
	overlay_state = "skr_poncho_tan"

/obj/item/clothing/accessory/poncho/skrell/brown
	name = "brown skrell poncho"
	icon_state = "skr_poncho_brn"
	item_state = "skr_poncho_brn"
	overlay_state = "skr_poncho_brn"

//Capes
/obj/item/clothing/accessory/poncho/shouldercape/nationcapes
	name = "\improper Jargon cape"
	desc = "A cape that has the Jargon flag on the back."
	desc_fluff = "A relatively new addition to Skrell fashion, these cloaks are meant to identify the origin of the wearer. Since first contact, it has been a popular way for Skrell to distinguish themselves from Skrell from other regions of the Orion Spur, and has become a popular way to denote political ties or support. This cape signifies that the wearer comes from the Jargon Federation - specifically, the inner systems."
	icon = 'icons/obj/contained_items/skrell/nationcapes.dmi'
	icon_override = 'icons/obj/contained_items/skrell/nationcapes.dmi'
	item_state = "jargcape"
	icon_state = "jargcape"
	flippable = TRUE
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/shouldercape/nationcapes/traverse
	name = "\improper Traverse cape"
	desc = "A cape that has the Free Traverse flag on the back."
	desc_fluff = "A relatively new addition to Skrell fashion, these cloaks are meant to identify the origin of the wearer. Since first contact, it has been a popular way for Skrell to distinguish themselves from Skrell from other regions of the Orion Spur, and has become a popular way to denote political ties or support. This cape signifies that the wearer comes from the Jargon Federation - specifically, the Traverse. As the Free Traverse Flag is linked to the lyukal and general Traverse independence movements, it is not recommended to wear this flag openly in Federation space."
	item_state = "travcape"
	icon_state = "travcape"

/obj/item/clothing/accessory/poncho/shouldercape/nationcapes/sol
	name = "\improper Sol cape"
	desc = "A cape that has the Solarian Alliance flag on the back."
	desc_fluff = "A relatively new addition to Skrell fashion, these cloaks are meant to identify the origin of the wearer. Since first contact, it has been a popular way for Skrell to distinguish themselves from Skrell from other regions of the Orion Spur, and has become a popular way to denote political ties or support. This cape signifies that the wearer comes from the Sol Alliance. Unlike similar capes, it is generally acceptable to Fed-aligned Skrell to wear this due to the Sol Alliance's relationship with the Federation."
	item_state = "solcape"
	icon_state = "solcape"

/obj/item/clothing/accessory/poncho/shouldercape/nationcapes/coc
	name = "\improper CoC cape"
	desc = "A cape that has the Coalition of Colonies flag on the back."
	desc_fluff = "A relatively new addition to Skrell fashion, these cloaks are meant to identify the origin of the wearer. Since first contact, it has been a popular way for Skrell to distinguish themselves from Skrell from other regions of the Orion Spur, and has become a popular way to denote political ties or support. This cape signifies that the wearer comes from the Coalition of Colonies. Due to the poor relationship between the Coalition of Colonies and the Jargon Federation, Fed-aligned Skrell do not approve of this cape."
	item_state = "coccape"
	icon_state = "coccape"

/obj/item/clothing/accessory/poncho/shouldercape/nationcapes/biesel
	name = "\improper Biesel cape"
	desc = "A cape that has the Republic of Biesel flag on the back."
	desc_fluff = "A relatively new addition to Skrell fashion, these cloaks are meant to identify the origin of the wearer. Since first contact, it has been a popular way for Skrell to distinguish themselves from Skrell from other regions of the Orion Spur, and has become a popular way to denote political ties or support. This cape signifies that the wearer comes from the Republic of Biesel. Due to the mix of both pro-Fed and anti-Fed Skrell in the Republic, this cape usually does not warrant strong emotions until the wearer's political leanings are known."
	item_state = "biescape"
	icon_state = "biescape"
