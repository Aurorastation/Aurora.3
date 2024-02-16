/obj/item/clothing/gloves/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.ismultitool())
		var/siemens_percentage = 100 * siemens_coefficient
		to_chat(user, SPAN_NOTICE("You probe \the [src] with \the [attacking_item]. The gloves will let [siemens_percentage]% of an electric shock through."))
		return
	return ..()
