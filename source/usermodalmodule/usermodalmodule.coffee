############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("usermodalmodule")
#endregion

############################################################
import * as logoutModal from "./logoutmodal.js"
import * as deleteModal from "./deletemodal.js"
import * as optiondeleteModal from "./optiondeletemodal.js"
import * as rewardoptioneditModal from "./rewardoptioneditmodal.js"

############################################################
export initialize = ->
    log "initialize"
    deleteModal.initialize()
    optiondeleteModal.initialize()
    logoutModal.initialize()
    rewardoptioneditModal.initialize()
    return
