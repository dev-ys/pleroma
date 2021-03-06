# Pleroma: A lightweight social networking server
# Copyright © 2017-2018 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.CommonAPI.UtilsTest do
  alias Pleroma.Web.CommonAPI.Utils
  alias Pleroma.Web.Endpoint
  alias Pleroma.Builders.{UserBuilder}
  use Pleroma.DataCase

  test "it adds attachment links to a given text and attachment set" do
    name =
      "Sakura%20Mana%20%E2%80%93%20Turned%20on%20by%20a%20Senior%20OL%20with%20a%20Temptating%20Tight%20Skirt-s%20Full%20Hipline%20and%20Panty%20Shot-%20Beautiful%20Thick%20Thighs-%20and%20Erotic%20Ass-%20-2015-%20--%20Oppaitime%208-28-2017%206-50-33%20PM.png"

    attachment = %{
      "url" => [%{"href" => name}]
    }

    res = Utils.add_attachments("", [attachment])

    assert res ==
             "<br><a href=\"#{name}\" class='attachment'>Sakura Mana – Turned on by a Se…</a>"
  end

  describe "it confirms the password given is the current users password" do
    test "incorrect password given" do
      {:ok, user} = UserBuilder.insert()

      assert Utils.confirm_current_password(user, "") == {:error, "Invalid password."}
    end

    test "correct password given" do
      {:ok, user} = UserBuilder.insert()
      assert Utils.confirm_current_password(user, "test") == {:ok, user}
    end
  end

  test "parses emoji from name and bio" do
    {:ok, user} = UserBuilder.insert(%{name: ":karjalanpiirakka:", bio: ":perkele:"})

    expected = [
      %{
        "type" => "Emoji",
        "icon" => %{"type" => "Image", "url" => "#{Endpoint.url()}/finmoji/128px/perkele-128.png"},
        "name" => ":perkele:"
      },
      %{
        "type" => "Emoji",
        "icon" => %{
          "type" => "Image",
          "url" => "#{Endpoint.url()}/finmoji/128px/karjalanpiirakka-128.png"
        },
        "name" => ":karjalanpiirakka:"
      }
    ]

    assert expected == Utils.emoji_from_profile(user)
  end

  describe "format_input/4" do
    test "works for bare text/plain" do
      text = "hello world!"
      expected = "hello world!"

      output = Utils.format_input(text, [], [], "text/plain")

      assert output == expected

      text = "hello world!\n\nsecond paragraph!"
      expected = "hello world!<br><br>second paragraph!"

      output = Utils.format_input(text, [], [], "text/plain")

      assert output == expected
    end

    test "works for bare text/html" do
      text = "<p>hello world!</p>"
      expected = "<p>hello world!</p>"

      output = Utils.format_input(text, [], [], "text/html")

      assert output == expected

      text = "<p>hello world!</p>\n\n<p>second paragraph</p>"
      expected = "<p>hello world!</p>\n\n<p>second paragraph</p>"

      output = Utils.format_input(text, [], [], "text/html")

      assert output == expected
    end

    test "works for bare text/markdown" do
      text = "**hello world**"
      expected = "<p><strong>hello world</strong></p>\n"

      output = Utils.format_input(text, [], [], "text/markdown")

      assert output == expected

      text = "**hello world**\n\n*another paragraph*"
      expected = "<p><strong>hello world</strong></p>\n<p><em>another paragraph</em></p>\n"

      output = Utils.format_input(text, [], [], "text/markdown")

      assert output == expected
    end
  end
end
