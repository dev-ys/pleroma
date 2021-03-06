defmodule Pleroma.Repo.Migrations.CreateFilters do
  use Ecto.Migration

  def change do
    create table(:filters) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :filter_id, :integer
      add :hide, :boolean
      add :phrase, :string
      add :context, {:array, :string}
      add :expires_at, :datetime
      add :whole_word, :boolean

      timestamps()
    end

    create index(:filters, [:user_id])
    create index(:filters, [:phrase], where: "hide = true", name: :hided_phrases_index)
  end
end
