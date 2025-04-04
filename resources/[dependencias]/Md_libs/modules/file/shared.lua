Md.file = {}

function Md.file.load(modname)
  if type(modname) ~= 'string' then return end
  local modpath = modname:gsub('%.', '/')

  local file = LoadResourceFile('Md_libs', ('modules/%s.lua'):format(modpath))

  if file then
    local fn, err = load(file, ('@@Md_libs/modules/%s.lua'):format(modpath))

    if not fn or err then
      return error(('\n^1Error loading file (%s): %s^0'):format(modpath, err), 3)
    end

    pcall(fn)
  end
end

return Md.file