############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("menumodule")
#endregion

############################################################
import M from "mustache"

############################################################
import * as app from "./appcoremodule.js"
import * as logoutmodal from "./logoutmodal.js"
import * as rewardModule from "./rewardmodule.js"

############################################################
menuHome = document.getElementById("menu-home")
menuAccount = document.getElementById("menu-account")
menuAddReward = document.getElementById("menu-add-reward")
allRewards = document.getElementById("all-rewards")
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
    return

############################################################
#region event Listeners
userEntryClicked = (evnt) ->
    log "userEntryClicked"
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
    return

menuAccountClicked = (evnt) ->
    log "menuAccountClicked"
    app.configureAccount()
    return

addRewardClicked = (evnt) ->
    log "addRewardClicked"
    app.createNewReward()
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

############################################################
export updateAllRewards = ->
    log "updateAllRewards"
    allRewards = rewardModule.getAllRewards()
    ## TODO implement
    
    # {activeAccount, allAccounts, accountValidity} = accountModule.getAccountsInfo()
    
    # html = ""
    # for accountObj,idx in allAccounts
    #     log "#{idx}:#{accountObj.label}"
    #     cObj = {}
    #     cObj.userLabel = accountObj.label
    #     cObj.index = idx
    #     html += M.render(entryTemplate, cObj)

    # allUsers.innerHTML = html
    
    # if allAccounts.length == 0 then menu.classList.add("no-user")
    # else menu.classList.remove("no-user")
    
    # activeUser = document.querySelector(".menu-entry[user-index='#{activeAccount}']")
    # if activeUser? then activeUser.classList.add("active-user")

    # allUserEntries = document.querySelectorAll("#all-users > *")
    # for userEntry,idx in allUserEntries
    #     log "userEntry: #{idx}:#{userEntry.getAttribute("user-index")}"
    #     userEntry.addEventListener("click", userEntryClicked)
    return
