############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("rewardconfigurationmodule")
#endregion

############################################################
#region imported Modules
import M from "mustache"

############################################################
import * as S from "./statemodule.js"

############################################################
import * as app from "./appcoremodule.js"
import * as deletemodal from "./deletemodal.js"
import * as optioneditmodal from "./optioneditmodal.js"
import * as optiondeleteModal from "./optiondeletemodal.js"

#endregion

############################################################
#region DOM cache
rewardconfigurationframe = document.getElementById("rewardconfigurationframe")
rewardconfigurationTitle = document.getElementById("rewardconfiguration-title")

nameInput = document.getElementById("name-input")
conditionTextarea = document.getElementById("condition-textarea")
timeframeInput = document.getElementById("timeframe-input")
frequencyInput = document.getElementById("frequency-input")

rewardconfigurationCancelButton = rewardconfigurationframe.getElementsByClassName("editframe-cancel-button")[0]
rewardconfigurationDeleteButton = rewardconfigurationframe.getElementsByClassName("editframe-delete-button")[0]
rewardconfigurationSaveButton = rewardconfigurationframe.getElementsByClassName("editframe-save-button")[0]

rewardOptionsTotalWeight = document.getElementById("reward-options-total-weight")
rewardOptionsContainer = document.getElementById("reward-options-container")
addRewardOptionButton = document.getElementById("add-reward-option-button")

#endregion

############################################################
rewardOptionTemplate = document.getElementById("reward-option-template").innerHTML

############################################################
editIndex = NaN
editObj = null
editOptions = null

state = "none"

############################################################
export initialize = ->
    log "initialize"

    # connect configuration action buttons
    rewardconfigurationCancelButton.addEventListener("click", configurationCancelClicked)
    rewardconfigurationDeleteButton.addEventListener("click", configurationDeleteClicked)
    rewardconfigurationSaveButton.addEventListener("click", configurationSaveClicked)

    addRewardOptionButton.addEventListener("click", addRewardOptionButtonClicked)

    # stop double-click zoom-in on edit-items
    allEditItems = rewardconfigurationframe.getElementsByClassName("editframe-edit-item")
    item.addEventListener("click", (evnt) -> evnt.stopPropagation()) for item in allEditItems

    return

############################################################
#region Event Listeners

addRewardOptionButtonClicked = (evnt) ->
    log "addRewardOptionButtonClicked"

    # if !editObj.options? then editObj.options = []
    if !editOptions? then editOptions = []

    context = {editObj, editIndex}
    app.triggerRewardOptionEdit(context)
    return

configurationCancelClicked = (evnt) ->
    log "configurationCancelClicked"
    evnt.preventDefault()
    resetConfiguration()
    app.triggerHome()
    return

configurationDeleteClicked = (evnt) ->
    log "configurationDeleteClicked"
    evnt.preventDefault()
    app.triggerRewardDeletion({ editObj, editIndex })
    return

configurationSaveClicked = (evnt) ->
    log "configurationSaveClicked"
    evnt.preventDefault()

    
    if editIndex == allRewards.length then allRewards.push(editObj)

    editObj.name = nameInput.value 
    editObj.condition = conditionTextarea.value
    editObj.timeframe = timeframeInput.value
    editObj.frequency = frequencyInput.value
    
    editObj.options = editOptions
    
    # olog allRewards

    S.save("allRewards")
    S.callOutChange("allRewards")
    resetConfiguration()
    app.triggerHome()
    return

############################################################
rewardButtonClicked = (evnt) ->
    log "rewardButtonClicked"
    el = evnt.currentTarget
    rewardIndex = el.getAttribute("reward-index")
    log rewardIndex

    app.triggerRewardSelection(rewardIndex)
    return

rewardOptionClicked = (evnt) ->
    log "rewardOptionClicked"

    index = this.parentNode.getAttribute("reward-option-index")

    if !editOptions[index]? then throw new Error("Option of index #{index} did not exist!")
    optionObj = editOptions[index]
    optionIndex = index

    context = {editObj, editIndex, optionObj, optionIndex}
    app.triggerRewardOptionEdit(context)
    return

rewardOptionDeleteClicked = (evnt) ->
    log "rewardOptionDeleteClicked"

    index = this.parentNode.getAttribute("reward-option-index")

    if !editOptions[index]? then throw new Error("Option of index #{index} did not exist!")
    optionObj = editOptions[index]

    try
        # await optiondeleteModal.userConfirmation(optionObj)
        editOptions.splice(index, 1)
        updateRewardOptions()
    catch err
        log err

    return

#endregion

############################################################
updateRewardOptions = ->
    log "updateRewardOptions"
    totalWeight = 0 
    rewardOptionsHTML = ""

    # rewardOptions = []
    # if editObj? and Array.isArray(editObj.options) then rewardOptions = editObj.options
    rewardOptions = editOptions || []

    totalWeight += option.weight for option in rewardOptions
        
    for option,idx in rewardOptions
        cObj = {}
        cObj.name = option.name
        cObj.weight = option.weight
        cObj.index = idx
        if totalWeight == 0 then cObj.percent = 100
        else cObj.percent = Math.round(100 * (option.weight / totalWeight)) 
        
        rewardOptionsHTML += M.render(rewardOptionTemplate, cObj)

    rewardOptionsTotalWeight.textContent = "Total Weight: #{totalWeight}"
    rewardOptionsContainer.innerHTML = rewardOptionsHTML
    
    ## Add EventListeners
    rewardOptionElements = rewardOptionsContainer.getElementsByClassName("reward-option")
    for el in rewardOptionElements
        el.addEventListener("click", rewardOptionClicked) 

    rewardOptionDeleteButtons = rewardOptionsContainer.getElementsByClassName("reward-option-delete-button")
    for el in rewardOptionDeleteButtons
        el.addEventListener("click", rewardOptionDeleteClicked) 
    return

############################################################
resetConfiguration = ->
    log "resetConfiguration"
    
    #reset internal state
    editIndex = NaN
    editObj = null
    editOptions = null

    #more internal state?

    # Resetting UI state
    nameInput.value = ""
    conditionTextarea.value = ""
    timeframeInput.value = ""
    frequencyInput.value = ""

    rewardOptionsTotalWeight.textContent = "Total Weight: 0"
    rewardOptionsContainer.innerHTML = ""

    rewardconfigurationDeleteButton.classList.remove("shown")
    return

############################################################
export newReward = ->
    log "prepareEditNewReward"
    return if state == "create"
    resetConfiguration()
    
    editIndex = allRewards.length
    editObj = {}
    editOptions = []

    rewardconfigurationTitle.textContent = "New Reward"
    state = "create"
    return

export editReward = (index) ->
    log "prepareEditReward #{index}"
    return if state == "edit #{index}"

    if index >= allRewards.length then throw new Error("prepareEditReward: Index out of bounds!")

    editIndex = index
    editObj = allRewards[index]

    if editObj.options? then editOptions = JSON.parse(JSON.stringify(editObj.options))
    else editOptions = []

    nameInput.value = editObj.name
    conditionTextarea.value = editObj.condition
    timeframeInput.value = editObj.timeframe
    frequencyInput.value = editObj.frequency

    updateRewardOptions()

    rewardconfigurationTitle.textContent = "Edit Reward"
    rewardconfigurationDeleteButton.classList.add("shown")
    
    state = "edit #{index}"
    return

############################################################
export finalizeDeletion = ->
    log "finalizeDeletion"
    deleteReward(editIndex)
    resetConfiguration()
    return

############################################################
export addNewRewardOption = (optionObj) ->
    log "addNewRewardOption"
    editOptions.push(optionObj)
    updateRewardOptions()
    return

export finalizeRewardOptionEdit = (index, optionObj) ->
    log "finalizeRewardOptionEdit"

    if !editOptions[index]? then throw new Error("Option of index #{index} did not exist!")

    editOptions[index] = optionObj
    updateRewardOptions()
    return

