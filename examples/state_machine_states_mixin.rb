# encoding: utf-8

center <<-EOS
  State Machine single object static/dynamic state mix-in

  Lecky Lao(@leckylao)

  RORO 08-04-2014
EOS

section "Static State" do
  center <<-EOS
    States:
    ┌─────────────┐
    │parked       │
    ├─────────────┤
    │idling       │
    ├─────────────┤
    │first_gear   │
    ├─────────────┤
    │driving      │
    └─────────────┘
  EOS

  center <<-EOS
    Events:
    ┌──────────────────────────────────────────────────────────┐
    │ignite (parked => idling)                                 │
    ├──────────────────────────────────────────────────────────┤
    │shift_up (idling => first_gear, first_gear => driving)    │
    ├──────────────────────────────────────────────────────────┤
    │shift_down (driving => first_gear, first_gear => idling)  │
    ├──────────────────────────────────────────────────────────┤
    │park (idling => parked)                                   │
    └──────────────────────────────────────────────────────────┘
  EOS
end

section "Dynamic State" do
  center <<-EOS
    Dynamic machine states under state driving:
    ┌────────────────┐
    │go_straight     │
    ├────────────────┤
    │turn_left       │
    ├────────────────┤
    │turn_right      │
    └────────────────┘
  EOS

  center <<-EOS
    Events:
    ┌──────────────────────────────────────────────────────────┐
    │do_go_straight (previous_state => go_straight)            │
    ├──────────────────────────────────────────────────────────┤
    │do_turn_left (previous_state => turn_left)                │
    ├──────────────────────────────────────────────────────────┤
    │do_turn_right (previous_state => turn_right)              │
    └──────────────────────────────────────────────────────────┘
  EOS
end

section "----Example----" do
  block <<-EOS
    Main Mainche States:

      * initial: parked
      * (ignite)=> idling
      * (shift_up)=> first_gear
      * (shift_up)=> driving
      * (shift_down)=> first_gear
      * (shift_down)=> idling
      * (park)=> parked
  EOS

  block <<-EOS
    Sub Machine States:

      * initial: driving
      * (go_straight)=> going_straight
      * (turn_left)=> turning_left
      * (turn_right)=> turning_right
  EOS
end

section "----Columns----" do
  center <<-EOS
    Main Static Machine:

    :state, :previous_state
  EOS

  center <<-EOS
    Sub Dynamic Machine:

    :machine_state, :previous_machine_state
  EOS
end

section "----Class----" do
  code <<-EOS
    class Vehicle
      state_machine :state, initial => :parked do
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
    end
  EOS

  code <<-EOS
    class Machine
      def initialize(object, *args, &block)
        machine_class = Class.new
        machine = machine_class.state_machine(:machine_state, *args, &block)
        attribute = machine.attribute
        action = machine.action

        # Delegate attributes
        machine_class.class_eval do

          define_method(:definition) { machine }
          define_method(attribute) { object.send(attribute) }
          define_method("\#{attribute}=") {|value| object.send("\#{attribute}=", value) }
          define_method(action) { object.send(action) } if action
          # Custom
          define_method(:attributes) { object.send(:attributes) }
          define_method(:previous_machine_state) { object.send(:previous_machine_state) }
          define_method(:previous_machine_state=) {|value| object.send(:previous_machine_state=, value) }
        end

        machine_class.new
      end

    end
  EOS
end

section "----Methods----" do
  code <<-EOS
    def next_state
      return unless self.respond_to?(:state_events) # No more states
      begin
        next_event = self.machine.machine_state_events.last
        if next_event
          self.machine.send(next_event)
        else # No more dynamic states
          next_event = self.state_events.last
          self.send(next_event)
        end
      rescue NoMethodError
        next_event = self.state_events.last
        self.send(next_event)
      end
      logger.info "Next event: " + next_event.inspect
    end
  EOS

  code <<-EOS
    def retry
      begin
        if self.previous_machine_state
          self.update_attributes(:machine_state => self.previous_machine_state)
          self.machine.send(self.machine.machine_state_events.last)
        else
          self.update_attributes(state:self.previous_state)
          self.send(self.state_events.last)
        end
      rescue NoMethodError
        self.update_attributes(state:self.previous_state)
        self.send(self.state_events.last)
      end
    end
  EOS

  code <<-EOS
    def machine_init
      pre_state = :driving
      states = [:go_straight, :turn_left, :turn_right].sample

      Machine.new(self, :initial => :driving, :action => :save) do
        states.each do |state_sym|
          event_name = %(do_\#{state}).to_sym

          before_transition any => any do |vehicle, transition|
            vehicle.previous_machine_state = transition.from
          end

          state(state_sym)

          event(event_name) do
            transition pre_state => state_name
          end

          pre_state = state_name
        end
      end

    end
  EOS
end

section "----Demo----" do
end

center <<-EOS
  That's all. Thanks! Any questions?

  State Machine single object static/dynamic state mix-in

  Lecky Lao(@leckylao)

  RORO 08-04-2014
EOS

__END__
