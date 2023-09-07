############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("rewardmodule")
#endregion

############################################################
import M from "mustache"

############################################################
import * as S from "./statemodule.js"

############################################################
import * as app from "./appcoremodule.js"
import * as deletemodal from "./deletemodal.js"
import * as optioneditmodal from "./optioneditmodal.js"
import * as optiondeleteModal from "./optiondeletemodal.js"

############################################################
selectedReward = null
allRewards = []

############################################################
noRewards = true

############################################################
export initialize = ->
    log "initialize"
    allRewards = S.load("allRewards") || []
    S.save("allRewards", allRewards, true)
    
    S.set("selectedReward", null)
    if allRewards.length > 0 then noAccount = false

    # olog allRewards
    return

############################################################
export deleteReward = (index) ->
    log "deleteReward #{index}"
    if index >= allRewards.length then throw new Error("deleteReward: Index out of bounds!")

    deleteSelected = allRewards[index] == selectedReward
    
    allRewards.splice(index, 1)
    
    if deleteSelected
        selectedReward = null
        S.set("selectedReward", null)

    if allRewards.length == 0
        noRewards = true

    S.save("allRewards")
    S.callOutChange("allRewards")
    return

############################################################
export deleteAll = ->
    log "deleteAll"
    resetConfiguration()

    allRewards = []
    selectedReward = null
    S.set("selectedReward", null)

    noRewards = true

    S.save("allRewards", allRewards)
    return

############################################################
export getInfo = ->
    log "getInfo"
    allInfo = {}
    allInfo.allRewards = allRewards
    allInfo.selectedReward = selectedReward
    return allInfo