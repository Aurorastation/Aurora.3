//The base core object, worn on the wizard's back.
/obj/item/technomancer_core
	name = "manipulation core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats."
	icon = 'icons/obj/clothing/technomancer.dmi'
	contained_sprite = TRUE
	icon_state = "technomancer_core"
	item_state = "technomancer_core"
	w_class = ITEMSIZE_HUGE
	slot_flags = SLOT_BACK
	unacidable = TRUE
	origin_tech = list(TECH_MATERIAL = 8, TECH_ENGINEERING = 8, TECH_POWER = 8, TECH_BLUESPACE = 10,TECH_COMBAT = 7, TECH_MAGNET = 9, TECH_DATA = 5)
	var/energy = 10000
	var/max_energy = 10000
	var/regen_rate = 50				// 200 seconds to full
	var/energy_delta = 0			// How much we're gaining (or perhaps losing) every process().
	var/mob/living/wearer			// Reference to the mob wearing the core.
	var/instability_modifier = 0.8	// Multiplier on how much instability is added.
	var/energy_cost_modifier = 1.0	// Multiplier on how much spells will cost.
	var/spell_power_modifier = 1.0	// Multiplier on how strong spells are.
	var/cooldown_modifier 	 = 1.0	// Multiplier on cooldowns for spells.
	var/list/spells = list()		// This contains the buttons used to make spells in the user's hand.
	var/list/appearances = list(	// Assoc list containing possible icon_states that the wiz can change the core to.
		"default"			= "technomancer_core",
		)

	// Some spell-specific variables go here, since spells themselves are temporary.  Cores are more long term and more accessable than
	// mind datums.  It may also allow creative players to try to pull off a 'soul jar' scenario.
	var/list/summoned_mobs = list()	// Maintained horribly with maintain_summon_list().
	var/list/wards_in_use = list()	// Wards don't count against the cap for other summons.
	var/max_summons = 10			// Maximum allowed summoned entities.  Some cores will have different caps.

	var/never_remove = FALSE		// whether it can ever be removed

	var/global/list/chameleon_options

/obj/item/technomancer_core/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	if(!never_remove)
		verbs += /obj/item/technomancer_core/proc/toggle_lock
	else
		canremove = FALSE
	if(!chameleon_options)
		var/list/blocked = list(/obj/item/storage/backpack/satchel/leather/withwallet) + typesof(/obj/item/technomancer_core)
		chameleon_options = list("Reset")
		chameleon_options += generate_chameleon_choices(/obj/item/storage/backpack, blocked)

/obj/item/technomancer_core/Destroy()
	dismiss_all_summons()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

// Add the spell buttons to the HUD.
/obj/item/technomancer_core/equipped(mob/user)
	wearer = user
	for(var/obj/spellbutton/spell in spells)
		wearer.ability_master.add_technomancer_ability(spell, spell.ability_icon_state)
	..()

// Removes the spell buttons from the HUD.
/obj/item/technomancer_core/dropped(mob/user)
	if(!wearer)
		return
	for(var/obj/screen/ability/obj_based/technomancer/A in wearer.ability_master.ability_objects)
		wearer.ability_master.remove_ability(A)
	wearer = null
	..()

// 'pay_energy' is too vague of a name for a proc at the mob level.
/mob/proc/technomancer_pay_energy(amount)
	return FALSE

/mob/living/carbon/human/technomancer_pay_energy(amount)
	if(istype(back, /obj/item/technomancer_core))
		var/obj/item/technomancer_core/TC = back
		return TC.pay_energy(amount)
	return FALSE

/obj/item/technomancer_core/proc/pay_energy(amount)
	amount = round(amount * energy_cost_modifier, 0.1)
	if(amount <= energy)
		energy = max(energy - amount, 0)
		return TRUE
	return FALSE

/obj/item/technomancer_core/proc/give_energy(amount)
	energy = min(energy + amount, max_energy)
	return TRUE

/obj/item/technomancer_core/process()
	var/old_energy = energy
	regenerate()
	pay_dues()
	energy_delta = energy - old_energy
	if(world.time % 5 == 0) // Maintaining fat lists is expensive, I imagine.
		maintain_summon_list()
	if(wearer && wearer.mind)
		if(!technomancers.is_technomancer(wearer.mind)) // In case someone tries to wear a stolen core.
			wearer.adjust_instability(20)
	if(!never_remove && (!wearer || wearer.stat == DEAD)) // Unlock if we're dead or not worn.
		canremove = TRUE

/obj/item/technomancer_core/proc/regenerate()
	energy = min(max(energy + regen_rate, 0), max_energy)
	if(wearer && ishuman(wearer))
		var/mob/living/carbon/human/H = wearer
		H.wiz_energy_update_hud()

// We pay for on-going effects here.
/obj/item/technomancer_core/proc/pay_dues()
	if(summoned_mobs.len)
		pay_energy(round(summoned_mobs.len * 5))

// Because sometimes our summoned mobs will stop existing and leave a null entry in the list, we need to do cleanup every
// so often so .len remains reliable.
/obj/item/technomancer_core/proc/maintain_summon_list()
	if(!summoned_mobs.len) // No point doing work if there's no work to do.
		return
	for(var/A in summoned_mobs)
		// First, a null check.
		if(isnull(A))
			summoned_mobs -= A
			continue
		// Now check for dead mobs who shouldn't be on the list.
		if(istype(A, /mob/living))
			var/mob/living/L = A
			if(L.stat == DEAD)
				summoned_mobs -= L
				addtimer(CALLBACK(src, .proc/remove_summon, L), 1)

/obj/item/technomancer_core/proc/remove_summon(var/mob/living/L)
	L.visible_message("<span class='notice'>\The [L] begins to fade away...</span>")
	animate(L, alpha = 255, alpha = 0, time = 30) // Makes them fade into nothingness.
	sleep(30)
	qdel(L)

// Deletes all the summons and wards from the core, so that Destroy() won't have issues.
/obj/item/technomancer_core/proc/dismiss_all_summons()
	for(var/mob/living/L in summoned_mobs)
		summoned_mobs -= L
		qdel(L)
	for(var/mob/living/ward in wards_in_use)
		wards_in_use -= ward
		qdel(ward)

/obj/item/technomancer_core/verb/change_appearance(picked in chameleon_options)
	set name = "Change Core Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(picked != "Reset" && !ispath(chameleon_options[picked]))
		return

	if(!usr.mind || !technomancers.is_technomancer(usr.mind))
		to_chat(usr, SPAN_WARNING("You have no idea how to do this!"))
		return

	var/chameleon_type
	if(picked == "Reset")
		chameleon_type = type
	else
		chameleon_type = chameleon_options[picked]

	set_appearance_to(chameleon_type)

/obj/item/technomancer_core/proc/set_appearance_to(var/path)
	disguise(path)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_back()
		update_held_icon()

/obj/item/technomancer_core/emp_act()
	set_appearance_to(type)

// This is what is clicked on to place a spell in the user's hands.
/obj/spellbutton
	name = "generic spellbutton"
	var/spellpath
	var/obj/item/technomancer_core/core
	var/ability_icon_state

/obj/spellbutton/New(loc, var/path, var/new_name, var/new_icon_state)
	if(!path || !ispath(path))
		message_admins("ERROR: /obj/spellbutton/New() was not given a proper path!")
		qdel(src)
	src.name = new_name
	src.spellpath = path
	src.loc = loc
	src.core = loc
	src.ability_icon_state = new_icon_state

/obj/spellbutton/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.place_spell_in_hand(spellpath)

/obj/spellbutton/DblClick()
	return Click()

/mob/living/carbon/human/Stat()
	. = ..()

	if(. && istype(back,/obj/item/technomancer_core))
		var/obj/item/technomancer_core/core = back
		setup_technomancer_stat(core)

/mob/living/carbon/human/proc/setup_technomancer_stat(var/obj/item/technomancer_core/core)
	if(core && statpanel("Spell Core"))
		var/charge_status = "[core.energy]/[core.max_energy] ([round( (core.energy / core.max_energy) * 100)]%) \
		([round(core.energy_delta)]/s)"
		var/instability_delta = instability - last_instability
		var/instability_status = "[src.instability] ([round(instability_delta, 0.1)]/s)"
		stat("Core charge", charge_status)
		stat("User instability", instability_status)
		for(var/obj/spellbutton/button in core.spells)
			stat(button)

/obj/item/technomancer_core/proc/add_spell(var/path, var/new_name, var/ability_icon_state)
	if(!path || !ispath(path))
		message_admins("ERROR: /obj/item/technomancer_core/add_spell() was not given a proper path!  \
		The path supplied was [path].")
		return
	var/obj/spellbutton/spell = new(src, path, new_name, ability_icon_state)
	spells.Add(spell)
	if(wearer)
		wearer.ability_master.add_technomancer_ability(spell, ability_icon_state)

/obj/item/technomancer_core/proc/remove_spell(var/obj/spellbutton/spell_to_remove)
	if(spell_to_remove in spells)
		spells.Remove(spell_to_remove)
		if(wearer)
			var/obj/screen/ability/obj_based/technomancer/A = wearer.ability_master.get_ability_by_instance(spell_to_remove)
			if(A)
				wearer.ability_master.remove_ability(A)
		qdel(spell_to_remove)

/obj/item/technomancer_core/proc/remove_all_spells()
	for(var/obj/spellbutton/spell in spells)
		spells.Remove(spell)
		qdel(spell)

/obj/item/technomancer_core/proc/has_spell(var/datum/technomancer/spell_to_check)
	for(var/obj/spellbutton/spell in spells)
		if(spell.spellpath == spell_to_check.obj_path)
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/wiz_energy_update_hud()
	if(client && hud_used)
		if(istype(back, /obj/item/technomancer_core)) //I reckon there's a better way of doing this.
			var/obj/item/technomancer_core/core = back
			energy_display.invisibility = 0
			instability_display.invisibility = 0
			var/ratio = core.energy / core.max_energy
			ratio = max(round(ratio, 0.05) * 100, 5)
			energy_display.icon_state = "wiz_energy[ratio]"
		else
			energy_display.invisibility = 101
			instability_display.invisibility = 101

//Resonance Aperture

//Variants which the wizard can buy.

//High risk, high reward core.
/obj/item/technomancer_core/unstable
	name = "unstable core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This one is rather unstable, \
	and could prove dangerous to the user, as it feeds off unstable energies that can occur with overuse of this machine."
	energy = 13000
	max_energy = 13000
	regen_rate = 35 //~371 seconds to full, 118 seconds to full at 50 instability (rate of 110)
	instability_modifier = 1.2
	energy_cost_modifier = 0.7
	spell_power_modifier = 1.1

/obj/item/technomancer_core/unstable/regenerate()
	var/instability_bonus = 0
	if(loc && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		instability_bonus = H.instability * 1.5
	energy = min(energy + regen_rate + instability_bonus, max_energy)
	if(loc && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.wiz_energy_update_hud()

//Lower capacity but safer core.
/obj/item/technomancer_core/rapid
	name = "rapid core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This one has a superior \
	recharge rate, at the price of storage capacity.  It also includes integrated motion assistance, increasing agility somewhat."
	energy = 7000
	max_energy = 7000
	regen_rate = 70 //100 seconds to full
	slowdown = -1
	instability_modifier = 0.9
	cooldown_modifier = 0.9

//Big batteries but slow regen, buying energy spells is highly recommended.
/obj/item/technomancer_core/bulky
	name = "bulky core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This variant is more \
	cumbersome and bulky, due to the additional energy capacitors installed, which allows for a massive energy storage, as well \
	as stronger function usage.  It also comes at a price of a subpar fractal \
	reactor."
	energy = 20000
	max_energy = 20000
	regen_rate = 25 //800 seconds to full
	slowdown = 1
	instability_modifier = 1.0
	spell_power_modifier = 1.4

// Using this can result in abilities costing less energy.  If you're lucky.
/obj/item/technomancer_core/recycling
	name = "recycling core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type tries to recover \
	some of the energy lost from using functions due to inefficiency."
	energy = 12000
	max_energy = 12000
	regen_rate = 40 //300 seconds to full
	instability_modifier = 0.6
	energy_cost_modifier = 0.8

/obj/item/technomancer_core/recycling/pay_energy(amount)
	var/success = ..()
	if(success)
		if(prob(30))
			give_energy(round(amount / 2))
			if(amount >= 50) // Managing to recover less than half of this isn't worth telling the user about.
				to_chat(wearer, "<span class='notice'>\The [src] has recovered [amount/2 >= 1000 ? "a lot of" : "some"] energy.</span>")
	return success

// For those dedicated to summoning hoards of things.
/obj/item/technomancer_core/summoner
	name = "summoner core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type is optimized for \
	plucking hapless creatures and machines from other locations, to do your bidding.  The maximum amount of entities that you can \
	bring over at once is higher with this core, up to 40 entities, and the maintenance cost is significantly lower."
	energy = 8000
	max_energy = 8000
	regen_rate = 35 //228 seconds to full
	max_summons = 40
	instability_modifier = 1.2
	spell_power_modifier = 1.2

/obj/item/technomancer_core/summoner/pay_dues()
	if(summoned_mobs.len)
		pay_energy( round(summoned_mobs.len) )

// For those who hate instability.
/obj/item/technomancer_core/safety
	name = "safety core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type is designed to be \
	the closest thing you can get to 'safe' for a Core.  Instability from this is significantly reduced.  You can even dance if \
	you want to, and leave your apprentice behind."
	energy = 7000
	max_energy = 7000
	regen_rate = 30 //233 seconds to full
	instability_modifier = 0.3
	spell_power_modifier = 0.7

// For those who want to blow everything on a few spells.
/obj/item/technomancer_core/overcharged
	name = "overcharged core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type will use as much \
	energy as it can in order to pump up the strength of functions used to insane levels."
	energy = 15000
	max_energy = 15000
	regen_rate = 40 //375 seconds to full
	instability_modifier = 1.1
	spell_power_modifier = 1.75
	energy_cost_modifier = 2.0

// For use only for the GOLEM.
/obj/item/technomancer_core/golem
	name = "integrated core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type is not meant \
	to be worn on the back like other cores.  Instead it is meant to be installed inside a synthetic shell.  As a result, it's \
	a lot more robust."
	item_state = null
	energy = 25000
	max_energy = 25000
	regen_rate = 100 //250 seconds to full
	instability_modifier = 0.75
	never_remove = TRUE


/obj/item/technomancer_core/proc/toggle_lock()
	set name = "Toggle Core Lock"
	set category = "Object"
	set desc = "Toggles the locking mechanism on your manipulation core."

	canremove = !canremove
	to_chat(usr, "<span class='notice'>You [canremove ? "de" : ""]activate the locking mechanism on \the [src].</span>")
