class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content image).freeze
  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.micropost.content_max}
  validates :image, blob: {content_type: {in: Settings.micropost.content.in,
                                          message:
                                            I18n.t("microposts.image_format")},
                           size: {less_than_or_equal_to:
                                    Settings.micropost.size_less.megabytes,
                                  message: I18n.t("micropost.size_less_than")}}
  scope :recent_posts, ->{order created_at: :desc}
  delegate :name, to: :user, prefix: :user

  def display_image
    image.variant resize_to_limit: [Settings.micropost.resize_to_limit,
                                    Settings.micropost.resize_to_limit]
  end
end
