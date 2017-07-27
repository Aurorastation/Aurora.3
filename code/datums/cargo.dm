/datum/cargo_item
	var/path = null //Path of the item
	var/name = "Cargo Item" //Name of the item
	var/description = "You should not see this" //Description of the item
	var/list/categories = list() //List of categories this item appears in
	var/list/suppliers = list() //List of supliers and their prices
	var/amount = 1 //Amount of items in the crate
	var/access = null //What access requirement should be added to the container
	var/container_type = "crate" //crate or box
	var/groupable = 1 //If the item can be thrown into the same container as other items
/datum/cargo_item/proc/get_list()
	var/list/data = list()
	data["name"] = name
	data["path"] = path
	data["description"] = description
	data["categories"] = categories
	data["amount"] = amount
	data["suppliers"] = suppliers
	return data

/datum/cargo_category
	var/name = "cargo_category" //Name of the category
	var/display_name = "Cargo Category"
	var/description = "You should not see this" //Description of the Category
	var/icon = "gear" //NanoUI Icon for the category
	var/list/items = list() //List of items in the category
/datum/cargo_category/proc/get_list()
	var/list/data = list()
	data["name"] = name
	data["display_name"] = display_name
	data["description"] = description
	data["icon"] = icon
	return data
/datum/cargo_category/proc/get_item_list()
	var/list/item_list = list()
	for(var/datum/cargo_item/ci in items)
		item_list.Add(list(ci.get_list()))
	return item_list

/datum/cargo_order
	var/list/items = list() //List of cargo_order_items in the order
	var/order_id = 0 //ID of the order
	var/price = 0 //Total price of the order
	var/item_id = 1 //Current id of the item in the order
	var/status = "basket" //Status of the order: basket - Adding items, submitted - Submited to cargo, approved - Order sent to suppliers, rejected - Order has been denied, shipped - Has been shipped to the station, delivered - Order has been delivered
	var/container_type = "" //Type of the container for the order - cate, box
	var/list/required_access = list() //Access required to unlock the crate
	var/can_add_items = 1 //If new items can be added to the order 
	var/customer = "" //Person that ordered the items
	var/authorized_by = "" //Person that authorized the order
	var/received_by = "" //Person the order has been delivered to by cargo
	var/time_submited = "" //Time the order has been sent to cargo
	var/time_approved = "" //Time the order has been approved by cargo
	var/time_shipped = "" //Time the order has been shipped to the station
	var/time_delivered = "" //Time the order has been delivered
/datum/cargo_order/New()
	price = SScargo.credits_per_crate + SScargo.cargo_handlingfee //Set the base price of the order
/datum/cargo_order/proc/get_item_list()
	var/list/item_list = list()
	for (var/datum/cargo_order_item/coi in items)
		item_list.Add(list(coi.get_list()))
	return item_list
/datum/cargo_order/proc/get_list()
	var/list/data = list()
	data["order_id"] = order_id
	data["price"] = price
	data["status"] = status
	data["customer"] = customer
	data["authorized_by"] = authorized_by
	data["received_by"] = received_by
	data["time_submited"] = time_submited
	data["time_approved"] = time_approved
	data["time_shipped"] = time_shipped
	data["time_delivered"] = time_delivered
	data["items"] = get_item_list()
	return data
/datum/cargo_order/proc/add_item(var/datum/cargo_order_item/coi)
	//Check if the container type of the added item matches the one of the current order
	if(container_type == "")
		container_type = coi.ci.container_type
	else if (container_type != coi.ci.container_type)
		return 0 //You can only add items with the same container type to the order
	
	//TODO: Check if the item is not groupable --> It can only be added if there are no other items in the order and sets the order to accept no more items
	
	//Check if more items can be added to the order
	if(!can_add_items)
		return 0

	//Set item id of coi and increment item_id of co
	coi.item_id = item_id
	item_id += 1

	//Add coi to ordered item
	items.Add(coi)
	price += coi.price

	//Update the access requirement of the order
	if(coi.ci.access)
		required_access.Add(coi.ci.access)

	return 1
/datum/cargo_order/proc/remove_item(var/remove_item_id)
	//Find the item with the specified id in the items list
	for (var/datum/cargo_order_item/coi in items)
		if(coi)
			if(coi.item_id == remove_item_id)
				items.Remove(coi)
				price -= coi.price
				qdel(coi)
				return 1
	return 0
/datum/cargo_order/proc/get_value()
	return price
/datum/cargo_order/proc/get_item_count()
	return items.len
/datum/cargo_order/proc/get_container_type()
	if(container_type == "crate")
		if(required_access.len > 0)
			return /obj/structure/closet/crate/secure
		else
			return /obj/structure/closet/crate
	else if(container_type == "box")
		return /obj/structure/largecrate

/datum/cargo_order_item
	var/datum/cargo_item/ci //Item that has been ordered
	var/supplier //Supplier the item has been ordered from
	var/price //Price of the item with the given supplier
	var/item_id //Item id in the order
/datum/cargo_order_item/proc/get_list()
	var/list/data = list()
	data["name"] = ci.name
	data["supplier"] = supplier
	data["price"] = price
	data["item_id"] = item_id
	return data
/datum/cargo_order_item/Destroy()
	ci = null

/datum/cargo_shipment
	var/list/orders //List of orders in that shipment
	var/shipment_num //Number of the shipment
	var/shipment_cost_sell //The amount of money cargo got for the shipment
	var/shipment_cost_purchse //The amount of money cargo paid for the shipment
	var/shipment_invoice //The invoice for the shipment (detailing the expenses ,credits received and charges)
	var/current_shuttle_fee //The shuttle fee at the time of calling it
	var/shuttle_called_by //The person that called the shuttle
	var/shuttle_recalled_by //The person that recalled the shuttle
/datum/cargo_shipment/proc/generate_invoice()
	return shipment_invoice