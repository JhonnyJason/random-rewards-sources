############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("deletemodal")
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
messageTemplate = ""
modalContent = null

#endregion

############################################################
export initialize =  ->
    log "initialize"
    core = new ModalCore(deletemodal)
    core.connectDefaultElements()
    
    messageTemplate = deletemodalMessageTemplate.innerHTML
    modalContent = deletemodal.getElementsByClassName("modal-content")[0]
    return

############################################################
export userConfirmation = (cObj) ->
    log "userConfirmation"
    return if promiseConsumed

    modalContent.innerHTML = M.render(messageTemplate, cObj) 
    core.activate() unless core.modalPromise?
    promiseConsumed = true
    return core.modalPromise

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