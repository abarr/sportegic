defmodule Sportegic.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :firstname, :string
    field :lastname, :string
    field :mobile, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:firstname, :lastname, :mobile, :user_id])
    |> validate_required([:firstname, :lastname, :mobile,  :user_id])
  end
end
