# frozen_string_literal: true

module JonDevBr
  module Tags
    # Parses `key="value"` pairs out of Liquid tag markup.
    #
    # Every ds-* tag takes keyword arguments rather than positional ones:
    # with between one and four attributes each, several of them optional,
    # positional order would be impossible to remember and easy to break.
    module Attributes
      PAIR = /(?<key>\w+)\s*=\s*"(?<value>[^"]*)"/

      def self.parse(markup)
        markup.to_s.scan(PAIR).to_h
      end

      # Parses and validates. Raises Liquid::SyntaxError naming the tag and
      # the offending key, so a build failure points straight at the source.
      def self.parse!(markup, tag_name:, required: [], optional: [])
        attributes = parse(markup)
        known = required.map(&:to_s) + optional.map(&:to_s)

        reject_unknown!(attributes, known: known, tag_name: tag_name)
        require_present!(attributes, required: required.map(&:to_s), tag_name: tag_name)

        attributes
      end

      def self.reject_unknown!(attributes, known:, tag_name:)
        unknown = attributes.keys - known
        return if unknown.empty?

        raise Liquid::SyntaxError,
              "{% #{tag_name} %}: unknown attribute(s) #{unknown.join(", ")}. " \
              "Known attributes: #{known.join(", ")}."
      end

      def self.require_present!(attributes, required:, tag_name:)
        missing = required - attributes.keys
        return if missing.empty?

        raise Liquid::SyntaxError,
              "{% #{tag_name} %}: missing required attribute(s) #{missing.join(", ")}."
      end

      private_class_method :reject_unknown!, :require_present!
    end
  end
end
