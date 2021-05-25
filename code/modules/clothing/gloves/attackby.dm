/obj/item/clothing/gloves/attackby(obj/item/W, mob/user)
	if(W.ismultitool())
		var/siemens_percentage = 100 * siemens_coefficient
		to_chat(user, SPAN_NOTICE("You probe \the [src] with \the [W]. The gloves will let [siemens_percentage]% of an electric shock through."))
		return
	return ..()