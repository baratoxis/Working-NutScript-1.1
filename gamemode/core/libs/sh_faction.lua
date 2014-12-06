--[[
    NutScript is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    NutScript is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with NutScript.  If not, see <http://www.gnu.org/licenses/>.
--]]

nut.faction = nut.faction or {}
nut.faction.teams = nut.faction.teams or {}
nut.faction.indices = nut.faction.indices or {}

local CITIZEN_MODELS = {
	"models/humans/group01/male_01.mdl",
	"models/humans/group01/male_02.mdl",
	"models/humans/group01/male_04.mdl",
	"models/humans/group01/male_05.mdl",
	"models/humans/group01/male_06.mdl",
	"models/humans/group01/male_07.mdl",
	"models/humans/group01/male_08.mdl",
	"models/humans/group01/male_09.mdl",
	"models/humans/group02/male_01.mdl",
	"models/humans/group02/male_03.mdl",
	"models/humans/group02/male_05.mdl",
	"models/humans/group02/male_07.mdl",
	"models/humans/group02/male_09.mdl",
	"models/humans/group01/female_01.mdl",
	"models/humans/group01/female_02.mdl",
	"models/humans/group01/female_03.mdl",
	"models/humans/group01/female_06.mdl",
	"models/humans/group01/female_07.mdl",
	"models/humans/group02/female_01.mdl",
	"models/humans/group02/female_03.mdl",
	"models/humans/group02/female_06.mdl",
	"models/humans/group01/female_04.mdl"
}

function nut.faction.loadFromDir(directory)
	for k, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		FACTION = nut.faction.teams[niceName] or {index = table.Count(nut.faction.teams) + 1, isDefault = true}
			if (PLUGIN) then
				FACTION.plugin = PLUGIN.uniqueID
			end

			nut.util.include(directory.."/"..v, "shared")
			team.SetUp(FACTION.index, FACTION.name or "Unknown", FACTION.color or Color(125, 125, 125))

			if (!FACTION.models) then
				FACTION.models = CITIZEN_MODELS
			end

			FACTION.uniqueID = niceName

			for k, v in pairs(FACTION.models) do
				if (type(v) == "string") then
					util.PrecacheModel(v)
				elseif (type(v) == "table") then
					util.PrecacheModel(v[1])
				end
			end

			nut.faction.indices[FACTION.index] = FACTION
			nut.faction.teams[niceName] = FACTION
		FACTION = nil
	end
end

if (CLIENT) then
	function nut.faction.hasWhitelist(faction)
		local data = nut.faction.indices[faction]

		if (data) then
			if (data.isDefault) then
				return true
			end

			local nutData = nut.localData and nut.localData.whitelists or {}

			return nutData[SCHEMA.folder] and nutData[SCHEMA.folder][data.uniqueID] == true or false
		end

		return false
	end
end