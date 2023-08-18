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

#endregion

############################################################
lastContentClick = 0
contentIsLarge = false

#############################################################
currentState = "no-rewards"

############################################################
export initialize = ->
    log "initialize"
    addNewRewardButton.addEventListener("click", addNewRewardClicked)
    content.addEventListener("click", contentClicked)
    return


############################################################
addNewRewardClicked = (evnt) ->
    log "addNewRewardClicked"
    app.createNewReward()
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
    content.classList.remove("no-rewards")
    content.classList.remove("rewards-list")
    content.classList.remove("reward-inactive")
    content.classList.remove("reward-unjudged")
    content.classList.remove("reward-judgement-overlay")
    content.classList.remove("reward-active")
    content.classList.remove("configure-account")
    content.classList.remove("configure-reward")
    return
    
############################################################
#region State Setter Functions
export setStateToNoRewards = ->
    log "setStateToNoRewards"
    resetAllStateClasses()

    currentState = "no-rewards"
    content.classList.add(currentState)
    return

export setStateToRewardsList = ->
    log "setStateToRewardsList"
    resetAllStateClasses()

    currentState = "rewards-list"
    content.classList.add(currentState)
    return

export setStateToRewardInactive = ->
    log "setStateToRewardInactive"
    resetAllStateClasses()

    currentState = "reward-inactive"
    content.classList.add(currentState)
    return

export setStateToRewardUnjudged = ->
    log "setStateToRewardUnjudged"
    resetAllStateClasses()

    currentState = "reward-unjudged"
    content.classList.add(currentState)
    return

export setStateToRewardJudgementOverlay = ->
    log "setStateToRewardJudgementOverlay"
    resetAllStateClasses()

    currentState = "reward-judgement-overlay"
    content.classList.add(currentState)
    return

export setStateToRewardActive = ->
    log "setStateToRewardActive"
    resetAllStateClasses()

    currentState = "reward-active"
    content.classList.add(currentState)
    return

export setStateToConfigureAccount = ->
    log "setStateToConfigureAccount"
    resetAllStateClasses()

    currentState = "configure-account"
    content.classList.add(currentState)
    return

export setStateToConfigureReward = ->
    log "setStateToConfigureReward"
    resetAllStateClasses()

    currentState = "configure-reward"
    content.classList.add("configure-reward")
    return

#endregion