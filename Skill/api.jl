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

function mk_action_delete_today()
   
    return Dict(
        :type => "delete today",
        :customData => ""
    )
end


# add an action to the status database:
#
function add_action_to_db(action)

    db = db_read_entry(DB_KEY)
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

function del_actions_by_today()
        
    db = db_read_entry(DB_KEY)
    db[DB_KEY_ACTIONS] = filter(x->Date(Dates.DateTime(x[:exec_time])) == Dates.today(),
                            db[DB_KEY_ACTIONS])
    db_write_entry(DB_KEY, db)
end


# Add a new weather record to db if, the last record is older than 1 hour:
# old records are deleted.
# The entries are added in key "SusiWeatherHistory" in the db.
#
# JSON of key :SusiWeather is:
# "times" => [time1, time2, ...]
# "comment" => "Weather history"
#
# Each time is a record from HermesMQTT.get_weather()
#
function add_weather_history_to_db()

    
    weather_history = db_read_value(:SusiWeather, :times)
    if isnothing(weather_history)
        weather_history = []
    end

    # sort a dictionary by key (newest last):
    #
    sort!(weather_history, by=x->x[:time])
    # println("weather_history: $(weather_history)")
    
    # do nothing, if last record is less than 1 hour old:
    #
    if length(weather_history) > 0
        last = weather_history[end]
        if Dates.DateTime(last[:time]) > Dates.DateTime(now() - Dates.Hour(1))
            return
        end
    end


    # remove unneeded history:
    # hist fom config.ini or default = 7 days
    #
    history_len = get_config_skill(INI_WEATHER_DAYS, skill="HermesMQTT")

    if !isnothing(history_len)
        history_len = tryparse(Int, history_len)
    end
    if isnothing(history_len)
        history_len = 7
    end
    old = Dates.DateTime(Dates.now() - Dates.Day(history_len)) |> string

    filter!(x->x[:time]>old, weather_history)

    # add new record:
    #
    weather = HermesMQTT.get_weather()
    if !isnothing(weather)
        push!(weather_history, weather)
        db_write_value(:SusiWeather, :times, weather_history)
    end
end




