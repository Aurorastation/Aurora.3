// GALATEAN BIOAUGMENTATIONS
// the weird, uncomfortable places where meat meets metal

/obj/item/implant/export_lasgun
	name = "bioelectrical conduit"
	desc = "A Galatean bioaugmentation that channels the innate bioelectricity of the human nervous system. Use of this augment against the terms of its packaging are a violation of Galatean law."
	icon_state = "implant_excel"
	implant_icon = "excel"
	implant_color = "#ffd079"
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ILLEGAL = 3)
	default_action_type = null
	known = TRUE

/obj/item/implant/export_lasgun/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Planetary Weapons Development Bureau Bioelectricity Conduit, Export-Model <BR>
<b>Life:</b> Six years.<BR>
<b>Important Notes:</b> Personnel injected with this device can operate certain approved models of laser weapon without side effects..<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Conducts the body's electricity into usable forms of electricity for Galatean export-model weaponry.<BR>
<b>Integrity:</b> Implant will last for a period of six standard years, after which it will degrade and require removal."}

/obj/item/implant/export_lasgun/implanted(mob/M)
	to_chat(M, SPAN_GOOD("Static dances across your skin."))
	if(ishuman(M))
		return TRUE

/obj/item/implantcase/export_lasgun
	name = "glass case - 'bioconduit'"
	imp = /obj/item/implant/export_lasgun

/obj/item/implanter/export_lasgun
	name = "implanter-bioconductor"
	imp = /obj/item/implant/export_lasgun
