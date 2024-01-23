############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
#region Imported Modules

############################################################
import * as S from "./statemodule.js"
import * as nav from "./navhandler.js"
import * as uiState from "./uistatemodule.js"

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
appUIBaseState = "no-rewards"
appUIModfier = "none"

############################################################
appUIRootState = "no-rewards"

#endregion

############################################################
export initialize = ->
    log "initialize"
    nav.initialize(loadAppWithNavState, setNavState)
    S.addOnChangeListener("allRewards", rewardsChanged)
    return

############################################################
#region functions exposed to navmodule

export loadAppWithNavState = (navState) ->
    log "loadAppWithNavState"
    baseState = navState.base
    modifier = navState.modifier
    context = navState.ctx

    await startUp()

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

export setNavState = (navState) ->
    log "setNavState"
    baseState = navState.base
    modifier = navState.modifier
    context = navState.ctx

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
#region Event Listeners

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
    uiState.applyUIState(base, mod)
    return

############################################################
startUp = ->
    log "startUp"
    determineRootState()
    updateUIData()
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
#region User Interaction Processes
startConfirmLogoutProcess = ->
    log "startConfirmLogoutProcess"
    try
        setAppState("", "logoutconfirmation")
        await logoutModal.userConfirmation()
        rewardModule.deleteAll()
        await nav.backToRoot()
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
        await nav.backToRoot()
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

#endregion