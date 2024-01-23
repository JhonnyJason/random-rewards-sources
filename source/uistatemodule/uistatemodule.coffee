############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("uistatemodule")
#endregion

############################################################
#region imported UI modules
import * as content from "./contentmodule.js"
import * as menu from "./menumodule.js"

import * as deleteModal from "./deletemodal.js"
import * as judgeModal from "./judgemodal.js"
import * as logoutModal from "./logoutmodal.js"
import * as optiondeleteModal from "./optiondeletemodal.js"
import * as optioneditModal from "./optioneditmodal.js"

#endregion

############################################################
applyBaseState = {}
applyModifier = {}

############################################################
#region Base State Application Functions

applyBaseState["no-rewards"] = ->
    content.setStateToWelcome()
    return

applyBaseState["one-reward"] = ->
    content.setStateOneReward()
    return

applyBaseState["many-rewards"] = ->
    content.setStateToRewardsList()
    return

applyBaseState["configure-reward"] = ->
    content.setStateToConfigureReward()    
    return

applyBaseState["configure-account"] = ->
    content.setStateToConfigureAccount()    
    return

#endregion

############################################################
#region Modifier Application Functions

applyModifier["none"] = ->
    ## OFF
    menu.setMenuOff()
    # Modals
    deleteModal.turnDownModal("uistate-change")
    judgeModal.turnDownModal("uistate-change")
    logoutModal.turnDownModal("uistate-change")
    optiondeleteModal.turnDownModal("uistate-change")
    optioneditModal.turnDownModal("uistate-change")
    return

applyModifier["menu"] = ->
    ## ON
    menu.setMenuOn()

    ## OFF
    # Modals
    deleteModal.turnDownModal("uistate-change")
    judgeModal.turnDownModal("uistate-change")
    logoutModal.turnDownModal("uistate-change")
    optiondeleteModal.turnDownModal("uistate-change")
    optioneditModal.turnDownModal("uistate-change")
    return

############################################################
#region Modal Modifiers

applyModifier["deleteconfirmation"] = ->
    ## ON
    deleteModal.turnUpModal()
    
    ## OFF
    menu.setMenuOff()
    # Modals
    judgeModal.turnDownModal("uistate-change")
    logoutModal.turnDownModal("uistate-change")
    optiondeleteModal.turnDownModal("uistate-change")
    optioneditModal.turnDownModal("uistate-change")
    return

applyModifier["judgement"] = ->
    ## ON
    logoutModal.turnDownModal("uistate-change")
    judgeModal.turnUpModal()
    
    ## OFF
    menu.setMenuOff()
    # Modals
    deleteModal.turnDownModal("uistate-change")
    optiondeleteModal.turnDownModal("uistate-change")
    optioneditModal.turnDownModal("uistate-change")
    return

applyModifier["logoutconfirmation"] = ->
    ## ON
    logoutModal.turnUpModal()
    
    ## OFF
    menu.setMenuOff()
    # Modals
    deleteModal.turnDownModal("uistate-change")
    judgeModal.turnDownModal("uistate-change")
    optiondeleteModal.turnDownModal("uistate-change")
    optioneditModal.turnDownModal("uistate-change")
    return

applyModifier["optiondeleteconfirmation"] = ->
    ## ON
    optiondeleteModal.turnUpModal()
    
    ## OFF
    menu.setMenuOff()
    # Modals
    deleteModal.turnDownModal("uistate-change")
    judgeModal.turnDownModal("uistate-change")
    logoutModal.turnDownModal("uistate-change")
    optioneditModal.turnDownModal("uistate-change")
    return

applyModifier["editoption"] = ->
    ## ON
    optioneditModal.turnUpModal()
    
    ## OFF
    menu.setMenuOff()
    # Modals
    deleteModal.turnDownModal("uistate-change")
    judgeModal.turnDownModal("uistate-change")
    logoutModal.turnDownModal("uistate-change")
    optiondeleteModal.turnDownModal("uistate-change")
    return

#endregion

#endregion


############################################################
#region exported general Application Functions
export applyUIState = (base, modifier) ->
    log "applyUIState"
    if base? then applyUIStateBase(base)
    if modifier? then applyUIStateModifier(modifier)
    return

############################################################
export applyUIStateBase = (base) ->
    log "applyUIBaseState #{base}"
    applyBaseFunction = applyBaseState[base]

    if typeof applyBaseFunction != "function" then throw new Error("on applyUIStateBase:base '#{base}' did not have an application function!")

    applyBaseFunction()
    return

############################################################
export applyUIStateModifier = (modifier) ->
    log "applyUIStateModifier #{modifier}"
    applyModifierFunction = applyModifier[modifier]

    if typeof applyUIStateModifier != "function" then throw new Error("on applyUIStateModifier: modifier '#{modifier}' did not have an apply function!")

    applyModifierFunction()
    return

#endregion
