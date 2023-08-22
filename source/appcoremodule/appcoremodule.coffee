############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
import * as S from "./statemodule.js"

############################################################
import * as contentModule from "./contentmodule.js"
import * as rewardModule from "./rewardmodule.js"

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return


############################################################
export startUp = ->
    log "startUp"
    # update everything which needs date from allRewards
    S.callOutChange("allRewards")
    
    goHome()
    return

############################################################
#region menu called functions

############################################################
export goHome = ->
    log "goHome"
    rewardInfo = rewardModule.getInfo()
    if rewardInfo.allRewards.length > 0 then contentModule.setStateToRewardsList()
    else contentModule.setStateToWelcome()
    return

############################################################
export configureAccount = ->
    log "configureAccount"
    contentModule.setStateToConfigureAccount()
    return

############################################################
export createNewReward = ->
    log "createNewReward"
    rewardModule.prepareEditNewReward()    
    contentModule.setStateToConfigureReward()
    return

############################################################
export configureReward = (index) ->
    log "configureReward"
    rewardModule.prepareEditReward(index)
    contentModule.setStateToConfigureReward()
    return

############################################################
export selectReward = (index) ->
    log "selectReward"
    ## TODO implement
    return

############################################################
export logout = ->
    log "logout"
    # Notice: here we already checked if the user really wants to log out
    rewardModule.deleteAll()
    contentModule.setStateToWelcome()
    return

#endregion