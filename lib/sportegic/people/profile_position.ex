defmodule Sportegic.People.ProfilePosition do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles_position" do
    field :profile_id, :id
    field :type_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile_position, attrs) do
    profile_position
    |> cast(attrs, [])
    |> validate_required([])
  end
end
