class Comment < Base
  belongs_to :article
  belongs_to :user

  collection_path "articles/:article_id/comments"
end