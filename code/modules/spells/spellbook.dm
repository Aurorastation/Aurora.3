#define LOCKED 				2
#define CAN_MAKE_CONTRACTS	4

var/list/artefact_feedback = list(/obj/structure/closet/wizard/armor = 		"HS",
								/obj/item/gun/energy/staff/focus = 	"MF",
								/obj/item/monster_manual = 			"MA",
								/obj/item/contract/apprentice = 		"CP",
								/obj/structure/closet/wizard/souls = 		"SS",
								/obj/structure/closet/wizard/scrying = 		"SO",
								/obj/item/teleportation_scroll = 	"TS",
								/obj/item/gun/energy/staff = 		"ST",
								/obj/item/gun/energy/staff/animate =	"SA",
								/obj/item/melee/energy/wizard =		"WS",
								/obj/item/gun/energy/staff/chaos =	"SC",
								/obj/item/storage/belt/wands/full =	"WB")

/obj/item/spellbook
	name = "master spell book"
	desc = "The legendary book of spells of the wizard."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "spellbook"
	throw_speed = 1
	throw_range = 5
	w_class = 2
	var/uses = 1
	var/temp = null
	var/datum/spellbook/spellbook
	var/spellbook_type = /datum/spellbook/ //for spawning specific spellbooks.

/obj/item/spellbook/New()
	..()
	set_spellbook(spellbook_type)

/obj/item/spellbook/proc/set_spellbook(var/type)
	if(spellbook)
		qdel(spellbook)
	spellbook = new type()
	uses = spellbook.max_uses
	name = spellbook.name
	desc = spellbook.desc

/obj/item/spellbook/attack_self(mob/user as mob)
	if(!user)
		return
	if(!(user.faction == "Space Wizard"))
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LA = H.get_organ(BP_L_ARM)
			var/obj/item/organ/external/RA = H.get_organ(BP_R_ARM)
			var/active_hand = H.hand
			to_chat(user, "<span class='warning'>You feel unimaginable agony as your eyes pour over millenia of forbidden knowledge!</span>")
			user.show_message("<b>[user]</b> screams in horror!",2)
			H.ChangeToHusk()
			H.adjust_fire_stacks(0, H.fire_stacks)
			H.IgniteMob(2)
			H.updatehealth()
			user.drop_item()
			playsound(user, 'sound/hallucinations/i_see_you2.ogg', 100, 1)
			if(active_hand)
				LA.droplimb(0,DROPLIMB_BURN)
			else
				RA.droplimb(0,DROPLIMB_BURN)
			return
	else
		interact(user)

/obj/item/spellbook/interact(mob/user as mob)
	var/dat = null
	if(temp)
		dat = "[temp]<br><a href='byond://?src=\ref[src];temp=1'>Return</a>"
	else
		dat = "<center><h3>[spellbook.title]</h3><i>[spellbook.title_desc]</i><br>You have [uses] spell slot[uses > 1 ? "s" : ""] left.</center><br>"
		dat += "<center><font color='#ff33cc'>Requires Wizard Garb</font><br><font color='#ff6600'>Selectable Target</font><br><font color='#33cc33'>Spell Charge Type: Recharge, Sacrifice, Charges</font></center><br>"
		for(var/i in 1 to spellbook.spells.len)
			var/name = "" //name of target
			var/desc = "" //description of target
			var/info = "" //additional information
			if(ispath(spellbook.spells[i],/datum/spellbook))
				var/datum/spellbook/S = spellbook.spells[i]
				name = initial(S.name)
				desc = initial(S.book_desc)
				info = "<font color='#ff33cc'>[initial(S.max_uses)] Spell Slots</font>"
			else if(ispath(spellbook.spells[i],/obj))
				var/obj/O = spellbook.spells[i]
				name = "Artefact: [capitalize(initial(O.name))]" //because 99.99% of objects dont have capitals in them and it makes it look weird.
				desc = initial(O.desc)
			else if(ispath(spellbook.spells[i],/spell))
				var/spell/S = spellbook.spells[i]
				name = initial(S.name)
				desc = initial(S.desc)
				var/testing = initial(S.spell_flags)
				if(testing & NEEDSCLOTHES)
					info = "<font color='#ff33cc'>W</font>"
				var/type = ""
				switch(initial(S.charge_type))
					if(Sp_RECHARGE)
						type = "R"
					if(Sp_HOLDVAR)
						type = "S"
					if(Sp_CHARGES)
						type = "C"
				info += "<font color='#33cc33'>[type]</font>"
			dat += "<A href='byond://?src=\ref[src];path=[spellbook.spells[i]]'>[name]</a>"
			if(length(info))
				dat += " ([info])"
			dat += " ([spellbook.spells[spellbook.spells[i]]] spell slot[spellbook.spells[spellbook.spells[i]] > 1 ? "s" : "" ])"
			if(spellbook.book_flags & CAN_MAKE_CONTRACTS)
				dat += " <A href='byond://?src=\ref[src];path=[spellbook.spells[i]];contract=1;'>Make Contract</a>"
			dat += "<br><i>[desc]</i><br>"
		dat += "<center><A href='byond://?src=\ref[src];reset=1'>Re-memorize your spellbook.</a></center>"
		dat += "<center><A href='byond://?src=\ref[src];lock=1'>[spellbook.book_flags & LOCKED ? "Unlock" : "Lock"] the spellbook.</a></center>"
	user << browse(dat,"window=spellbook")

/obj/item/spellbook/Topic(href,href_list)
	..()

	var/mob/living/carbon/human/H = usr

	if(H.stat || H.restrained())
		return

	if(!istype(H))
		return

	if(H.mind && spellbook.book_flags & LOCKED && H.mind.special_role == "apprentice") //make sure no scrubs get behind the lock
		return

	if(!H.contents.Find(src))
		H << browse(null,"window=spellbook")
		return

	if(href_list["lock"])
		if(spellbook.book_flags & LOCKED)
			spellbook.book_flags &= ~LOCKED
		else
			spellbook.book_flags |= LOCKED

	if(href_list["temp"])
		temp = null

	if(href_list["path"])
		var/path = text2path(href_list["path"])
		if(uses < spellbook.spells[path])
			to_chat(usr, "<span class='notice'>You do not have enough spell slots to purchase this.</span>")
			return
		uses -= spellbook.spells[path]
		send_feedback(path) //feedback stuff
		if(ispath(path,/datum/spellbook))
			src.set_spellbook(path)
			temp = "You have chosen a new spellbook."
		else
			if(href_list["contract"])
				if(!(spellbook.book_flags & CAN_MAKE_CONTRACTS))
					return //no
				spellbook.max_uses -= spellbook.spells[path] //no basksies
				var/obj/O = new /obj/item/contract/boon(get_turf(usr),path)
				temp = "You have purchased \the [O]."
			else
				if(ispath(path,/spell))
					temp = src.add_spell(usr,path)
				else
					var/obj/O = new path(get_turf(usr))
					temp = "You have purchased \a [O]."
					spellbook.max_uses -= spellbook.spells[path]
					//finally give it a bit of an oomf
					playsound(get_turf(usr),'sound/effects/phasein.ogg',50,1)
	if(href_list["reset"])
		var/area/wizard_station/A = locate()
		if(usr in A.contents)
			uses = spellbook.max_uses
			H.spellremove()
			temp = "All spells have been removed. You may now memorize a new set of spells."
			feedback_add_details("wizard_spell_learned","UM") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
		else
			to_chat(usr, "<span class='warning'>You must be in the wizard academy to re-memorize your spells.</span>")

	src.interact(usr)


/obj/item/spellbook/proc/send_feedback(var/path)
	if(ispath(path,/datum/spellbook))
		var/datum/spellbook/S = path
		feedback_add_details("wizard_spell_learned","[initial(S.feedback)]")
	else if(ispath(path,/spell))
		var/spell/S = path
		feedback_add_details("wizard_spell_learned","[initial(S.feedback)]")
	else if(ispath(path,/obj))
		feedback_add_details("wizard_spell_learned","[artefact_feedback[path]]")


/obj/item/spellbook/proc/add_spell(var/mob/user, var/spell_path)
	for(var/spell/S in user.spell_list)
		if(istype(S,spell_path))
			if(!S.can_improve())
				uses += spellbook.spells[spell_path]
				return "You cannot improve the spell [S] further."
			if(S.can_improve(Sp_SPEED) && S.can_improve(Sp_POWER))
				switch(alert(user, "Do you want to upgrade this spell's speed or power?", "Spell upgrade", "Speed", "Power", "Cancel"))
					if("Speed")
						return S.quicken_spell()
					if("Power")
						return S.empower_spell()
					else
						uses += spellbook.spells[spell_path]
						return
			else if(S.can_improve(Sp_POWER))
				return S.empower_spell()
			else if(S.can_improve(Sp_SPEED))
				return S.quicken_spell()

	var/spell/S = new spell_path()
	user.add_spell(S)
	return "You learn the spell [S]"

/datum/spellbook
	var/name = "\improper book of tomes"
	var/desc = "The legendary book of spells of the wizard."
	var/book_desc = "Holds information on the various tomes available to a wizard"
	var/feedback = "" //doesn't need one.
	var/book_flags = 0
	var/max_uses = 1
	var/title = "Book of Tomes"
	var/title_desc = "This tome marks down all the available tomes for use. Choose wisely, there are no refunds."
	var/list/spells = list(/datum/spellbook/standard = 1,
				/datum/spellbook/cleric = 1,
				/datum/spellbook/battlemage = 1,
				/datum/spellbook/druid = 1,
				/datum/spellbook/necromancer = 1
				) //spell's path = cost of spell