############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("headermodule")
#endregion

############################################################
import * as trigger from "./navtriggers.js"

############################################################
appLogo = document.getElementById("app-logo")
menuButton = document.getElementById("menu-button")
menuCloseButton = document.getElementById("menu-close-button")

############################################################
export initialize = ->
    log "initialize"
    appLogo.addEventListener("click", appLogoClicked)
    menuButton.addEventListener("click", menuButtonClicked)
    menuCloseButton.addEventListener("click", menuCloseButtonClicked)
    return

############################################################
appLogoClicked = ->
    log "appLogoClicked"
    trigger.home()
    return

menuButtonClicked = ->
    log "menuButtonClicked"
    trigger.menu(true)
    return

menuCloseButtonClicked = ->
    log "menuCloseButtonClicked"
    trigger.menu(false)
    return



