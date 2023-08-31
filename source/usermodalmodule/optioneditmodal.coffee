############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("optioneditmodal")
#endregion

############################################################
import M from "mustache"

############################################################
import { ModalCore } from "./modalcore.js"

############################################################
#region Internal Variables

core = null
promiseConsumed = false

############################################################
headerTitle = null

#endregion

############################################################
export initialize =  ->
    log "initialize"
    core = new ModalCore(optioneditmodal)
    core.connectDefaultElements()

    headerTitle = optioneditmodal.getElementsByClassName("modal-header-title")[0]    
    return

############################################################
export userEdit = (optionObj) ->
    log "userEdit"
    return if promiseConsumed

    headerTitle.textContent = "Edit Reward Option"

    ## use optionObj to fill inputs
    optioneditmodalNameInput.value = optionObj.name
    optioneditmodalWeightInput.value = optionObj.weight
    
    core.activate() unless core.modalPromise?
    promiseConsumed = true
    await core.modalPromise
            
    ## apply edits to optionObj
    optionObj = {}
    optionObj.name = optioneditmodalNameInput.value
    optionObj.weight =  parseInt(optioneditmodalWeightInput.value)

    if optionObj.name == "" then optionObj.name = "Unnamed"
    if !optionObj.weight then optionObj.weight = 0
    
    return optionObj

export userCreate = ->
    log "userCreate"
    return if promiseConsumed

    headerTitle.textContent = "New Reward Option"
    ## clear inputs
    optioneditmodalNameInput.value = ""
    optioneditmodalWeightInput.value = 0

    core.activate() unless core.modalPromise?
    promiseConsumed = true
    await  core.modalPromise
    
    ## apply edits to a new optionObj
    optionObj = {}
    optionObj.name = optioneditmodalNameInput.value 
    optionObj.weight =  parseInt(optioneditmodalWeightInput.value)

    if optionObj.name == "" then optionObj.name = "Unnamed"
    if !optionObj.weight then optionObj.weight = 0

    return optionObj

############################################################
#region UI state manipulation

export turnUpModal = ->
    ## prod log "turnUpModal"
    return if core.modalPromise? # already up
    promiseConsumed = false    
    core.activate()
    return

export turnDownModal = (reason) ->
    ## prod log "turnDownModal"
    if core.modalPromise? and !promiseConsumed
        core.modalPromise.catch(() -> return)
        # core.modalPromise.catch((err) -> log("unconsumed: #{err}"))

    core.reject(reason)
    promiseConsumed = false
    return

#endregion