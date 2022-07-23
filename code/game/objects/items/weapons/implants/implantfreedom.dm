//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implant/freedom
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	implant_color = "r"
	var/activation_emote = "chuckle"
	var/uses = 1

/obj/item/implant/freedom/New()
	uses = rand(1, 5)
	..()

/obj/item/implant/freedom/trigger(emote, mob/living/carbon/source)
	if(!activation_emote)
		return
	if(uses < 1)
		to_chat(source, SPAN_WARNING("\The [src] gives a faint beep inside your head, indicating that it's out of uses!"))
		activation_emote = null //Disable this to allow them to emote normally
		return
	if(emote == activation_emote)
		uses--
		to_chat(source, "You feel a faint click.")
		if(source.handcuffed)
			var/obj/item/W = source.handcuffed
			source.handcuffed = null
			if(source.buckled_to && source.buckled_to.buckle_require_restraints)
				source.buckled_to.unbuckle()
			source.update_inv_handcuffed()
			if(source.client)
				source.client.screen -= W
			if(W)
				W.forceMove(source.loc)
				dropped(source)
				if (W)
					W.layer = initial(W.layer)
		if(source.legcuffed)
			var/obj/item/W = source.legcuffed
			source.legcuffed = null
			source.update_inv_legcuffed()
			if(source.client)
				source.client.screen -= W
			if(W)
				W.forceMove(source.loc)
				dropped(source)
				if(W)
					W.layer = initial(W.layer)
	return


/obj/item/implant/freedom/implanted(mob/living/carbon/source)
	activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	if(source.mind)
		source.mind.store_memory("\The [src] can be activated by using the [activation_emote] emote, <B>say *[activation_emote]</B> to attempt to activate.")
	to_chat(source, "The implanted [src] can be activated by using the [activation_emote] emote, <B>say *[activation_emote]</B> to attempt to activate.")
	return TRUE


/obj/item/implant/freedom/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Freedom Beacon<BR>
<b>Life:</b> optimum 5 uses<BR>
<b>Important Notes:</b> <span class='warning'>Illegal</span><BR>
<HR>
<b>Implant Details:</b> <BR>
<b>Function:</b> Transmits a specialized cluster of signals to override handcuff locking
mechanisms<BR>
<b>Special Features:</b><BR>
<i>Neuro-Scan</i>- Analyzes certain shadow signals in the nervous system<BR>
<b>Integrity:</b> The battery is extremely weak and commonly after injection its
life can drive down to only 1 use.<HR>
No Implant Specifics"}
	return dat
