module PagedMedia
  module PreIngest
    module ContentdmNewspaper
      def ContentdmNewspaper.preingest(dir)
        Dir.glob(dir + '/*').select { |f| File.directory?(f) }.each do |subdir|
          puts "Looking in: #{subdir}"
          xml_files = Dir.glob(subdir + "/" + "*.xml").select { |f| File.file?(f) }
          puts "XML files found: #{xml_files.inspect}"
          xml_files.each do |xml_file|
            puts "XML file: #{xml_file}"
            xml_content = File.open(xml_file).read
            xml = Nokogiri::XML(xml_content)
            ContentdmNewspaper.preingest_file(xml_file, xml)
          end
        end
      end
      def ContentdmNewspaper.add_newspaper(record)
        issue = {}
        issue['newspaper'] = {}
        issue['newspaper']['title'] = record.xpath('title').map(&:content)
        issue['newspaper']['visibility'] = 'open'
        issue['newspaper']['creator'] = record.xpath('publisher').map(&:content)
        #issue['newspaper']['ordered_members'] = []
        pages = ContentdmNewspaper.add_pages(record.xpath('structure'))
        issue['newspaper']['ordered_members'] = pages
        return issue
      end
      def ContentdmNewspaper.add_pages(pages_xml)
        pages = []
        pages_xml.xpath('page').each do |page_xml|
          page = {}
          page['file_set'] = {}
          page['file_set']['title'] = page_xml.xpath('pagetitle').map(&:content)
          page['file_set']['visibility'] = 'open'
          #files = {}
          #page_xml.xpath('pagefile').each do |file_xml|
            #file_type = file_xml.xpath('pagefiletype').text
          #end
          pages << page
        end
        return pages
      end
      def ContentdmNewspaper.download_content()

      end
      def ContentdmNewspaper.preingest_file(filename, xml)
        # set up output
        yaml = {}
        basename = Pathname.new(filename).basename.to_s.gsub('.xml', '')
        collectionname = basename.gsub('_', ' ')

        # create collection
        yaml['collection'] = {}
        yaml['collection']['title'] = [collectionname]
        yaml['collection']['visibility'] = 'open'
        #yaml['collection']['ordered_members'] = {}

        # each record is an issue
        issues = []
        xml.xpath('/metadata/record').each do |record|
          issues << ContentdmNewspaper.add_newspaper(record)
        end

        # add issues to collection
        yaml['collection']['ordered_members'] = issues

        # save output
        output_dir = "spec/fixtures/ingest/#{basename}"
        FileUtils.mkdir_p(output_dir) unless File.exists?(output_dir)
        yaml_file = "#{output_dir}/manifest_#{basename}.yml"
        puts "OUTPUT: #{yaml_file}"
        File.open(yaml_file, 'w') { |f| f.write yaml.to_yaml }
      end
    end
  end
end
