############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("rewardmodule")
#endregion


############################################################
import * as S from "./statemodule.js"
import * as app from "./appcoremodule.js"

############################################################
#region DOM cache
rewardconfigurationframe = document.getElementById("rewardconfigurationframe")

nameInput = document.getElementById("name-input")
conditionTextarea = document.getElementById("condition-textarea")
timeframeInput = document.getElementById("timeframe-input")
frequencyInput = document.getElementById("frequency-input")

rewardconfigurationCancelButton = rewardconfigurationframe.getElementsByClassName("editframe-cancel-button")[0]
rewardconfigurationSaveButton = rewardconfigurationframe.getElementsByClassName("editframe-save-button")[0]
#endregion

############################################################
selectedReward = NaN
allRewards = []

noRewards = true

############################################################
export initialize = ->
    log "initialize"
    allRewards = S.load("allRewards") || []
    S.save("allRewards", allRewards, true)
    S.set("selectedReward", NaN)
    if allRewards.length > 0 then noAccount = false

    rewardconfigurationCancelButton.addEventListener("click", configurationCancelClicked)
    rewardconfigurationSaveButton.addEventListener("click", configurationSaveClicked)

    allEditItems = rewardconfigurationframe.getElementsByClassName("editframe-edit-item")
    item.addEventListener("click", (evnt) -> evnt.stopPropagation()) for item in allEditItems
    return


############################################################
configurationCancelClicked = (evnt) ->
    log "configurationCancelClicked"
    evnt.preventDefault()
    resetConfiguration()
    app.goHome()
    return

configurationSaveClicked = (evnt) ->
    log "configurationSaveClicked"
    evnt.preventDefault()

    #TODO implement
    return


############################################################
resetConfiguration = (evnt) ->
    log "resetConfiguration"
    ##TODO reset internal state
    
    # Resetting UI state
    nameInput.value = ""
    conditionTextarea.value = ""
    timeframeInput.value = ""
    frequencyInput.value = ""

    return

