module Photish
  module Config
    class DefaultConfig
      def hash
        {
          port: 9876,
          site_dir: File.join(Dir.pwd, 'site'),
          photo_dir: File.join(Dir.pwd, 'photos'),
          output_dir: File.join(Dir.pwd, 'output'),
          workers: workers,
          threads: threads,
          worker_index: 0,
          force: false,
          photish_executable: photish_executable,
          qualities: qualities,
          templates: templates,
          logging: logging,
          url: url,
          plugins: [],
          image_extensions: image_extensions
        }
      end

      private

      def image_extensions
        out, _err, _status = Open3.capture3('convert -list format')
        out.split($/)
           .map { |line| /(\S+)(?=\*)/.match(line).try(:[], 0) }
           .compact
           .map { |ext| ext.downcase }
      end

      def url
        {
          host: '',
          base: nil,
          type: 'absolute_uri'
        }
      end

      def logging
        {
          colorize: true,
          output: ['stdout', 'file'],
          level: 'info'
        }
      end

      def templates
        {
          layout: 'layout.slim',
          collection: 'collection.slim',
          album: 'album.slim',
          photo: 'photo.slim'
        }
      end

      def qualities
        [
          { name: 'Original',
            params: [] },
          { name: 'Low',
            params: ['-resize', '200x200'] }
        ]
      end

      def workers
        1
      end

      def threads
        processor_count
      end

      def processor_count
        Facter.value('processors')['count']
      end

      def photish_executable
        File.join(File.dirname(__FILE__),
                  '..',
                  '..',
                  '..',
                  'exe',
                  'photish')
      end
    end
  end
end
