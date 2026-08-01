/// Registers name and prices for the commissary from a paper.
/// First line is ignored, acting as header for name/pricing, mainly for readability.
/// The second line and after are read as the name of the thing and the price of the thing.
/// Example below
/// name,price
/// Candy,2.50
/// Snack,3.10
/// Meal,10.00
/// The above would add 3 items, the candy, snack and meal, with their respective prices.
/// It returns a list containing name and prices
/proc/read_paper_price_list(var/obj/item/paper/R)
	var/text = R.info

	// Split on line breaks
	var/list/lines = splittext(text, "<BR>")
	var/list/result = list()

	// Skip header line
	for(var/i = 2; i <= lines.len; i++)
		var/line = trim(lines[i])
		if(!length(line))
			continue

		var/list/split_input = splittext(line, ";")

		// category;name;price
		if(length(split_input) >= 3)
			var/category = trim(split_input[1])
			var/name = trim(split_input[2])
			var/price_text = trim(split_input[3])

			if(!length(category))
				category = "Uncategorized"
			if(!length(name))
				continue

			var/price = text2num(price_text)

			// Reject null prices
			if(isnull(price))
				continue

			// Reject invalid prices
			if(price == 0 && price_text != "0" && price_text != "0.0" && price_text != "0.00")
				continue

			result += list(list(
				"name" = name,
				"price" = price,
				"category" = category
			))
			continue

		// name;price
		if(length(split_input) >= 2)
			var/name = trim(split_input[1])
			var/price_text = trim(split_input[2])

			if(!length(name))
				continue

			var/price = text2num(price_text)

			// Reject null prices
			if(isnull(price))
				continue

			// Reject invalid prices
			if(price == 0 && price_text != "0" && price_text != "0.0" && price_text != "0.00" && price != null)
				continue

			result += list(list(
				"name" = name,
				"price" = price,
				"category" = "Uncategorized"
			))

	return result


// Prints the prices from a register/quikpay into a list that can be used for read_paper_price_list()
/proc/print_price_to_paper(var/shop_name, var/list/items, var/paper_loc, mob/user)
	if(!items || !items.len)
		return FALSE

	var/obj/item/paper/notepad/receipt/R = new(paper_loc)
	var/title = "Price List: [shop_name]"
	var/text = "category;name;price<BR>"

	for(var/list/L in items)
		var/item_category = sanitize_tg(L["category"])
		var/item_name = sanitize_tg(L["name"])
		var/item_price = L["price"]

		if(!length(item_category))
			item_category = "Uncategorized"

		text += "[item_category];[item_name];[round(item_price, 0.01)]<BR>"

	R.set_content(title, text)

	user.put_in_any_hand_if_possible(R)
	R.ripped = TRUE
	return TRUE
