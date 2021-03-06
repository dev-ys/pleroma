# Pleroma: A lightweight social networking server
# Copyright © 2017-2019 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.Router do
  use Pleroma.Web, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(Pleroma.Plugs.OAuthPlug)
    plug(Pleroma.Plugs.BasicAuthDecoderPlug)
    plug(Pleroma.Plugs.UserFetcherPlug)
    plug(Pleroma.Plugs.SessionAuthenticationPlug)
    plug(Pleroma.Plugs.LegacyAuthenticationPlug)
    plug(Pleroma.Plugs.AuthenticationPlug)
    plug(Pleroma.Plugs.UserEnabledPlug)
    plug(Pleroma.Plugs.SetUserSessionIdPlug)
    plug(Pleroma.Plugs.EnsureUserKeyPlug)
  end

  pipeline :authenticated_api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(Pleroma.Plugs.OAuthPlug)
    plug(Pleroma.Plugs.BasicAuthDecoderPlug)
    plug(Pleroma.Plugs.UserFetcherPlug)
    plug(Pleroma.Plugs.SessionAuthenticationPlug)
    plug(Pleroma.Plugs.LegacyAuthenticationPlug)
    plug(Pleroma.Plugs.AuthenticationPlug)
    plug(Pleroma.Plugs.UserEnabledPlug)
    plug(Pleroma.Plugs.SetUserSessionIdPlug)
    plug(Pleroma.Plugs.EnsureAuthenticatedPlug)
  end

  pipeline :admin_api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(Pleroma.Plugs.OAuthPlug)
    plug(Pleroma.Plugs.BasicAuthDecoderPlug)
    plug(Pleroma.Plugs.UserFetcherPlug)
    plug(Pleroma.Plugs.SessionAuthenticationPlug)
    plug(Pleroma.Plugs.LegacyAuthenticationPlug)
    plug(Pleroma.Plugs.AuthenticationPlug)
    plug(Pleroma.Plugs.AdminSecretAuthenticationPlug)
    plug(Pleroma.Plugs.UserEnabledPlug)
    plug(Pleroma.Plugs.SetUserSessionIdPlug)
    plug(Pleroma.Plugs.EnsureAuthenticatedPlug)
    plug(Pleroma.Plugs.UserIsAdminPlug)
  end

  pipeline :mastodon_html do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(Pleroma.Plugs.OAuthPlug)
    plug(Pleroma.Plugs.BasicAuthDecoderPlug)
    plug(Pleroma.Plugs.UserFetcherPlug)
    plug(Pleroma.Plugs.SessionAuthenticationPlug)
    plug(Pleroma.Plugs.LegacyAuthenticationPlug)
    plug(Pleroma.Plugs.AuthenticationPlug)
    plug(Pleroma.Plugs.UserEnabledPlug)
    plug(Pleroma.Plugs.SetUserSessionIdPlug)
    plug(Pleroma.Plugs.EnsureUserKeyPlug)
  end

  pipeline :pleroma_html do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(Pleroma.Plugs.OAuthPlug)
    plug(Pleroma.Plugs.BasicAuthDecoderPlug)
    plug(Pleroma.Plugs.UserFetcherPlug)
    plug(Pleroma.Plugs.SessionAuthenticationPlug)
    plug(Pleroma.Plugs.AuthenticationPlug)
    plug(Pleroma.Plugs.EnsureUserKeyPlug)
  end

  pipeline :well_known do
    plug(:accepts, ["json", "jrd+json", "xml", "xrd+xml"])
  end

  pipeline :config do
    plug(:accepts, ["json", "xml"])
  end

  pipeline :oauth do
    plug(:accepts, ["html", "json"])
  end

  pipeline :pleroma_api do
    plug(:accepts, ["html", "json"])
  end

  pipeline :mailbox_preview do
    plug(:accepts, ["html"])

    plug(:put_secure_browser_headers, %{
      "content-security-policy" =>
        "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline' 'unsafe-eval'"
    })
  end

  scope "/api/pleroma", Pleroma.Web.TwitterAPI do
    pipe_through(:pleroma_api)
    get("/password_reset/:token", UtilController, :show_password_reset)
    post("/password_reset", UtilController, :password_reset)
    get("/emoji", UtilController, :emoji)
    get("/captcha", UtilController, :captcha)
  end

  scope "/api/pleroma", Pleroma.Web do
    pipe_through(:pleroma_api)
    post("/uploader_callback/:upload_path", UploaderController, :callback)
  end

  scope "/api/pleroma/admin", Pleroma.Web.AdminAPI do
    pipe_through(:admin_api)
    delete("/user", AdminAPIController, :user_delete)
    post("/user", AdminAPIController, :user_create)
    put("/users/tag", AdminAPIController, :tag_users)
    delete("/users/tag", AdminAPIController, :untag_users)

    get("/permission_group/:nickname", AdminAPIController, :right_get)
    get("/permission_group/:nickname/:permission_group", AdminAPIController, :right_get)
    post("/permission_group/:nickname/:permission_group", AdminAPIController, :right_add)
    delete("/permission_group/:nickname/:permission_group", AdminAPIController, :right_delete)

    post("/relay", AdminAPIController, :relay_follow)
    delete("/relay", AdminAPIController, :relay_unfollow)

    get("/invite_token", AdminAPIController, :get_invite_token)
    post("/email_invite", AdminAPIController, :email_invite)

    get("/password_reset", AdminAPIController, :get_password_reset)
  end

  scope "/", Pleroma.Web.TwitterAPI do
    pipe_through(:pleroma_html)
    get("/ostatus_subscribe", UtilController, :remote_follow)
    post("/ostatus_subscribe", UtilController, :do_remote_follow)
    post("/main/ostatus", UtilController, :remote_subscribe)
  end

  scope "/api/pleroma", Pleroma.Web.TwitterAPI do
    pipe_through(:authenticated_api)
    post("/blocks_import", UtilController, :blocks_import)
    post("/follow_import", UtilController, :follow_import)
    post("/change_password", UtilController, :change_password)
    post("/delete_account", UtilController, :delete_account)
  end

  scope "/oauth", Pleroma.Web.OAuth do
    get("/authorize", OAuthController, :authorize)
    post("/authorize", OAuthController, :create_authorization)
    post("/token", OAuthController, :token_exchange)
    post("/revoke", OAuthController, :token_revoke)
  end

  scope "/api/v1", Pleroma.Web.MastodonAPI do
    pipe_through(:authenticated_api)

    patch("/accounts/update_credentials", MastodonAPIController, :update_credentials)
    get("/accounts/verify_credentials", MastodonAPIController, :verify_credentials)
    get("/accounts/relationships", MastodonAPIController, :relationships)
    get("/accounts/search", MastodonAPIController, :account_search)
    post("/accounts/:id/follow", MastodonAPIController, :follow)
    post("/accounts/:id/unfollow", MastodonAPIController, :unfollow)
    post("/accounts/:id/block", MastodonAPIController, :block)
    post("/accounts/:id/unblock", MastodonAPIController, :unblock)
    post("/accounts/:id/mute", MastodonAPIController, :relationship_noop)
    post("/accounts/:id/unmute", MastodonAPIController, :relationship_noop)
    get("/accounts/:id/lists", MastodonAPIController, :account_lists)

    get("/follow_requests", MastodonAPIController, :follow_requests)
    post("/follow_requests/:id/authorize", MastodonAPIController, :authorize_follow_request)
    post("/follow_requests/:id/reject", MastodonAPIController, :reject_follow_request)

    post("/follows", MastodonAPIController, :follow)

    get("/blocks", MastodonAPIController, :blocks)

    get("/mutes", MastodonAPIController, :empty_array)

    get("/timelines/home", MastodonAPIController, :home_timeline)

    get("/timelines/direct", MastodonAPIController, :dm_timeline)

    get("/favourites", MastodonAPIController, :favourites)
    get("/bookmarks", MastodonAPIController, :bookmarks)

    post("/statuses", MastodonAPIController, :post_status)
    delete("/statuses/:id", MastodonAPIController, :delete_status)

    post("/statuses/:id/reblog", MastodonAPIController, :reblog_status)
    post("/statuses/:id/unreblog", MastodonAPIController, :unreblog_status)
    post("/statuses/:id/favourite", MastodonAPIController, :fav_status)
    post("/statuses/:id/unfavourite", MastodonAPIController, :unfav_status)
    post("/statuses/:id/pin", MastodonAPIController, :pin_status)
    post("/statuses/:id/unpin", MastodonAPIController, :unpin_status)
    post("/statuses/:id/bookmark", MastodonAPIController, :bookmark_status)
    post("/statuses/:id/unbookmark", MastodonAPIController, :unbookmark_status)

    post("/notifications/clear", MastodonAPIController, :clear_notifications)
    post("/notifications/dismiss", MastodonAPIController, :dismiss_notification)
    get("/notifications", MastodonAPIController, :notifications)
    get("/notifications/:id", MastodonAPIController, :get_notification)

    post("/media", MastodonAPIController, :upload)
    put("/media/:id", MastodonAPIController, :update_media)

    get("/lists", MastodonAPIController, :get_lists)
    get("/lists/:id", MastodonAPIController, :get_list)
    delete("/lists/:id", MastodonAPIController, :delete_list)
    post("/lists", MastodonAPIController, :create_list)
    put("/lists/:id", MastodonAPIController, :rename_list)
    get("/lists/:id/accounts", MastodonAPIController, :list_accounts)
    post("/lists/:id/accounts", MastodonAPIController, :add_to_list)
    delete("/lists/:id/accounts", MastodonAPIController, :remove_from_list)

    get("/domain_blocks", MastodonAPIController, :domain_blocks)
    post("/domain_blocks", MastodonAPIController, :block_domain)
    delete("/domain_blocks", MastodonAPIController, :unblock_domain)

    get("/filters", MastodonAPIController, :get_filters)
    post("/filters", MastodonAPIController, :create_filter)
    get("/filters/:id", MastodonAPIController, :get_filter)
    put("/filters/:id", MastodonAPIController, :update_filter)
    delete("/filters/:id", MastodonAPIController, :delete_filter)

    post("/push/subscription", MastodonAPIController, :create_push_subscription)
    get("/push/subscription", MastodonAPIController, :get_push_subscription)
    put("/push/subscription", MastodonAPIController, :update_push_subscription)
    delete("/push/subscription", MastodonAPIController, :delete_push_subscription)

    get("/suggestions", MastodonAPIController, :suggestions)

    get("/endorsements", MastodonAPIController, :empty_array)
  end

  scope "/api/web", Pleroma.Web.MastodonAPI do
    pipe_through(:authenticated_api)

    put("/settings", MastodonAPIController, :put_settings)
  end

  scope "/api/v1", Pleroma.Web.MastodonAPI do
    pipe_through(:api)
    get("/instance", MastodonAPIController, :masto_instance)
    get("/instance/peers", MastodonAPIController, :peers)
    post("/apps", MastodonAPIController, :create_app)
    get("/custom_emojis", MastodonAPIController, :custom_emojis)

    get("/timelines/public", MastodonAPIController, :public_timeline)
    get("/timelines/tag/:tag", MastodonAPIController, :hashtag_timeline)
    get("/timelines/list/:list_id", MastodonAPIController, :list_timeline)

    get("/statuses/:id", MastodonAPIController, :get_status)
    get("/statuses/:id/context", MastodonAPIController, :get_context)
    get("/statuses/:id/card", MastodonAPIController, :status_card)
    get("/statuses/:id/favourited_by", MastodonAPIController, :favourited_by)
    get("/statuses/:id/reblogged_by", MastodonAPIController, :reblogged_by)

    get("/accounts/:id/statuses", MastodonAPIController, :user_statuses)
    get("/accounts/:id/followers", MastodonAPIController, :followers)
    get("/accounts/:id/following", MastodonAPIController, :following)
    get("/accounts/:id", MastodonAPIController, :user)

    get("/trends", MastodonAPIController, :empty_array)

    get("/search", MastodonAPIController, :search)
  end

  scope "/api/v2", Pleroma.Web.MastodonAPI do
    pipe_through(:api)
    get("/search", MastodonAPIController, :search2)
  end

  scope "/api", Pleroma.Web do
    pipe_through(:config)

    get("/help/test", TwitterAPI.UtilController, :help_test)
    post("/help/test", TwitterAPI.UtilController, :help_test)
    get("/statusnet/config", TwitterAPI.UtilController, :config)
    get("/statusnet/version", TwitterAPI.UtilController, :version)
    get("/pleroma/frontend_configurations", TwitterAPI.UtilController, :frontend_configurations)
  end

  scope "/api", Pleroma.Web do
    pipe_through(:api)

    get("/statuses/user_timeline", TwitterAPI.Controller, :user_timeline)
    get("/qvitter/statuses/user_timeline", TwitterAPI.Controller, :user_timeline)
    get("/users/show", TwitterAPI.Controller, :show_user)

    get("/statuses/followers", TwitterAPI.Controller, :followers)
    get("/statuses/friends", TwitterAPI.Controller, :friends)
    get("/statuses/blocks", TwitterAPI.Controller, :blocks)
    get("/statuses/show/:id", TwitterAPI.Controller, :fetch_status)
    get("/statusnet/conversation/:id", TwitterAPI.Controller, :fetch_conversation)

    post("/account/register", TwitterAPI.Controller, :register)
    post("/account/password_reset", TwitterAPI.Controller, :password_reset)

    get(
      "/account/confirm_email/:user_id/:token",
      TwitterAPI.Controller,
      :confirm_email,
      as: :confirm_email
    )

    post("/account/resend_confirmation_email", TwitterAPI.Controller, :resend_confirmation_email)

    get("/search", TwitterAPI.Controller, :search)
    get("/statusnet/tags/timeline/:tag", TwitterAPI.Controller, :public_and_external_timeline)
  end

  scope "/api", Pleroma.Web do
    pipe_through(:api)

    get("/statuses/public_timeline", TwitterAPI.Controller, :public_timeline)

    get(
      "/statuses/public_and_external_timeline",
      TwitterAPI.Controller,
      :public_and_external_timeline
    )

    get("/statuses/networkpublic_timeline", TwitterAPI.Controller, :public_and_external_timeline)
  end

  scope "/api", Pleroma.Web, as: :twitter_api_search do
    pipe_through(:api)
    get("/pleroma/search_user", TwitterAPI.Controller, :search_user)
  end

  scope "/api", Pleroma.Web, as: :authenticated_twitter_api do
    pipe_through(:authenticated_api)

    get("/account/verify_credentials", TwitterAPI.Controller, :verify_credentials)
    post("/account/verify_credentials", TwitterAPI.Controller, :verify_credentials)

    post("/account/update_profile", TwitterAPI.Controller, :update_profile)
    post("/account/update_profile_banner", TwitterAPI.Controller, :update_banner)
    post("/qvitter/update_background_image", TwitterAPI.Controller, :update_background)

    get("/statuses/home_timeline", TwitterAPI.Controller, :friends_timeline)
    get("/statuses/friends_timeline", TwitterAPI.Controller, :friends_timeline)
    get("/statuses/mentions", TwitterAPI.Controller, :mentions_timeline)
    get("/statuses/mentions_timeline", TwitterAPI.Controller, :mentions_timeline)
    get("/statuses/dm_timeline", TwitterAPI.Controller, :dm_timeline)
    get("/qvitter/statuses/notifications", TwitterAPI.Controller, :notifications)

    # XXX: this is really a pleroma API, but we want to keep the pleroma namespace clean
    #      for now.
    post("/qvitter/statuses/notifications/read", TwitterAPI.Controller, :notifications_read)

    post("/statuses/update", TwitterAPI.Controller, :status_update)
    post("/statuses/retweet/:id", TwitterAPI.Controller, :retweet)
    post("/statuses/unretweet/:id", TwitterAPI.Controller, :unretweet)
    post("/statuses/destroy/:id", TwitterAPI.Controller, :delete_post)

    post("/statuses/pin/:id", TwitterAPI.Controller, :pin)
    post("/statuses/unpin/:id", TwitterAPI.Controller, :unpin)

    get("/pleroma/friend_requests", TwitterAPI.Controller, :friend_requests)
    post("/pleroma/friendships/approve", TwitterAPI.Controller, :approve_friend_request)
    post("/pleroma/friendships/deny", TwitterAPI.Controller, :deny_friend_request)

    post("/friendships/create", TwitterAPI.Controller, :follow)
    post("/friendships/destroy", TwitterAPI.Controller, :unfollow)
    post("/blocks/create", TwitterAPI.Controller, :block)
    post("/blocks/destroy", TwitterAPI.Controller, :unblock)

    post("/statusnet/media/upload", TwitterAPI.Controller, :upload)
    post("/media/upload", TwitterAPI.Controller, :upload_json)
    post("/media/metadata/create", TwitterAPI.Controller, :update_media)

    post("/favorites/create/:id", TwitterAPI.Controller, :favorite)
    post("/favorites/create", TwitterAPI.Controller, :favorite)
    post("/favorites/destroy/:id", TwitterAPI.Controller, :unfavorite)

    post("/qvitter/update_avatar", TwitterAPI.Controller, :update_avatar)

    get("/friends/ids", TwitterAPI.Controller, :friends_ids)
    get("/friendships/no_retweets/ids", TwitterAPI.Controller, :empty_array)

    get("/mutes/users/ids", TwitterAPI.Controller, :empty_array)
    get("/qvitter/mutes", TwitterAPI.Controller, :raw_empty_array)

    get("/externalprofile/show", TwitterAPI.Controller, :external_profile)
  end

  pipeline :ap_relay do
    plug(:accepts, ["activity+json"])
  end

  pipeline :ostatus do
    plug(:accepts, ["html", "xml", "atom", "activity+json"])
  end

  pipeline :oembed do
    plug(:accepts, ["json", "xml"])
  end

  scope "/", Pleroma.Web do
    pipe_through(:ostatus)

    get("/objects/:uuid", OStatus.OStatusController, :object)
    get("/activities/:uuid", OStatus.OStatusController, :activity)
    get("/notice/:id", OStatus.OStatusController, :notice)
    get("/users/:nickname/feed", OStatus.OStatusController, :feed)
    get("/users/:nickname", OStatus.OStatusController, :feed_redirect)

    post("/users/:nickname/salmon", OStatus.OStatusController, :salmon_incoming)
    post("/push/hub/:nickname", Websub.WebsubController, :websub_subscription_request)
    get("/push/subscriptions/:id", Websub.WebsubController, :websub_subscription_confirmation)
    post("/push/subscriptions/:id", Websub.WebsubController, :websub_incoming)
  end

  scope "/", Pleroma.Web do
    pipe_through(:oembed)

    get("/oembed", OEmbed.OEmbedController, :url)
  end

  pipeline :activitypub do
    plug(:accepts, ["activity+json"])
    plug(Pleroma.Web.Plugs.HTTPSignaturePlug)
  end

  scope "/", Pleroma.Web.ActivityPub do
    # XXX: not really ostatus
    pipe_through(:ostatus)

    get("/users/:nickname/followers", ActivityPubController, :followers)
    get("/users/:nickname/following", ActivityPubController, :following)
    get("/users/:nickname/outbox", ActivityPubController, :outbox)
    get("/objects/:uuid/likes", ActivityPubController, :object_likes)
  end

  pipeline :activitypub_client do
    plug(:accepts, ["activity+json"])
    plug(:fetch_session)
    plug(Pleroma.Plugs.OAuthPlug)
    plug(Pleroma.Plugs.BasicAuthDecoderPlug)
    plug(Pleroma.Plugs.UserFetcherPlug)
    plug(Pleroma.Plugs.SessionAuthenticationPlug)
    plug(Pleroma.Plugs.LegacyAuthenticationPlug)
    plug(Pleroma.Plugs.AuthenticationPlug)
    plug(Pleroma.Plugs.UserEnabledPlug)
    plug(Pleroma.Plugs.SetUserSessionIdPlug)
    plug(Pleroma.Plugs.EnsureUserKeyPlug)
  end

  scope "/", Pleroma.Web.ActivityPub do
    pipe_through([:activitypub_client])

    get("/users/:nickname/inbox", ActivityPubController, :read_inbox)
    post("/users/:nickname/outbox", ActivityPubController, :update_outbox)
  end

  scope "/relay", Pleroma.Web.ActivityPub do
    pipe_through(:ap_relay)
    get("/", ActivityPubController, :relay)
  end

  scope "/", Pleroma.Web.ActivityPub do
    pipe_through(:activitypub)
    post("/users/:nickname/inbox", ActivityPubController, :inbox)
    post("/inbox", ActivityPubController, :inbox)
  end

  scope "/.well-known", Pleroma.Web do
    pipe_through(:well_known)

    get("/host-meta", WebFinger.WebFingerController, :host_meta)
    get("/webfinger", WebFinger.WebFingerController, :webfinger)
    get("/nodeinfo", Nodeinfo.NodeinfoController, :schemas)
  end

  scope "/nodeinfo", Pleroma.Web do
    get("/:version", Nodeinfo.NodeinfoController, :nodeinfo)
  end

  scope "/", Pleroma.Web.MastodonAPI do
    pipe_through(:mastodon_html)

    get("/web/login", MastodonAPIController, :login)
    post("/web/login", MastodonAPIController, :login_post)
    get("/web/*path", MastodonAPIController, :index)
    delete("/auth/sign_out", MastodonAPIController, :logout)
  end

  pipeline :remote_media do
  end

  scope "/proxy/", Pleroma.Web.MediaProxy do
    pipe_through(:remote_media)
    get("/:sig/:url", MediaProxyController, :remote)
    get("/:sig/:url/:filename", MediaProxyController, :remote)
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through([:mailbox_preview])

      forward("/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox")
    end
  end

  scope "/", Fallback do
    get("/registration/:token", RedirectController, :registration_page)
    get("/:maybe_nickname_or_id", RedirectController, :redirector_with_meta)
    get("/*path", RedirectController, :redirector)

    options("/*path", RedirectController, :empty)
  end
end

defmodule Fallback.RedirectController do
  use Pleroma.Web, :controller
  alias Pleroma.Web.Metadata
  alias Pleroma.User

  def redirector(conn, _params, code \\ 200) do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(code, index_file_path())
  end

  def redirector_with_meta(conn, %{"maybe_nickname_or_id" => maybe_nickname_or_id} = params) do
    with %User{} = user <- User.get_cached_by_nickname_or_id(maybe_nickname_or_id) do
      redirector_with_meta(conn, %{user: user})
    else
      nil ->
        redirector(conn, params)
    end
  end

  def redirector_with_meta(conn, params) do
    {:ok, index_content} = File.read(index_file_path())
    tags = Metadata.build_tags(params)
    response = String.replace(index_content, "<!--server-generated-meta-->", tags)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, response)
  end

  def index_file_path do
    Pleroma.Plugs.InstanceStatic.file_path("index.html")
  end

  def registration_page(conn, params) do
    redirector(conn, params)
  end

  def empty(conn, _params) do
    conn
    |> put_status(204)
    |> text("")
  end
end
