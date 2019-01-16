# Frost Queue
Frost Queue is meant to be a simple multi-purpose Queue written in Lua. It is implimented as a modified ring buffer or circular array. The main benefit of Frost Queue over a normal ring buffer is that it can grow dynamically without blocking input, losing inputs though overwriting elements that haven't been read yet, or halting input while copying from the old queue to a new larger queue.
## Frost Queue Class Methods
Frost Queue supports these methods:
- Queue:new(size) Method to create new Queue with inital size = size argument.
   ```
   local q = Queue:new(10)
   ```
- Queue:add(element) Method to add an element to the Queue.
   ```
   q:add(e)
   ```
- Queue:use() Method that returns next unread element from the Queue. (If you want to look without removing the element, see Peek below.)
   ```
   local elemnt = q:use()
   ```
- Queue:peek(nth) Method to return elements without removing them from the Queue. If called with no arguments, it will look at the next element. Peek will return nil when there is no next element on the Queue. It can also look for the nth element or return nil if there isn't that many elements.
   ```
   local next = q:peek() --Gets the next element
   local thrid = q:peek(3) --Get third element, if any or return nil
   ```
- Queue:search(filter, ...) Return a table of elements that caused the filter function to return true.
   ```
   local matches = q:search(string.find, "match")
   ```
- Queue:split(filter, ...) Returns two Queues of elements. The first contains any elements that made the filter function return true. The second contains any values that did not make the filter function return false.
   ```
   local a, b = q:split(string.find, "a")
   ```
- Queue:merge(a, b, fun, ...) Merges two Queues into one. By default, when no "fun" parameter is given, b is merged into a with its elements placed behind a's. If a function is given in parameter "fun", it will be used instead.
   ```
   local simple_merge = (a, b)
   ```
- Queue:update() Returns whether the Queue has been changed since the last time the update function has been called. Update will return true to indicate that the Queue has chanegd if Queue:use() or Queue:add() has been called. (It may not catch if a Queue has been merged, split or had other operation has been done to a Queue.)
- Queue:map(fun, ...) Returns a new Queue where each element of the calling Queue has had the function given by the "fun" argument called on it. This does not affect the original Queue's elements.
   ```
   local add_5 = q:map(function(x) return x + 5 end)
   ```
