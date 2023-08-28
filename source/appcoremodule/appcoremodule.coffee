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
startUpProcessed = false

############################################################
appUIBaseState = "no-rewards"
appUIModfier = "none"

############################################################
export initialize = ->
    log "initialize"
    S.addOnChangeListener("navState", navStateChanged)
    return


############################################################
startUp = ->
    log "startUp"
    # update everything which needs date from allRewards
    S.callOutChange("allRewards")
    goHome()
    startUpProcessed = true
    return

navStateChanged = ->
    ## prod log "navStateChanged"
    {base, modifier} = S.get("navState")
    olog { base, modifier }

    if !startUpProcessed then await startUp()

    ########################################
    # Apply States
    setAppState(base, modifier)
    # switch base
    #     when "" then setAppState(base, modifier)
    #     when "" then setAppState(base, modifier)
    
    return

setAppState = (base, mod) ->
    ## prod log "setAppState"
    if base then appUIBaseState = base
    if mod then appUIModfier = mod

    ## prod log "#{appUIBaseState}:#{appUIModfier}"
    S.set("uiState", "#{appUIBaseState}:#{appUIModfier}")
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