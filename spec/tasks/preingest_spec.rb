require './lib/tasks/paged_media/preingest'
require './lib/tasks/paged_media/ingest'

PREINGEST_CHANGES = { Collection => 1, Newspaper => 5, MusicalScore => 2 }

describe PagedMedia::PreIngest do
  describe PagedMedia::PreIngest::Tasks do
    describe '.preingest' do
      before(:all) do
        # ensure previous tests have not left clutter behind
        PREINGEST_CHANGES.keys.each { |object_class| object_class.destroy_all }
        PagedMedia::PreIngest::Tasks.preingest
        PagedMedia::Ingest::Tasks.ingest
      end
      # manually remove generated ingest files, ingested objects
      after(:all) do
        PagedMedia::Ingest::Helpers.ingest_folders.each do |subdir|
          unless subdir.match /package1/
            manifest_files = Dir.glob(subdir + "/" + "manifest*.yml").select { |f| File.file?(f) }
            manifest_files.each { |f| `rm -f #{f}` }
          end
        end
        PREINGEST_CHANGES.keys.each { |object_class| object_class.destroy_all }
      end
      describe "create ingestable objects" do
        PREINGEST_CHANGES.each do |object_class, count|
          specify "#{object_class.to_s}: #{count}" do
            expect(object_class.count).to eq count
          end
        end
      end
    end
  end
end
