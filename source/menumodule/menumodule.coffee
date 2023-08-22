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
import * as logoutmodal from "./logoutmodal.js"
import * as rewardModule from "./rewardmodule.js"

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
    
    S.addOnChangeListener("allRewards", rewardsChanged)
    return

############################################################
#region event Listeners

############################################################
rewardsChanged = ->
    log "rewardsChanged"
    allRewards = S.get("allRewards")
    
    # olog allRewards


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
rewardEntryClicked = (evnt) ->
    log "rewardEntryClicked"
    el = evnt.currentTarget
    rewardIndex = el.getAttribute("reward-index")
    log rewardIndex
    app.configureReward(rewardIndex)

    # {activeAccount} = accountModule.getAccountsInfo()
    # userIndex = parseInt(userIndex)

    # if userIndex == activeAccount then contentModule.setToUserImagesState()

    # accountModule.setAccountActive(userIndex) unless userIndex == NaN
    return

menuHomeClicked = (evnt) ->
    log "menuHomeClicked"
    app.goHome()
    # setMenuOff()
    return

menuAccountClicked = (evnt) ->
    log "menuAccountClicked"
    app.configureAccount()
    # setMenuOff()
    return

addRewardClicked = (evnt) ->
    log "addRewardClicked"
    app.createNewReward()
    # setMenuOff()
    return

logoutClicked = (evnt) ->
    log "logoutClicked"
    try
        await logoutmodal.userConfirmation()
        log "LogoutModal.userConfirmation() succeeded!"
        app.logout()
    catch err then log err
    return

#endregion

############################################################
export setMenuOff = ->
    document.body.classList.remove("menu-on")
    return

############################################################
export setMenuOn = ->
    document.body.classList.add("menu-on")
    return