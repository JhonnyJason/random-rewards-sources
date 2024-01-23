############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("utilmodule")
#endregion

############################################################
export waitMS = (timeMS) ->
    pConstruct = (resolve) -> setTimeout(resolve, timeMS)
    return new Promise(pConstruct)


############################################################
export copyToClipboard = (text) ->
    try
        await navigator.clipboard.writeText(text)
        log "Clipboard API succeeded"
        if msgBox? then msgBox.info("Copied: "+text)
        return
    catch err then log err