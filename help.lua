function describe_function(obj,indent)
  local indent = indent or ""
  local info = debug.getinfo(obj)
  local params = {}
  for i=1,info.nparams do
    table.insert(params,string.format("para%d",i))
  end
  if info.isvararg then
    table.insert(params,"...")
  end
  params = table.concat(params,",")
  return string.format("function(%s)",params)
end

function describe_other(obj,indent)
  local indent = indent or ""
  return string.format("%s%s\n",indent,obj)
end

function describe_table(obj,indent,described)
  local described = described or {}
  local indent = indent or ""
  description = ""
  for k,v in pairs(obj) do
    description = description .. string.format("%s%s:%s\n",indent,k,describe(v,indent,described))
  end
  return description
end

function describe(obj,indent,described)
  local indent = indent or ""
  local described = described or {}
  for i,k in ipairs(described) do
    if k == obj then
      return describe_other(obj,indent)
    end
  end
  table.insert(described,obj)
  local description=""
  if type(obj) == "table" then
      description = description .. describe_table(obj,indent,described)
  elseif type(obj) == "function" then
    description = description .. describe_function(obj,indent)
  else
    description = description .. describe_other(obj,indent)
  end

  local metatable = getmetatable(obj)
  if metatable then
    description = description .. string.format("%smetatable of %s is %s which contains:\n",indent,obj,metatable)
    description = description .. describe(metatable,indent.."  ",described)
  end
  return description
end
