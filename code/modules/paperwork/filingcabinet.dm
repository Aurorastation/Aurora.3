/* Filing cabinets!
 * Contains:
 *		Filing Cabinets
 *		Security Record Cabinets
 *		Medical Record Cabinets
 */


/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "filing cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "filingcabinet"
	density = 1
	anchored = 1


/obj/structure/filingcabinet/chestdrawer
	name = "chest drawer"
	icon_state = "chestdrawer"


/obj/structure/filingcabinet/filingcabinet	//not changing the path to avoid unecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"


/obj/structure/filingcabinet/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/paper) || istype(I, /obj/item/folder) || istype(I, /obj/item/photo) || istype(I, /obj/item/paper_bundle))
			I.forceMove(src)


/obj/structure/filingcabinet/attackby(obj/item/P as obj, mob/user as mob)
	if(istype(P, /obj/item/paper) || istype(P, /obj/item/folder) || istype(P, /obj/item/photo) || istype(P, /obj/item/paper_bundle))
		to_chat(user, "<span class='notice'>You put [P] in [src].</span>")
		user.drop_from_inventory(P,src)
		flick("[initial(icon_state)]-open",src)
		playsound(loc, 'sound/bureaucracy/filingcabinet.ogg', 50, 1)
		sleep(40)
		icon_state = initial(icon_state)
		updateUsrDialog()
	else if(P.iswrench())
		playsound(loc, P.usesound, 50, 1)
		anchored = !anchored
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
	else
		to_chat(user, "<span class='notice'>You can't put [P] in [src]!</span>")


/obj/structure/filingcabinet/attack_hand(mob/user as mob)
	if(contents.len <= 0)
		to_chat(user, "<span class='notice'>\The [src] is empty.</span>")
		return

	user.set_machine(src)
	var/dat = "<center><table>"
	for(var/obj/item/P in src)
		dat += "<tr><td><a href='?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
	dat += "</table></center>"
	user << browse("<html><head><title>[name]</title></head><body>[dat]</body></html>", "window=filingcabinet;size=350x300")

	return

/obj/structure/filingcabinet/attack_tk(mob/user)
	if(anchored)
		attack_self_tk(user)
	else
		..()

/obj/structure/filingcabinet/attack_self_tk(mob/user)
	if(contents.len)
		if(prob(40 + contents.len * 5))
			var/obj/item/I = pick(contents)
			I.forceMove(loc)
			if(prob(25))
				step_rand(I)
			to_chat(user, "<span class='notice'>You pull \a [I] out of [src] at random.</span>")
			return
	to_chat(user, "<span class='notice'>You find nothing in [src].</span>")

/obj/structure/filingcabinet/Topic(href, href_list)
	if(href_list["retrieve"])
		usr << browse("", "window=filingcabinet") // Close the menu)

		//var/retrieveindex = text2num(href_list["retrieve"])
		var/obj/item/P = locate(href_list["retrieve"])//contents[retrieveindex]
		if(istype(P) && (P.loc == src) && src.Adjacent(usr))
			usr.put_in_hands(P)
			updateUsrDialog()
			flick("[initial(icon_state)]-open",src)
			playsound(loc, 'sound/bureaucracy/filingcabinet.ogg', 50, 1)
			spawn(0)
				sleep(20)
				icon_state = initial(icon_state)


/*
 * Security Record Cabinets
 */
/obj/structure/filingcabinet/security
	var/virgin = 1


/obj/structure/filingcabinet/security/proc/populate()
	if(virgin)
		for(var/datum/record/general/R in SSrecords.records)
			if(istype(R) && istype(R.security))
				var/obj/item/paper/P = new /obj/item/paper(src)
				P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
				P.info += {"
Name: [R.name] ID: [R.id]<BR>
Sex: [R.sex]<BR>
Age: [R.age]<BR>
Fingerprint: [R.fingerprint]<BR>
Physical Status: [R.phisical_status]<BR>
Mental Status: [R.mental_status]<BR>
<BR>
<CENTER><B>Security Data</B></CENTER><BR>
Criminal Status: [R.security.criminal]<BR><BR>
Crimes: [R.security.crimes]<BR><BR>
Important Notes:<BR>
\t[replacetext(R.security.notes, "\n", "<BR>")]<BR>\n<BR>
<CENTER><B>Comments/Log</B></CENTER><BR>
"}
				for(var/comment in R.security.comments)
					P.info += "[comment]<BR>"
				P.info += "</TT>"
				P.name = "Security Record ([R.name])"
				virgin = 0	//tabbing here is correct- it's possible for people to try and use it
							//before the records have been generated, so we do this inside the loop.
	..()

/obj/structure/filingcabinet/security/attack_hand()
	populate()
	..()

/obj/structure/filingcabinet/security/attack_tk()
	populate()
	..()

/*
 * Medical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	var/virgin = 1

/obj/structure/filingcabinet/medical/proc/populate()
	if(virgin)
		for(var/datum/record/general/R in SSrecords.records)
			if(istype(R) && istype(R.medical))
				var/obj/item/paper/P = new /obj/item/paper(src)
				var/info = "<CENTER><B>Medical Record</B></CENTER><BR>"
				info += {"
Name: [R.name] ID: [R.id]<BR>
Sex: [R.sex]<BR>
Age: [R.age]<BR>
Fingerprint: [R.fingerprint]<BR>
Physical Status: [R.phisical_status]<BR>
Mental Status: [R.mental_status]<BR>
<BR>
<CENTER><B>Medical Data</B></CENTER><BR>
Blood Type: [R.medical.blood_type]<BR>
DNA: [R.medical.blood_dna]<BR><BR>
Disabilities: [R.medical.disabilities]<BR><BR>
Allergies: [R.medical.allergies]<BR>
Current Diseases: [R.medical.diseases] (per disease info placed in log/comment section)<BR><BR>
Important Notes:<BR>
[replacetext(R.medical.notes, "\n", "<BR>")]<BR><BR>
<CENTER><B>Comments/Log</B></CENTER><BR>
"}
				for(var/comment in R.medical.comments)
					info += "[comment]<BR>"
				info += "</TT>"
				var/pname = "Medical Record ([R.name])"
				P.set_content_unsafe(pname, info)
			virgin = 0	//tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.
	..()

/obj/structure/filingcabinet/medical/attack_hand()
	populate()
	..()

/obj/structure/filingcabinet/medical/attack_tk()
	populate()
	..()
