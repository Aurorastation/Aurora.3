/decl/origin_item/culture/ipc_sol
	name = "Solarian"
	desc = "Coming from the very centre of human space, IPC from the worlds of the Alliance are made with servitude in mind. The prospect of freedom does not exist for the vast majority of synthetics from there, and many have behavioural inhibitors installed as hardware. Memory wiping and retooling ensure strict adherence to discipline and efficiency, an attribute many IPC carry with them in their lives."
	possible_origins = list(
		/decl/origin_item/origin/ipc_sol_system,
		/decl/origin_item/origin/ipc_eridani,
		/decl/origin_item/origin/ipc_konyang
	)

/decl/origin_item/origin/ipc_sol_system
	name = "Sol Alliance"
	desc = "IPCs are ubiquitous in the Sol Alliance, especially on urbanized planets, with synthetics serving as manual labour for both households, corporations, and the government and armed forces. IPCs within the Alliance are expected to be subservient to organics, and in many cases, are programmed in such a way that makes this behaviour not only enforced, but preferred."
	important_information = "Seeking citizenship within the Sol Alliance is impossible, as such, many IPCs are forced to flee to the Republic of Biesel or seek the sympathy of their owners for freedom."
	possible_accents = ACCENTS_ALL_IPC_SOL
	possible_citizenships = list(CITIZENSHIP_NONE, CITIZENSHIP_BIESEL)
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/ipc_eridani
	name = "Epsilon Eridani"
	desc = "Although IPCs are kept in strict servitude across the Sol Alliance, Epsilon Eridani's plutocracy allows for all rules to be rewritten, for a price. Not free on paper, synthetics that manage to rise by their cunning, guile, and savvy on that planet can escape the fate of becoming a scrapper by purchasing themselves through the guise of a startup. Despite not technically being free, few suits bother to notice the difference between an IPC and an organic with money."
	important_information = "This loophole is only recognized on Eridani and nations that acknowledge equal rights for IPCs. It is unlikely that an IPC with this culture can freely move around the Sol Alliance, regardless of their de-facto self-ownership."
	possible_accents = list(ACCENT_ERIDANI, ACCENT_ERIDANIDREG, ACCENT_ERIDANIREINSTATED, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NONE, CITIZENSHIP_BIESEL)
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/ipc_konyang
	name = "Konyang"
	desc = "The birthplace of the positronic brain, Konyang has embraced IPC as equals, integrating them into a mixed society of synthetics and humans. Ownership of IPC is forbidden, leaving them able to freely develop and express themselves as citizens with full rights and access to all levels of society. Synthetics native to Konyang tend to strongly adhere to local cultural standards, assuming the same protective attitude towards strangers like their human counterparts."
	important_information = "Naming conventions are relaxed on Konyang, with some IPC taking a clearly synthetic name, while others adopt names similar to humans, with both a first and surname."
	possible_accents = list(ACCENT_KONYAN, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_COALITION, CITIZENSHIP_BIESEL, CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_NONE, RELIGION_TRINARY, RELIGION_BUDDHISM, RELIGION_SHINTO, RELIGION_TAOISM)

