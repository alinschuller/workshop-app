require 'blog/operation'
require 'blog/admin/articles/form_schema'
require 'blog/admin/import'

module Blog
  module Admin
    module Articles
      class Create < Blog::Operation
        include Import['article_repo']

        def call(args)
          article_validation = FormSchema.call(args)

          article_validation.success? ? Right(article_repo.create(args)) : Left(article_validation)
        end
      end
    end
  end
end
