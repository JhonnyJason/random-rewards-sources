############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("navtriggers")
#endregion

############################################################
import * as nav from "./navhandler.js"

############################################################
## User Action Triggers = Navigation Action Triggers

############################################################
#region Menu Action Triggers

export home = ->
    log "triggerHome"
    return nav.toRoot(true)

export menu = (menuOn) ->
    log "triggerMenu #{menuOn}"    
    if menuOn then return nav.toMod("menu")
    else return nav.toMod("none")

############################################################
export configureAccount = ->
    log "configureAccount"
    return nav.toBaseAt("configure-account", null, 1)

############################################################
export selectReward = (context) ->
    log "selectReward"
    # return nav.toBase("-reward") ##TODO

############################################################
export logout = ->
    log "logout"
    return nav.toMod("logoutconfirmation")

#endregion

############################################################
#region Reward Action Triggers

export createReward = ->
    log "createReward"
    return nav.toBaseAt("configure-reward", null, 1)    

export editReward = (context) ->
    log "editReward"
    return nav.toBaseAt("configure-reward", context, 1)

export deleteReward = (context) ->
    log "deleteReward"
    return nav.toMod("deleteconfirmation", context)

export editRewardOption = (context) ->
    log "editRewardOption"
    return nav.toMod("editoption", context)    

#endregion