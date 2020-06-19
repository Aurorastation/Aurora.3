/datum/codex_category/materials
	name = "Materials"
	desc = "Various natural and artificial materials."

/datum/codex_category/materials/Initialize()
	for(var/thing in SSmaterials.materials)
		var/material/mat = thing
		if(!mat.hidden_from_codex)
			var/datum/codex_entry/entry = new(_display_name = "[mat.display_name] (material)")
			var/list/material_info = list()

			material_info += "Its melting point is [mat.melting_point] K."

			if(mat.conductive)
				material_info += "It conducts electricity."
			else
				material_info += "It does not conduct electricity."
			
			if(mat.opacity < 0.5)
				material_info += "It is transparent."

			var/material/steel = SSmaterials.materials_by_name[MATERIAL_STEEL]
			var/comparison = round(mat.hardness / steel.hardness, 0.1)
			if(comparison >= 0.9 && comparison <= 1.1)
				material_info += "It is as hard as steel."
			else if (comparison < 0.9)
				comparison = round(1/max(comparison,0.01),0.1)
				material_info += "It is ~[comparison] times softer than steel."
			else
				material_info += "It is ~[comparison] times harder than steel."

			comparison = round(mat.integrity / steel.integrity, 0.1)
			if(comparison >= 0.9 && comparison <= 1.1)
				material_info += "It is as durable as steel."
			else if (comparison < 0.9)
				comparison = round(1/comparison,0.1)
				material_info += "It is ~[comparison] times structurally weaker than steel."
			else
				material_info += "It is ~[comparison] times more durable than steel."

			if(mat.radioactivity)
				material_info += "It is radioactive."

			if(mat.flags & MATERIAL_UNMELTABLE)
				material_info += "It is impossible to melt."

			if(mat.flags & MATERIAL_BRITTLE)
				material_info += "It is brittle and can shatter under strain."

			if(mat.flags & MATERIAL_PADDING)
				material_info += "It can be used to pad furniture."

			entry.mechanics_text = jointext(material_info,"<br>")
			entry.update_links()
			SScodex.add_entry_by_string(entry.display_name, entry)
			items += entry.display_name
	..()