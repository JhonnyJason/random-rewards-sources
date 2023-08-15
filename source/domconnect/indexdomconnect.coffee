indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.menuCloseButton = document.getElementById("menu-close-button")
    global.menuButton = document.getElementById("menu-button")
    global.logoutmodal = document.getElementById("logoutmodal")
    return
    
module.exports = indexdomconnect