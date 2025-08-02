#define SHUTDOWN_QUERY_TIMELIMIT (1 MINUTES)
SUBSYSTEM_DEF(dbcore)
	name = "Database"
	flags = SS_TICKER|SS_NO_INIT
	wait = 10 // Not seconds because we're running on SS_TICKER
	runlevels = RUNLEVEL_LOBBY|RUNLEVELS_DEFAULT
	init_order = INIT_ORDER_DBCORE
	priority = FIRE_PRIORITY_DATABASE


	/// Number of failed connection attempts this try. Resets after the timeout or successful connection
	var/failed_connections = 0
	/// Max number of consecutive failures before a timeout (here and not a define so it can be vv'ed mid round if needed)
	var/max_connection_failures = 5
	/// world.time that connection attempts can resume
	var/failed_connection_timeout = 0
	/// Total number of times connections have had to be timed out.
	var/failed_connection_timeout_count = 0

	var/last_error

	/// The maximum number of queries that can be executed at the same time
	var/max_concurrent_queries = 25

	/// Number of all queries, reset to 0 when logged in SStime_track. Used by SStime_track
	var/all_queries_num = 0
	/// Number of active queries, reset to 0 when logged in SStime_track. Used by SStime_track
	var/queries_active_num = 0
	/// Number of standby queries, reset to 0 when logged in SStime_track. Used by SStime_track
	var/queries_standby_num = 0

	/// All the current queries that exist.
	var/list/all_queries = list()
	/// Queries being checked for timeouts.
	var/list/processing_queries

	/// Queries currently being handled by database driver
	var/list/datum/db_query/queries_active = list()
	/// Queries pending execution, mapped to complete arguments
	var/list/datum/db_query/queries_standby = list()

	/// We are in the process of shutting down and should not allow more DB connections
	var/shutting_down = FALSE

	/// Arbitrary handle returned from rust_g.
	var/connection

/datum/controller/subsystem/dbcore/stat_entry(msg)
	msg = "P:[length(all_queries)]|Active:[length(queries_active)]|Standby:[length(queries_standby)]"
	return ..()

/// Resets the tracking numbers on the subsystem. Used by SStime_track.
/datum/controller/subsystem/dbcore/proc/reset_tracking()
	all_queries_num = 0
	queries_active_num = 0
	queries_standby_num = 0

/datum/controller/subsystem/dbcore/fire(resumed = FALSE)
	if(!IsConnected())
		return

	if(!resumed)
		if(!length(queries_active) && !length(queries_standby) && !length(all_queries))
			processing_queries = null
			return
		processing_queries = all_queries.Copy()

	// First handle the already running queries
	for (var/datum/db_query/query in queries_active)
		if(!process_query(query))
			queries_active -= query

	// Now lets pull in standby queries if we have room.
	if (length(queries_standby) > 0 && length(queries_active) < max_concurrent_queries)
		var/list/queries_to_activate = queries_standby.Copy(1, min(length(queries_standby), max_concurrent_queries) + 1)

		for (var/datum/db_query/query in queries_to_activate)
			queries_standby.Remove(query)
			create_active_query(query)

	// And finally, let check queries for undeleted queries, check ticking if there is a lot of work to do.
	while(length(processing_queries))
		var/datum/db_query/query = popleft(processing_queries)
		if(world.time - query.last_activity_time > (5 MINUTES))
			stack_trace("Found undeleted query, check the sql.log for the undeleted query and add a delete call to the query datum.")
			log_subsystem_dbcore("Undeleted query: \"[query.sql]\" LA: [query.last_activity] LAT: [query.last_activity_time]")
			qdel(query)
		if(MC_TICK_CHECK)
			return


/// Helper proc for handling activating queued queries
/datum/controller/subsystem/dbcore/proc/create_active_query(datum/db_query/query)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	run_query(query)
	queries_active_num++
	queries_active += query
	return query

/datum/controller/subsystem/dbcore/proc/process_query(datum/db_query/query)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(QDELETED(query))
		return FALSE
	if(query.process((TICKS2DS(wait)) / 10))
		queries_active -= query
		return FALSE
	return TRUE

/datum/controller/subsystem/dbcore/proc/run_query_sync(datum/db_query/query)
	run_query(query)
	UNTIL(query.process())
	return query

/datum/controller/subsystem/dbcore/proc/run_query(datum/db_query/query)
	query.job_id = rustg_sql_query_async(connection, query.sql, json_encode(query.arguments))

/datum/controller/subsystem/dbcore/proc/queue_query(datum/db_query/query)
	if (!length(queries_standby) && length(queries_active) < max_concurrent_queries)
		create_active_query(query)
		return

	queries_standby_num++
	queries_standby |= query

/datum/controller/subsystem/dbcore/Recover()
	connection = SSdbcore.connection

/datum/controller/subsystem/dbcore/Shutdown()
	shutting_down = TRUE
	var/msg = "Clearing DB queries standby:[length(queries_standby)] active: [length(queries_active)] all: [length(all_queries)]"
	to_chat(world, SPAN_NOTICE(msg))
	log_subsystem_dbcore(msg)
	//This is as close as we can get to the true round end before Disconnect() without changing where it's called, defeating the reason this is a subsystem
	var/endtime = REALTIMEOFDAY + SHUTDOWN_QUERY_TIMELIMIT
	if(SSdbcore.Connect())
		//Take over control of all active queries
		var/queries_to_check = queries_active.Copy()
		queries_active.Cut()

		//Start all waiting queries
		for(var/datum/db_query/query in queries_standby)
			run_query(query)
			queries_to_check += query
			queries_standby -= query

		//wait for them all to finish
		for(var/datum/db_query/query in queries_to_check)
			UNTIL(query.process() || REALTIMEOFDAY > endtime)

		//log shutdown to the db
		//var/datum/db_query/query_round_shutdown = SSdbcore.NewQuery(
		//	"UPDATE [format_table_name("round")] SET shutdown_datetime = Now(), end_state = :end_state WHERE id = :round_id",
		//	list("end_state" = SSticker.end_state, "round_id" = GLOB.round_id),
		//	TRUE
		//)
		//query_round_shutdown.Execute(FALSE)
		//qdel(query_round_shutdown)

	msg = "Done clearing DB queries standby:[length(queries_standby)] active: [length(queries_active)] all: [length(all_queries)]"
	to_chat(world, SPAN_NOTICE(msg))
	log_subsystem_dbcore(msg)
	if(IsConnected())
		Disconnect()

//nu
/datum/controller/subsystem/dbcore/can_vv_get(var_name)
	if(var_name == NAMEOF(src, connection))
		return FALSE
	if(var_name == NAMEOF(src, all_queries))
		return FALSE
	if(var_name == NAMEOF(src, queries_active))
		return FALSE
	if(var_name == NAMEOF(src, queries_standby))
		return FALSE
	if(var_name == NAMEOF(src, processing_queries))
		return FALSE

	return ..()

/datum/controller/subsystem/dbcore/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, connection))
		return FALSE
	if(var_name == NAMEOF(src, all_queries))
		return FALSE
	if(var_name == NAMEOF(src, queries_active))
		return FALSE
	if(var_name == NAMEOF(src, queries_standby))
		return FALSE
	if(var_name == NAMEOF(src, processing_queries))
		return FALSE
	return ..()

/// Loads the DB Configuration from the config/dbconfig.txt - To be replaced with a config subsystem at some point
/datum/controller/subsystem/dbcore/proc/GetDBConfig()
	var/list/data = list(
		"address"="localhost",
		"port"="3306",
		"database"="aurorastation",
		"login",
		"password",
		"query_timeout_async"="10",
		"query_timeout_blocking"="5",
		"min_sql_connections"="1",
		"max_sql_connections"="25",
		"max_concurrent_queries"="25"
		)

	var/list/Lines = file2list("config/dbconfig.txt")

	if (!Lines)
		// Return dummy object for safety.
		return new/DBConnection()

	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		name = lowertext(copytext(t, 1, pos))
		value = copytext(t, pos + 1)

		if (!name)
			continue

		if (name in data)
			data[name] = value
		else
			log_subsystem_dbcore("Unknown setting while setting up database connection. Filename: 'config/dbconfig.txt', value: '[value]'.")

	return data

/// Establish a Connection with the Database if we are not already connected
/datum/controller/subsystem/dbcore/proc/Connect()
	if(IsConnected())
		return TRUE

	if(connection)
		Disconnect() //clear the current connection handle so isconnected() calls stop invoking rustg
		connection = null //make sure its cleared even if runtimes happened

	if(failed_connection_timeout <= world.time) //it's been long enough since we failed to connect, reset the counter
		failed_connections = 0
		failed_connection_timeout = 0

	if(failed_connection_timeout > 0)
		return FALSE

	if(!GLOB.config.sql_enabled)
		return FALSE

	//Just re-use the old db config file. //We might port the configuration subsystem from tg in the future, then that can be done better..
	var/list/dbconfig = GetDBConfig()


	var/user = dbconfig["login"]
	var/pass = dbconfig["password"]
	var/db = dbconfig["database"]
	var/address = dbconfig["address"]
	var/port = text2num(dbconfig["port"])
	var/timeout = max(text2num(dbconfig["query_timeout_async"]), text2num(dbconfig["query_timeout_blocking"]))
	var/min_sql_connections = text2num(dbconfig["min_sql_connections"])
	var/max_sql_connections = text2num(dbconfig["max_sql_connections"])

	var/result = json_decode(rustg_sql_connect_pool(json_encode(list(
		"host" = address,
		"port" = port,
		"user" = user,
		"pass" = pass,
		"db_name" = db,
		"read_timeout" = timeout,
		"write_timeout" = timeout,
		"min_threads" = min_sql_connections,
		"max_threads" = max_sql_connections,
	))))
	. = (result["status"] == "ok")
	if (.)
		connection = result["handle"]
	else
		connection = null
		last_error = result["data"]
		log_subsystem_dbcore("Connect() failed | [last_error]")
		++failed_connections
		//If it failed to establish a connection more than 5 times in a row, don't bother attempting to connect for a time.
		if(failed_connections > max_connection_failures)
			failed_connection_timeout_count++
			//basic exponential backoff algorithm
			failed_connection_timeout = world.time + ((2 ** failed_connection_timeout_count) SECONDS)

/// Disconnect from the Database
/datum/controller/subsystem/dbcore/proc/Disconnect()
	failed_connections = 0
	if (connection)
		rustg_sql_disconnect_pool(connection)
	connection = null

/// Check if we have established a DB Connection
/datum/controller/subsystem/dbcore/proc/IsConnected()
	if(!GLOB.config.sql_enabled)
		return FALSE
	if (!connection)
		return FALSE
	return json_decode(rustg_sql_connected(connection))["status"] == "online"

/// Returns the last error message
/datum/controller/subsystem/dbcore/proc/ErrorMsg()
	if(!GLOB.config.sql_enabled)
		return "Database disabled by configuration"
	return last_error

/datum/controller/subsystem/dbcore/proc/ReportError(error)
	last_error = error

/**
 * Creates a new /datum/db_query
 *
 * * sql_query - The Query string to be executed
 * * arguments - The Arguments for the quey
 * * allow_during_shutdown - If the query can be executed during shutdown
 *
 * Returns /datum/db_query
 */
/datum/controller/subsystem/dbcore/proc/NewQuery(sql_query, arguments, allow_during_shutdown=FALSE)
	//If the subsystem is shutting down, disallow new queries
	if(!allow_during_shutdown && shutting_down)
		CRASH("Attempting to create a new db query during the world shutdown")

	return new /datum/db_query(connection, sql_query, arguments)

/**
 * Creates a new /datum/db_query_template
 * The returned template then needs to be Execute()´d to get a /datum/db_query
 *
 * * sql_query - The Query string to be executed
 *
 * Returns /datum/db_query_template
 */
/datum/controller/subsystem/dbcore/proc/NewQueryTemplate(sql_query)
	return new /datum/db_query_template(sql_query)

/// The DB Query Template is used to prepare db queries that are re-used repeatedly
/datum/db_query_template
	var/sql
/**
 * Creates a new query template that can be reused multiple times
 *
 * * sql - The query to be Executed
 *
 */
/datum/db_query_template/New(sql)
	src.sql = sql

/**
 * Executes a new instance of the query with the supplied arguments
 *
 * * arguments - The parameters of the query
 * * allow_during_shutdown - If the query is permited to be executed during shutdown
 *
 */
/datum/db_query_template/proc/Execute(arguments, allow_during_shutdown=FALSE)
	var/datum/db_query/query =  SSdbcore.NewQuery(sql, arguments, allow_during_shutdown)
	return query.Execute()

/datum/db_query
	// Inputs
	var/connection
	var/sql
	var/arguments

	/// The callback to invoke when the query is executed successfully
	var/datum/callback/success_callback
	/// The callback to invoke when the query was not executed successfully
	var/datum/callback/fail_callback

	// Status information
	/// Current status of the query.
	var/status
	/// Job ID of the query passed by rustg.
	var/job_id
	var/last_error
	var/last_activity
	var/last_activity_time

	// Output
	var/list/list/rows
	var/next_row_to_take = 1
	var/affected
	var/last_insert_id

	var/list/item  //list of data values populated by NextRow()

/datum/db_query/New(connection, sql, arguments)
	SSdbcore.all_queries += src
	SSdbcore.all_queries_num++
	Activity("Created")
	item = list()

	src.connection = connection
	src.sql = sql
	src.arguments = arguments

/datum/db_query/Destroy()
	Close()
	SSdbcore.all_queries -= src
	SSdbcore.queries_standby -= src
	SSdbcore.queries_active -= src
	return ..()

/**
 * SetSuccessCallback
 *
 * Sets a callback to be executed if the query completes successfully.
 * The parameter for the callback is this query
 *
 * * success_callback - The callback to be executed
 *
 * Returns `TRUE` if the callback was set successfully
 * Returns `FALSE` if the callback could not be set, because another callback was already set
 */
/datum/db_query/proc/SetSuccessCallback(datum/callback/success_callback)
	if (src.success_callback != null)
		return FALSE

	src.success_callback = success_callback
	return TRUE

/**
 * SetSuccessCallback
 *
 * Sets a callback to be executed if the query fails.
 * The parameter for the callback is this query
 *
 * * fail_callback - The callback to be executed
 *
 * Returns `TRUE` if the callback was set successfully
 * Returns `FALSE` if the callback could not be set, because another callback was already set
 */
/datum/db_query/proc/SetFailCallback(datum/callback/fail_callback)
	if (src.fail_callback != null)
		return FALSE
	src.fail_callback = fail_callback

/// Stores the last activity and the time it happened on the query
/datum/db_query/proc/Activity(activity)
	last_activity = activity
	last_activity_time = world.time

/**
 * warn_execute
 *
 * Execute()'s the query and prints a warning to the chat of the `usr` if it fails
 *
 * * async - Default `TRUE` - See Execute() for a description
 *
 * Returns `TRUE` if the query was successfully executed
 */
/datum/db_query/proc/warn_execute(async = TRUE)
	. = Execute(async)
	if(!.)
		to_chat(usr, SPAN_DANGER("A SQL error occurred during this operation, check the server logs."))

/**
 * Execute
 *
 * Executes the query and waits until the query is successfully executed before return'ing
 * The query can be executed "sync" or "async".
 * If the query is executed async, the query is scheduled by the DBCore and not blocking other operations
 * If the query is executed sync, the query is executed immediately in a blocking manner
 * In case Success/Fail Callbacks are set, they are executed.
 *
 * * async - Default `TRUE`
 *
 * Returns `TRUE` if the query was successfully executed
 */
/datum/db_query/proc/Execute(async = TRUE)
	Activity("Execute")
	if(status == DB_QUERY_STARTED)
		CRASH("Attempted to start a new query while waiting on the old one")

	if(!SSdbcore.IsConnected())
		last_error = "No connection!"
		return FALSE

	var/start_time
	if(!async)
		start_time = REALTIMEOFDAY
	Close()
	status = DB_QUERY_STARTED
	if(async)
		if(!MC_RUNNING(SSdbcore.init_stage))
			SSdbcore.run_query_sync(src)
		else
			SSdbcore.queue_query(src)
		sync()
	else
		var/job_result_str = rustg_sql_query_blocking(connection, sql, json_encode(arguments))
		store_data(json_decode(job_result_str))

	. = (status == DB_QUERY_FINISHED)
	var/timed_out = !. && findtext(last_error, "Operation timed out")
	if(!async && timed_out)
		log_subsystem_dbcore("SLOW QUERY TIMEOUT. Query: [sql], start_time: [start_time], end_time: [REALTIMEOFDAY]")
		slow_query_check()

/**
 * ExecuteNoSleep
 *
 * This executes a query without waiting for the results of the query.
 * This means, that you should not rely on being able to access the results of the query directly after the function call.
 * Instead you need to use the Callbacks, where you can then process the query result.
 *
 * - permit_before_dbcore_running `FALSE` - If set to TRUE allows the query to be queued before the DBCore Subsystem is running (will still only be executed after it is running)
 */
/datum/db_query/proc/ExecuteNoSleep(permit_before_dbcore_running=FALSE)
	Activity("Execute")
	if(status == DB_QUERY_STARTED)
		CRASH("Attempted to start a new query while waiting on the old one")

	if(!SSdbcore.IsConnected())
		last_error = "No connection!"
		return FALSE

	Close()
	status = DB_QUERY_STARTED
	if(!MC_RUNNING(SSdbcore.init_stage) && !permit_before_dbcore_running)
		status = DB_QUERY_BROKEN
		last_error = "MC not running, Cant Execute NoSleep Query"
		log_subsystem_dbcore("Attemted to Execute NoSleep Query while MC was not running: [sql], Arguments: [json_encode(arguments)], error: [last_error]")
		return FALSE
	else
		SSdbcore.queue_query(src)
		return TRUE

/// Sleeps until execution of the query has finished.
/datum/db_query/proc/sync()
	while(status < DB_QUERY_FINISHED)
		stoplag()

/**
 * process
 *
 * Invoked by the DBcore Subsystem
 * Checks if the query has been completed.
 * Stores the results of the query in the /datum/db_query
 * Calls invoke_callback()
 * And logs failed queries
 *
 * Returns `TRUE` if the query finished (successful or not)
 */
/datum/db_query/process(seconds_per_tick)
	if(status >= DB_QUERY_FINISHED)
		return TRUE // we are done processing after all

	status = DB_QUERY_STARTED
	var/job_result = rustg_sql_check_query(job_id)
	if(job_result == RUSTG_JOB_NO_RESULTS_YET)
		return FALSE //no results yet

	store_data(json_decode(job_result))
	invoke_callback()
	if (status != DB_QUERY_FINISHED)
		log_subsystem_dbcore("SQL Query Failed. Query: [sql], Arguments: [json_encode(arguments)], error: [last_error]")
	return TRUE

/// Stores the returned query data and updates the `status` of the /datum/db_query
/datum/db_query/proc/store_data(result)
	switch(result["status"])
		if("ok")
			rows = result["rows"]
			affected = result["affected"]
			last_insert_id = result["last_insert_id"]
			status = DB_QUERY_FINISHED
			return
		if("err")
			last_error = result["data"]
			status = DB_QUERY_BROKEN
			return
		if("offline")
			last_error = "CONNECTION OFFLINE"
			status = DB_QUERY_BROKEN
			return

/// Invokes the appropriate query callback if set
/datum/db_query/proc/invoke_callback()
	if (status == DB_QUERY_FINISHED)
		if (success_callback)
			success_callback.InvokeAsync(src)
	else
		if (fail_callback)
			fail_callback.InvokeAsync(src)

/// Messages the admin on sync queries to ask if the server just hung
/datum/db_query/proc/slow_query_check()
	message_admins("HEY! A database query timed out. Did the server just hang? <a href='?_src_=holder;slowquery=yes'>\[YES\]</a>|<a href='?_src_=holder;slowquery=no'>\[NO\]</a>")

/// Load the NextRow from the query data into the item variable of the /datum/db_query
/datum/db_query/proc/NextRow(async = TRUE)
	Activity("NextRow")

	if (rows && next_row_to_take <= rows.len)
		item = rows[next_row_to_take]
		next_row_to_take++
		return !!item
	else
		return FALSE

/datum/db_query/proc/ErrorMsg()
	return last_error

/// Deletes the Rows and Items from the Query
/datum/db_query/proc/Close()
	rows = null
	item = null
#undef SHUTDOWN_QUERY_TIMELIMIT
