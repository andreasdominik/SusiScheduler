#
# The main file for the App.
#
# DO NOT CHANGE THIS FILE UNLESS YOU KNOW
# WHAT YOU ARE DOING!
#
module SusiScheduler

using Dates

const MODULE_NAME = @__MODULE__
const MODULE_DIR = @__DIR__
const APP_DIR = dirname(MODULE_DIR)
const SKILLS_DIR = dirname(APP_DIR)
const APP_NAME = basename(APP_DIR)

using HermesMQTT
Susi = HermesMQTT

# List of intents to listen to:
# (intent, topic, module, skill-action)
#
SKILL_INTENT_ACTIONS = Tuple{AbstractString, AbstractString, 
                             Module, Function}[]

Susi.load_skill_config(APP_DIR, skill=APP_NAME)

Susi.set_module(MODULE_NAME)
Susi.set_appdir(APP_DIR)
Susi.set_appname(APP_NAME)


include("scheduler.jl")
include("exported.jl")
include("api.jl")
include("skill-actions.jl")
include("config.jl")
read_language_sentences(APP_DIR)

const DB_KEY = :SusiScheduler
const DB_KEY_ACTIONS = :actions

# mask the following functions:
#
get_config(name; multiple=false, one_prefix=nothing) =
    HermesMQTT.get_config_skill(name; multiple=multiple, one_prefix=one_prefix, skill=APP_NAME)
is_in_config(name; one_prefix=nothing) = 
    HermesMQTT.is_in_config_skill(name; skill=APP_NAME, one_prefix=one_prefix)           
match_config(name, val::AbstractString; one_prefix=nothing) = 
    HermesMQTT.match_config_skill(name, val; skill=APP_NAME, one_prefix=one_prefix)
 
print_log(s) = HermesMQTT.print_log_skill(s; skill=APP_NAME)
print_debug(s) = HermesMQTT.print_debug_skill(s; skill=APP_NAME)


action_channel = Channel(128)
@async start_scheduler()

export 
get_intent_actions, register_intent_action, register_on_off_action,
callback_run

end

