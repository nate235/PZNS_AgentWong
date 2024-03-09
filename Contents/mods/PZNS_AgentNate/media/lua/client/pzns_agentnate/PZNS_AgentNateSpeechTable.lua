-- Cows: SpeechTable is OPTIONAL, if you don't feel like writing custom speech, don't implement it and remove it.
local PZNS_AgentNateSpeechTable = {}; -- Cows: RENAME THIS VARIABLE AND UPDATE ALL REFERENCES TO IT FOR YOUR NEEDS.

-- Cows: Note that the translation files are all inside the "shared/Translate" folder, specifically referencing the "IG_UI_xx.txt" file.
PZNS_AgentNateSpeechTable.PZNS_OrderConfirmed = {
    getText("IGUI_PZNS_Speech_AgentNate_Confirm_01"),
    getText("IGUI_PZNS_Speech_AgentNate_Confirm_02"),
    getText("IGUI_PZNS_Speech_AgentNate_Confirm_03"),
};

PZNS_AgentNateSpeechTable.PZNS_OrderSpeechHoldPosition = {
    getText("IGUI_PZNS_Speech_AgentNate_HoldPosition_01"),
    getText("IGUI_PZNS_Speech_AgentNate_HoldPosition_02"),
    getText("IGUI_PZNS_Speech_AgentNate_HoldPosition_03"),
};

PZNS_AgentNateSpeechTable.PZNS_OrderSpeechFollow = {
    getText("IGUI_PZNS_Speech_AgentNate_Follow_01"),
    getText("IGUI_PZNS_Speech_AgentNate_Follow_02"),
    getText("IGUI_PZNS_Speech_AgentNate_Follow_03"),
};

PZNS_AgentNateSpeechTable.PZNS_JobSpeechRemoveFromGroup = {
    getText("IGUI_PZNS_Speech_AgentNate_RemoveFromGroup_01"),
    getText("IGUI_PZNS_Speech_AgentNate_RemoveFromGroup_02"),
    getText("IGUI_PZNS_Speech_AgentNate_RemoveFromGroup_03"),
};

PZNS_AgentNateSpeechTable.PZNS_JobSpeechIdle = {
    getText("IGUI_PZNS_Speech_AgentNate_JobSpeechIdle_01"),
    getText("IGUI_PZNS_Speech_AgentNate_JobSpeechIdle_02"),
    getText("IGUI_PZNS_Speech_AgentNate_JobSpeechIdle_03"),
};

return PZNS_AgentNateSpeechTable;
