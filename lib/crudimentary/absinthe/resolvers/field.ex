defmodule CRUDimentary.Absinthe.Resolvers.Field do
  defmacro __using__(params) do
    quote do
      use CRUDimentary.Absinthe.Resolvers.Base

      def call(nil, _, _, _, _), do: raise(ArgumentError, message: "field can not be nil")
      def call(
            current_account,
            parent,
            args,
            %{definition: %{schema_node: %{identifier: field}}} = resolution
          ) do
        if field in unquote(params[:policy]).accessible_attributes(parent, current_account) do
          try do
            call(field, current_account, parent, args, resolution)
          rescue
            FunctionClauseError ->
              unquote(__MODULE__).return_field(parent, field)
          end
        else
          {:ok, nil}
        end
      end
    end
  end

  def return_field(struct, field), do: {:ok, Map.from_struct(struct)[field]}
end
