var/datum/controller/subsystem/docs/SSdocs

/datum/controller/subsystem/docs
	name = "Documents"
	wait = 30 SECONDS
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_FIRST

	var/total = 0
	var/list/docs = list()

/datum/controller/subsystem/docs/Recover()
	src.docs = SSdocs.docs

/datum/controller/subsystem/docs/Initialize(timeofday)
	//Load in the docs config
	if(config.docs_load_docs_from == "sql")
		log_debug("SSdocs: Attempting to Load from SQL")
		load_from_sql()
	else if(config.docs_load_docs_from == "json")
		log_debug("SSdocs: Attempting to Load from JSON")
		load_from_json()
	else
		log_game("SSdocs: invalid load option specified in config")

	..()

/datum/controller/subsystem/docs/New()
	NEW_SS_GLOBAL(SSdocs)

/*
	Fetching Data
*/
//A rewritten version of pickweight.
/datum/controller/subsystem/docs/proc/pick_document()
	var/subtotal = rand() * src.total
	var/doc
	for (doc in docs)
		subtotal -= docs[doc].chance
		if (subtotal <= 0)
			return docs[doc]


/*
	Loading Data
*/
//Reset docs to prep for loading in new items
/datum/controller/subsystem/docs/proc/reset_docs()
	docs = list()

//Load the document data from SQL
/datum/controller/subsystem/docs/proc/load_from_sql()
	if(!establish_db_connection(dbcon))
		log_debug("SSdocs: SQL ERROR - Failed to connect. - Falling back to JSON")
		return load_from_json()
	else
		//Reset the currently loaded data
		reset_docs()

		//Load the categories
		var/DBQuery/document_query = dbcon.NewQuery("SELECT name, title, chance, content FROM ss13_documents WHERE deleted_at IS NULL")
		document_query.Execute()
		while(document_query.NextRow())
			CHECK_TICK
			try
				add_document(
					document_query.item[1],
					document_query.item[2],
					document_query.item[3],
					document_query.item[4])
			catch(var/exception/ec)
				log_debug("SSdocs: Error when loading document: [ec]")

//Loads the cargo data from JSON
/datum/controller/subsystem/docs/proc/load_from_json()
	var/list/docsconfig = list()
	try
		docsconfig = json_decode(return_file_text("config/docs.json"))
	catch(var/exception/ej)
		log_debug("SSdocs: Warning: Could not load config, as docs.json is missing - [ej]")
		return

	//Reset the currently loaded data
	reset_docs()

	//Load the documents
	for (var/document in docsconfig)
		CHECK_TICK
		try
			add_document(
				docsconfig[document]["name"],
				docsconfig[document]["title"],
				docsconfig[document]["chance"],
				docsconfig[document]["content"])
		catch(var/exception/ec)
			log_ss("docs","Error when loading document: [ec]")
			log_debug("SSdocs: Error when loading document: [ec]")
	return 1

/datum/controller/subsystem/docs/proc/add_document(var/name,var/title,var/chance,var/content)
	var/datum/docs_document/dd = new()
	dd.name = name
	dd.title = title
	dd.chance = chance
	dd.content = content

	//Add the document to the cargo_categories list
	docs[dd.name] = dd
	src.total += dd.chance
	return dd

/datum/docs_document
	var/name = "document" // internal name of the document
	var/title = "paper" // player-facing title of the document
	var/chance = 0
	var/content = "" // Can contain html, but pencode is not processed.

/obj/random/document
	name = "random document"
	desc = "This is a random text document."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	has_postspawn = 1

/obj/random/document/item_to_spawn()
	return /obj/item/weapon/paper

/obj/random/document/post_spawn(var/obj/item/spawned)
	var/datum/docs_document/doc = SSdocs.pick_document()
	if(!istype(doc))
		return
	if(!istype(spawned, /obj/item/weapon/paper))
		return
	var/obj/item/weapon/paper/P = spawned
	P.set_content_unsafe(doc.title, doc.content)