local vanilla = lib.load('config.vanilla') --[[@as MonarchVanillaConfig]]
local patches = lib.load('config.patches') --[[@as MonarchPatchesConfig]]
local customs = lib.load('config.customs') --[[@as MonarchCustomsConfig]]
local dynamic = lib.load('config.dynamic') --[[@as MonarchDynamicConfig]]

-- Function to toggle the IPL
---@param ipl string The IPL ID
---@param toggle boolean To enable/disable the IPL
local function toggleIpl(ipl, toggle)
    local active = IsIplActive(ipl)

    if toggle and not active then
        RequestIpl(ipl)
    elseif not toggle and active then
        RemoveIpl(ipl)
    end
end

-- Function to setup the entitysets in config
---@param interior number The ID of the interior
---@param entitysets table<number, MonarchEntityset> The entitysets to setup
local function setupEntitySets(interior, entitysets)
    for _, data in ipairs(entitysets) do
        local active = IsInteriorEntitySetActive(interior, data.id)

        if data.enable and not active then
            ActivateInteriorEntitySet(interior, data.id)
        elseif not data.enable and active then
            DeactivateInteriorEntitySet(interior, data.id)
        end
    end

    RefreshInterior(interior)
end

-- Function to toggle the interior
---@param interior number The ID of the interior
---@param data MonarchInterior The interior data
local function toggleInt(interior, data)
    local disabled = IsInteriorDisabled(interior)

    if data.enable and disabled then
        DisableInterior(interior, false)
    elseif not data.enable and not disabled then
        DisableInterior(interior, true)
    end

    if data.entitysets and not IsInteriorDisabled(interior) then
        setupEntitySets(interior, data.entitysets)
    end
end

-- Function to check if patch should be applied
---@param patch MonarchPatch
local function checkPatch(patch)
    for _, resource in ipairs(patch.maps) do
        if GetResourceState(resource) ~= 'started' then
            return
        end
    end

    if patch.ints then
        for int, data in pairs(patch.ints) do
            toggleInt(int, data)
        end
    end

    if patch.ipls then
        for ipl, data in pairs(patch.ipls) do
            toggleIpl(ipl, data.enable)
        end
    end
end

-- Function to clean the IPLs and toggle them dynamically instead
---@param ipls string[] The IPLs to clean
local function cleanIpls(ipls)
    for _, ipl in ipairs(ipls) do
        if IsIplActive(ipl) then
            RemoveIpl(ipl)
        end
    end
end

-- Function to load dynamically the IPLs of the zone
---@param ipls string[] The IPLs to load
local function toggleDynamicIpl(ipls, inside)
    for _, name in ipairs(ipls) do
        if inside then
            RequestIpl(name)
        elseif not inside then
            RemoveIpl(name)
        end
    end
end

-- Function to create the zone of the dynamic ipls
---@param data MonarchDynamicZone
local function createZone(data)
    cleanIpls(data.ipls)

    lib.zones.box({
        coords = data.coords,
        size = data.size,
        rotation = data.rotation,
        debug = data.debug,
        onEnter = function(self)
            toggleDynamicIpl(data.ipls, true)
        end,
        onExit = function(self)
            toggleDynamicIpl(data.ipls, false)
        end,
    })
end

-- SETUP VANILLA
for ipl, data in pairs(vanilla.ipls) do
    toggleIpl(ipl, data.enable)
end

for int, data in pairs(vanilla.ints) do
    toggleInt(int, data)
end

-- PATCHES FIXES (Avoids conflicts with custom Maps/MLOs)
for _, data in ipairs(patches) do
    checkPatch(data)
end

-- SETUP CUSTOM 
for ipl, data in pairs(customs.ipls) do
    toggleIpl(ipl, data.enable)
end

for int, data in pairs(customs.ints) do
    toggleInt(int, data)
end

-- SETUP DYNAMIC
for _, data in pairs(dynamic) do
    createZone(data)
end