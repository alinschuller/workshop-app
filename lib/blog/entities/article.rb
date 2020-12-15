require "types"

module Blog
  module Entities
    class Article < Dry::Struct
      attribute :title, Types::Strict::String
      attribute :status, Types::ArticleStatus
      attribute :published_at, Types::DateTime
    end
  end
end
