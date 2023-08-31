############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
#region Imported Modules

############################################################
import * as S from "./statemodule.js"
import * as nav from "./navmodule.js"

############################################################
import * as menuModule from "./menumodule.js"
import * as contentModule from "./contentmodule.js"
import * as rewardModule from "./rewardmodule.js"

#endregion

############################################################
#region Internal Variables

############################################################
startUpProcessed = false

############################################################
appUIBaseState = "no-rewards"
appUIModfier = "none"

############################################################
appUIRootState = "no-rewards"

#endregion

############################################################
export initialize = ->
    log "initialize"
    S.addOnChangeListener("navState", navStateChanged)
    S.addOnChangeListener("allRewards", rewardsChanged)
    return

############################################################
#region Event Listeners

############################################################
navStateChanged = ->
    ## prod log "navStateChanged"
    navState = S.get("navState")
    olog navState
    baseState = navState.base
    modifier = navState.modifier
    context = navState.ctx

    if !startUpProcessed then await startUp()

    ########################################
    switch baseState
        when "RootState" then baseState = appUIRootState
        when "configure-reward" 
            if typeof context == "number" then rewardModule.prepareEditReward(context)
            else rewardModule.prepareEditNewReward()
        # when "configure-account" then ##TODO

    if modifier == "logoutconfirmation" then startConfirmLogoutProcess()
    
    ########################################
    setAppState(baseState, modifier)    
    return

############################################################
rewardsChanged = ->
    log "rewardsChanged"
    determineRootState()
    updateUIData()
    return

#endregion

############################################################
#region Helper Functions

############################################################
setAppState = (base, mod) ->
    log "setAppState"
    if base then appUIBaseState = base
    if mod then appUIModfier = mod

    log "#{appUIBaseState}:#{appUIModfier}"
    S.set("uiState", "#{appUIBaseState}:#{appUIModfier}")
    return

############################################################
startUp = ->
    log "startUp"
    determineRootState()
    updateUIData()
    ## Check: is there more to be done here?
    startUpProcessed = true
    return

############################################################
determineRootState = ->
    log "determineRootState"
    allRewards = S.get("allRewards")

    if !Array.isArray(allRewards) or allRewards.length == 0
        appUIRootState = "no-rewards"
        return

    if allRewards.length == 1
        appUIRootState = "one-reward"
        return

    appUIRootState = "many-rewards"        
    return

updateUIData = ->
    log "updateUIData"
    menuModule.updateRewards()
    rewardModule.updateRewardsList()
    return

############################################################
startConfirmLogoutProcess = ->
    log "startConfirmLogoutProcess"
    try
        await logoutmodal.userConfirmation()
        rewardModule.deleteAll()
        triggerHome()
    catch err then log err
    return

#endregion

############################################################
#region User Action Triggers

export triggerHome = ->
    log "triggerHome"
    # setAppState(appUIRootState, "none")
    await nav.backToRoot()
    # rewardInfo = rewardModule.getInfo()
    # if rewardInfo.allRewards.length > 0 then 
    # else contentModule.setStateToWelcome()
    return

export triggerMenu = (menuOn) ->
    log "triggerMenu"
    if menuOn? and menuOn and appUIModfier == "menu" then return
    if menuOn? and !menuOn and appUIModfier != "menu" then return
    
    if menuOn? and menuOn and appUIModfier != "menu"
        await nav.addModification("menu")
        return

    if menuOn? and !menuOn and appUIModfier == "menu"
        await nav.unmodify()
        return

    ## No specific hint if turning menu on or off -> toggle
    if appUIModfier == "menu" then await nav.unmodify()
    else await nav.addModification("menu")
    return

############################################################
export triggerAccountConfiguration = ->
    log "triggerAccountConfiguration"
    await nav.addStateNavigation("configure-account")
    return

export triggerRewardCreation = ->
    log "triggerRewardCreation"
    await nav.addStateNavigation("configure-reward")    
    return

export triggerRewardConfiguration = (index) ->
    log "triggerRewardConfiguration"
    await nav.addStateNavigation("configure-reward", index)    
    return

export triggerRewardSelection = (index) ->
    log "triggerRewardSelection"
    # await nav.addStateNavigation("-reward")##TODO
    return

############################################################
export triggerLogout = ->
    log "triggerLogout"
    await nav.addModification("logoutconfirmation")
    return


#endregion