############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("optiondeletemodal")
#endregion

############################################################
import M from "mustache"

############################################################
import { ModalCore } from "./modalcore.js"

############################################################
core = null

############################################################
export initialize =  ->
    log "initialize"
    core = new ModalCore(optiondeletemodal)
    core.connectDefaultElements()    
    return

############################################################
export userConfirmation = (cObj) ->
    log "userConfirmation"
    ## TODO use name for sensitive warning
    core.activate()
    return core.modalPromise