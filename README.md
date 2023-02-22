# SusiScheduler.jl

This voice assistant skill is part of the HermesMQTT framework for 
Snips/Rhasspy-like voice assistants. It adds schedule functionality to 
the voice assistant.

The skill do *not* provide any user frontend. It provides intents to register commands
or intents to be executed at a specific time. The scheduler will then publish the
registered command or intent to the MQTT bus at the requested time.


For details, please see the [documentation](https://andreasdominik.github.io/HermesMQTT.jl).

## Installation

The skill is installed by the HermesMQTT-installer as 
part of the framework.


## Intents

### Scheduler:AddAction

This intent will add an Action to the Scheduler.
MQTT-payload is a JSON with struct:
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
If `type` is `intent`, the intent will be published, 
if `type` is `command`,
the command will publised to the NLU as plain text 
(such as *"play the Moolight Sonata in the bedroom 
at 7 o'clock in the morning"*).


### Scheduler:DeleteAll

Delete all scheduled actions.


### Scheduler:DeleteOrigin

Delete all schedules for a given origin (i.e. skill that created 
the scheduled action).