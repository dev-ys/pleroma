# Pleroma: A lightweight social networking server
# Copyright © 2017-2018 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Mix.Tasks.Pleroma.Relay do
  use Mix.Task
  alias Pleroma.Web.ActivityPub.Relay
  alias Mix.Tasks.Pleroma.Common

  @shortdoc "Manages remote relays"
  @moduledoc """
  Manages remote relays

  ## Follow a remote relay

  ``mix pleroma.relay follow <relay_url>``

  Example: ``mix pleroma.relay follow  https://example.org/relay``

  ## Unfollow a remote relay

  ``mix pleroma.relay unfollow <relay_url>``

  Example: ``mix pleroma.relay unfollow https://example.org/relay``
  """
  def run(["follow", target]) do
    Common.start_pleroma()

    with {:ok, _activity} <- Relay.follow(target) do
      # put this task to sleep to allow the genserver to push out the messages
      :timer.sleep(500)
    else
      {:error, e} -> Mix.shell().error("Error while following #{target}: #{inspect(e)}")
    end
  end

  def run(["unfollow", target]) do
    Common.start_pleroma()

    with {:ok, _activity} <- Relay.unfollow(target) do
      # put this task to sleep to allow the genserver to push out the messages
      :timer.sleep(500)
    else
      {:error, e} -> Mix.shell().error("Error while following #{target}: #{inspect(e)}")
    end
  end
end
