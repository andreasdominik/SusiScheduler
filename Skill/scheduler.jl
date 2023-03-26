function start_scheduler()

    # loop forever
    # and execute one trigger per loop, if one is due
    #
    interval_exec = 5  # sec
    interval_wait = 60  # sec
    while true

        global action_channel

        # add a record of weather history to db:
        #
        add_weather_history_to_db()

println(">>> scheduler loop")
        # add actions to db:
        # read from channel, until empty:
        #
        while isready(action_channel)
            action = take!(action_channel)

            if action[:type] == "delete all"
                del_all_actions_from_db()
            elseif action[:type] == "delete origin"
                del_actions_by_origin(action[:customData])
            elseif action[:type] in ["command", "intent"]
                add_action_to_db(action)
            #elseif action[:type] == "delete topic"
            #    del_actions_by_topic!(db, action[:customData])
            end 
        end

        # exec oldest action since last iteration
        #
        db = db_read_entry(DB_KEY)
        while !isnothing(db) && db isa Dict &&
              haskey(db, DB_KEY_ACTIONS) &&
              length(db[DB_KEY_ACTIONS]) > 0 && 
              is_due(db[DB_KEY_ACTIONS][1])

           next_action = deepcopy(db[DB_KEY_ACTIONS][1])
           run_action(next_action)
           deleteat!(db[DB_KEY_ACTIONS], 1)
           db_write_entry(DB_KEY, db)
           sleep(interval_exec)
        end

        sleep(interval_wait)
    end
end


function is_due(action)
    return Dates.DateTime(action[:exec_time]) < now()
end

function run_action(action)

    if action[:type] == "command"
        run_command(action[:customData])
    elseif action[:type] == "intent"
        run_intent(action[:customData])
    else
        print_log("ERROR: Unknown action type for Scheduler: $(action[:type])")
    end
end


function run_command(command)

    publish_nlu_query(command)
end


function run_intent(payload)

    publish_intent(payload)
    
end
