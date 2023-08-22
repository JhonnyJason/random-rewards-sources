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
core = null

############################################################
messageTemplate = ""
modalContent = null

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
    modalContent.innerHTML = M.render(messageTemplate, cObj) 
    core.activate()
    return core.modalPromise