############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("judgemodal")
#endregion

############################################################
import { ModalCore } from "./modalcore.js"

############################################################
core = null

############################################################
export initialize =  ->
    log "initialize"
    core = new ModalCore(judgemodal)
    core.connectDefaultElements()
    return

############################################################
export userConfirmation = ->
    log "userConfirmation"
    core.activate()
    return core.modalPromise