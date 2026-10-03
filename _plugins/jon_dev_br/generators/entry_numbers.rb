# frozen_string_literal: true

module JonDevBr
  module Generators
    # Assigns the `num` display metadata shown in every entry row.
    #
    # Posts are numbered per language in chronological order: the oldest
    # entry is 001 and each new one takes the next number, so a published
    # entry keeps its number for good. (The reference design counts the other
    # way, newest first; the author chose stable numbers instead.) `num` is
    # display metadata and never appears in a URL, an element id, or a feed id.
    # A post and its translation share a number because every post is paired.
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
          assign(docs.sort_by(&:date))
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
