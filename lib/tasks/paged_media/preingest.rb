require 'pp'
module PagedMedia
  module PreIngest
    module Tasks
      def Tasks.preingest
        puts "Pre-Ingest folders found: #{Helpers.preingest_folders.inspect}"
        Helpers::preingest_folders.each do |subdir|
          puts "Running preingest for subfolder: #{subdir}"
          xml_files = Dir.glob(subdir + "/" + "*.xml").select { |f| File.file?(f) }
          puts "XML files found: #{xml_files.inspect}"
          xml_files.each do |xml_file|
            puts "XML file: #{xml_file}"
            xml_content = File.open(xml_file).read
            xml = Nokogiri::XML(xml_content)
            Helpers.preingest_file(xml_file, xml)
          end
        end
      end
    end
    module Helpers
      def Helpers.preingest_folders
        ingest_root = "spec/fixtures/pre-ingest/paged_media/"
        return Dir.glob(ingest_root + "*").select { |f| File.directory?(f) }
      end
      def Helpers.preingest_file(filename, xml)
        # set up output
        yaml = {}

        # stub in test output
        yaml['paged_work'] = {}
        yaml['paged_work']['title'] = ['Preingest title 1']
        yaml['paged_work']['creator'] = ['Preingest creator 1']
        yaml['paged_work']['depositor'] = 'user@example.com'
        yaml['paged_work']['edit_users'] = ['user@example.com']
        yaml['paged_work']['visibility'] = 'open'
        yaml['paged_work']['ordered_members'] = []

        # parse real output
        yaml['paged_work']['title'] = [xml.css('RecordSet Container DisplayTitle').first.content]

        # save output
        p = Pathname.new(filename)
        dirname = p.dirname.to_s
        basename = p.basename.to_s
        yaml_file = "#{dirname}/manifest_#{basename.gsub('.xml','.yml')}"
        puts "OUTPUT: #{yaml_file}"
        File.open(yaml_file, 'w') { |f| f.write yaml.to_yaml }
      end
    end
  end
end
