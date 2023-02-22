function start_scheduler()

    db = read_schedule_db()

    # loop forever
    # and execute one trigger per loop, if one is due
    #
    interval = 60  # sec
    while true

        global action_channel

        # add actions to db:
        # read from channel, until empty:
        #
        if isready(action_channel)
            action = take!(actionChannel)
            print_debug("action from Channel: $action")

            if action[:type] in ["command", "intent"] 
                add_action_to_db(action)
            elseif action[:type] == "delete all"
                del_all_actions_from_db()
            elseif action[:type] == "delete origin"
                del_actions_by_origin(action[:customData])
            #elseif action[:type] == "delete topic"
            #    del_actions_by_topic!(db, action[:customData])
            end 
        end

        # exec oldest action since last iteration
        #
        
        db = db_read_entry(DB_KEY)
        actions = db[DB_KEY_ACTIONS]
        if length(actions) > 0 && is_due(actions[1])
            next_action = deepcopy(actions[1])
            run_action(next_action)
            deleteat!(1, actions)
        end

        sleep(interval)
    end
end


function is_due(action)
    return DateTime(action[:exec_time]) < now()
end

function run_action(action)

    if action[:type] == "command"
        print_debug("run_action: command: $(action[:customData])")
        run_command(action[:customData])
    elseif action[:type] == "intent"
        print_debug("run_action: intent: $(action[:customData])")
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
