############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
import * as app from "./appcoremodule.js"

############################################################
#region DOM Cache
addNewRewardButton = document.getElementById("add-new-reward-button")
mainElement = document.getElementsByTagName("main")[0]
#endregion

############################################################
lastContentClick = 0
contentIsLarge = false

#############################################################
currentState = "welcome"

############################################################
export initialize = ->
    log "initialize"
    addNewRewardButton.addEventListener("click", addNewRewardClicked)
    mainElement.addEventListener("click", contentClicked)
    return

############################################################
addNewRewardClicked = (evnt) ->
    log "addNewRewardClicked"
    app.createReward()
    return

contentClicked = (evnt) ->
    # log "contentClicked"
    # log lastContentClick
    currentContentClick = performance.now()
    delta = currentContentClick - lastContentClick
    lastContentClick = currentContentClick
    if delta < 400 then doubleClickHappened()
    return

############################################################
doubleClickHappened = ->
    # log "doubleClickHappened"
    lastContentClick = 0
    contentIsLarge = !contentIsLarge # toggle

    if contentIsLarge then realBody.classList.add("large-content")
    else realBody.classList.remove("large-content")

    return

############################################################
resetAllStateClasses = ->
    log "resetAllStateClasses"
    mainElement.classList.remove("welcome")
    mainElement.classList.remove("rewards-list")
    mainElement.classList.remove("reward-inactive")
    content.classList.remove("reward-unjudged")
    mainElement.classList.remove("reward-judgement-overlay")
    mainElement.classList.remove("reward-active")
    mainElement.classList.remove("configure-account")
    mainElement.classList.remove("configure-reward")
    return
    
############################################################
#region UI State Manipulation

export setStateToWelcome = ->
    log "setStateToWelcome"
    resetAllStateClasses()

    currentState = "welcome"
    mainElement.classList.add(currentState)
    return

export setStateToRewardsList = ->
    log "setStateToRewardsList"
    resetAllStateClasses()

    currentState = "rewards-list"
    mainElement.classList.add(currentState)
    return

export setStateOneReward = ->
    log "setStateOneReward"
    resetAllStateClasses()
    return

export setStateToRewardInactive = ->
    log "setStateToRewardInactive"
    resetAllStateClasses()

    currentState = "reward-inactive"
    mainElement.classList.add(currentState)
    return

export setStateToRewardUnjudged = ->
    log "setStateToRewardUnjudged"
    resetAllStateClasses()

    currentState = "reward-unjudged"
    mainElement.classList.add(currentState)
    return

export setStateToRewardJudgementOverlay = ->
    log "setStateToRewardJudgementOverlay"
    resetAllStateClasses()

    currentState = "reward-judgement-overlay"
    mainElement.classList.add(currentState)
    return

export setStateToRewardActive = ->
    log "setStateToRewardActive"
    resetAllStateClasses()

    currentState = "reward-active"
    mainElement.classList.add(currentState)
    return

export setStateToConfigureAccount = ->
    log "setStateToConfigureAccount"
    resetAllStateClasses()

    currentState = "configure-account"
    mainElement.classList.add(currentState)
    return

export setStateToConfigureReward = ->
    log "setStateToConfigureReward"
    resetAllStateClasses()

    currentState = "configure-reward"
    mainElement.classList.add("configure-reward")
    return

#endregion