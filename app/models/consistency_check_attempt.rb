# frozen_string_literal: true

# The ConsistencyCheckAttempt model
class ConsistencyCheckAttempt < ReasoningAttempt
  many_to_one :oms, class: OMS
end
