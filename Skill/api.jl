#
# API function goes here, to be called by the
# skill-actions (and trigger-actions):
#

# make an action JSON-object with a command:
#
function mk_action_cmd(command, exec_time, origin)
   
    return Dict(
        :type => "command",
        :origin => origin,
        :exec_time => exec_time,
        :customData => command
    )
end


# make an action JSON-object with an intent:
#
function mk_action_intent(intent, exec_time, origin)
   
    return Dict(
        :type => "intent",
        :origin => origin,
        :exec_time => exec_time,
        :customData => intent
    )
end


function mk_action_delete_all()
   
    return Dict(
        :type => "delete all",
        :customData => ""
    )
end


function mk_action_delete_origin(origin)
   
    return Dict(
        :type => "delete origin",
        :customData => origin
    )
end

function mk_action_delete_topic(topic)
   
    return Dict(
        :type => "delete topic",
        :customData => topic
    )
end


# add an action to the status database:
#
function add_action_to_db(action)

    db = db_read_entry(DB_KEY)
println(">>> db = $db")
    if isnothing(db)
        db = Dict(:comment => "Scheduled actions", DB_KEY_ACTIONS => [])
    end
    push!(db[DB_KEY_ACTIONS], action)
    sort!(db[DB_KEY_ACTIONS], by=x->x[:exec_time])
    db_write_entry(DB_KEY, db)
end


function del_all_actions_from_db()
    
    db = db_read_entry(DB_KEY)
    empty!(db[DB_KEY_ACTIONS])
    db_write_entry(DB_KEY, db)
end
    

function del_actions_by_origin(origin)
        
    db = db_read_entry(DB_KEY)
    db[DB_KEY_ACTIONS] = filter(x->x[:origin] != origin, db[DB_KEY_ACTIONS])
    db_write_entry(DB_KEY, db)
end


function del_actions_by_topic(topic)
        
    db = db_read_entry(DB_KEY)
    db[DB_KEY_ACTIONS] = filter(x->(x[:type] != "intent" && x[:customData][:intent][:intentName] == topic), db[DB_KEY_ACTIONS])
    db_write_entry(DB_KEY, db)
end

