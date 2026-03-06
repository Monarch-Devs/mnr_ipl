-- Global Objects

---@class MonarchEntityset
---@field enable boolean To enable/disable the entityset
---@field id string The ID of the entityset 

---@class MonarchIpl
---@field enable boolean To enable/disable the IPL

---@class MonarchInterior
---@field enable boolean To enable/disable the interior
---@field entitysets MonarchEntityset[]? Entitysets available for the interior

-- Vanilla Config (config/vanilla.lua)

---@class MonarchVanillaConfig
---@field ipls table<string, MonarchIpl> Vanilla IPLs config
---@field ints table<number, MonarchInterior> Vanilla Interiors config

-- Patches Config (config/patches.lua)

---@class MonarchPatch
---@field maps string[]
---@field ipls table<string, MonarchIpl>?
---@field ints table<number, MonarchInterior>?

---@class MonarchPatchesConfig : MonarchPatch[]

-- Customs Config (config/customs.lua)

---@class MonarchCustomsConfig
---@field ipls table<string, MonarchIpl>
---@field ints table<number, MonarchInterior>

-- Dynamic Config (config/dynamic.lua)

---@class MonarchDynamicZone
---@field coords vector3 The center coordinates of the zone
---@field size vector3 The size of the zone
---@field rotation number The rotation of the zone
---@field debug boolean Whether to show the debug zone
---@field ipls string[] IPLs to load when inside the zone

---@alias MonarchDynamicConfig table<string, MonarchDynamicZone>