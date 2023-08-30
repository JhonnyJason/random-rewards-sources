############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("menumodule")
#endregion

############################################################
import M from "mustache"

############################################################
import * as S from "./statemodule.js"

############################################################
import * as app from "./appcoremodule.js"

############################################################
menuHome = document.getElementById("menu-home")
menuAccount = document.getElementById("menu-account")
menuAddReward = document.getElementById("menu-add-reward")
menuAllRewards = document.getElementById("menu-all-rewards")
menuLogout = document.getElementById("menu-logout")
menuEntryTemplate =  document.getElementById("menu-entry-template")

############################################################
entryTemplate = menuEntryTemplate.innerHTML

############################################################
export initialize = ->
    log "initialize"
    menuHome.addEventListener("click", menuHomeClicked)
    menuAccount.addEventListener("click", menuAccountClicked)
    menuAddReward.addEventListener("click", addRewardClicked)
    menuLogout.addEventListener("click", logoutClicked)
    menu.addEventListener("click", setMenuOff)
    return

############################################################
#region Event Listeners

############################################################
rewardEntryClicked = (evnt) ->
    log "rewardEntryClicked"
    el = evnt.currentTarget
    rewardIndex = el.getAttribute("reward-index")
    log rewardIndex
    app.triggerRewardConfiguration(rewardIndex)

    # {activeAccount} = accountModule.getAccountsInfo()
    # userIndex = parseInt(userIndex)

    # if userIndex == activeAccount then contentModule.setToUserImagesState()

    # accountModule.setAccountActive(userIndex) unless userIndex == NaN
    return

menuHomeClicked = (evnt) ->
    log "menuHomeClicked"
    app.triggerHome()
    return

menuAccountClicked = (evnt) ->
    log "menuAccountClicked"
    app.triggerAccountConfiguration()
    return

addRewardClicked = (evnt) ->
    log "addRewardClicked"
    app.triggerRewardCreation()
    return

logoutClicked = (evnt) ->
    log "logoutClicked"
    app.triggerLogout()
    return

#endregion

############################################################
export updateRewards = ->
    log "updateRewards"
    allRewards = S.get("allRewards")
    olog allRewards

    if !Array.isArray(allRewards) or allRewards.length == 0
        menuAllRewards.innerHTML = ""
        menu.classList.add("no-rewards")
        return

    html = ""
    for reward,idx in allRewards
        # log "#{idx}:#{reward.name}"
        cObj = {}
        cObj.index = idx
        cObj.rewardLabel = reward.name
        html += M.render(entryTemplate, cObj)
    
    # log html
    menuAllRewards.innerHTML = html
    menu.classList.remove("no-rewards")

    allRewardEntries = document.querySelectorAll("#menu-all-rewards > *")
    for rewardEntry,idx in allRewardEntries
        # log "rewardEntry: #{idx}:#{rewardEntry.getAttribute("reward-index")}"
        rewardEntry.addEventListener("click", rewardEntryClicked)
    return

############################################################
#region UI State Manipulation
export setMenuOff = ->
    document.body.classList.remove("menu-on")
    return

############################################################
export setMenuOn = ->
    document.body.classList.add("menu-on")
    return

#endregion