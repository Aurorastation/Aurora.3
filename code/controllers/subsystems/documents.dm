#define SSDOCS_MEDIUM_PAPER "paper"
#define SSDOCS_MEDIUM_FILE "file"

var/datum/controller/subsystem/docs/SSdocs

/datum/controller/subsystem/docs
	name = "Documents"
	wait = 30 SECONDS
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_FIRST

	var/total_docs = 0
	var/list/docs = list()
	var/list/docs_by_tags = list()
	var/list/total_by_tags = list()

/datum/controller/subsystem/docs/Recover()
	src.docs = SSdocs.docs
	src.docs_by_tags = SSdocs.docs_by_tags

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
	var/subtotal = rand() * src.total_docs
	for (var/doc in docs)
		var/datum/docs_document/dd = doc
		subtotal -= dd.chance
		if (subtotal <= 0)
			return dd
	return null

//Pick a document by one tag
/datum/controller/subsystem/docs/proc/pick_document_by_tag(var/tag)
	if(!docs_by_tags[tag])
		return null
	var/subtotal = rand() * src.total_by_tags[tag]
	for (var/doc in docs_by_tags[tag])
		var/datum/docs_document/dd = doc
		subtotal -= dd.chance
		if (subtotal <= 0)
			return dd
	return null

//Pick a document by any tag from a list of tags. Weighted.
/datum/controller/subsystem/docs/proc/pick_document_by_any_tag(var/list/tags)
	if(!istype(tags) || !tags.len)
		return null
	var/total_chance = 0
	var/tag_sublist = list()
	for(var/t in tags)
		if(!total_by_tags[t])
			return null
		total_chance += total_by_tags[t]
		tag_sublist += docs_by_tags[t]
	var/subtotal = total_chance * rand()
	for(var/doc in tag_sublist)
		var/datum/docs_document/dd = doc
		subtotal -= dd.chance
		if(subtotal <= 0)
			return dd
	return null

//Pick a document by multiple tags that it must have.
/datum/controller/subsystem/docs/proc/pick_document_by_tags(var/list/tags)
	if(!istype(tags) || !tags.len)
		return null
	var/list/tag_sublist = docs_by_tags[pick(tags)] // the list cannot start off as empty
	for(var/t in tags)
		if(!docs_by_tags[t])
			return null
		tag_sublist &= docs_by_tags[t]
	log_ss("docs", "Tag sublist has length [tag_sublist.len].")
	var/subtotal = 0
	for(var/doc in tag_sublist)
		var/datum/docs_document/dd = doc
		subtotal += dd.chance
	subtotal *= rand()
	for (var/doc in tag_sublist)
		var/datum/docs_document/dd = doc
		subtotal -= dd.chance
		if (subtotal <= 0)
			return tag_sublist[dd]
	return null
/*
	Loading Data
*/
//Reset docs to prep for loading in new items
/datum/controller/subsystem/docs/proc/reset_docs()
	docs = list()
	docs_by_tags = list()
	total_docs = 0
	total_by_tags = list()

//Load the document data from SQL
/datum/controller/subsystem/docs/proc/load_from_sql()
	if(!establish_db_connection(dbcon))
		log_debug("SSdocs: SQL ERROR - Failed to connect. - Falling back to JSON")
		return load_from_json()
	else
		//Reset the currently loaded data
		reset_docs()

		//Load the categories
		var/DBQuery/document_query = dbcon.NewQuery("SELECT name, title, chance, content, tags FROM ss13_documents WHERE deleted_at IS NULL")
		document_query.Execute()
		while(document_query.NextRow())
			CHECK_TICK
			try
				add_document(
					document_query.item[1],
					document_query.item[2],
					text2num(document_query.item[3]),
					document_query.item[4],
					json_decode(document_query.item[5]))
			catch(var/exception/ec)
				log_debug("SSdocs: Error when loading document: [ec]")
	return 1

//Loads the document data from JSON
/datum/controller/subsystem/docs/proc/load_from_json()
	var/list/docsconfig = list()
	try
		docsconfig = json_decode(return_file_text("config/docs.json"))
	catch(var/exception/ej)
		log_debug("SSdocs: Warning: Could not load config, as docs.json is missing - [ej]")
		return 0

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
				docsconfig[document]["content"],
				docsconfig[document]["tags"])
		catch(var/exception/ec)
			log_ss("docs","Error when loading document: [ec]")
	return 1

/datum/controller/subsystem/docs/proc/add_document(var/name,var/title,var/chance,var/content,var/tags)
	var/datum/docs_document/dd = new()
	dd.name = name
	dd.title = title
	dd.chance = chance
	dd.content = content
	if(istext(tags))
		tags = splittext(tags, ";")
	dd.tags = tags

	//Adds the document to the docs, sorted by tags
	for(var/t in tags)
		if(!(docs_by_tags[t]))
			docs_by_tags[t] = list()
			total_by_tags[t] = 0
		docs_by_tags[t][dd.name] += dd
		total_by_tags[t] += dd.chance

	//Add the document to the docs list
	docs[dd.name] = dd
	total_docs += dd.chance
	return dd

/datum/docs_document
	var/name = "document" // internal name of the document
	var/title = "paper" // player-facing title of the document
	var/chance = 0
	var/content = "" // Can contain html, but pencode is not processed.
	var/list/tags = list() // A list of tags that apply to the document.

/obj/random/document
	name = "random document"
	desc = "This is a random text document."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	has_postspawn = 1
	var/tags = list() // for use by mappers, typically

/obj/random/document/item_to_spawn()
	return /obj/item/paper

/obj/random/document/post_spawn(var/obj/item/paper/spawned)
	if(!istype(spawned))
		return
	var/list/total_tags = tags | list(SSDOCS_MEDIUM_PAPER)
	var/datum/docs_document/doc
	if (total_tags.len == 1)
		doc = SSdocs.pick_document_by_tag(total_tags[1])
	else
		doc = SSdocs.pick_document_by_tags(total_tags)

	if (!istype(doc))
		log_ss("docs","Null paper acquired in post_spawn!")
		return null

	log_ss("docs","Document [doc.name] successfully spawned!")
	var/obj/item/paper/P = spawned
	P.set_content(doc.title, doc.content)

/obj/random/document/junk/post_spawn(var/obj/item/spawned)
	..()
	if(istype(spawned, /obj/item/paper) && prob(80)) // 1 in 5 junk-spawned documents will be perfectly readable
		var/obj/item/paper/P = spawned
		P.info = stars(P.info, 85) // 85% readable, preserves tags
		P.icon_state = "scrap"

/datum/controller/subsystem/docs/proc/create_file(var/datum/docs_document/file)
	var/datum/computer_file/data/F = new/datum/computer_file/data()
	F.filename = file.title
	F.filetype = "TXT"
	log_ss("docs","Digital file created: [file.title].TXT")
	F.stored_data = file.content
	F.calculate_size()
	return F
