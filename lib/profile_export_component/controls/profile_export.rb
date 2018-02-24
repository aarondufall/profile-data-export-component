module ProfileExportComponent
  module Controls
    module ProfileExport
      def self.example
        profile_export = ProfileExportComponent::ProfileExport.build

        profile_export.id = self.id
        profile_export.something_happened_time = Time::Effective::Raw.example

        profile_export
      end

      def self.id
        ID.example(increment: id_increment)
      end

      def self.id_increment
        1111
      end

      module New
        def self.example
          ProfileExportComponent::ProfileExport.build
        end
      end

      module Identified
        def self.example
          profile_export = New.example
          profile_export.id = ProfileExport.id
          profile_export
        end
      end
    end
  end
end
