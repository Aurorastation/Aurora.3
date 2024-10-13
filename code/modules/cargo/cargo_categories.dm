/singleton/cargo_category

	/// The internal name of the category. Items belonging to the category must have their "category" name match this exactly.
	var/name = "category"

	/// The display name of this category. Displayed as the "category" on user interfaces such as the Cargo Order console.
	var/display_name = "Generic Category"

	/// The description of the category.
	var/description = "A generic category."

	/// The FontAwesome icon of this category.
	var/icon = "box"

	/// Items belonging to this category will have their prices multiplied by this factor. Default 1.
	var/price_modifier = 1

	/// AUTO-POPULATED: The list of items in this category.
	var/list/items = list()

	/// The shipment data of this category.
	var/list/shipment_data = list(
		"shipment_num" = 0,
		"shipment_cost_sell" = 0,
		"shipment_cost_purchase" = 0,
		"shipment_invoice" = "",
		"shuttle_fee" = 0,
		"shuttle_time" = 0,
		"shuttle_called_by" = "",
		"shuttle_recalled_by" = "",
		"completed" = 0
	)

/// Returns a string-formatted list of the cargo category's properties, to be used in TGUI.
/singleton/cargo_category/proc/get_list()
	var/list/data = list()
	data["name"] = src.name
	data["display_name"] = src.display_name
	data["description"] = src.description
	data["icon"] = src.icon
	data["price_modifier"] = src.price_modifier
	return data

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
