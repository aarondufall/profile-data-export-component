module ProfileExportComponent
  module Consumers
    class Events
      include Consumer::Postgres

      identifier :view_data

      handler Handlers::Events
    end
  end
end
