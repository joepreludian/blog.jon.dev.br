# frozen_string_literal: true

require_relative "base"

module JonDevBr
  module Tags
    # Renders NOTE, CAUTION, and WARNING placards, borrowed from aviation.
    #
    #   {% callout level="NOTE" %}
    #   Redundancy you have never exercised is decoration.
    #   {% endcallout %}
    #
    # Levels are bilingual. The literal the author writes is what renders, so
    # a Portuguese post reads as a Portuguese placard.
    class Callout < Base
      VARIANTS = {
        "NOTE" => "note",
        "NOTA" => "note",
        "CAUTION" => "caution",
        "CUIDADO" => "caution",
        "WARNING" => "warning",
        "AVISO" => "warning"
      }.freeze

      required :level

      def initialize(tag_name, markup, parse_context)
        super
        @variant = VARIANTS[attribute(:level).to_s.upcase]
        return if @variant

        raise Liquid::SyntaxError,
              "{% callout %}: unknown level #{attribute(:level).inspect}. " \
              "Expected one of: #{VARIANTS.keys.join(", ")}."
      end

      private

      def render_html(body, context)
        <<~HTML
          <div class="ds-callout ds-callout--#{@variant}">
            <span class="ds-callout__level">#{escaped(:level)}</span>
            <div class="ds-callout__body">#{markdownify(body, context)}</div>
          </div>
        HTML
      end
    end
  end
end

Liquid::Template.register_tag("callout", JonDevBr::Tags::Callout)
