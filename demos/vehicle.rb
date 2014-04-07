require 'rubygems'
require 'state_machine'

class Vehicle
  attr_accessor :previous_state, :machine_state, :previous_machine_state
  state_machine :state, :initial => :parked do
    before_transition any => any do |vehicle, transition|
      vehicle.previous_state = transition.from
    end

    # States:
    state :parked
    state :idling
    state :first_gear
    state :driving do
      def machine
        machine_init
      end
    end

    # Events:
    event :ignite do
      transition :parked => :idling
    end

    event :shift_up do
      transition :idling => :first_gear, :first_gear => :driving
    end

    event :shift_down do
      transition :driving => :first_gear, :first_gear => :idling
    end

    event :park do
      transition :idling => :parked
    end
  end

  def next_state!
    return unless self.respond_to?(:state_events) # No more states
    begin
      next_event = self.machine.machine_state_events.first
      if next_event
        self.machine.send(next_event)
      else # No more dynamic states
        next_event = self.state_events.first
        self.previous_machine_state = nil
        self.send(next_event)
      end
    rescue NoMethodError => e
      raise e unless e.message =~ /^super: no superclass method `machine' for /
      next_event = self.state_events.first
      self.send(next_event)
    end
    next_event
  end

  def previous_state!
    begin
      if self.previous_machine_state
        self.machine_state = self.previous_machine_state
      else
        self.state = self.previous_state
      end
    rescue NoMethodError => e
      raise e unless e.message =~ /^super: no superclass method `machine' for /
      self.state = self.previous_state
    end
  end

  def machine_init
    pre_state = :driving
    states = [:going_straight, :turning_left, :turning_right].shuffle

    @machine ||= Machine.new(self, :initial => :driving, action: :save) do
      states.each do |state_sym|
        event_name = %(do_#{state_sym}).to_sym

        before_transition any => any do |vehicle, transition|
          vehicle.previous_machine_state = transition.from
        end

        state(state_sym)

        event(event_name) do
          transition pre_state => state_sym
        end

        pre_state = state_sym
      end
    end
  end

  def save
    true
  end

end

class Machine
  def self.new(object, *args, &block)
    machine_class = Class.new
    machine = machine_class.state_machine(:machine_state, *args, &block)
    attribute = machine.attribute
    action = machine.action

    # Delegate attributes
    machine_class.class_eval do

      define_method(:definition) { machine }
      define_method(attribute) { object.send(attribute) }
      define_method("#{attribute}=") {|value| object.send("#{attribute}=", value) }
      define_method(action) { object.send(action) } if action
      # Custom
      define_method(:previous_machine_state) { object.send(:previous_machine_state) }
      define_method(:previous_machine_state=) {|value| object.send(:previous_machine_state=, value) }
    end

    machine_class.new
  end

end
