Md.entity = {}

---@param entity integer
function Md.entity.delete(entity)
  if not DoesEntityExist(entity) then return end
  DeleteEntity(entity)
end

return Md.entity