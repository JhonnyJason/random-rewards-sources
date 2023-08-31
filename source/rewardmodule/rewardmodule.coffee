############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("rewardmodule")
#endregion

############################################################
import M from "mustache"

############################################################
import * as S from "./statemodule.js"

############################################################
import * as app from "./appcoremodule.js"
import * as deletemodal from "./deletemodal.js"
import * as rewardoptioneditModal from "./rewardoptioneditmodal.js"
import * as optiondeleteModal from "./optiondeletemodal.js"

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

rewardslistContainer = document.getElementById("rewardslist-container")

rewardOptionsTotalWeight = document.getElementById("reward-options-total-weight")
rewardOptionsContainer = document.getElementById("reward-options-container")
addRewardOptionButton = document.getElementById("add-reward-option-button")

rewardslistButtonTemplateElement =  document.getElementById("rewardslist-button-template")
rewardOptionTemplateElement = document.getElementById("reward-option-template")

#endregion

############################################################
rewardslistButtonTemplate = ""
rewardOptionTemplate = ""

############################################################
selectedReward = null
allRewards = []

############################################################
noRewards = true

############################################################
editIndex = NaN
editObj = null
editOptions = null

############################################################
export initialize = ->
    log "initialize"
    allRewards = S.load("allRewards") || []
    S.save("allRewards", allRewards, true)
    
    S.set("selectedReward", null)
    if allRewards.length > 0 then noAccount = false

    # olog allRewards

    # connect configuration action buttons
    rewardconfigurationCancelButton.addEventListener("click", configurationCancelClicked)
    rewardconfigurationDeleteButton.addEventListener("click", configurationDeleteClicked)
    rewardconfigurationSaveButton.addEventListener("click", configurationSaveClicked)

    addRewardOptionButton.addEventListener("click", addRewardOptionButtonClicked)

    # stop double-click zoom-in on edit-items
    allEditItems = rewardconfigurationframe.getElementsByClassName("editframe-edit-item")
    item.addEventListener("click", (evnt) -> evnt.stopPropagation()) for item in allEditItems

    # get templates
    rewardslistButtonTemplate = rewardslistButtonTemplateElement.innerHTML
    rewardOptionTemplate = rewardOptionTemplateElement.innerHTML
    return

############################################################
addRewardOptionButtonClicked = (evnt) ->
    log "addRewardOptionButtonClicked"

    # if !editObj.options? then editObj.options = []
    if !editOptions? then editOptions = []
    
    try
        optionObj = await rewardoptioneditModal.userCreate()
        editOptions.push(optionObj)
        updateRewardOptions()
    catch err
        log err

    return

configurationCancelClicked = (evnt) ->
    log "configurationCancelClicked"
    evnt.preventDefault()
    resetConfiguration()
    app.goHome()
    return

configurationDeleteClicked = (evnt) ->
    log "configurationDeleteClicked"
    evnt.preventDefault()

    try
        cObj = {}
        cObj.label = editObj.name
        await deletemodal.userConfirmation(cObj)
        log "DeleteModal.userConfirmation() succeeded!"

        deleteReward(editIndex)
        resetConfiguration()
        app.goHome()

    catch err then log err
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
    app.goHome()
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

    try
        optionObj = await rewardoptioneditModal.userEdit(optionObj)
        updateRewardOptions()
    catch err
        log err

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
export updateRewardsList = ->
    log "updateRewardsList"

    html = ""
    for reward,idx in allRewards
        log "#{idx}:#{reward.name}"
        cObj = {}
        cObj.index = idx
        cObj.rewardLabel = reward.name
        html += M.render(rewardslistButtonTemplate, cObj)
    
    rewardslistContainer.innerHTML = html

    allRewardButtons = document.querySelectorAll("#rewardslist-container > *")
    for rewardButton,idx in allRewardButtons
        log "rewardButton: #{idx}:#{rewardButton.getAttribute("reward-index")}"
        rewardButton.addEventListener("click", rewardButtonClicked)

    return

############################################################
deleteReward = (index) ->
    log "deleteReward"
    if index >= allRewards.length then throw new Error("deleteReward: Index out of bounds!")

    deleteSelected = allRewards[index] == selectedReward
    
    allRewards.splice(index, 1)
    
    if deleteSelected
        selectedReward = null
        S.set("selectedReward", null)

    if allRewards.length == 0
        noRewards = true

    S.save("allRewards")
    S.callOutChange("allRewards")
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
export prepareEditNewReward = ->
    log "prepareEditNewReward"
    resetConfiguration()
    
    editIndex = allRewards.length
    editObj = {}
    editOptions = []

    rewardconfigurationTitle.textContent = "New Reward"
    return

export prepareEditReward = (index) ->
    log "prepareEditReward"
    
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
    return

############################################################
export deleteAll = ->
    log "deleteAll"
    allRewards = []
    selectedReward = null
    S.set("selectedReward", null)

    noRewards = true

    S.save("allRewards", allRewards)
    return

############################################################
export getInfo = -> 
    log "getInfo"
    allInfo = {}
    allInfo.allRewards = allRewards
    allInfo.selectedReward = selectedReward
    return allInfo