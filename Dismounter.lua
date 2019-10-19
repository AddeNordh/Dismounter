
local frame = CreateFrame("frame", 'Dismmount Frame');
frame:RegisterEvent("UI_ERROR_MESSAGE") ;
frame:SetScript("OnEvent", function(self, event, addon, msg) 
    if (string.match(msg, "mounted")) then
        Dismount();
--[[         if (spellKey ~= nil) then
            local binding = GetBindingByKey(spellKey);
            RunBinding(binding, "up")
            print(binding);
        end ]]
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
                        TakeTaxiNode(i) 
                    end;
                end)
            end
        end);
    end
end)



--[[ 
local spellKey = nil;
local spellKeyFrame = CreateFrame("Frame", "spellKeyFrame")
 
local function setSpellKey(self, key)
    spellKey = key;
end
 
spellKeyFrame:SetScript("OnKeyDown", setSpellKey);
spellKeyFrame:SetPropagateKeyboardInput(true); ]]