require 'blog/entities/article'

module Blog
  module Admin
    module Articles
      class ArticleRepo
        def create(args)
          Blog::Entities::Article.new(args)
        end
      end
    end
  end
end
