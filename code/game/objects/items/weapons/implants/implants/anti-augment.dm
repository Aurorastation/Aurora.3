/obj/item/implant/anti_augment
	name = "augmentation disrupter implant"
	desc = "An implant that emits signals able to disrupt the use of commonly used augments."
	icon_state = "implant_excel" //Temporary
	implant_icon = "excel" //Ditto
	implant_color = "#ffd079" //Ditto
	default_action_type = null
	known = TRUE

/obj/item/implant/anti_augment/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Hephaestus Industries HP-152 Augmentation Disrupter Implant<BR>
<b>Life:</b> Three Months.<BR>
<b>Important Notes:</b> Emits a signal able to block most augments from functioning.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Emits a short radio wave that will block most augments.<BR>
<b>Special Features:</b> Will stop the host from using any augment they might have.<BR>
<b>Integrity:</b> Implant will last so long as it inside the host."}

/obj/item/implant/anti_augment/isLegal()
	return TRUE

/obj/item/implant/anti_augment/emp_act(severity)
	switch(severity)
		if(1.0)
			if (prob(75))
				qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(25))
				qdel(src)
	return

/obj/item/implantcase/anti_augment
	name = "glass case - 'augmentation disrupter'"
	imp = /obj/item/implant/anti_augment

/obj/item/implanter/anti_augment
	name = "implanter-augmentation disrupter"
	imp = /obj/item/implant/anti_augment
