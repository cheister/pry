class Pry
  class Command
    class Ls < Pry::ClassCommand
      class Formatter
        attr_writer :grep
        attr_reader :pry_instance

        def initialize(pry_instance)
          @pry_instance = pry_instance
          @target = pry_instance.current_context
          @default_switch = nil
        end

        def write_out
          return false unless correct_opts?

          output_self
        end

        private

        def color(type, str)
          Pry::Helpers::Text.send pry_instance.config.ls["#{type}_color"], str
        end

        # Add a new section to the output.
        # Outputs nothing if the section would be empty.
        def output_section(heading, body)
          return '' if body.compact.empty?

          fancy_heading = Pry::Helpers::Text.bold(color(:heading, heading))
          Pry::Helpers.tablify_or_one_line(fancy_heading, body, @pry_instance.config)
        end

        def format_value(value)
          Pry::ColorPrinter.pp(value, '')
        end

        def correct_opts?
          @default_switch
        end

        def output_self
          raise NotImplementedError
        end

        def grep
          @grep || proc { |x| x }
        end
      end
    end
  end
end
