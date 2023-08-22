############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("usermodalmodule")
#endregion

############################################################
import * as logoutModal from "./logoutmodal.js"
import * as deleteModal from "./deletemodal.js"

############################################################
export initialize = ->
    log "initialize"
    deleteModal.initialize()
    logoutModal.initialize()
    return
