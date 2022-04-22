#define ALL_SPELLS "All"
#define OFFENSIVE_SPELLS "Offensive"
#define DEFENSIVE_SPELLS "Defensive"
#define UTILITY_SPELLS "Utility"
#define SUPPORT_SPELLS "Support"

var/list/all_technomancer_spells = typesof(/datum/technomancer/spell) - /datum/technomancer/spell
var/list/all_technomancer_equipment = typesof(/datum/technomancer/equipment) - /datum/technomancer/equipment
var/list/all_technomancer_consumables = typesof(/datum/technomancer/consumable) - /datum/technomancer/consumable
var/list/all_technomancer_assistance = typesof(/datum/technomancer/assistance) - /datum/technomancer/assistance

/datum/technomancer
	var/name = "technomancer thing"
	var/desc = "If you can see this, something broke."
	var/cost = 100
	var/hidden = 0
	var/obj_path = null
	var/ability_icon_state = null
	var/has_additional_info = FALSE

/datum/technomancer/proc/additional_info()
	return

/datum/technomancer/spell
	var/category = ALL_SPELLS
	var/enhancement_desc = null
	var/spell_power_desc = null

/obj/item/technomancer_catalog
	name = "catalog"
	desc = "A \"book\" featuring a holographic display, metal cover, and miniaturized teleportation device, allowing the user to \
	requisition various things from.. where ever they came from."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano91"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	var/budget = 1000
	var/max_budget = 1000
	var/mob/living/carbon/human/owner = null
	var/list/spell_instances = list()
	var/list/equipment_instances = list()
	var/list/consumable_instances = list()
	var/list/assistance_instances = list()
	var/tab = 4 // Info tab, so new players can read it before doing anything.
	var/spell_tab = ALL_SPELLS
	var/show_scepter_text = 0

/obj/item/technomancer_catalog/apprentice
	name = "apprentice's catalog"
	budget = 700
	max_budget = 700

/obj/item/technomancer_catalog/golem
	name = "golem's catalog"
	budget = 500
	max_budget = 500

/obj/item/technomancer_catalog/master //for badmins, I suppose
	name = "master's catalog"
	budget = 2000
	max_budget = 2000


// Proc: bind_to_owner()
// Parameters: 1 (new_owner - mob that the book is trying to bind to)
// Description: Links the catalog to hopefully the technomancer, so that only they can access it.
/obj/item/technomancer_catalog/proc/bind_to_owner(var/mob/living/carbon/human/new_owner)
	if(!owner && technomancers.is_technomancer(new_owner.mind))
		owner = new_owner

// Proc: New()
// Parameters: 0
// Description: Sets up the catalog, as shown below.
/obj/item/technomancer_catalog/New()
	..()
	set_up()

// Proc: set_up()
// Parameters: 0
// Description: Instantiates all the catalog datums for everything that can be bought.
/obj/item/technomancer_catalog/proc/set_up()
	if(!spell_instances.len)
		for(var/S in all_technomancer_spells)
			spell_instances += new S()
	if(!equipment_instances.len)
		for(var/E in all_technomancer_equipment)
			equipment_instances += new E()
	if(!consumable_instances.len)
		for(var/C in all_technomancer_consumables)
			consumable_instances += new C()
	if(!assistance_instances.len)
		for(var/A in all_technomancer_assistance)
			assistance_instances += new A()

/obj/item/technomancer_catalog/apprentice/set_up()
	..()
	for(var/datum/technomancer/assistance/A in assistance_instances)
		assistance_instances.Remove(A)

/obj/item/technomancer_catalog/golem/set_up()
	..()
	for(var/datum/technomancer/assistance/A in assistance_instances)
		assistance_instances.Remove(A)

// Proc: show_categories()
// Parameters: 1 (category - the category link to display)
// Description: Shows an href link to go to a spell subcategory if the category is not already selected, otherwise is bold, to reduce
// code duplicating.
/obj/item/technomancer_catalog/proc/show_categories(var/category)
	if(category)
		if(spell_tab != category)
			return "<a href='byond://?src=\ref[src];spell_category=[category]'>[category]</a>"
		else
			return "<b>[category]</b>"

// Proc: attack_self()
// Parameters: 1 (user - the mob clicking on the catalog)
// Description: Shows an HTML window, to buy equipment and spells, if the user is the legitimate owner.  Otherwise it cannot be used.
/obj/item/technomancer_catalog/attack_self(mob/user)
	if(!user)
		return 0
	if(owner && user != owner)
		to_chat(user, "<span class='danger'>\The [src] knows that you're not the original owner, and has locked you out of it!</span>")
		return 0
	else if(!owner)
		bind_to_owner(user)

	switch(tab)
		if(0) //Functions
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><b>Functions</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=4'>Info</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			dat += "<a href='byond://?src=\ref[src];refund_functions=1'>Refund Functions</a><br><br>"

			dat += "[show_categories(ALL_SPELLS)] | [show_categories(OFFENSIVE_SPELLS)] | [show_categories(DEFENSIVE_SPELLS)] | \
			[show_categories(UTILITY_SPELLS)] | [show_categories(SUPPORT_SPELLS)]<br>"
			for(var/datum/technomancer/spell/spell in spell_instances)
				if(spell.hidden)
					continue
				if(spell_tab != ALL_SPELLS && spell.category != spell_tab)
					continue
				dat += "<b>[spell.name]</b><br>"
				dat += "<i>[spell.desc]</i><br>"
				if(spell.spell_power_desc)
					dat += "<font color='purple'>Spell Power: [spell.spell_power_desc]</font><br>"
				if(spell.enhancement_desc)
					dat += "<font color='blue'>Scepter Effect: [spell.enhancement_desc]</font><br>"
				if(spell.has_additional_info)
					dat += "<i><font color='green'>[spell.additional_info()]</font></i><br>"
				if(spell.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];spell_choice=[spell.name]'>Purchase</a> ([spell.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			user << browse(dat, "window=radio")
			onclose(user, "radio")
		if(1) //Equipment
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<b>Equipment</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=4'>Info</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/technomancer/equipment/E in equipment_instances)
				dat += "<b>[E.name]</b><br>"
				dat += "<i>[E.desc]</i><br>"
				if(E.has_additional_info)
					dat += "<i><font color='green'>[E.additional_info()]</font></i><br>"
				if(E.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];item_choice=[E.name]'>Purchase</a> ([E.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			user << browse(dat, "window=radio")
			onclose(user, "radio")
		if(2) //Consumables
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<b>Consumables</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=4'>Info</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/technomancer/consumable/C in consumable_instances)
				dat += "<b>[C.name]</b><br>"
				dat += "<i>[C.desc]</i><br>"
				if(C.has_additional_info)
					dat += "<i><font color='green'>[C.additional_info()]</font></i><br>"
				if(C.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];item_choice=[C.name]'>Purchase</a> ([C.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			user << browse(dat, "window=radio")
			onclose(user, "radio")
		if(3) //Assistance
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<b>Assistance</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=4'>Info</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/technomancer/assistance/A in assistance_instances)
				dat += "<b>[A.name]</b><br>"
				dat += "<i>[A.desc]</i><br>"
				if(A.has_additional_info)
					dat += "<i><font color='green'>[A.additional_info()]</font></i><br>"
				if(A.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];item_choice=[A.name]'>Purchase</a> ([A.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			user << browse(dat, "window=radio")
			onclose(user, "radio")
		if(4) //Info
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a> | "
			dat += "<b>Info</b></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			dat += "<br>"
			dat += "<h1>Manipulation Core Owner's Manual</h1><br>"
			dat += "This brief entry in your catalog will try to explain what everything does.  For starters, the thing you're \
			probably wearing on your back is known as a <b>Manipulation Core</b>, or just a 'Core'.  It allows you to do amazing \
			things with almost no effort, depending on what <b>functions</b> you've purchased for it.  Don't lose your core!<br>"
			dat += "<br>"
			dat += "There are a few things you need to keep in mind as you use your Core to manipulate the universe.  The core \
			requires a special type of <b>energy</b>, that is referred to as just 'Energy' in the catalog.  All cores generate \
			their own energy, some more than others.  Most functions require energy be spent in order to work, so make sure not \
			to run out in a critical moment.  Besides waiting for your Core to recharge, you can buy certain functions which \
			do something to generate energy.<br>"
			dat += "<br>"
			dat += "The second thing you need to know is that awesome power over the physical world has consquences, in the form \
			of <b>Instability</b>.  Instability is the result of your Core's energy being used to fuel it, and so little is \
			understood about it, even among fellow Core owners, however it is almost always a bad thing to have.  Instability will \
			'cling' to you as you use functions, with powerful functions creating lots of instability.  The effects of holding onto \
			instability are generally harmless or mildly annoying at low levels, with effects such as sparks in the air or forced \
			blinking.  Accumulating more and more instability will lead to worse things happening, which can easily be fatal, if not \
			managed properly.<br>"
			dat += "<br>"
			dat += "Fortunately, all Cores come with a meter to tell you how much instability you currently hold.  \
			Instability will go away on its own as time goes on.  You can tell if you have instability by the characteristic \
			purple colored lightning that appears around something with instability lingering on it.  High amounts of instability \
			may cause the object afflicted with it to glow a dark purple, which is often known simply as <b>Glow</b>, which spreads \
			the instability.  You should stay far away from anyone afflicted by Glow, as they will be a danger to both themselves and \
			anything nearby.  Multiple sources of Glow can perpetuate the glow for a very long time if they are not seperated.<br>"
			dat += "<br>"
			dat += "You should strive to keep you and your apprentices' cores secure.  To help with this, each core comes with a \
			locking mechanism, which should make attempts at forceful removal by third parties (or you) futile, until it is \
			unlocked again.  Do note that there is a safety mechanism, which will automatically unlock the core if the wearer \
			suffers death.  There exists a secondary safety mechanism (safety for the core, not you) that is triggered when \
			the core detects itself being carried, with the carrier not being authorized.  It will respond by giving a \
			massive amount of Instability to them, so be careful, or perhaps make use of that.<br>"
			dat += "<br>"
			dat += "<b>You can refund functions, equipment items, and assistance items, so long as you are in your base.</b>  \
			Once you leave, you can't refund anything, however you can still buy things if you still have points remaining.  \
			To refund functions, just click the 'Refund Functions' button on the top, when in the functions tabs.  \
			For equipment items, you need to hit it against the catalog.<br>"
			dat += "<br>"
			dat += "Your blue robes and hat are both stylish, and somewhat protective against hostile energies, which includes \
			EXTERNAL instability sources (like Glow), and mundane electricity.  If you're looking for protection against other \
			things, it's suggested you purchase or otherwise obtain armor.<br>"
			dat += "<br>"
			dat += "There are a few terms you may not understand in the catalog, so this will try to explain them.<br>"
			dat += "A function can be thought of as a 'spell', that you use by holding in your hands and trying to use it on \
			a target of your choice.<br>"
			dat += "Some functions can have their abilities enhanced by a special rod called the Scepter of Enhancement.  \
			If a function is able to be boosted with it, it will be shown underneath the description of the function as \
			<font color='blue'><i>'Scepter Effect:'</i></font>.  Note that you must hold the scepter for it to work, so try to avoid losing it.<br>"
			dat += "Functions can also be boosted with the core itself.  A function that is able to benefit \
			from this will have <font color='purple'><i>'Spell Power:'</i></font> underneath.  Different Cores have different \
			amounts of spell power.<br>"
			dat += "When a function refers to 'allies', it means you, your apprentices, currently controlled entities (with the \
			Control function), and friendly simple-minded entities that you've summoned with the Scepter of Enhancement.<br>"
			dat += "A meter is equal to one 'tile'.<br>"
			user << browse(dat, "window=radio")
			onclose(user, "radio")

// Proc: Topic()
// Parameters: 2 (href - don't know, href_list - the choice that the person using the interface above clicked on.)
// Description: Acts upon clicks on links for the catalog, if they are the rightful owner.
/obj/item/technomancer_catalog/Topic(href, href_list)
	..()
	var/mob/living/carbon/human/H = usr

	if(use_check_and_message(H))
		return

	if(!ishuman(H))
		return 1 //why does this return 1?

	if(H != owner)
		to_chat(H, SPAN_WARNING("\The [src] won't allow you to do that, as you don't own \the [src]!"))
		return

	if(loc == H || (in_range(src, H) && isturf(loc)))
		H.set_machine(src)
		if(href_list["tab_choice"])
			tab = text2num(href_list["tab_choice"])
		if(href_list["spell_category"])
			spell_tab = href_list["spell_category"]
		if(href_list["spell_choice"])
			var/datum/technomancer/new_spell = null
			//Locate the spell.
			for(var/datum/technomancer/spell/spell in spell_instances)
				if(spell.name == href_list["spell_choice"])
					new_spell = spell
					break

			var/obj/item/technomancer_core/core = null
			if(istype(H.back, /obj/item/technomancer_core))
				core = H.back

			if(new_spell && core)
				if(new_spell.cost <= budget)
					if(!core.has_spell(new_spell))
						budget -= new_spell.cost
						to_chat(H, "<span class='notice'>You have just bought [new_spell.name].</span>")
						core.add_spell(new_spell.obj_path, new_spell.name, new_spell.ability_icon_state)
					else //We already own it.
						to_chat(H, "<span class='danger'>You already have [new_spell.name]!</span>")
						return
				else //Can't afford.
					to_chat(H, "<span class='danger'>You can't afford that!</span>")
					return

		// This needs less copypasta.
		if(href_list["item_choice"])
			var/datum/technomancer/desired_object = null
			for(var/datum/technomancer/O in equipment_instances + consumable_instances + assistance_instances)
				if(O.name == href_list["item_choice"])
					desired_object = O
					break

			if(desired_object)
				if(desired_object.cost <= budget)
					budget -= desired_object.cost
					to_chat(H, "<span class='notice'>You have just bought \a [desired_object.name].</span>")
					var/obj/O = new desired_object.obj_path(get_turf(H))
					technomancer_belongings.Add(O) // Used for the Track spell.

				else //Can't afford.
					to_chat(H, "<span class='danger'>You can't afford that!</span>")
					return


		if(href_list["refund_functions"])
			var/turf/T = get_turf(H)
			if(T.z in current_map.player_levels)
				to_chat(H, "<span class='danger'>You can only refund at your base, it's too late now!</span>")
				return
			var/obj/item/technomancer_core/core = null
			if(istype(H.back, /obj/item/technomancer_core))
				core = H.back
			if(core)
				for(var/obj/spellbutton/spell in core.spells)
					for(var/datum/technomancer/spell/spell_datum in spell_instances)
						if(spell_datum.obj_path == spell.spellpath)
							budget += spell_datum.cost
							core.remove_spell(spell)
							break
		attack_self(H)

/obj/item/technomancer_catalog/attackby(var/atom/movable/AM, var/mob/user)
	var/turf/T = get_turf(user)
	if(T.z in current_map.player_levels)
		to_chat(user, "<span class='danger'>You can only refund at your base, it's too late now!</span>")
		return TRUE
	for(var/datum/technomancer/equipment/E in equipment_instances + assistance_instances)
		if(AM.type == E.obj_path) // We got a match.
			if(budget + E.cost > max_budget)
				to_chat(user, "<span class='warning'>\The [src] will not allow you to overflow your maximum budget by refunding that.</span>")
				return TRUE
			else
				budget = budget + E.cost
				to_chat(user, "<span class='notice'>You've refunded \the [AM].</span>")

				// We sadly need to do special stuff here or else people who refund cores with spells will lose points permanently.
				if(istype(AM, /obj/item/technomancer_core))
					var/obj/item/technomancer_core/core = AM
					for(var/obj/spellbutton/spell in core.spells)
						for(var/datum/technomancer/spell/spell_datum in spell_instances)
							if(spell_datum.obj_path == spell.spellpath)
								budget += spell_datum.cost
								to_chat(user, "<span class='notice'>[spell.name] was inside \the [core], and was refunded.</span>")
								core.remove_spell(spell)
								break
				qdel(AM)
				return TRUE
	to_chat(user, "<span class='warn'>\The [src] is unable to refund \the [AM].</span>")

