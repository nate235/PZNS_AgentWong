local PZNS_DebuggerUtils = require("02_mod_utils/PZNS_DebuggerUtils");
local PZNS_PlayerUtils = require("02_mod_utils/PZNS_PlayerUtils");
local PZNS_UtilsDataGroups = require("02_mod_utils/PZNS_UtilsDataGroups");
local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_UtilsDataZones = require("02_mod_utils/PZNS_UtilsDataZones");
local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");
local PZNS_NPCGroupsManager = require("04_data_management/PZNS_NPCGroupsManager");
local PZNS_NPCsManager = require("04_data_management/PZNS_NPCsManager");
require "11_events_spawning/PZNS_Events"; -- Cows: THIS IS REQUIRED, DON'T MESS WITH IT, ALWAYS KEEP THIS AT TOP
--------------------------------------- End Framework Requirements ---------------------------------------------
--- Cows: This is an individual NPC example, group of NPCs will be in another example.
local PZNS_AgentNateSpeechTable = require("pzns_agentnate/PZNS_AgentNateSpeechTable"); -- Cows: RENAME THIS VARIABLE AND UPDATE ALL REFERENCES TO IT FOR YOUR NEEDS.
local PZNS_AgentNate = {};                                                             -- Cows: RENAME THIS VARIABLE AND UPDATE ALL REFERENCES TO IT FOR YOUR NEEDS.

-- Cows: Mod Variables.
local isFrameWorkIsInstalled = false;   -- Cows: Initialize as false, will be true after confirming the framework is installed.
local isNPCSpawned = false;             -- Cows: Initialize as false, will be true after confirming the npc is spawned.
local frameworkID = "PZNS_Framework";   -- Cows: Self-explanatory, you need the framework to run PZNS NPCs.
local npcSurvivorID = "PZNS_AgentNate"; -- Cows: CHANGE THIS VALUE AND MAKE SURE IT IS UNIQUE! Otherwise PZNS will not be able to manage this NPC.

--- Cows: Automatically Re-set the custom npc speech table, this is to ensure the custom npc always uses the latest speech table if an update occurs.
--- OPTIONAL: Only use this function if you have custom speech tables for your NPC.
local function resetNPCSpeechTable()
    local npcSurvivor = PZNS_NPCsManager.getActiveNPCBySurvivorID(npcSurvivorID);
    if (npcSurvivor ~= nil) then
        PZNS_UtilsNPCs.PZNS_SetNPCSpeechTable(npcSurvivor, PZNS_AgentNateSpeechTable);
    end
end

--- Cows: Check if the Framework installed
---@return boolean
local function checkIsFrameWorkIsInstalled()
    local activatedMods = getActivatedMods();
    --
    if (activatedMods:contains(frameworkID)) then
        isFrameWorkIsInstalled = true;
        --resetNPCSpeechTable(); -- Cows: Comment out or remove if your NPC has no custom speechTable.
    else
        local function alertCallback()
            getSpecificPlayer(0):Say("!!! " .. npcSurvivorID .. " IS NOT ACTIVE !!!");
            getSpecificPlayer(0):Say("!!! PZNS_Framework IS NOT INSTALLED !!!");
        end
        Events.EveryOneMinute.Add(alertCallback); -- Cows: Else alert user about not having PZNS_Framework installed...
    end

    return isFrameWorkIsInstalled;
end

--- Cows: with the recent sandbox options update, users can use the sandbox option to clear ALL NPCs needs hourly.
--- OPTIONAL: Only use this function if you want to override the sandbox option.
function PZNS_AgentNate.clearNPCsNeeds()
    local npcSurvivor = PZNS_NPCsManager.getActiveNPCBySurvivorID(npcSurvivorID);
    PZNS_UtilsNPCs.PZNS_ClearNPCAllNeedsLevel(npcSurvivor);
end

--- Cows: Example of spawning in an NPC. This NPC is "Agent Nate"
function PZNS_AgentNate.spawnMyNPC()
    local isNPCActive = PZNS_NPCsManager.getActiveNPCBySurvivorID(npcSurvivorID);
    local isSpawned = false;
    local defaultID = 0;
    --
    local playerID = "Player" .. tostring(defaultID);
    local playerGroupID = "Player" .. tostring(defaultID) .. "Group";
    local isGroupExists = PZNS_NPCGroupsManager.getGroupByID(playerGroupID);
    -- Cows: Check if the group exists before continuing, can be removed if NPC doesn't need or have a group.
    if (isGroupExists) then
        -- Cows: Check if the NPC is active before continuing.
        if (isNPCActive == nil) then
            local playerSurvivor = getSpecificPlayer(defaultID);
            local npcSurvivor = PZNS_NPCsManager.createNPCSurvivor(
                npcSurvivorID,             -- Unique Identifier for the npcSurvivor so that it can be managed.
                false,                     -- isFemale
                "Nate",                    -- Surname
                "Agent",                   -- Forename
                playerSurvivor:getSquare() -- Square to spawn at
            );
            --
            if (npcSurvivor ~= nil) then
                --PZNS_UtilsNPCs.PZNS_SetNPCSpeechTable(npcSurvivor, PZNS_AgentNateSpeechTable); -- Cows: Speech table is OPTIONAL, remove/comment out this line if you don't have custom speech text planned.
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Strength", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Fitness", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Aiming", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Reloading", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorTraits(npcSurvivor, "Lucky");
                -- Cows: Setup npcSurvivor outfit... Example mod patcher check
                -- "ada_Nate" is a costume mod created/uploaded by "Satispie" at https://steamcommunity.com/sharedfiles/filedetails/?id=2908872385
                if (PZNS_DebuggerUtils.PZNS_IsModActive("ada_Nate") == true) then
                    PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.ada_Nate");
                else
                    -- Cows: Else use vanilla assets
                    PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.Vest_DefaultTEXTURE");
                    PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.Skirt_Mini");
                    PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.Shoes_ArmyBoots");
                end
                PZNS_UtilsNPCs.PZNS_AddItemToInventoryNPCSurvivor(npcSurvivor, "Base.Pistol");
                PZNS_UtilsNPCs.PZNS_AddEquipWeaponNPCSurvivor(npcSurvivor, "Base.BaseballBat");
                -- PZNS_UtilsNPCs.PZNS_SetLoadedGun(npcSurvivor);
                PZNS_UtilsNPCs.PZNS_AddItemToInventoryNPCSurvivor(npcSurvivor, "Base.9mmClip");
                PZNS_UtilsNPCs.PZNS_AddItemToInventoryNPCSurvivor(npcSurvivor, "Base.9mmClip");
                PZNS_UtilsNPCs.PZNS_AddItemsToInventoryNPCSurvivor(npcSurvivor, "Base.Bullets9mm", 60);
                -- Cows: Set the job...
                PZNS_UtilsNPCs.PZNS_SetNPCJob(npcSurvivor, "Wander In Bulding");
                -- Cows: Begin styling customizations...
                PZNS_UtilsNPCs.PZNS_SetNPCHairModel(npcSurvivor, "Guard");
                PZNS_UtilsNPCs.PZNS_SetNPCHairColor(npcSurvivor, 0.105882354, 0.09019608, 0.08627451);
                PZNS_UtilsNPCs.PZNS_SetNPCSkinTextureIndex(npcSurvivor, 1);
                PZNS_UtilsNPCs.PZNS_SetNPCSkinColor(npcSurvivor, 1.0, 1.0, 1.0, 1.0);
                PZNS_UtilsDataNPCs.PZNS_SaveNPCData(npcSurvivorID, npcSurvivor);
                isSpawned = true;
            end
        end
    else
        isSpawned = true; -- Cows: Else NPC already spawned or already exists.
    end
    --
    return isSpawned;
end

--- Cows: This is an in-game every one minute check (about 2 seconds in real-life time by default)
--- This is needed because not all NPCs will spawn within range of the player's loaded cell and must therefore be checked regularly to spawn in-game.
function PZNS_AgentNate.npcsSpawnCheck()
    if (isFrameWorkIsInstalled == true) then
        local function npcSpawnedCallback()
            isNPCSpawned = PZNS_AgentNate.spawnMyNPC();
        end
        local function checkIsNPCSpawned()
            if (isNPCSpawned == true) then
                Events.EveryOneMinute.Remove(npcSpawnedCallback);
                Events.EveryOneMinute.Remove(checkIsNPCSpawned);
            end
        end
        Events.EveryOneMinute.Add(npcSpawnedCallback);
        Events.EveryOneMinute.Add(checkIsNPCSpawned);
        -- Events.EveryHours.Add(PZNS_AgentNate.clearNPCsNeeds); -- Cows: Optional, commented out
    end
end

Events.OnGameStart.Add(checkIsFrameWorkIsInstalled);
Events.OnGameStart.Add(PZNS_AgentNate.npcsSpawnCheck);

return PZNS_AgentNate;
