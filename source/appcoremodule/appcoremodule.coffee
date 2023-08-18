############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("appcoremodule")
#endregion

############################################################
import * as contentModule from "./contentmodule.js"

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
    contentModule.setStateToConfigureAccount()
    return

############################################################
export createNewReward = ->
    log "createNewReward"
    
    ## TODO implement creating new reward element
    contentModule.setStateToConfigureReward()
    return

############################################################
export configureReward = ->
    log "configureReward"
    ## TODO implement load correct Reward do edit field
    contentModule.setStateToConfigureReward()
    return

############################################################
export logout = ->
    log "logout"
    # Notice: here we already checked if the user really wants to log out

    ##TODO implement removal of all rewarsd
    contentModule.setStateToNoRewards()
    return

#endregion