local Class = {}

function Class.new(name, parent)
  -- Initialize class table with anything we were given.
  class = {
    class_name = name,
    class_parent = parent,
  }

  -- The class table itself acts as the metatable for instance tables.
  class.__index = class

  -- Make sure a constructor is defined if not provided.
  class.init = class.init or function() end

  -- When the class is called like a function, create a fresh instance table,
  -- set its metatable to the class table, and invoke the init() function to
  -- construct the instance table.
  return setmetatable(class, {
    __call = function(c, ...)
      local instance = setmetatable({}, c)
      instance:init(...)
      return instance
    end,

    __index = parent,
  })
end

-- When the Class module is called like a function, invoke Class.new().
setmetatable(Class, {
  __call = function(_, ...)
    return Class.new(...)
  end
})

return Class
