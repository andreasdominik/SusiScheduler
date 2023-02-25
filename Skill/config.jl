# DO NOT CHANGE THE FOLLOWING 3 LINES UNLESS YOU KNOW
# WHAT YOU ARE DOING!
# set CONTINUE_WO_HOTWORD to true to be able to chain
# commands without need of a hotword in between:
#
const CONTINUE_WO_HOTWORD = false

# set a local const LANG:
#
const LANG = "de"



# Slots:
# Name of slots to be extracted from intents:
#


# name of entries in config.ini:
#

#
# link between actions and intents:
# intent is linked to action{Funktion}
# the action is only matched, if
#   * intentname matches and
#   * if the siteId matches, if site is  defined in config.ini
#     (such as: "switch TV in room abc").
#
# Susi.register_intent_action("TEMPLATE_SKILL", TEMPLATE_INTENT_action)
# Susi.register_on_off_action(TEMPLATE_INTENT_action)
register_intent_action("Scheduler:AddAction", Scheduler_AddAction_action)
register_intent_action("Scheduler:DeleteAll", Scheduler_DeleteAll_action)
register_intent_action("Scheduler:DeleteOrigin", Scheduler_DeleteOrigin_action)
register_intent_action("Scheduler:DeleteTopic", Scheduler_DeleteTopic_action)
