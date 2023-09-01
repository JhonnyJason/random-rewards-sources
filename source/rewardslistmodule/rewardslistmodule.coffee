############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("rewardslistmodule")
#endregion

############################################################
import M from "mustache"

############################################################
import * as S from "./statemodule.js"
import * as app from "./appcoremodule.js"

############################################################
rewardslistContainer = document.getElementById("rewardslist-container")
buttonTemplate = document.getElementById("rewardslist-button-template").innerHTML

############################################################
rewardButtonClicked = (evnt) ->
    log "rewardButtonClicked"
    el = evnt.currentTarget
    rewardIndex = el.getAttribute("reward-index")
    log rewardIndex

    app.triggerRewardSelection(rewardIndex)
    return

############################################################
export updateRewards = ->
    log "updateRewards"
    allRewards = S.get("allRewards")

    html = ""
    for reward,idx in allRewards
        log "#{idx}:#{reward.name}"
        cObj = {}
        cObj.index = idx
        cObj.rewardLabel = reward.name
        html += M.render(buttonTemplate, cObj)
    
    rewardslistContainer.innerHTML = html

    allRewardButtons = document.querySelectorAll("#rewardslist-container > *")
    for rewardButton,idx in allRewardButtons
        log "rewardButton: #{idx}:#{rewardButton.getAttribute("reward-index")}"
        rewardButton.addEventListener("click", rewardButtonClicked)

    return