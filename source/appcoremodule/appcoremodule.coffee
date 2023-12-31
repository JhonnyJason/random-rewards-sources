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
import * as rewardsList from "./rewardslistmodule.js"
import * as rewardConfiguration from "./rewardconfigurationmodule.js"

############################################################
import * as deleteModal from "./deletemodal.js"
import * as judgeModal from "./judgemodal.js"
import * as logoutModal from "./logoutmodal.js"
import * as optiondeleteModal from "./optiondeletemodal.js"
import * as optioneditModal from "./optioneditmodal.js"

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

navStateChanged = ->
    log "navStateChanged"
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
            if context? then index = parseInt(context.editIndex)
            else index = NaN
            if Number.isNaN(index) then rewardConfiguration.newReward()
            else rewardConfiguration.editReward(index)
        # when "configure-account" then ##TODO
        

    switch modifier
        when "logoutconfirmation" then startConfirmLogoutProcess()
        when "deleteconfirmation" then startRewardDeletionProcess(context)
        when "editoption"
            if context.optionObj? then startRewardOptionEditProcess(context)
            else startRewardOptionAddProcess(context)

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
    rewardsList.updateRewards()
    return

############################################################
startConfirmLogoutProcess = ->
    log "startConfirmLogoutProcess"
    try
        setAppState("", "logoutconfirmation")
        await logoutModal.userConfirmation()
        rewardModule.deleteAll()
        triggerHome()
    catch err #then await nav.unmodify()
        log err
        await nav.unmodify()
    return

startRewardDeletionProcess = (context) ->
    log "startRewardDeletionProcess"
    try
        cObj = {}
        cObj.label = context.editObj.name
        setAppState("", "deleteconfirmation")
        await deleteModal.userConfirmation(cObj)
        rewardModule.finalizeDeletion()
        triggerHome()

    catch err #then await nav.unmodify()
        log err
        await nav.unmodify()
    return

startRewardOptionAddProcess = ->
    log "startRewardOptionAddProcess"
    try  
        setAppState("", "editoption")   
        optionObj = await optioneditModal.userCreate()
        rewardModule.addNewRewardOption(optionObj)
    catch err then log err
    finally await nav.unmodify()
    return

startRewardOptionEditProcess = (context) ->
    log "startRewardOptionEditProcess"
    index = parseInt(context.optionIndex)
    if Number.isNaN(index) then throw new Error("on startRewardOptionEditProcess: optionIndex isNaN!")
    try  
        setAppState("", "editoption")   
        optionObj = await optioneditModal.userEdit(context.optionObj)
        rewardModule.finalizeRewardOptionEdit(index, optionObj)
    catch err then log err
    finally await nav.unmodify()
    return

startRewardOptionAddProcess = (context) ->
    log "startRewardOptionAddProcess"
    try  
        setAppState("", "editoption")   
        optionObj = await optioneditModal.userCreate()
        rewardModule.addNewRewardOption(optionObj)
    catch err then log err
    finally await nav.unmodify()
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

export triggerRewardDeletion = (rewardContext) ->
    log "triggerRewardDeletion"
    await nav.addModification("deleteconfirmation", rewardContext)
    return

export triggerRewardOptionEdit = (rewardOptionContext) ->
    log "triggerRewardOptionEdit"
    await nav.addModification("editoption", rewardOptionContext)    
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