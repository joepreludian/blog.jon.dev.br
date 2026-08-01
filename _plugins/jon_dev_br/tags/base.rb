# frozen_string_literal: true

require_relative "attributes"

module JonDevBr
  module Tags
    # Shared superclass for the ds-* block tags.
    #
    # Subclasses declare their attributes with `required` and `optional`, then
    # implement `render_html(body, context)`. Attributes are validated at parse
    # time, so a malformed tag fails the build with a message naming the file
    # rather than silently rendering nothing.
    class Base < Liquid::Block
      class << self
        def required(*keys)
          @required_keys = keys.map(&:to_s) unless keys.empty?
          @required_keys || []
        end

        def optional(*keys)
          @optional_keys = keys.map(&:to_s) unless keys.empty?
          @optional_keys || []
        end
      end

      def initialize(tag_name, markup, parse_context)
        super
        @attributes = Attributes.parse!(
          markup,
          tag_name: tag_name,
          required: self.class.required,
          optional: self.class.optional
        )
      end

      # Subclasses implement render_html, never render.
      def render(context)
        render_html(super.to_s.strip, context)
      end

      private

      def attribute(key)
        @attributes[key.to_s]
      end

      def markdownify(text, context)
        context
          .registers[:site]
          .find_converter_instance(Jekyll::Converters::Markdown)
          .convert(text)
      end

      def render_html(_body, _context)
        raise NotImplementedError, "#{self.class} must implement render_html"
      end
    end
  end
end
