############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("contentmodule")
#endregion

############################################################
import * as app from "./appcoremodule.js"

############################################################
# DOM Cache
addNewRewardButton = document.getElementById("add-new-reward-button")

############################################################
lastContentClick = 0
contentIsLarge = false

############################################################
export initialize = ->
    log "initialize"
    addNewRewardButton.addEventListener("click", addNewRewardClicked)
    content.addEventListener("click", contentClicked)

    #Implement or Remove :-)
    return


############################################################
addNewRewardClicked = (evnt) ->
    log "addNewRewardClicked"
    app.createNewReward()
    return

contentClicked = (evnt) ->
    # log "contentClicked"
    # log lastContentClick
    currentContentClick = performance.now()
    delta = currentContentClick - lastContentClick
    lastContentClick = currentContentClick
    if delta < 400 then doubleClickHappened()
    return

############################################################
doubleClickHappened = ->
    # log "doubleClickHappened"
    lastContentClick = 0
    contentIsLarge = !contentIsLarge # toggle

    if contentIsLarge then realBody.classList.add("large-content")
    else realBody.classList.remove("large-content")

    return