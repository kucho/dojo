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
