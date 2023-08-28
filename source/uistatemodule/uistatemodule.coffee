############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("uistatemodule")
#endregion

############################################################
import * as S from "./statemodule.js"

############################################################
#region imported UI modules
import * as content from "./contentmodule.js"
import * as menu from "./menumodule.js"

import * as deleteModal from "./deletemodal.js"
import * as judgeModal from "./judgemodal.js"
import * as logoutModal from "./logoutmodal.js"
import * as optiondeleteModal from "./optiondeletemodal.js"
import * as rewardoptioneditModal from "./rewardoptioneditmodal.js"

#endregion

############################################################
applyState = {}

############################################################
export initialize = ->
    ## prod log "initialize"
    S.addOnChangeListener("uiState", applyUIState)
    return

############################################################
applyUIState = ->
    ## prod log "applyUIState"
    uiState = S.get("uiState")
    applyFunction = applyState[uiState]
    if typeof applyFunction == "function" then return applyFunction()
         
    # ## prod log "on applyUIState: uiState '#{uiState}' did not have an apply function!"
    throw new Error("on applyUIState: uiState '#{uiState}' did not have an apply function!")
    return

############################################################
#region applyState functions
applyState["no-rewards:none"]

#endregion