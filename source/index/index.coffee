import Modules from "./allmodules"
import domconnect from "./indexdomconnect"
domconnect.initialize()

import { appLoaded } from "./navhandler.js"
global.allModules = Modules


############################################################
run = ->
    promises = (m.initialize() for n,m of Modules when m.initialize?) 
    await Promise.all(promises)
    appLoaded()

############################################################
run()