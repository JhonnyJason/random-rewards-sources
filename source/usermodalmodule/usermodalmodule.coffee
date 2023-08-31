############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("usermodalmodule")
#endregion

############################################################
#region Specific Modals imported

import * as deleteModal from "./deletemodal.js"
import * as judgeModal from "./judgemodal.js"
import * as logoutModal from "./logoutmodal.js"
import * as optiondeleteModal from "./optiondeletemodal.js"
import * as optioneditmodal from "./optioneditmodal.js"

#endregion

############################################################
export initialize = ->
    log "initialize"
    deleteModal.initialize()
    judgeModal.initialize()
    logoutModal.initialize()
    optiondeleteModal.initialize()
    optioneditmodal.initialize()
    return
