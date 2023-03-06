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
# get_config(name; multiple=false, one_prefix=nothing, skill=SusiScheduler) =
#     Susi._get_config(name; multiple=multiple, one_prefix=one_prefix, skill=skill)
# 
# match_config(name, val::String; skill=SusiScheduler) =
#     Susi._match_config(name, val; skill=skill)
# 
# is_in_config(name; skill=SusiScheduler) =
#     Susi._is_in_config(name; skill=skill)
# 
# print_log()
# print_debug()

action_channel = Channel(128)
@async start_scheduler()

export 
get_intent_actions, register_intent_action, register_on_off_action,
callback_run

end

