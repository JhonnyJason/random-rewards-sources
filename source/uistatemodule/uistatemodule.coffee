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
applyBaseState = {}
applyModifier = {}

############################################################
export initialize = ->
    ## prod log "initialize"
    S.addOnChangeListener("uiState", applyUIState)
    return

############################################################
applyUIState = ->
    ## prod log "applyUIState"
    uiState = S.get("uiState")

    tokens = uiState.split(":")
    base = tokens[0]
    modifier = tokens[1]

    applyBaseFunction = applyBaseState[base]
    applyModifierFunction = applyModifier[modifier]

    if typeof applyBaseFunction != "function" then throw new Error("on applyUIState: with '#{uiState}' base '#{base}' did not have an apply function!")
    if typeof applyModifierFunction != "function" then throw new Error("on applyUIState: with '#{uiState}' modifier '#{modifier}' did not have an apply function!")

    applyBaseFunction()
    applyModifierFunction()
    return

############################################################

applyBaseState["no-rewards"] = ->
    content.setStateToWelcome()
    return

applyBaseState["many-rewards"] = ->
    content.setStateToRewardsList()
    return

applyBaseState["configure-reward"] = ->
    content.setStateToConfigureReward()    
    return

############################################################
applyModifier["none"] = ->
    menu.setMenuOff()
    ## TODO add handle for modals
    return

applyModifier["menu"] = ->
    menu.setMenuOn()
    ## TODO add handle for modals
    return

applyModifier["logoutconfirmation"] = ->
    menu.setMenuOff()
    ## TODO add handle for modals
    return