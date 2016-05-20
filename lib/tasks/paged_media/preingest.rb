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
      def Helpers.structure_to_array(xml_node)
        array = []
        xml_node.xpath('child::*').each do |child|
          c = {}
          if child.name == 'Div'
            c['container'] = {}
            c['title'] = [child['label']]
            c['ordered_members'] = Helpers.structure_to_array(child)
            array << c
          elsif child.name == 'Chunk'
            c['file_set'] = {}
            c['file_set']['depositor'] = 'user@example.com'
            c['file_set']['edit_users'] = ['user@example.com']
            c['file_set']['title'] = [child['label']]
            array << c
          end
        end
        array
      end
      def Helpers.preingest_folders
        ingest_root = "spec/fixtures/pre-ingest/paged_media/"
        return Dir.glob(ingest_root + "*").select { |f| File.directory?(f) }
      end
      def Helpers.preingest_file(filename, xml)
        # set up output
        yaml = {}

        # stub in test output
        yaml['paged_work'] = {}
        yaml['paged_work']['title'] = ['TITLE MISSING']
        yaml['paged_work']['creator'] = ['AUTHOR MISSING']
        yaml['paged_work']['depositor'] = 'user@example.com'
        yaml['paged_work']['edit_users'] = ['user@example.com']
        yaml['paged_work']['visibility'] = 'open'
        yaml['paged_work']['ordered_members'] = []

        # parse real output
        yaml['paged_work']['title'] = xml.xpath('/ScoreAccessPage/RecordSet/Container/DisplayTitle').map(&:content)
        yaml['paged_work']['creator'] = xml.xpath('/ScoreAccessPage/Bibinfo/Author').map(&:content)
        structure = xml.xpath('/ScoreAccessPage/RecordSet/Container/Structure/Item').first
        s = Helpers.structure_to_array(structure)
        yaml['paged_work']['ordered_members'] = s


        # save output
        p = Pathname.new(filename)
        dirname = p.dirname.to_s
        basename = p.basename.to_s
        yaml_file = "#{dirname}/manifest_#{basename.gsub('.xml','.yml')}"
        pp yaml
        puts "OUTPUT: #{yaml_file}"
        File.open(yaml_file, 'w') { |f| f.write yaml.to_yaml }
      end
    end
  end
end
