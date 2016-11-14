local fun  = require('fun')
local log  = require('log')
local json = require('json')

local iter, op  = fun.iter, fun.operator

function split(self, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) table.insert(fields, c) end)
    return fields
end

local function opge(l, r)
    l = type(l) == 'string' and tonumber(l) or l
    r = type(r) == 'string' and tonumber(r) or r
    return l >= r
end

local function check_version(expected)
    local vtable  = split(_TARANTOOL, '.')
    local vtable2 = split(vtable[3],  '-')
    vtable[3], vtable[4] = vtable2[1], vtable2[2]
    return iter(vtable):zip(expected):every(opge)
end

local function get_actual_numtype()
    return check_version{1, 7, 2} and 'unsigned' or 'num'
end

local function get_actual_strtype()
    return check_version{1, 7, 2} and 'string' or 'str'
end

local function get_actual_vinylname()
    return check_version{1, 7} and 'vinyl' or 'sophia'
end

return {
    check_version = check_version,
    vinyl_name = get_actual_vinylname,
    num_type = get_actual_numtype,
    str_type = get_actual_strtype
}