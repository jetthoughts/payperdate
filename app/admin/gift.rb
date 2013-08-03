ActiveAdmin.register Gift do
  index title: 'Gift statistics' do
    selectable_column

    column :gift do |gift|
      link_to admin_gift_template_path(gift.gift_template) do
        image_tag gift.image_url(:thumb)
      end
    end

    column "Comment" do |gift|
      gift.comment
    end

    column "Sender" do |gift|
      link_to gift.user.name, admin_user_path(gift.user)
    end

    column "Recipient" do |gift|
      link_to gift.recipient.name, admin_user_path(gift.recipient)
    end

    column "Sent at" do |gift|
      gift.created_at.to_s(:short)
    end
  end

end
