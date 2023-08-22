indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.realBody = document.getElementById("real-body")
    global.content = document.getElementById("content")
    global.menuEntryTemplate = document.getElementById("menu-entry-template")
    global.menu = document.getElementById("menu")
    global.menuHome = document.getElementById("menu-home")
    global.menuAccount = document.getElementById("menu-account")
    global.menuAddReward = document.getElementById("menu-add-reward")
    global.menuAllRewards = document.getElementById("menu-all-rewards")
    global.menuLogout = document.getElementById("menu-logout")
    global.menuCloseButton = document.getElementById("menu-close-button")
    global.menuButton = document.getElementById("menu-button")
    global.logoutmodal = document.getElementById("logoutmodal")
    global.deletemodalMessageTemplate = document.getElementById("deletemodal-message-template")
    global.deletemodal = document.getElementById("deletemodal")
    return
    
module.exports = indexdomconnect