#
# actions called by the main callback()
# provide one function for each intent, defined in the Snips/Rhasspy
# console.
#
# ... and link the function with the intent name as shown in config.jl
#
# The functions will be called by the main callback function with
# 2 arguments:
# + MQTT-Topic as String
# + MQTT-Payload (The JSON part) as a nested dictionary, with all keys
#   as Symbols (Julia-style).
#




"""
    Scheduler_AddAction_action(topic, payload)

This intent will add an Action to the Scheduler.
Payload is a JSON with struct:
```
{
    "intent": "Scheduler:AddAction",
    "action": "add action",
    "siteId": "default",
    "sessionId": "1234567890",
    "type": "intent", # or "command",
    "exec_time": "2020-01-01 00:00:00",
    "origin" : "SusiWakeUp", 
    "customData": intent as JSON or command as string
}
```
The command or intend will be scheduled for execution at the given time.
If `type` is `intent`, the intent will be published, if `type` is `command`,
the command will publised to the NLU as plain text 
(e.g. *"play the Moolight Sonata in the bedroom at 2020-01-01 06:00:00"*).
"""
function Scheduler_AddAction_action(topic, payload)


    print_log("action Scheduler_AddAction_action() started.")

    if payload[:type] == "intent"
        action = mk_action_intent(payload[:customData], payload[:exec_time], payload[:origin])
    elseif payload[:type] == "command"
        action = mk_action_cmd(payload[:customData], payload[:exec_time], payload[:origin])
    else
        print_log("ERROR: Unknown action type for Scheduler: $(payload[:type])")
        return false
    end

print_log(">>> action->channel: $action")
    put!(action_channel, action)
    return true
end


"""
    Scheduler_DeleteAll_action(topic, payload)

Delete all scheduled actions.
"""
function Scheduler_DeleteAll_action(topic, payload)

    global action_channel
    print_log("action Scheduler_DeleteAll_action() started.")

    action = mk_action_delete_all()
    put!(action_cannel, action)
    return true
end




"""
    Scheduler_DeleteOrigin_action(topic, payload)

Delete all schedules for a given origin.
"""
function Scheduler_DeleteOrigin_action(topic, payload)

    global action_channel
    print_log("action Scheduler_DeleteOrigin_action() started.")
    
    action = mk_action_delete_origin(payload[:origin])
    put!(action_cannel, action)
    return true
end




"""
    Scheduler_DeleteTopic_action(topic, payload)

Delete all schedules for a given topic.
"""
function Scheduler_DeleteTopic_action(topic, payload)

    global action_channel
    print_log("action Scheduler_DeleteTopic_action() started.")
    
    action = mk_action_delete_topic(payload[:topic])
    put!(action_cannel, action)
    return true
end
