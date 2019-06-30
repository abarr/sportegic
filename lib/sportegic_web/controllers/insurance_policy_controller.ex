defmodule SportegicWeb.InsurancePolicyController do
  use SportegicWeb, :controller

  alias Sportegic.People
  alias Sportegic.People.{InsurancePolicy, Attachment}
  alias Sportegic.LookupTypes

  # Allows for getting Types by LookupType
  @type_ref "Insurance Types"

  plug SportegicWeb.Plugs.Authenticate
  action_fallback SportegicWeb.FallbackController

  def action(conn, _) do
    person = People.get_person!(conn.params["person_id"], conn.assigns.organisation)
    args = [conn, conn.params, person, conn.assigns.organisation, conn.assigns.permissions]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "view:insurance_permissions", "", permissions) do
      insurance_policies = People.list_insurance_policies(person, org)
      render(conn, "index.html", insurance_policies: insurance_policies, person: person)
    end
  end

  def new(conn, _params, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "create:insurance_permissions", "", permissions) do
      changeset = People.change_insurance_policy(%InsurancePolicy{attachments: [%Attachment{}]})
      lookup = LookupTypes.get_lookup_by_name!(@type_ref, org)

      types =
        LookupTypes.list_types(lookup, org)
        |> Enum.map(fn type -> [key: type.name, value: type.id] end)

      types = [[key: "Choose a Type", value: "", disabled: "true", selected: "true"] | types]

      render(conn, "new.html", changeset: changeset, person: person, types: types)
    end
  end

  def create(conn, %{"insurance_policy" => insurance_policy_params}, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "create:insurance_permissions", "", permissions) do
      insurance_policy_params =
        insurance_policy_params
        |> Map.put("person_id", person.id)

      with {:ok, _insurance} <- People.create_insurance_policy(insurance_policy_params, org) do
        conn
        |> put_flash(:success, "Insurance Policy created successfully.")
        |> redirect(to: Routes.person_insurance_policy_path(conn, :index, person))
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          lookup = LookupTypes.get_lookup_by_name!(@type_ref, org)

          types =
            LookupTypes.list_types(lookup, org)
            |> Enum.map(fn type -> [key: type.name, value: type.id] end)

          conn
          |> put_flash(:danger, "There are errors on the page.")
          |> render("new.html", changeset: changeset, person: person, types: types)
      end
    end
  end

  def edit(conn, %{"id" => id}, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "edit:insurance_permissions", "", permissions) do
      insurance_policy = People.get_insurance_policy!(person, id, org)
      changeset = People.change_insurance_policy(insurance_policy)

      types =
        LookupTypes.get_lookup_by_name!(@type_ref, org)
        |> LookupTypes.list_types(org)
        |> Enum.map(fn type -> [key: type.name, value: type.id] end)

      render(conn, "edit.html",
        insurance_policy: insurance_policy,
        changeset: changeset,
        person: person,
        types: types
      )
    end
  end

  def update(conn, %{"id" => id, "insurance_policy" => insurance_policy_params}, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "edit:insurance_permissions", "", permissions) do    
      insurance_policy = People.get_insurance_policy!(person, id, org)

      case People.update_insurance_policy(insurance_policy, insurance_policy_params, org) do
        {:ok, _insurance} ->
          conn
          |> put_flash(:info, "Insurance Policy updated successfully.")
          |> redirect(to: Routes.person_insurance_policy_path(conn, :index, person))

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:danger, "Unable to update the insurance policy")
          |> render("edit.html",
            insurance_policy: insurance_policy,
            changeset: changeset,
            person: person
          )
      end
    end
  end

  def delete(conn, %{"id" => id}, person, org, permissions) do
    with :ok <- Bodyguard.permit(People, "delete:insurance_permissions", "", permissions) do
      insurance_policy = People.get_insurance_policy!(person, id, org)
      {:ok, _insurance} = People.delete_insurance_policy(insurance_policy, org)

      conn
      |> put_flash(:danger, "Insurance Policy deleted successfully.")
      |> redirect(to: Routes.person_insurance_policy_path(conn, :index, person))
    end
  end
end
