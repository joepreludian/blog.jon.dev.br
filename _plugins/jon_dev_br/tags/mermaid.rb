# frozen_string_literal: true

require "cgi"
require_relative "base"

module JonDevBr
  module Tags
    # A framed Mermaid diagram with a mono caption.
    #
    #   {% mermaid caption="fig 01 — the entire failover system." %}
    #   flowchart LR
    #     C[client] --> D[dns]
    #   {% endmermaid %}
    #
    # The graph source stays in the markup inside a <pre class="mermaid">,
    # which is Mermaid's own entry point. <pre> rather than <div> so the source
    # stays readable if the script has not run yet.
    #
    # The `data-mermaid` attribute is what MermaidBootstrap looks for.
    class Mermaid < Base
      required :caption

      private

      def render_html(body, _context)
        <<~HTML
          <figure class="ds-mermaid">
            <div class="ds-mermaid__frame">
              <pre class="mermaid" data-mermaid>#{CGI.escapeHTML(body)}</pre>
            </div>
            <figcaption class="ds-mermaid__cap">
              <span>#{attribute(:caption)}</span>
              <span class="ds-mermaid__meta">fig · mermaid</span>
            </figcaption>
          </figure>
        HTML
      end
    end
  end
end

Liquid::Template.register_tag("mermaid", JonDevBr::Tags::Mermaid)
