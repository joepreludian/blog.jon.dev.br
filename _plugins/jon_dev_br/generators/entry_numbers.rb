# frozen_string_literal: true

module JonDevBr
  module Generators
    # Assigns the `num` display metadata shown in every entry row.
    #
    # Posts are numbered per language in reverse-chronological order, so the
    # newest entry is 001 — the scheme the reference design uses. A published
    # entry's number therefore changes when a newer one appears. That is
    # accepted: `num` is display metadata and never appears in a URL, an
    # element id, or a feed id.
    #
    # Projects have no dates, so they are numbered by their `order` key.
    class EntryNumbers < Jekyll::Generator
      safe true
      priority :normal

      WIDTH = 3

      def generate(site)
        number_posts(site)
        number_projects(site)
      end

      private

      def number_posts(site)
        site.posts.docs.group_by { |doc| doc.data["lang"] }.each_value do |docs|
          assign(docs.sort_by(&:date).reverse)
        end
      end

      def number_projects(site)
        projects = site.collections["projects"]
        return if projects.nil?

        projects.docs.group_by { |doc| doc.data["lang"] }.each_value do |docs|
          assign(docs.sort_by { |doc| doc.data["order"].to_i })
        end
      end

      def assign(docs)
        docs.each_with_index do |doc, index|
          doc.data["num"] = format("%0#{WIDTH}d", index + 1)
        end
      end
    end
  end
end
