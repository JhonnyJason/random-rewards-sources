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
    global.rewardoptioneditmodal = document.getElementById("rewardoptioneditmodal")
    global.rewardoptioneditmodalNameInput = document.getElementById("rewardoptioneditmodal-name-input")
    global.rewardoptioneditmodalWeightInput = document.getElementById("rewardoptioneditmodal-weight-input")
    global.rewardoptionseditmodalDeleteButton = document.getElementById("rewardoptionseditmodal-delete-button")
    global.logoutmodal = document.getElementById("logoutmodal")
    global.optiondeletemodal = document.getElementById("optiondeletemodal")
    global.deletemodalMessageTemplate = document.getElementById("deletemodal-message-template")
    global.deletemodal = document.getElementById("deletemodal")
    return
    
module.exports = indexdomconnect