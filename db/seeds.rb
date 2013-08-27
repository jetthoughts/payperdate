# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


services = [
  { key: :bookmark_members,             cost: 5.00,   use_credits: true,  name: "Bookmark Members" },
  { key: :participate_speed_dating,     cost: 10.00,  use_credits: true,  name: "Participate in speed dating events" },
  { key: :play_games,                   cost: 2.00,   use_credits: true,  name: "Play Games" },
  { key: :read_shoutbox,                cost: 0.00,   use_credits: false, name: "Read shoutbox" },
  { key: :write_shoutbox,               cost: 1.00,   use_credits: true,  name: "Write shoutbox" },
  { key: :view_hot_list,                cost: 0.00,   use_credits: true,  name: "View Hot List" },
  { key: :newsfeed_view,                cost: 0.00,   use_credits: true,  name: "View newsfeed" },
  { key: :add_newsfeed_comment,         cost: 0.00,   use_credits: true,  name: "Add newsfeed comment" },
  { key: :password_protected_album,     cost: 0.00,   use_credits: false, name: "Password Protected Album" },
  { key: :change_user_status,           cost: 0.00,   use_credits: false, name: "Add profile status" },
  { key: :add_blog_post,                cost: 5.00,   use_credits: true,  name: "Add Blog Post" },
  { key: :rate_media,                   cost: 5.00,   use_credits: true,  name: "Rate Video" },
  { key: :rate_musica,                  cost: 5.00,   use_credits: true,  name: "Rate Music" },
  { key: :view_latest_activity,         cost: 1.00,   use_credits: true,  name: "View Latest Activity" },
  { key: :block_members,                cost: 5.00,   use_credits: true,  name: "Block Members" },
  { key: :create_friends_network,       cost: 5.00,   use_credits: false, name: "Create Friends Network" },
  { key: :upload_music,                 cost: 5.00,   use_credits: true,  name: "Upload Music" },
  { key: :view_event,                   cost: 5.00,   use_credits: true,  name: "View Event" },
  { key: :hide_advertisement,           cost: 0.00,   use_credits: false, name: "Hide Advertisement" },
  { key: :instant_messenger,            cost: 150.00, use_credits: false, name: "Instant Messenger" },
  { key: :initiate_im_session,          cost: 50.00,  use_credits: true,  name: "Initiate IM Session" },
  { key: :rate_blog_post,               cost: 4.00,   use_credits: true,  name: "Rate Blog Post" },
  { key: :rate_news,                    cost: 4.00,   use_credits: true,  name: "Rate News" },
  { key: :read_message,                 cost: 7.00,   use_credits: true,  name: "Read Internal Messages" },
  { key: :search,                       cost: 5.00,   use_credits: true,  name: "Search Profiles" },
  { key: :send_message,                 cost: 15.00,  use_credits: true,  name: "Send Internal Messages" },
  { key: :send_readable_message,        cost: 20.00,  use_credits: true,  name: "Send Readable Messages" },
  { key: :send_gift,                    cost: 10.00,  use_credits: true,  name: "Send Gift" },
  { key: :upload_media,                 cost: 5.00,   use_credits: true,  name: "Upload Video" },
  { key: :rate_photo,                   cost: 1.00,   use_credits: true,  name: "Rate Photo" },
  { key: :upload_photo,                 cost: 10.00,  use_credits: true,  name: "Upload Photo" },

  { key: :set_friends_only_photo,       cost: 5.00,   use_credits: true,  name: "Set Friends Only Photo"},
  { key: :view_photo,                   cost: 5.00,   use_credits: true,  name: "View Photo"},
  { key: :view_video,                   cost: 5.00,   use_credits: true,  name: "View Video"},
  { key: :view_profiles,                cost: 0.50,   use_credits: true,  name: "View Profiles"},
  { key: :set_private_status,           cost: 0.00,   use_credits: true,  name: "Set private status"},
  { key: :submit_events,                cost: 4.00,   use_credits: true,  name: "Submit Events"},
  { key: :chat,                         cost: 15.00,  use_credits: true,  name: "Chat"},
  { key: :read_forum,                   cost: 1.00,   use_credits: true,  name: "Read Forum topics and posts"},
  { key: :write_forum,                  cost: 1.00,   use_credits: true,  name: "Write new posts and edit posts"},
  { key: :search_forum,                 cost: 1.00,   use_credits: true,  name: "Search in Forum"},
  { key: :post_classifieds_item,        cost: 2.00,   use_credits: true,  name: "Post Classifieds Items"},
  { key: :add_blog_post_comment,        cost: 1.00,   use_credits: true,  name: "Add Blog Post Comments"},
  { key: :add_event_comment,            cost: 1.00,   use_credits: true,  name: "Add Event Comments"},
  { key: :add_video_comment,            cost: 1.00,   use_credits: true,  name: "Add Video Comments"},
  { key: :add_photo_comment,            cost: 1.00,   use_credits: true,  name: "Add Photo Comments"},
  { key: :view_blog_post,               cost: 1.00,   use_credits: true,  name: "View Blog Post"},
  { key: :add_classifieds_comment,      cost: 0.00,   use_credits: true,  name: "Add Classifieds Comments"},
  { key: :view_news,                    cost: 1.00,   use_credits: true,  name: "View News"},
  { key: :add_news_comment,             cost: 1.00,   use_credits: true,  name: "Add News Comments"},
  { key: :add_music_comment,            cost: 0.00,   use_credits: true,  name: "Add Music Comments"},
  { key: :add_profile_comment,          cost: 5.00,   use_credits: true,  name: "Add Profile Comment"},
  { key: :set_password_protected_photo, cost: 5.00,   use_credits: true,  name: "Set Password Protected Photo"},
  { key: :reply_readable_message,       cost: 1.00,   use_credits: true,  name: "Reply Readable Messages"},
  { key: :add_nprofile_notes,           cost: 1.00,   use_credits: true,  name: "Add Notes about Profiles"},
  { key: :view_music,                   cost: 5.00,   use_credits: true,  name: "Music View"},
  { key: :profile_view_history,         cost: 5.00,   use_credits: true,  name: "Profile View History"},
  { key: :custom_html,                  cost: 5.00,   use_credits: true,  name: "Profile custom HTML"},
  { key: :hide_im_button,               cost: 0.00,   use_credits: true,  name: "Hide IM button"},
  { key: :mplayer,                      cost: 1.00,   use_credits: true,  name: "MPlayer"},
  { key: :hide_online_activity,         cost: 0.00,   use_credits: true,  name: "Hide time of last activity and IM button"},
  { key: :profile_background,           cost: 1.00,   use_credits: true,  name: "Profile Background"},
  { key: :add_group_comment,            cost: 1.00,   use_credits: true,  name: "Add Groups Comments"},
  { key: :create_group,                 cost: 5.00,   use_credits: true,  name: "Create Group"},
  { key: :hot_list,                     cost: 10.00,  use_credits: true,  name: "Add Profile to Hot List"},
  { key: :unlimited_search_result,      cost: 0.00,   use_credits: true,  name: "Unlimited Search Result"},
  { key: :profile_rss,                  cost: 0.00,   use_credits: true,  name: "Profile Rss"}
]

services.each do |service|
  Service.create! service
end

ranks = [
  { name: 'Great!',       value: 3 },
  { name: 'OK',           value: 2 },
  { name: 'Not so much!', value: 1 }
]

ranks.each do |rank|
  Rank.create! rank
end
