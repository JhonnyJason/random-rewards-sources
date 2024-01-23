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
    return nav.clearNavTree()

export menu = (menuOn) ->
    log "triggerMenu #{menuOn}"    
    if menuOn then return nav.navigateModifier("menu")
    else return nav.navigateModifier("none")

############################################################
export configureAccount = ->
    log "configureAccount"
    return nav.navigateBaseState("configure-account")

############################################################
export selectReward = (context) ->
    log "selectReward"
    # return nav.navigateBaseState("-reward") ##TODO

############################################################
export logout = ->
    log "logout"
    return nav.navigateModifier("logoutconfirmation")

#endregion

############################################################
#region Reward Action Triggers

export createReward = ->
    log "createReward"
    return nav.navigateBaseState("configure-reward")    

export editReward = (context) ->
    log "editReward"
    return nav.navigateBaseStateAt("configure-reward", context, 1)

export deleteReward = (context) ->
    log "deleteReward"
    return nav.navigateModifier("deleteconfirmation", context)

export editRewardOption = (context) ->
    log "editRewardOption"
    return nav.navigateModifier("editoption", context)    


#endregion