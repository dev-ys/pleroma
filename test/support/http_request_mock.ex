# Pleroma: A lightweight social networking server
# Copyright © 2017-2018 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule HttpRequestMock do
  require Logger

  def request(
        %Tesla.Env{
          url: url,
          method: method,
          headers: headers,
          query: query,
          body: body
        } = _env
      ) do
    with {:ok, res} <- apply(__MODULE__, method, [url, query, body, headers]) do
      res
    else
      {_, _r} = error ->
        # Logger.warn(r)
        error
    end
  end

  # GET Requests
  #
  def get(url, query \\ [], body \\ [], headers \\ [])

  def get("https://osada.macgirvin.com/channel/mike", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!("test/fixtures/httpoison_mock/https___osada.macgirvin.com_channel_mike.json")
     }}
  end

  def get(
        "https://osada.macgirvin.com/.well-known/webfinger?resource=acct:mike@osada.macgirvin.com",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/mike@osada.macgirvin.com.json")
     }}
  end

  def get(
        "https://social.heldscal.la/.well-known/webfinger?resource=https://social.heldscal.la/user/29191",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/https___social.heldscal.la_user_29191.xml")
     }}
  end

  def get("https://pawoo.net/users/pekorino.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/https___pawoo.net_users_pekorino.atom")
     }}
  end

  def get(
        "https://pawoo.net/.well-known/webfinger?resource=acct:https://pawoo.net/users/pekorino",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/https___pawoo.net_users_pekorino.xml")
     }}
  end

  def get(
        "https://social.stopwatchingus-heidelberg.de/api/statuses/user_timeline/18330.atom",
        _,
        _,
        _
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/atarifrosch_feed.xml")
     }}
  end

  def get(
        "https://social.stopwatchingus-heidelberg.de/.well-known/webfinger?resource=acct:https://social.stopwatchingus-heidelberg.de/user/18330",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/atarifrosch_webfinger.xml")
     }}
  end

  def get("https://mamot.fr/users/Skruyb.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/https___mamot.fr_users_Skruyb.atom")
     }}
  end

  def get(
        "https://mamot.fr/.well-known/webfinger?resource=acct:https://mamot.fr/users/Skruyb",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/skruyb@mamot.fr.atom")
     }}
  end

  def get(
        "https://social.heldscal.la/.well-known/webfinger?resource=nonexistant@social.heldscal.la",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/nonexistant@social.heldscal.la.xml")
     }}
  end

  def get("https://squeet.me/xrd/?uri=lain@squeet.me", _, _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/lain_squeet.me_webfinger.xml")
     }}
  end

  def get("https://mst3k.interlinked.me/users/luciferMysticus", _, _,
        Accept: "application/activity+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/lucifermysticus.json")
     }}
  end

  def get("https://prismo.news/@mxb", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/https___prismo.news__mxb.json")
     }}
  end

  def get("https://hubzilla.example.org/channel/kaniini", _, _,
        Accept: "application/activity+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/kaniini@hubzilla.example.org.json")
     }}
  end

  def get("https://niu.moe/users/rye", _, _, Accept: "application/activity+json") do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/rye.json")
     }}
  end

  def get("http://mastodon.example.org/users/admin/statuses/100787282858396771", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!(
           "test/fixtures/httpoison_mock/http___mastodon.example.org_users_admin_status_1234.json"
         )
     }}
  end

  def get("https://puckipedia.com/", _, _, Accept: "application/activity+json") do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/puckipedia.com.json")
     }}
  end

  def get("https://peertube.moe/accounts/7even", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/7even.json")
     }}
  end

  def get("https://peertube.moe/videos/watch/df5f464b-be8d-46fb-ad81-2d4c2d1630e3", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/peertube.moe-vid.json")
     }}
  end

  def get("https://baptiste.gelez.xyz/@/BaptisteGelez", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/baptiste.gelex.xyz-user.json")
     }}
  end

  def get("https://baptiste.gelez.xyz/~/PlumeDevelopment/this-month-in-plume-june-2018/", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/baptiste.gelex.xyz-article.json")
     }}
  end

  def get("http://mastodon.example.org/users/admin", _, _, Accept: "application/activity+json") do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/admin@mastdon.example.org.json")
     }}
  end

  def get("http://mastodon.example.org/@admin/99541947525187367", _, _,
        Accept: "application/activity+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/mastodon-note-object.json")
     }}
  end

  def get("https://shitposter.club/notice/7369654", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/7369654.html")
     }}
  end

  def get("https://mstdn.io/users/mayuutann", _, _, Accept: "application/activity+json") do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/mayumayu.json")
     }}
  end

  def get("https://mstdn.io/users/mayuutann/statuses/99568293732299394", _, _,
        Accept: "application/activity+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/mayumayupost.json")
     }}
  end

  def get("https://pleroma.soykaf.com/users/lain/feed.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!(
           "test/fixtures/httpoison_mock/https___pleroma.soykaf.com_users_lain_feed.atom.xml"
         )
     }}
  end

  def get(url, _, _, Accept: "application/xrd+xml,application/jrd+json")
      when url in [
             "https://pleroma.soykaf.com/.well-known/webfinger?resource=acct:https://pleroma.soykaf.com/users/lain",
             "https://pleroma.soykaf.com/.well-known/webfinger?resource=https://pleroma.soykaf.com/users/lain"
           ] do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/https___pleroma.soykaf.com_users_lain.xml")
     }}
  end

  def get("https://shitposter.club/api/statuses/user_timeline/1.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!(
           "test/fixtures/httpoison_mock/https___shitposter.club_api_statuses_user_timeline_1.atom.xml"
         )
     }}
  end

  def get(
        "https://shitposter.club/.well-known/webfinger?resource=https://shitposter.club/user/1",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/https___shitposter.club_user_1.xml")
     }}
  end

  def get("https://shitposter.club/notice/2827873", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!("test/fixtures/httpoison_mock/https___shitposter.club_notice_2827873.html")
     }}
  end

  def get("https://shitposter.club/api/statuses/show/2827873.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!(
           "test/fixtures/httpoison_mock/https___shitposter.club_api_statuses_show_2827873.atom.xml"
         )
     }}
  end

  def get("https://testing.pleroma.lol/objects/b319022a-4946-44c5-9de9-34801f95507b", _, _, _) do
    {:ok, %Tesla.Env{status: 200}}
  end

  def get("https://shitposter.club/api/statuses/user_timeline/5381.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/spc_5381.atom")
     }}
  end

  def get(
        "https://shitposter.club/.well-known/webfinger?resource=https://shitposter.club/user/5381",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/spc_5381_xrd.xml")
     }}
  end

  def get("http://shitposter.club/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/shitposter.club_host_meta")
     }}
  end

  def get("https://shitposter.club/api/statuses/show/7369654.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/7369654.atom")
     }}
  end

  def get("https://shitposter.club/notice/4027863", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/7369654.html")
     }}
  end

  def get("https://social.sakamoto.gq/users/eal/feed.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/sakamoto_eal_feed.atom")
     }}
  end

  def get("http://social.sakamoto.gq/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/social.sakamoto.gq_host_meta")
     }}
  end

  def get(
        "https://social.sakamoto.gq/.well-known/webfinger?resource=https://social.sakamoto.gq/users/eal",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/eal_sakamoto.xml")
     }}
  end

  def get("https://social.sakamoto.gq/objects/0ccc1a2c-66b0-4305-b23a-7f7f2b040056", _, _,
        Accept: "application/atom+xml"
      ) do
    {:ok, %Tesla.Env{status: 200, body: File.read!("test/fixtures/httpoison_mock/sakamoto.atom")}}
  end

  def get("http://mastodon.social/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/mastodon.social_host_meta")
     }}
  end

  def get(
        "https://mastodon.social/.well-known/webfinger?resource=https://mastodon.social/users/lambadalambda",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!(
           "test/fixtures/httpoison_mock/https___mastodon.social_users_lambadalambda.xml"
         )
     }}
  end

  def get("http://gs.example.org/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/gs.example.org_host_meta")
     }}
  end

  def get(
        "http://gs.example.org/.well-known/webfinger?resource=http://gs.example.org:4040/index.php/user/1",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!(
           "test/fixtures/httpoison_mock/http___gs.example.org_4040_index.php_user_1.xml"
         )
     }}
  end

  def get("http://gs.example.org/index.php/api/statuses/user_timeline/1.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!(
           "test/fixtures/httpoison_mock/http__gs.example.org_index.php_api_statuses_user_timeline_1.atom.xml"
         )
     }}
  end

  def get("https://social.heldscal.la/api/statuses/user_timeline/29191.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!(
           "test/fixtures/httpoison_mock/https___social.heldscal.la_api_statuses_user_timeline_29191.atom.xml"
         )
     }}
  end

  def get("http://squeet.me/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{status: 200, body: File.read!("test/fixtures/httpoison_mock/squeet.me_host_meta")}}
  end

  def get("https://squeet.me/xrd?uri=lain@squeet.me", _, _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/lain_squeet.me_webfinger.xml")
     }}
  end

  def get(
        "https://social.heldscal.la/.well-known/webfinger?resource=shp@social.heldscal.la",
        _,
        _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/shp@social.heldscal.la.xml")
     }}
  end

  def get("http://framatube.org/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/framatube.org_host_meta")
     }}
  end

  def get("http://framatube.org/main/xrd?uri=framasoft@framatube.org", _, _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       headers: [{"content-type", "application/json"}],
       body: File.read!("test/fixtures/httpoison_mock/framasoft@framatube.org.json")
     }}
  end

  def get("http://gnusocial.de/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/gnusocial.de_host_meta")
     }}
  end

  def get("http://gnusocial.de/main/xrd?uri=winterdienst@gnusocial.de", _, _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/winterdienst_webfinger.json")
     }}
  end

  def get("http://status.alpicola.com/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/status.alpicola.com_host_meta")
     }}
  end

  def get("http://macgirvin.com/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/macgirvin.com_host_meta")
     }}
  end

  def get("http://gerzilla.de/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/gerzilla.de_host_meta")
     }}
  end

  def get("https://gerzilla.de/xrd/?uri=kaniini@gerzilla.de", _, _,
        Accept: "application/xrd+xml,application/jrd+json"
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       headers: [{"content-type", "application/json"}],
       body: File.read!("test/fixtures/httpoison_mock/kaniini@gerzilla.de.json")
     }}
  end

  def get("https://social.heldscal.la/api/statuses/user_timeline/23211.atom", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body:
         File.read!(
           "test/fixtures/httpoison_mock/https___social.heldscal.la_api_statuses_user_timeline_23211.atom.xml"
         )
     }}
  end

  def get(
        "https://social.heldscal.la/.well-known/webfinger?resource=https://social.heldscal.la/user/23211",
        _,
        _,
        _
      ) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/https___social.heldscal.la_user_23211.xml")
     }}
  end

  def get("http://social.heldscal.la/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/social.heldscal.la_host_meta")
     }}
  end

  def get("https://social.heldscal.la/.well-known/host-meta", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: File.read!("test/fixtures/httpoison_mock/social.heldscal.la_host_meta")
     }}
  end

  def get("https://mastodon.social/users/lambadalambda.atom", _, _, _) do
    {:ok, %Tesla.Env{status: 200, body: File.read!("test/fixtures/lambadalambda.atom")}}
  end

  def get("https://social.heldscal.la/user/23211", _, _, Accept: "application/activity+json") do
    {:ok, Tesla.Mock.json(%{"id" => "https://social.heldscal.la/user/23211"}, status: 200)}
  end

  def get("http://example.com/ogp", _, _, _) do
    {:ok, %Tesla.Env{status: 200, body: File.read!("test/fixtures/rich_media/ogp.html")}}
  end

  def get("http://example.com/empty", _, _, _) do
    {:ok, %Tesla.Env{status: 200, body: "hello"}}
  end

  def get(url, query, body, headers) do
    {:error,
     "Not implemented the mock response for get #{inspect(url)}, #{query}, #{inspect(body)}, #{
       inspect(headers)
     }"}
  end

  # POST Requests
  #

  def post(url, query \\ [], body \\ [], headers \\ [])

  def post("http://example.org/needs_refresh", _, _, _) do
    {:ok,
     %Tesla.Env{
       status: 200,
       body: ""
     }}
  end

  def post(url, _query, _body, _headers) do
    {:error, "Not implemented the mock response for post #{inspect(url)}"}
  end
end
