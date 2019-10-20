
local shapeShifts = {
    "Ghost Wolf",
    "Bear Form",
    "Dire Bear Form",
    "Cat Form",
    "Moonkin Form",
    "Aquatic Form",
    "Travel Form",
    "Shadowform",
};

local shapeShiftErros = {
    ERR_MOUNT_SHAPESHIFTED,
    ERR_NOT_WHILE_SHAPESHIFTED,
    ERR_TAXIPLAYERSHAPESHIFTED
}

local mountedErrors = {
    SPELL_FAILED_NOT_MOUNTED,
    ERR_NOT_WHILE_MOUNTED,
    ERR_TAXIPLAYERALREADYMOUNTED,
    ERR_ATTACK_MOUNTED,
};

local standingErros = {
    ERR_LOOT_NOTSTANDING,
    ERR_TAXINOTSTANDING,
    SPELL_FAILED_NOT_STANDING
};

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true;
        end
    end

    return false;
end

local frame = CreateFrame("frame", 'Dismmount Frame');

frame:RegisterEvent("UI_ERROR_MESSAGE") ;

frame:SetScript("OnEvent", function(self, event, arg1, msg)
    
    if (has_value(mountedErrors, msg)) then
        Dismount();
    end

    if (has_value(standingErros, msg)) then
        DoEmote("STAND");
    end

    if (has_value(shapeShiftErros, msg)) then
        for i=1,40 do
            local name = UnitBuff("player", i);
            if (name and has_value(shapeShifts, name)) then
              CancelUnitBuff("player", i);
            end
        end
    end

end)

TaxiFrame:HookScript('OnShow', function()
    for i=1, NumTaxiNodes() do
        local frame = _G["TaxiButton"..i];
        frame:HookScript('OnMouseUp', function()
            GetNumRoutes(i);
            TakeTaxiNode(i);
            -- it takes some time before the player actually has dismounted so just try to take the flight path every 1/4s for 2s
            for t=0,8 do
                C_Timer.After(t/4,function() 
                    if (UnitOnTaxi("player") == false) then
                        TakeTaxiNode(i) ;
                    end;
                end)
            end
        end);
    end
end)


