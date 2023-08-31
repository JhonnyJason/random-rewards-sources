############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("judgemodal")
#endregion

############################################################
import { ModalCore } from "./modalcore.js"

############################################################
core = null
promiseConsumed = false

############################################################
export initialize =  ->
    log "initialize"
    core = new ModalCore(judgemodal)
    core.connectDefaultElements()
    return

############################################################
export userConfirmation = ->
    log "userConfirmation"
    return if promiseConsumed

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