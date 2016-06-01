Dir['./lib/tasks/paged_media/preingest/*'].each {|file| require file }
module PagedMedia
  module PreIngest
    module Tasks
      def Tasks.preingest
        puts "Pre-Ingest folders found: #{Helpers.preingest_folders.inspect}"
        Helpers::preingest_folders.each do |subdir_path|
          local_dir = Pathname.new(subdir_path).basename.to_s
          begin
            engine = "PagedMedia::PreIngest::#{local_dir.classify}".constantize
            puts "Loading preingest engine (#{local_dir.classify}) for subfolder: #{local_dir}"
          rescue
            puts "SKIPPING SUBDIRECTORY: #{local_dir}: No matching engine found"
          end
          engine.preingest(subdir_path) if engine
        end
      end
    end
    module Helpers
      def Helpers.preingest_folders
        ingest_root = "spec/fixtures/preingest/"
        return Dir.glob(ingest_root + "*").select { |f| File.directory?(f) }
      end
    end
  end
end
