module DataCommand
  class Consumer
    include ::Consumer::Postgres

    handler ViewData::PG::Handler
  end
end
