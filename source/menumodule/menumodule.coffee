############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("menumodule")
#endregion

############################################################
import M from "mustache"

############################################################
import * as app from "./appcoremodule.js"
import * as contentModule from "./contentmodule.js"
import * as logoutmodal from "./logoutmodal.js"

############################################################
# menuAddCode = document.getElementById("menu-add-code")
# menuMoreInfo = document.getElementById("menu-more-info")
# menuLogout = document.getElementById("menu-logout")
# menuVersion = document.getElementById("menu-version")
# allUsers = document.getElementById("all-users")
# menuEntryTemplate =  document.getElementById("menu-entry-template")

############################################################
# entryTemplate = menuEntryTemplate.innerHTML

############################################################
export initialize = ->
    log "initialize"
    # menuAddCode.addEventListener("click", addCodeClicked)
    # menuMoreInfo.addEventListener("click", moreInfoClicked)
    # menuLogout.addEventListener("click", logoutClicked)
    # menuVersion.addEventListener("click", menuVersionClicked)
    return

############################################################
#region event Listeners
userEntryClicked = (evnt) ->
    log "userEntryClicked"
    el = evnt.currentTarget
    userIndex = el.getAttribute("user-index")
    log userIndex
    {activeAccount} = accountModule.getAccountsInfo()
    userIndex = parseInt(userIndex)

    if userIndex == activeAccount then contentModule.setToUserImagesState()

    accountModule.setAccountActive(userIndex) unless userIndex == NaN
    return

addCodeClicked = (evnt) ->
    log "addCodeClicked"
    contentModule.setToAddCodeState()
    return

moreInfoClicked = (evnt) ->
    log "moreInfoClicked"
    app.moreInfo()
    return

logoutClicked = (evnt) ->
    log "logoutClicked"
    try
        await logoutmodal.userConfirmation()
        log "LogoutModal.userConfirmation() succeeded!"
        app.logout()
    catch err then log err
    return

menuVersionClicked = (evnt) ->
    log "menuVersionClicked"
    app.upgrade()
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
export updateAllUsers = ->
    log "updateAllUsers"
    {activeAccount, allAccounts, accountValidity} = accountModule.getAccountsInfo()
    
    html = ""
    for accountObj,idx in allAccounts
        log "#{idx}:#{accountObj.label}"
        cObj = {}
        cObj.userLabel = accountObj.label
        cObj.index = idx
        html += M.render(entryTemplate, cObj)

    allUsers.innerHTML = html
    
    if allAccounts.length == 0 then menu.classList.add("no-user")
    else menu.classList.remove("no-user")
    
    activeUser = document.querySelector(".menu-entry[user-index='#{activeAccount}']")
    if activeUser? then activeUser.classList.add("active-user")

    allUserEntries = document.querySelectorAll("#all-users > *")
    for userEntry,idx in allUserEntries
        log "userEntry: #{idx}:#{userEntry.getAttribute("user-index")}"
        userEntry.addEventListener("click", userEntryClicked)
    return
