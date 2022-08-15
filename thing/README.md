# Thing

For this challenge you will be using some meta-programming magic to create
a new Thing object. This object will allow you to define things in a descriptive sentence like format.

This challenge will build on itself in an increasingly complex manner as you progress through the test cases.
Examples of what can be done with "Thing":

```ruby
jane = Thing.new("Jane")
jane.name # =>
jane.is_a.person
puts jane.person? # => true
jane.is_a.person
jane.is_a.woman
jane.is_not_a.man
puts jane.person? # => true
puts jane.man? # => false
# can define properties on a per instance Level
jane.is_the.parent_of.joe
puts jane.parent_of # => joe

# can define number of child things
# when more than 1, an array is created
jane.has(2).legs
puts jane.legs.size # => 2
puts jane.legs.first.is_a?(Thing) # => true

# can define single items
jane.has(1).head

puts jane.head.is_a?(Thing) # => true

# can define number of things in a chainable and natural format
jane.has(2).arms.each { having(1).hand.having(5).fingers }

puts jane.arms.first.hand.fingers.size # => 5

# can define properties on nested items
jane.has(1).head.having(2).eyes.each { being_the.color.blue.with(1).pupil.being_the.color.black }

# can define methods
jane.can.speak("spoke") do |phrase|
  "#{name} says: #{phrase}"
end

jane.speak("hello") # => "Jane says: hello"

# if past tense was provided then method calls are tracked
puts jane.spoke # => ["Jane says: hello"]

# Note: Most of the test cases have already been provided for you so that you can see how the Thing object is supposed to work.
```