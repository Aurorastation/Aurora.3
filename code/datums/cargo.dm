/*
	A item orderable via cargo
*/
/datum/cargo_item
	var/id = 0 //ID of the item
	var/name = "Cargo Item" //Name of the item
	var/supplier = "rand" //ID of the supplier
	var/datum/cargo_supplier/supplier_datum = null //Datum of the supplier
	var/description = "You should not see this" //Description of the item
	var/list/categories = list() //List of categories this item appears in
	var/price = 0 //The price of the item
	var/list/items = list()
	var/amount = 1 //Total Amount of items in the crate (including multiplier)
	var/item_mul = 1 //Multiplier of the items
	var/access = null //What access requirement should be added to the container
	var/container_type = "crate" //crate or box
	var/groupable = 1 //If the item can be thrown into the same container as other items

//Gets a list of the cargo item - To be json encoded
/datum/cargo_item/proc/get_list()
	var/list/data = list()
	data["id"] = id
	data["name"] = name
	data["description"] = description
	data["categories"] = categories
	data["price"] = price
	data["amount"] = amount
	data["items"] = items
	data["supplier"] = supplier
	data["supplier_data"] = supplier_datum.get_list()

	//Adjust the price based on the supplier adjusetment and the categories
	data["price_adjusted"] = get_adjusted_price()
	return data

/datum/cargo_item/proc/get_adjusted_price()
	var/adjusted_price = price
	price *= supplier_datum.price_modifier
	for(var/category in categories)
		var/datum/cargo_category/cc = SScargo.get_category_by_name(category)
		if(cc)
			adjusted_price *= cc.price_modifier
	return adjusted_price


/*
	A supplier of items
*/
/datum/cargo_supplier
	var/short_name = "" //Short name of the cargo supplier
	var/name = "" //Long name of the cargo supplier
	var/description = "" //Description of the supplier
	var/tag_line = "" //Tag line of the supplier
	var/shuttle_time = 0 //Time the shuttle takes to get to the supplier
	var/shuttle_price = 0 //Price to call the shuttle
	var/available = 1 //If the supplier is available
	var/price_modifier = 1 //Price modifier for the supplier
	var/list/items = list() //List of items of tha supplier

//Gets a list of supplier - to be json encoded
/datum/cargo_supplier/proc/get_list()
	var/list/data = list()
	data["short_name"] = short_name
	data["name"] = name
	data["description"] = description
	data["tag_line"] = tag_line
	data["shuttle_time"] = shuttle_time
	data["shuttle_price"] = shuttle_price
	data["available"] = available
	data["price_modifier"] = price_modifier
	return data


/*
	A category displayed in the cargo order app
*/
/datum/cargo_category
	var/name = "cargo_category" //Name of the category
	var/display_name = "Cargo Category"
	var/description = "You should not see this" //Description of the Category
	var/icon = "gear" //NanoUI Icon for the category
	var/price_modifier = 1 //Price Modifier for the category
	var/list/items = list() //List of items in the category

// Gets a list of the cargo category - to be json encoded
/datum/cargo_category/proc/get_list()
	var/list/data = list()
	data["name"] = name
	data["display_name"] = display_name
	data["description"] = description
	data["icon"] = icon
	data["price_modifier"] = price_modifier
	return data

// Gets a list of the items in the cargo category - to be json encoded
/datum/cargo_category/proc/get_item_list()
	var/list/item_list = list()
	for(var/datum/cargo_item/ci in items)
		item_list.Add(list(ci.get_list()))
	return item_list

/*
	A order placed in the cargo order app.
	Contains multiple order items
*/
/datum/cargo_order
	var/list/items = list() //List of cargo_items in the order
	var/order_id = 0 //ID of the order
	var/price = 0 //Total price of the order
	var/item_id = 1 //Current id of the item in the order
	var/item_num = 0 //Numer of items in the container - Used to limit the items in the crate
	var/status = "basket" //Status of the order: basket - Adding items, submitted - Submitted to cargo, approved - Order sent to suppliers, rejected - Order has been denied, shipped - Has been shipped to the station, delivered - Order has been delivered
	var/container_type = "" //Type of the container for the order - cate, box
	var/list/required_access = list() //Access required to unlock the crate
	var/can_add_items = 1 //If new items can be added to the order 
	var/ordered_by = null //Person that ordered the items
	var/authorized_by = null //Person that authorized the order
	var/received_by = null //Person the order has been delivered to by cargo
	var/paid_by = null //Person that has paid for the order
	var/time_submitted = null //Time the order has been sent to cargo
	var/time_approved = null //Time the order has been approved by cargo
	var/time_shipped = null //Time the order has been shipped to the station
	var/time_delivered = null //Time the order has been delivered
	var/time_paid = null //The the order has been paid
	var/tracking_code = null //Use this code with the order ID to get details about the order
	var/reason = null //Reason for the order

//Gets the tracking code for the order. Generates one if it does not exist already
/datum/cargo_order/proc/get_tracking_code()
	if(!tracking_code)
		tracking_code = rand(1000,9999)
	return tracking_code

// Returns a list of the items in the order - Formated as list to be json_encoded
/datum/cargo_order/proc/get_item_list()
	var/list/item_list = list()
	for (var/datum/cargo_order_item/coi in items)
		item_list.Add(list(coi.get_list()))
	return item_list

// Returns a list of all the objects in the order - Formated as a list to be json_encoded
/datum/cargo_order/proc/get_object_list()
	var/list/object_list = list()
	for (var/datum/cargo_order_item/coi in items)
		for(var/object in coi.ci.items)
			object_list.Add(object)
	return object_list

// Gets a list of the order data - Formated as list to be json_encoded
/datum/cargo_order/proc/get_list()
	var/list/data = list()
	data["order_id"] = order_id
	data["tracking_code"] = get_tracking_code()
	data["price"] = get_value(2)
	data["price_customer"] = get_value(0)
	data["price_cargo"] = get_value(1)
	data["status"] = get_order_status(0)
	data["status_pretty"] = get_order_status(1)
	data["status_payment"] = get_payment_status(1)
	data["ordered_by"] = ordered_by
	data["authorized_by"] = authorized_by
	data["received_by"] = received_by
	data["paid_by"] = paid_by
	data["needs_payment"] = paid_by != null ? 0:1
	data["time_submitted"] = time_submitted
	data["time_approved"] = time_approved
	data["time_shipped"] = time_shipped
	data["time_delivered"] = time_delivered
	data["time_paid"] = time_paid
	data["items"] = get_item_list()
	data["shipment_cost"] = get_shipment_cost()
	data["reason"] = reason
	return data

//Adds a item to a order. Returns a status message
/datum/cargo_order/proc/add_item(var/datum/cargo_order_item/coi)
	if(!coi)
		return "Unable to add item - Internal Error"

	//Check if the container type of the added item matches the one of the current order
	if(container_type == "")
		container_type = coi.ci.container_type
	else if (container_type != coi.ci.container_type)
		return "Unable to add item - Different container required" //You can only add items with the same container type to the order
	
	//Check if more items can be added to the order
	if(!can_add_items)
		return "Unable to add item - Order can not contain more items"

	if(!coi.ci.groupable) //The item is not groupable with other items and needs to be ordered on its own
		if(get_item_count() > 0) // There are already other items in the order. -> Reject it
			return "Unable to add item - Item can not be grouped and must be ordered separately"
		else //No item in the order. Add it and set can_add_items to 0
			can_add_items = 0

	//Check if there is space in the container
	if(item_num + coi.ci.amount > get_container_storage())
		return "Unable to add item - Container full"

	//Set item id of coi and increment item_id of co
	coi.item_id = item_id
	item_id += 1

	//Increment the item number
	item_num += coi.ci.amount

	//Add coi to ordered item
	items.Add(coi)
	price += coi.price

	//Update the access requirement of the order
	if(coi.ci.access)
		required_access.Add(coi.ci.access)

	return "Item successfully added"

//Removes a item from a order - Returns a status message
/datum/cargo_order/proc/remove_item(var/remove_item_id)
	//Find the item with the specified id in the items list
	for (var/datum/cargo_order_item/coi in items)
		if(coi)
			if(coi.item_id == remove_item_id)
				items.Remove(coi)
				price -= coi.price
				item_num -= coi.ci.amount
				qdel(coi)
				return "Item removed successfully"
	return "Unable to remove item - Internal Error 608"

// Returns the value of the order
/datum/cargo_order/proc/get_value(var/type=0) 
	//Type specifies if the price cargo has to pay or the price the customer has to be should be returned
	// 0 - Price the customer has to pay
	// 1 - Price cargo has to pay
	// 2 - Just the value of the items in the crate
	switch(type)
		if(0)
			//The price of the contents of the crate + the price for the crate + the handling fee + the shipment fee
			return price + SScargo.get_cratefee() + SScargo.get_handlingfee() + get_shipment_cost()
		if(1)
			//The price of the contents of the crate + the price of the crate + the shipment fee
			return price + SScargo.get_cratefee() + get_shipment_cost()
		if(2)
			//Just the value of the items in the crate
			return price
		else
			//As a fallback, return the value of the items
			return price

// Returns the number of items in the order
/datum/cargo_order/proc/get_item_count()
	return items.len

// Returns the type of the required container for the order
/datum/cargo_order/proc/get_container_type()
	switch(container_type)
		if(CARGO_CONTAINER_CRATE)
			if(required_access.len > 0)
				return /obj/structure/closet/crate/secure
			else
				return /obj/structure/closet/crate
		if(CARGO_CONTAINER_BOX)
			if(required_access.len > 0)
				return /obj/structure/closet/crate/secure/large
			else
				return /obj/structure/largecrate
		if(CARGO_CONTAINER_FREEZER)
			return /obj/structure/closet/crate/freezer
		else
			log_debug("Cargo: Tried to get container type for invalid container [container_type]")
			return /obj/structure/largecrate

// Returns the numer of items that can be stored in the container
/datum/cargo_order/proc/get_container_storage()
	switch(container_type)
		if(CARGO_CONTAINER_CRATE)
			return 40 //Thats the default storage capacity of a crate
		if(CARGO_CONTAINER_FREEZER)
			return 40
		if(CARGO_CONTAINER_BOX)
			return 5 //You can fit 5 larger items into a box
		else
			log_debug("Cargo: Tried to get storage size for invalid container [container_type]")
			return 0 //Something went wrong

// Gets the list of the suppliers involved in the order
/datum/cargo_order/proc/get_supplier_list()
	var/list/supplier_list = list()
	for(var/datum/cargo_order_item/coi in items)
		supplier_list[coi.ci.supplier] = coi.ci.supplier
	return supplier_list

// Gets the shipment cost for the order
/datum/cargo_order/proc/get_shipment_cost()
	var/list/supplier_list = get_supplier_list()
	var/cost = 0
	for(var/supplier in supplier_list)
		var/datum/cargo_supplier/cs = SScargo.cargo_suppliers[supplier]
		if(cs)
			cost += cs.shuttle_price
	return cost

// Gets the order status
/datum/cargo_order/proc/get_order_status(var/pretty=1)
	if(pretty)
		switch(status)
			if("submitted")
				return "Submitted to Cargo"
			if("approved")
				return "Approved"
			if("rejected")
				return "Rejected"
			if("shipped")
				return "Shipped to the Station"
			if("delivered")
				return "Delivered"
			else
				return "Unknown Status"
	else
		return status
//Returns the payment status
/datum/cargo_order/proc/get_payment_status(var/pretty=1)
	if(pretty)
		if(paid_by != null)
			return "Paid by [paid_by]"
		else
			return "Unpaid"
	else
		if(paid_by != null)
			return 1
		else
			return 0

// Returns a Invoice for the Order
/datum/cargo_order/proc/get_report_invoice()
	var/list/order_data = list()
	var/invoice_type = "Preliminary"
	if(status == "delivered" && paid_by)
		invoice_type = "Final"
	order_data += "<h4>[invoice_type] Invoice #[order_id]</h4>"
	order_data += "<hr>"
	//List the personell involved in the order
	order_data += "<u>Ordered by:</u> [ordered_by]<br>"
	order_data += "<u>Submitted at:</u> [time_submitted]<br>"
	if(authorized_by)
		order_data += "<u>Authorized by: </u> [authorized_by]<br>"
		order_data += "<u>Approved at: </u> [time_approved]<br>"
	if(time_shipped)
		order_data += "<u>Shipped at:</u> [time_shipped]<br>"
	if(received_by)
		order_data += "<u>Received by:</u [received_by]><br>"
		order_data += "<u>Delivered at:</u> [time_delivered]<br>"
	order_data += "<hr>"
	order_data += "<u>Order ID:</u> [order_id]<br>"
	order_data += "<u>Tracking Code:</u> [get_tracking_code()]<br>"
	order_data += "<u>Order Status:</u> [get_order_status(1)]<br>"
	order_data += "<u>Payment Status:</u> [get_payment_status(1)]<br>"
	if(paid_by)
		order_data += "<u>Paid at:</u> [time_paid]<br>"
	order_data += "<hr>"
	if(required_access.len)
		order_data += "<u>Required Access:</u><br>"
		order_data += "<ul>"
		for(var/A in required_access)
			order_data += "<li>[get_access_desc(A)]</li>"
		order_data += "</ul>"
		order_data += "<hr>"
	order_data += "<u>Order Fees:</u><br>"
	order_data += "<ul>"
	for(var/item in get_item_list())
		order_data += "<li>[item["name"]]: [item["price"]]</li>"
	order_data += "<li>Crate Fee: [SScargo.get_cratefee()]</li>"
	order_data += "<li>Handling Fee: [SScargo.get_handlingfee()]</li>"
	order_data += "<li>Shuttle Fee: [get_shipment_cost()]</li>"
	order_data += "</ul>"

	return order_data.Join("")

// Returns a Delivery Order for the Crate
/datum/cargo_order/proc/get_report_delivery_order()
	var/list/order_data = list()
	order_data += "<h4>Delivery Order #[order_id]</h4>"
	order_data += "<hr>"
	order_data += "<u>Submitted at:</u> [time_submitted]<br>"
	order_data += "<u>Shipped at:</u> [time_shipped]<br>"
	order_data += "<u>Contents:</u><br>"
	order_data += "<ul>"
	for(var/object in get_object_list())
		order_data += "<li>[object]</li>"
	order_data += "</ul>"
	
	return order_data.Join("")

//Marks a order as submitted
/datum/cargo_order/proc/set_submitted(var/oid)
	status = "submitted"
	time_submitted = worldtime2text()
	order_id = SScargo.get_next_order_id()
	SScargo.all_orders.Add(src)
	return 1

//Marks a order as approved - Returns a status message
/datum/cargo_order/proc/set_approved(var/approved_by)
	if(status == "submitted")
		status = "approved"
		time_approved = worldtime2text()
		authorized_by = approved_by
		return "The order has been approved"
	else
		return "The order could not be approved - Invalid Status"

//Marks a order as rejected - Returns a status message
/datum/cargo_order/proc/set_rejected()
	if(status == "submitted")
		status = "rejected"
		time_approved = worldtime2text()
		return "The order has been rejected"
	else
		return "The order could not be rejected - Invalid Status"

//Marks a order as shipped
/datum/cargo_order/proc/set_shipped()
	status = "shipped"
	time_shipped = worldtime2text()

//Marks a order as delivered - Returns a status message
/datum/cargo_order/proc/set_delivered(var/customer_name, var/paid=0)
	if(status == "shipped")
		status = "delivered"
		time_delivered = worldtime2text()
		received_by = customer_name
		if(paid)
			set_paid(customer_name)
		return "The order has been delivered"
	else
		return "The order could not be delivered - Invalid Status"

//Mark a order as paid
/datum/cargo_order/proc/set_paid(var/customer_name)
	time_paid = worldtime2text()
	paid_by = customer_name
	return "The order has been paid for"

/*
	A cargo order item. Part of a category.
	specifies the item, the supplier and the price of the item
*/
/datum/cargo_order_item
	var/datum/cargo_item/ci //Item that has been ordered
	var/price //Price of the item with the given supplier
	var/item_id //Item id in the order
	//TODO-CARGO: Maybe add the option to set a fake item for traitors here -> So that cargo cant see what they are really ordering

//Calculate Price
/datum/cargo_order_item/proc/calculate_price()
	price = ci.get_adjusted_price()
	return price

// Gets a list of the cargo order item - to be json encoded
/datum/cargo_order_item/proc/get_list()
	var/list/data = list()
	data["name"] = ci.name
	data["supplier_name"] = ci.supplier_datum.name
	data["amount"] = ci.amount
	data["price"] = price
	data["item_id"] = item_id
	return data

/datum/cargo_order_item/Destroy()
	ci = null
	return ..()


/*
	A shipment sent to the station. Contains multiple orders
*/
/datum/cargo_shipment
	var/list/orders = list() //List of orders in that shipment
	var/shipment_num //Number of the shipment
	var/shipment_cost_sell = 0 //The amount of money cargo got for the shipment
	var/shipment_cost_purchase = 0 //The amount of money cargo paid for the shipment
	var/shipment_invoice = null//The invoice for the shipment (detailing the expenses ,credits received and charges)
	var/shuttle_fee //The shuttle fee at the time of calling it
	var/shuttle_time //The time the shuttle took to get to the station
	var/shuttle_called_by //The person that called the shuttle
	var/shuttle_recalled_by //The person that recalled the shuttle
	var/completed = 0
	var/message = null //Message from central

/datum/cargo_shipment/proc/get_list(var/shipment_completion = 1)
	if(shipment_completion != completed)
		return null
	else
		var/list/data = list()
		data["shipment_num"] = shipment_num
		data["shipment_cost_sell"] = shipment_cost_sell
		data["shipment_cost_purchase"] = shipment_cost_purchase
		data["shipment_invoice"] = shipment_invoice
		data["shuttle_fee"] = shuttle_fee
		data["shuttle_time"] = shuttle_time
		data["shuttle_called_by"] = shuttle_called_by
		data["shuttle_recalled_by"] = shuttle_recalled_by
		data["invoice"] = get_invoice()
		return data

// Generates the invoice at the time of shipping
/datum/cargo_shipment/proc/generate_invoice()
	var/list/invoice_data = list()
	invoice_data += "One day <br>"
	invoice_data += "This will contain the invoice <br>"
	invoice_data += "Right now its just a placeholder <br>"
	invoice_data += "Shipment num: [shipment_num]<br>"
	invoice_data += "shipment cost sell: [shipment_cost_sell]<br>"
	invoice_data += "shipment cost purchse: [shipment_cost_purchase]<br>"
	invoice_data += "shuttle fee: [shuttle_fee]<br>"
	invoice_data += "shuttle time: [shuttle_time]<br>"
	invoice_data += "shuttle called by: [shuttle_called_by]<br>"
	invoice_data += "shuttle recalled by: [shuttle_recalled_by]<br>"
	invoice_data += "centcom message:<br>[nl2br(message)]"

	shipment_invoice = invoice_data.Join("")
	completed = 1
	return shipment_invoice

// Returns the invoice. Generates it if it does not exist
/datum/cargo_shipment/proc/get_invoice()
	if(!shipment_invoice)
		if(completed == 1)
			generate_invoice()
		else
			return "Invoice Unavailable. Shipment not completed."
	return shipment_invoice