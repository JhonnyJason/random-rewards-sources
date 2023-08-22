############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("rewardoptioneditmodal")
#endregion

############################################################
import M from "mustache"

############################################################
import { ModalCore } from "./modalcore.js"

############################################################
core = null

############################################################
headerTitle = null

############################################################
export initialize =  ->
    log "initialize"
    core = new ModalCore(rewardoptioneditmodal)
    core.connectDefaultElements()

    headerTitle = rewardoptioneditmodal.getElementsByClassName("modal-header-title")[0]    
    return

############################################################
export userEdit = (optionObj) ->
    log "userEdit"

    headerTitle.textContent = "Edit Reward Option"

    ## user optionObj to fill inputs
    rewardoptioneditmodalNameInput.value = optionObj.name
    rewardoptioneditmodalWeightInput.value = optionObj.weight

    ## show deleteButton
    # rewardoptionseditmodalDeleteButton.classList.remove("hidden")
    core.activate()
    await core.modalPromise
    
    ## apply edits to optionObj
    optionObj.name = rewardoptioneditmodalNameInput.value 
    optionObj.weight =  parseInt(rewardoptioneditmodalWeightInput.value)

    return optionObj

export userCreate = ->
    log "userCreate"

    headerTitle.textContent = "New Reward Option"
    ## clear inputs
    rewardoptioneditmodalNameInput.value = ""
    rewardoptioneditmodalWeightInput.value = 0

    ## hide deleteButton
    rewardoptionseditmodalDeleteButton.classList.add("hidden")

    core.activate()
    await  core.modalPromise
    
    ## apply edits to a new optionObj
    optionObj = {}
    optionObj.name = rewardoptioneditmodalNameInput.value 
    optionObj.weight =  parseInt(rewardoptioneditmodalWeightInput.value)
    return optionObj
