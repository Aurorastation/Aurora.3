//Health Tracker Implant
/obj/item/implant/health
	name = "health implant"
	icon_state = "implant_health"
	implant_icon = "deathalarm" //This is intentionally the same as the death alarm
	implant_color = "#9cdb43" //This is intentionally the same as the death alarm
	var/healthstring = ""

/obj/item/implant/health/proc/sensehealth()
	if(!implanted)
		return "ERROR"
	else
		if(isliving(implanted))
			var/mob/living/L = implanted
			healthstring = "[round(L.getOxyLoss())] - [round(L.getFireLoss())] - [round(L.getToxLoss())] - [round(L.getBruteLoss())]"
		if(!healthstring)
			healthstring = "ERROR"
		return healthstring

/obj/item/implantcase/health
	name = "glass case - 'health'"
	imp = /obj/item/implant/health
