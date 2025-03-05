/obj/item/clothing/shoes/sandals
	desc = "A pair of rather plain wooden sandals."
	name = "sandals"
	icon = 'icons/obj/item/clothing/shoes/sandals.dmi'
	icon_state = "sandals"
	item_state = "sandals"
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)
	body_parts_covered = FALSE
	contained_sprite = TRUE
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")

/obj/item/clothing/shoes/sandals/geta
	name = "geta"
	desc = "A pair of rather plain Konyang-styled wooden sandals."
	icon_state = "geta"
	item_state = "geta"

/obj/item/clothing/shoes/sandals/flipflop
	name = "flip flops"
	desc = "A pair of foam flip flops. For those not afraid to show a little ankle."
	icon_state = "thongsandal"
	item_state = "thongsandal"

/obj/item/clothing/shoes/sandals/clogs
	name = "rubber clogs"
	desc = "A favorite of barbecue loving fathers, beachgoers, and people with no fashion sense. Don't wear these with socks."
	icon_state = "clogs"
	item_state = "clogs"

/obj/item/clothing/shoes/sandals/caligae
	name = "caligae"
	desc = "The standard Unathi marching footwear. Made of leather and rubber, with heavy hob-nailed soles, their unique design allows for improved traction and protection, leading to them catching on with other species."
	desc_extended = "These traditional Unathi footwear have remained relatively unchanged in principle,\
	with improved materials and construction being the only notable change.\
	Some are worn with socks, for warmth.\
	This pair is reinforced with leather of the Zazehal, a Moghesian species of eel that can grow up to twenty five feet long.\
	Typically, Zazehal Festivals are thrown every month of the warm season in which Unathi strew freshly killed birds across the shoreline and collect these creatures with baskets.\
	The fungi that grow on their skin is harvested and used as an exotic seasoning,\
	and their skin is used for its incredibly durable, shark-like leather.\
	Originally used for warriors, they became widespread for their comfort and durability.\
	Although made for the Unathi anatomy, they have picked up popularity among other species."
	icon_state = "caligae"
	item_state = "caligae"
	force = 11
	armor = list(
			MELEE = ARMOR_MELEE_KNIVES
			)
	siemens_coefficient = 0.75
	body_parts_covered = FEET|LEGS
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)
	icon_supported_species_tags = list("taj", "una")
	color = COLOR_CHESTNUT

/obj/item/clothing/shoes/sandals/caligae/socks
	has_accents = TRUE
	accent_color  = COLOR_GRAY20
