# Pleroma: A lightweight social networking server
# Copyright © 2017-2019 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Upload do
  @moduledoc """
  # Upload

  Options:
  * `:type`: presets for activity type (defaults to Document) and size limits from app configuration
  * `:description`: upload alternative text
  * `:base_url`: override base url
  * `:uploader`: override uploader
  * `:filters`: override filters
  * `:size_limit`: override size limit
  * `:activity_type`: override activity type

  The `%Pleroma.Upload{}` struct: all documented fields are meant to be overwritten in filters:

  * `:id` - the upload id.
  * `:name` - the upload file name.
  * `:path` - the upload path: set at first to `id/name` but can be changed. Keep in mind that the path
    is once created permanent and changing it (especially in uploaders) is probably a bad idea!
  * `:tempfile` - path to the temporary file. Prefer in-place changes on the file rather than changing the
  path as the temporary file is also tracked by `Plug.Upload{}` and automatically deleted once the request is over.

  Related behaviors:

  * `Pleroma.Uploaders.Uploader`
  * `Pleroma.Upload.Filter`

  """
  alias Ecto.UUID
  require Logger

  @type source ::
          Plug.Upload.t()
          | (data_uri_string :: String.t())
          | {:from_local, name :: String.t(), id :: String.t(), path :: String.t()}

  @type option ::
          {:type, :avatar | :banner | :background}
          | {:description, String.t()}
          | {:activity_type, String.t()}
          | {:size_limit, nil | non_neg_integer()}
          | {:uploader, module()}
          | {:filters, [module()]}

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          tempfile: String.t(),
          content_type: String.t(),
          path: String.t()
        }
  defstruct [:id, :name, :tempfile, :content_type, :path]

  @spec store(source, options :: [option()]) :: {:ok, Map.t()} | {:error, any()}
  def store(upload, opts \\ []) do
    opts = get_opts(opts)

    with {:ok, upload} <- prepare_upload(upload, opts),
         upload = %__MODULE__{upload | path: upload.path || "#{upload.id}/#{upload.name}"},
         {:ok, upload} <- Pleroma.Upload.Filter.filter(opts.filters, upload),
         {:ok, url_spec} <- Pleroma.Uploaders.Uploader.put_file(opts.uploader, upload) do
      {:ok,
       %{
         "type" => opts.activity_type,
         "url" => [
           %{
             "type" => "Link",
             "mediaType" => upload.content_type,
             "href" => url_from_spec(opts.base_url, url_spec)
           }
         ],
         "name" => Map.get(opts, :description) || upload.name
       }}
    else
      {:error, error} ->
        Logger.error(
          "#{__MODULE__} store (using #{inspect(opts.uploader)}) failed: #{inspect(error)}"
        )

        {:error, error}
    end
  end

  defp get_opts(opts) do
    {size_limit, activity_type} =
      case Keyword.get(opts, :type) do
        :banner ->
          {Pleroma.Config.get!([:instance, :banner_upload_limit]), "Image"}

        :avatar ->
          {Pleroma.Config.get!([:instance, :avatar_upload_limit]), "Image"}

        :background ->
          {Pleroma.Config.get!([:instance, :background_upload_limit]), "Image"}

        _ ->
          {Pleroma.Config.get!([:instance, :upload_limit]), "Document"}
      end

    opts = %{
      activity_type: Keyword.get(opts, :activity_type, activity_type),
      size_limit: Keyword.get(opts, :size_limit, size_limit),
      uploader: Keyword.get(opts, :uploader, Pleroma.Config.get([__MODULE__, :uploader])),
      filters: Keyword.get(opts, :filters, Pleroma.Config.get([__MODULE__, :filters])),
      description: Keyword.get(opts, :description),
      base_url:
        Keyword.get(
          opts,
          :base_url,
          Pleroma.Config.get([__MODULE__, :base_url], Pleroma.Web.base_url())
        )
    }

    # TODO: 1.0+ : remove old config compatibility
    opts =
      if Pleroma.Config.get([__MODULE__, :strip_exif]) == true &&
           !Enum.member?(opts.filters, Pleroma.Upload.Filter.Mogrify) do
        Logger.warn("""
        Pleroma: configuration `:instance, :strip_exif` is deprecated, please instead set:

          :pleroma, Pleroma.Upload, [filters: [Pleroma.Upload.Filter.Mogrify]]

          :pleroma, Pleroma.Upload.Filter.Mogrify, args: "strip"
        """)

        Pleroma.Config.put([Pleroma.Upload.Filter.Mogrify], args: "strip")
        Map.put(opts, :filters, opts.filters ++ [Pleroma.Upload.Filter.Mogrify])
      else
        opts
      end

    if Pleroma.Config.get([:instance, :dedupe_media]) == true &&
         !Enum.member?(opts.filters, Pleroma.Upload.Filter.Dedupe) do
      Logger.warn("""
      Pleroma: configuration `:instance, :dedupe_media` is deprecated, please instead set:

      :pleroma, Pleroma.Upload, [filters: [Pleroma.Upload.Filter.Dedupe]]
      """)

      Map.put(opts, :filters, opts.filters ++ [Pleroma.Upload.Filter.Dedupe])
    else
      opts
    end
  end

  defp prepare_upload(%Plug.Upload{} = file, opts) do
    with :ok <- check_file_size(file.path, opts.size_limit),
         {:ok, content_type, name} <- Pleroma.MIME.file_mime_type(file.path, file.filename) do
      {:ok,
       %__MODULE__{
         id: UUID.generate(),
         name: name,
         tempfile: file.path,
         content_type: content_type
       }}
    end
  end

  defp prepare_upload(%{"img" => "data:image/" <> image_data}, opts) do
    parsed = Regex.named_captures(~r/(?<filetype>jpeg|png|gif);base64,(?<data>.*)/, image_data)
    data = Base.decode64!(parsed["data"], ignore: :whitespace)
    hash = String.downcase(Base.encode16(:crypto.hash(:sha256, data)))

    with :ok <- check_binary_size(data, opts.size_limit),
         tmp_path <- tempfile_for_image(data),
         {:ok, content_type, name} <-
           Pleroma.MIME.bin_mime_type(data, hash <> "." <> parsed["filetype"]) do
      {:ok,
       %__MODULE__{
         id: UUID.generate(),
         name: name,
         tempfile: tmp_path,
         content_type: content_type
       }}
    end
  end

  # For Mix.Tasks.MigrateLocalUploads
  defp prepare_upload(upload = %__MODULE__{tempfile: path}, _opts) do
    with {:ok, content_type} <- Pleroma.MIME.file_mime_type(path) do
      {:ok, %__MODULE__{upload | content_type: content_type}}
    end
  end

  defp check_binary_size(binary, size_limit)
       when is_integer(size_limit) and size_limit > 0 and byte_size(binary) >= size_limit do
    {:error, :file_too_large}
  end

  defp check_binary_size(_, _), do: :ok

  defp check_file_size(path, size_limit) when is_integer(size_limit) and size_limit > 0 do
    with {:ok, %{size: size}} <- File.stat(path),
         true <- size <= size_limit do
      :ok
    else
      false -> {:error, :file_too_large}
      error -> error
    end
  end

  defp check_file_size(_, _), do: :ok

  # Creates a tempfile using the Plug.Upload Genserver which cleans them up
  # automatically.
  defp tempfile_for_image(data) do
    {:ok, tmp_path} = Plug.Upload.random_file("profile_pics")
    {:ok, tmp_file} = File.open(tmp_path, [:write, :raw, :binary])
    IO.binwrite(tmp_file, data)

    tmp_path
  end

  defp url_from_spec(base_url, {:file, path}) do
    path =
      path
      |> URI.encode()
      |> String.replace("?", "%3F")
      |> String.replace(":", "%3A")

    [base_url, "media", path]
    |> Path.join()
  end

  defp url_from_spec(_base_url, {:url, url}), do: url
end
