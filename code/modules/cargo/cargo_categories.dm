/singleton/cargo_category
	var/name = "category"
	var/display_name = "Generic Category"
	var/description = "A generic category."
	var/icon = "box" //tgui icon to use for category
	var/price_modifier = 1
	var/list/items = list()  // This should already be the default.

/singleton/cargo_category/security
	name = "security"
	display_name = "Security"
	description = "Weaponry, tools, and supplies for the Security department."
	icon = "shield"
	price_modifier = 1

/singleton/cargo_category/engineering
	name = "engineering"
	display_name = "Engineering"
	description = "Tools, machinery, and supplies for the Engineering department."
	icon = "wrench"
	price_modifier = 1

/singleton/cargo_category/hospitality
	name = "hospitality"
	display_name = "Hospitality"
	description = "Food, beverage, and supplies for hospitality establishments like the bar or kitchen."
	icon = "utensils"
	price_modifier = 1

/singleton/cargo_category/medical
	name = "medical"
	display_name = "Medical"
	description = "Medicine, chemicals, and supplies for the Medical department."
	icon = "heart"
	price_modifier = 1

/singleton/cargo_category/hydroponics
	name = "hydroponics"
	display_name = "Hydroponics"
	description = "Seeds, fertilizers, and supplies for the hydroponics bay."
	icon = "leaf"
	price_modifier = 1

/singleton/cargo_category/operations
	name = "operations"
	display_name = "Operations"
	description = "Maintenance and utility items for ship operations."
	icon = "clipboard"
	price_modifier = 1

/singleton/cargo_category/science
	name = "science"
	display_name = "Science"
	description = "Experimental tools, trinkets, and supplies for the Science department."
	icon = "atom"
	price_modifier = 1

/singleton/cargo_category/supply
	name = "supply"
	display_name = "Supply"
	description = "Supplies, supplies, and supplies for the Supply department."
	icon = "box"
	price_modifier = 1

/singleton/cargo_category/miscellaneous
	name = "miscellaneous"
	display_name = "Misc"
	description = "Other stuff."
	icon = "cube"
