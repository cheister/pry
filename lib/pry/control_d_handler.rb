class Pry
  # @api private
  # @since ?.?.?
  module ControlDHandler
    # Deal with the ^D key being pressed. Different behaviour in different
    # cases:
    #   1. In an expression behave like `!` command.
    #   2. At top-level session behave like `exit` command.
    #   3. In a nested session behave like `cd ..`.
    def self.default(eval_string, pry_instance)
      if !eval_string.empty?
        eval_string.replace('') # Clear input buffer.
      elsif pry_instance.binding_stack.one?
        pry_instance.binding_stack.clear
        throw(:breakout)
      else
        # Otherwise, saves current binding stack as old stack and pops last
        # binding out of binding stack (the old stack still has that binding).
        pry_instance.command_state['cd'] ||= Pry::Config.from_hash({})
        pry_instance.command_state['cd'].old_stack = pry_instance.binding_stack.dup
        pry_instance.binding_stack.pop
      end
    end
  end
end
