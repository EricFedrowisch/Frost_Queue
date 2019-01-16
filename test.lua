if package.config:sub(1,1) == "/" then os.execute("clear") end

local function line()
   print("--------------------------------------------")
end

local function tprint (t, shift, container)
   local container = container or nil
   if t ~= nil and type(t) == 'table' then
      shift = shift or 0
      for k, v in pairs(t) do
         local str = string.rep("   ", shift) .. k .. " = "
         if type(v) == "table"  and t ~= container and k ~= "_container" and k ~= "self" then
            print(str)
            tprint(v, shift+1, t)
         else
            print(str .. tostring(v))
         end
      end
   else
      if t == nil then
         print("nil")
      elseif type(t) ~= 'table' then
         error(tostring(t) .. " of type " .. type(t) .. " is not a table.")
      end
   end
end

local function q_add_setup(verbose)
   local q = require("frost_queue")
   local msgs = {"1st Add", "2nd Add", "3rd Add"}
   if verbose then
      print("Basic Non-Grow Required Q Test:")
      line()
      print("Init new Q:")
   end
   local test_q = q:new(3)
   if verbose then
      tprint(test_q)
      line()
      print("Add element...")
   end
   test_q:add(msgs[1])
   if verbose then
      tprint(test_q)
      line()
      print("Add element...")
   end
   test_q:add(msgs[2])
   if verbose then
      tprint(test_q)
      line()
      print("Add element...")
   end
   test_q:add(msgs[3])
   if verbose then
      tprint(test_q)
      line()
   end
   return test_q
end

local function q_test(verbose)
   local q = require("frost_queue")
   local test_q = q_add_setup(verbose)
   if verbose then
      tprint(test_q)
      line()
      print("Use Tests:")
   end
   local use = test_q:use()
   if verbose then
      print("Use 1st = ", use)
      tprint(test_q)
      line()
   end
   use = test_q:use()
   if verbose then
      print("Use 2nd = ", use)
      tprint(test_q)
      line()
   end
   use = test_q:use()
   if verbose then
      print("Use 3rd = ", use)
      tprint(test_q)
      line()
   end
   use = test_q:use()
   if verbose then
      print("Use Nonexistent 4th = ", use)
      tprint(test_q)
      line()
   end
   test_q:add("4th")
   if verbose then
      print("Adding 4th")
      tprint(test_q)
      line()
   end
   use = test_q:use()
   if verbose then
      print("Use 4th = ", use)
      tprint(test_q)
      line()
   end
   use = test_q:use()
   if verbose then
      print("Use Nonexistent 5th = ", use)
      tprint(test_q)
      line()
   end
end

local function q_overrun_setup(verbose)
   local q = require("frost_queue")
   local test_q = q_add_setup(verbose)
   test_q:add("4, 1st Overrun")
   if verbose then
      tprint(test_q)
      line()
   end
   test_q:add("5, 2nd Overrun")
   if verbose then
      tprint(test_q)
      line()
   end
   return test_q
end

local function q_peek_test(verbose)
   local test_q = q_overrun_setup(verbose)
   print("Next + 0:",test_q:peek())
   line()
   print("Next + 1:",test_q:peek(1))
   line()
   print("Next + 2:",test_q:peek(2))
   line()
   print("Next + 3:",test_q:peek(3))
   line()
   print("Next + 4:",test_q:peek(4))
   line()
   print("Next + 5:",test_q:peek(5))
   line()
end

local function q_search_test(verbose)
   local test_q = q_overrun_setup(verbose)
   print("Find elements with 'Add' in them:")
   local hits = test_q:search(string.find, "Add")
   tprint(hits)
   print("Find elements with '1' in them:")
   local hits = test_q:search(string.find, "1")
   tprint(hits)
end

local function q_overrun_test(verbose)
   local test_q = q_overrun_setup(verbose)
   local got = nil
   for i=1,5 do
      print("Use #" .. i)
      print("Got " .. tostring(test_q:use()))
      tprint(test_q)
      line()
   end
end


local function q_split_test(verbose)
   local test_q = q_overrun_setup(verbose)
   local a,b = test_q:split(string.find, "1")
   print("Q A, matches filter: 'string.find, 1")
   tprint(a)
   print("Q B, does not match filter: 'string.find, 1")
   tprint(b)
   print("Original Q Should be unchanged:")
   tprint(test_q)
end

local function q_update_test(verbose)
   local test_q = q_overrun_setup(verbose)
   print("Updated?")
   print(test_q:update())
   print("Updated Now?")
   print(test_q:update())
   print("Add element...")
   test_q:add(6)
   if verbose then
      tprint(test_q)
      line()
      print("Add element...")
   end
   print("Updated?")
   print(test_q:update())
   print("Updated Now?")
   print(test_q:update())
   print("Using element...")
   test_q:add(6)
   print("Updated?")
   print(test_q:update())
   print("Updated Now?")
   print(test_q:update())
end

local function q_merge_test(verbose)
   local q = require("frost_queue")
   local a_msgs = {"1st Add", "2nd Add", "3rd Add", "QA Over 1", "QA Over 2"}
   local b_msgs = {"1st Add", "2nd Add", "3rd Add", "QB Over 1", "QB Over 2"}
   local q_a = q:new(3)
   q_a:add(a_msgs[1])
   q_a:add(a_msgs[2])
   q_a:add(a_msgs[3])
   q_a:add(a_msgs[4])
   q_a:add(a_msgs[5])
   local q_b = q:new(3)
   q_b:add(b_msgs[1])
   q_b:add(b_msgs[2])
   q_b:add(b_msgs[3])
   q_b:add(b_msgs[4])
   q_b:add(b_msgs[5])
   local merged_q = q:merge(q_a, q_b)
   tprint(merged_q)
   local use = merged_q:use()
   while use ~= nil do
      print(use)
      use = merged_q:use()
   end
   tprint(merged_q)
end

local function q_map_test(verbose)
   local q = require("frost_queue")
   local function test_function(x)
      return x + 5
   end
   local map_q = q:new(3)
   map_q:add(5)
   map_q:add(10)
   map_q:add(15)
   map_q:add(20)
   tprint(map_q)
   line()
   local mapped = map_q:map(test_function)
   tprint(mapped)
end

local verbose = true
q_test(verbose)
q_peek_test(verbose)
q_search_test(verbose)
q_overrun_test(verbose)
q_split_test(verbose)
q_update_test(verbose)
q_merge_test(verbose)
q_map_test(verbose)
