require "blog/repository"

module Blog
  module Main
    class ArticleRepo < Blog::Repository[:articles]
      def listing
        articles.published.ordered_by_created_at
      end
    end
  end
end
