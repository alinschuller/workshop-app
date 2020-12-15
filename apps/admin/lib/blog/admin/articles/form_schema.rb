require "dry/validation"
require "types"

module Blog
  module Admin
    module Articles
      FormSchema = Dry::Validation.Form do
        required(:title).filled
        required(:status).value(included_in?: Types::ArticleStatus.values)
        required(:published_at).filled(:date?)
      end
    end
  end
end
