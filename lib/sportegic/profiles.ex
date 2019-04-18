defmodule Sportegic.Profiles do
  import Ecto.Query, warn: false
  alias Sportegic.Repo

  alias Sportegic.Profiles.Profile

  def list_profiles(org) do
    Repo.all(Profile, prefix: org)
  end

  def get_profile!(id, org), do: Repo.get!(Profile, id, prefix: org)

  #  Get profile using user_id from con
  def get_profile(user_id, org) do
    profile =
      Profile
      |> where([p], p.user_id == ^user_id)
      |> Repo.one(prefix: org)

    {:ok, profile}
  end

  def create_profile(attrs \\ %{}, org) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert(prefix: org)
  end

  def update_profile(%Profile{} = profile, attrs, org) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update(prefix: org)
  end

  def delete_profile(%Profile{} = profile, org) do
    Repo.delete(profile, prefix: org)
  end

  def change_profile(%Profile{} = profile) do
    Profile.changeset(profile, %{})
  end
end
