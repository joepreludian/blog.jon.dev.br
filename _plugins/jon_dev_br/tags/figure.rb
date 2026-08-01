# frozen_string_literal: true

require_relative "base"

module JonDevBr
  module Tags
    # A photograph in a white mat with a hairline border and a mono caption.
    #
    #   {% figure src="/assets/img/plane.jpg" alt="A Cessna on short final."
    #             caption="short final, SBJD" meta="Portra 400 · 50mm" %}{% endfigure %}
    #
    # With no `src` the frame shows the crosshatch placeholder. The design
    # system illustrates nothing and generates nothing: no image means a
    # placeholder until a real scan arrives.
    class Figure < Base
      required :caption
      optional :src, :alt, :meta

      PLACEHOLDER_LABEL = "no image"

      private

      def render_html(_body, _context)
        <<~HTML
          <figure class="ds-figure">
            <div class="ds-figure__frame">#{frame_contents}</div>
            <figcaption class="ds-figure__cap">
              <span>#{escaped(:caption)}</span>
              <span class="ds-figure__meta">#{escaped(:meta)}</span>
            </figcaption>
          </figure>
        HTML
      end

      def frame_contents
        return placeholder unless attribute(:src)

        %(<img src="#{attribute(:src)}" alt="#{attribute(:alt)}" loading="lazy">)
      end

      def placeholder
        %(<div class="ds-figure__ph">#{PLACEHOLDER_LABEL}</div>)
      end
    end
  end
end

Liquid::Template.register_tag("figure", JonDevBr::Tags::Figure)
