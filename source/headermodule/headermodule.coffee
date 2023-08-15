############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("headermodule")
#endregion

############################################################
import * as content from "./contentmodule.js"
import * as menuModule from "./menumodule.js"

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
    ## TODO: implement
    return

menuButtonClicked = ->
    log "menuButtonClicked"
    menuModule.setMenuOn()
    return

menuCloseButtonClicked = ->
    log "menuCloseButtonClicked"
    menuModule.setMenuOff()
    return



