############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("headermodule")
#endregion

############################################################
import * as app from "./appcoremodule.js"

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
    app.triggerHome()
    return

menuButtonClicked = ->
    log "menuButtonClicked"
    app.triggerMenu(true)
    return

menuCloseButtonClicked = ->
    log "menuCloseButtonClicked"
    app.triggerMenu(false)
    return



