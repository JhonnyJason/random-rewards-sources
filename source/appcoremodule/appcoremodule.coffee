############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return


############################################################
export startUp = ->
    log "startUp"
    return

############################################################
#region menu called functions

############################################################
export goHome = ->
    log "goHome"
    ## TODO implement
    return

############################################################
export configureAccount = ->
    log "configureAccount"
    ## TODO implement
    return

############################################################
export createNewReward = ->
    log "createNewReward"
    ## TODO implement
    return

############################################################
export configureReward = ->
    log "configureReward"
    ## TODO implement
    return

############################################################
export logout = ->
    log "logout"
    # Notice: here we already checked if the user really wants to log out

    ##TODO implement

    return

#endregion