############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("rewardmodule")
#endregion

############################################################
#region DOM cache
rewardconfigurationframe = document.getElementById("rewardconfigurationframe")
rewarconfigurationCancelButton = rewardconfigurationframe.getElementsByClassName("editframe-cancel-button")[0]
rewarconfigurationSaveButton = rewardconfigurationframe.getElementsByClassName("editframe-save-button")[0]
#endregion

############################################################
rewardconfigurationFormData = new FormData(rewardconfigurationframe)

############################################################
export initialize = ->
    log "initialize"
    oldName = rewardconfigurationFormData.get("name")
    log oldName
    rewardconfigurationFormData.set("name", "Set name :-)")
    log "I should have set the set Name ;-)"
    #Implement or Remove :-)
    return