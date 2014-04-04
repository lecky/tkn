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
    │going_straight  │
    ├────────────────┤
    │turning_left    │
    ├────────────────┤
    │turning_right   │
    └────────────────┘.sample
  EOS

  center <<-EOS
    Events:
    ┌──────────────────────────────────────────────────────────┐
    │go_straight (previous_state => going_straight)            │
    ├──────────────────────────────────────────────────────────┤
    │turn_left (previous_state => turning_left)                │
    ├──────────────────────────────────────────────────────────┤
    │turn_right (previous_state => turning_right)              │
    └──────────────────────────────────────────────────────────┘
  EOS
end

section "Example" do
  center <<-EOS
    Main Mainche States:
    parked (ignite)=> idling (shift_up)=> first_gear (shift_up)=> driving (shift_down)=> first_gear (shift_down)=> idling (park)=> parked

    Sub Machine States:
    driving (go_straight)=> going_straight (turn_left)=> turning_left (turn_right)=> turning_right
  EOS
end

section "Columns" do
  center <<-EOS
    Main (Static)Machine:
    state, previous_state

    Sub (Dynamic)Machine:
    machine_state, previous_machine_state
  EOS
end

section "Class" do
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
end

section "Methods" do
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
    end
  EOS
end

__END__
