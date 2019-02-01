# Pleroma: A lightweight social networking server
# Copyright © 2017-2019 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Config.DeprecationWarnings do
  require Logger

  def check_frontend_config_mechanism() do
    if Pleroma.Config.get(:fe) do
      Logger.warn("""
      !!!DEPRECATION WARNING!!!
      You are using the old configuration mechanism for the frontend. Please check config.md.
      """)
    end
  end

  def warn do
    check_frontend_config_mechanism()
  end
end
