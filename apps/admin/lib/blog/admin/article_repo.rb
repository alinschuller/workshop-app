require "blog/repository"
require "blog/admin/entities"

module Blog
  module Admin
    class ArticleRepo < Blog::Repository[:articles]
      struct_namespace Entities

      commands :create, update: :by_pk

      def by_id(id)
        articles.by_pk(id).one
      end

      def listing
        articles.order { created_at.desc }.to_a
      end

      private

      def articles
        super.combine(:author)
      end

    end
  end
end
