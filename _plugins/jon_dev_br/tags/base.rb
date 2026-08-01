# frozen_string_literal: true

require "cgi"
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

      # Liquid::Block#blank? reports whether the tag's *body* is empty and,
      # when true, the parent BlockBody silently drops this tag's rendered
      # output (see block_body.rb's render_node_to_output). That is fine for
      # stock Liquid blocks, whose output is the body itself, but every ds-*
      # tag renders real markup from render_html regardless of body content
      # — most sharply for youtube and figure, whose bodies are always empty.
      # Left at the inherited default, their entire output would vanish.
      def blank?
        false
      end

      private

      def attribute(key)
        @attributes[key.to_s]
      end

      # HTML-escapes an attribute's value for interpolation into rendered
      # markup. Attribute *values* are free text the author writes inline in
      # Liquid markup — unlike a tag's body, they never go through
      # `markdownify`, so nothing else escapes them. `Attributes::PAIR`'s
      # `[^"]*` keeps a value from ever containing a `"`, so this is not a
      # security boundary, but an unescaped `&` or `<` in a caption still
      # produces invalid HTML or accidental live markup.
      def escaped(key)
        CGI.escapeHTML(attribute(key).to_s)
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
