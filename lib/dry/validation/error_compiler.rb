require 'dry/validation/message_compiler'

module Dry
  module Validation
    class ErrorCompiler < MessageCompiler
      def message_type
        :failure
      end

      def message_class
        Message
      end

      def visit_error(node, opts = {})
        rule, error = node
        node_path = Array(opts.fetch(:path, rule))

        path = if rule.is_a?(Array) && rule.size > node_path.size
                 rule
               else
                 node_path
               end

        text = messages[rule]

        if text
          Message.new(node, path, text, rule: rule)
        else
          visit(error, opts.merge(path: path))
        end
      end

      def visit_input(node, opts = {})
        rule, result = node
        visit(result, opts.merge(rule: rule))
      end

      def visit_result(node, opts = {})
        input, other = node
        visit(other, opts.merge(input: input))
      end

      def visit_schema(node, opts = {})
        visit(node)
      end

      def visit_check(node, opts = {})
        path, other = node
        visit(other, opts.merge(path: Array(path)))
      end
    end
  end
end
