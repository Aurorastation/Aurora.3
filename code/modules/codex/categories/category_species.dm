/datum/codex_category/species
	name = "Species"
	desc = "Sapient species encountered in known space."

/datum/codex_category/species/Initialize()
	for(var/thing in all_species)
		var/datum/species/species = all_species[thing]
		if(!species.hidden_from_codex)
			var/datum/codex_entry/entry = new(_display_name = "[species.name] (Species)")
			entry.lore_text = species.blurb
			entry.mechanics_text = ""
			if(species.spawn_flags & CAN_JOIN)
				entry.mechanics_text += "Often present on human stations."
			if(species.flags & NO_BLOOD)
				entry.mechanics_text += "</br>Does not have blood."
			if(species.flags & NO_BREATHE)
				entry.mechanics_text += "</br>Does not breathe."
			if(species.flags & NO_SCAN)
				entry.mechanics_text += "</br>Does not have DNA."
			if(species.flags & NO_PAIN)
				entry.mechanics_text += "</br>Does not feel pain."
			if(species.flags & NO_SLIP)
				entry.mechanics_text += "</br>Has excellent traction."
			if(species.flags & NO_POISON)
				entry.mechanics_text += "</br>Immune to most poisons."
			if(species.appearance_flags & HAS_SKIN_TONE)
				entry.mechanics_text += "</br>Has a variety of skin tones."
			if(species.appearance_flags & HAS_SKIN_COLOR)
				entry.mechanics_text += "</br>Has a variety of skin colours."
			if(species.appearance_flags & HAS_EYE_COLOR)
				entry.mechanics_text += "</br>Has a variety of eye colours."
			if(species.flags & IS_PLANT)
				entry.mechanics_text += "</br>Has a plantlike physiology."
			entry.update_links()
			SScodex.add_entry_by_string(entry.display_name, entry)
			SScodex.add_entry_by_string(species.name, entry)
			items += entry.display_name
	..()