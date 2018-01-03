// (Re-)Apply mutations.
// TODO: Change inj to a bitflag for various forms of differing behavior.
// M: Mob to mess with
// connected: Machine we're in, type unchecked so I doubt it's used beyond monkeying
// flags: See below, bitfield.
#define MUTCHK_FORCED        1

/mob/living/carbon/human/domutcheck(connected = null, flags = 0)
	if(species && (species.flags & NO_SCAN))
		return

	..()

/mob/living/carbon/proc/domutcheck(var/connected=null, var/flags=0)
	if(!src.dna)
		return

	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue

		// Sanity checks, don't skip.
		if(!gene.can_activate(src, flags))
			continue

		// Current state
		var/gene_active = (gene.flags & GENE_ALWAYS_ACTIVATE)
		if(!gene_active)
			gene_active = dna.GetSEState(gene.block)

		// Prior state
		var/gene_prior_status = (gene.type in active_genes)
		var/changed = gene_active != gene_prior_status || (gene.flags & GENE_ALWAYS_ACTIVATE)

		// If gene state has changed:
		if(changed)
			// Gene active (or ALWAYS ACTIVATE)
			if(gene_active || (gene.flags & GENE_ALWAYS_ACTIVATE))
				testing("[gene.name] activated!")
				gene.activate(connected,flags)
				if(!QDELETED(src))
					active_genes |= gene.type
					update_icon = 1
			// If Gene is NOT active:
			else
				testing("[gene.name] deactivated!")
				gene.deactivate(src, connected,flags)
				if(!QDELETED(src))
					active_genes -= gene.type
					update_icon = 1
