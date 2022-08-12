class BoundedArray < Array
  def each(&block)
    super do |thing|
      thing.instance_eval(&block)
    end
  end
end

class Proxy
  def self.for(instance, &block)
    instance = new(instance)
    # Setup proxy
    instance.instance_exec(&block)
    instance
  end

  attr_reader :thing
  def initialize(thing)
    @thing = thing
  end

  def on_method_missing(&block)
    @on_method_missing = block
  end

  # rubocop:disable Style/MissingRespondToMissing
  def method_missing(symbol, *args, &block)
    @on_method_missing.call(symbol, args, &block)
  end
  # rubocop:enable Style/MissingRespondToMissing
end

class Thing
  attr_reader :name

  def initialize(name = nil)
    @name = name.to_s
  end

  def is_a
    Proxy.for(self) do
      on_method_missing do |name|
        thing.create_method("#{name}?") { true }
      end
    end
  end

  def is_not_a
    Proxy.for(self) do
      on_method_missing do |name|
        thing.create_method("#{name}?") { false }
      end
    end
  end

  def is_the
    Proxy.for(self) do
      on_method_missing do |property_name|
        Proxy.for(thing) do
          on_method_missing do |property_value|
            thing.create_method(property_name) { property_value.to_s }
            thing
          end
        end
      end
    end
  end

  alias_method :being_the, :is_the
  alias_method :and_the, :is_the

  def has(count)
    Proxy.for(self) do
      on_method_missing do |property_name|
        property_value = if count > 1
          BoundedArray.new(count) { Thing.new(property_name) }
        else
          Thing.new(property_name)
        end

        thing.create_method(property_name) { property_value }
        property_value
      end
    end
  end

  alias_method :having, :has
  alias_method :with, :has

  def can
    Proxy.for(self) do
      on_method_missing do |method_name, args, &method_block|
        activity_name = args.first

        if activity_name
          activity_runs = []
          thing.instance_variable_set("@#{activity_name}", activity_runs)

          execute_and_record = ->(arg) do
            activity_runs << instance_exec(arg, &method_block)
          end

          thing.create_method(method_name, &execute_and_record)
          thing.create_method(activity_name) { activity_runs }
        else
          thing.create_method(method_name, &method_block)
        end
      end
    end
  end

  def create_method(name, &block)
    define_singleton_method(name, &block)
  end
end

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
