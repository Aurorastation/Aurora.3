/datum/faction/scc
	name = "Stellar Corporate Conglomerate"
	description = {"<p>
	Formed at the height of corporate power in the galaxy, the SCC - or more officially, the Stellar Corporate Conglomerate is a group exercising undisputed economic dominance
	over the Orion Spur. The Chainlink was founded to secure privately owned assets within Tau Ceti owned by the various megacorporations during the Second Solarian Incursion. After the invasion,
	the SCC has found itself willing and eager to supersede any and all higher authority placed before it, with no signs of stopping any time soon. The Conglomerate has basically bound the
	largest shareholders and chief executive officers of the corporations to the whim and will of the Trasen family, who hold an unsteady authority over the colorful cast. Cooperation has been
	deemed essential at this point in time. The corporations remain in a shaky peace, to contrast the cutthroat, espionage-ridden past. Of course, this doesn't stop the greed or the lust for
	power and glory - they're just corporations, after all. The SCC's largest threat is Einstein Engines - this growing giant is older than all others on the galactic stage, and
	recently resurfaced in power due to the growing prominence of warp travel.
	</p>
	<p>Stellar Corporate Conglomerate employees can be in the following departments:
	<ul>
	<li><b>Command</b>
	</ul></p>
	"}

	title_suffix = "SCC"

	allowed_role_types = SCC_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/tajaran,
		/datum/species/unathi,
		/datum/species/diona,
		/datum/species/machine
	)

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_DIONA,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_UNATHI,
			SPECIES_IPC,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_SHELL,
		)
	)
