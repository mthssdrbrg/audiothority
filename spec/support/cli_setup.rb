# encoding: utf-8

require 'fileutils'


shared_context 'cli setup' do
  let :run do
    run_audiothorian(argv)
  end

  def run_audiothorian(*argv)
    Audiothority::Cli.start(*argv)
  end

  def copy_resources(dir)
    Dir[resources_glob].each do |path|
      path = Pathname.new(path)
      FileUtils.copy_entry(path.to_s, %(#{dir}/#{path.basename}))
    end
  end

  def resources_glob
    %(#{resources_dir}/the-album)
  end

  def resources_dir
    @resources_dir ||= File.expand_path('../../resources', __FILE__)
  end

  def music_dir
    @music_dir
  end

  def set_music_dir(dir)
    @music_dir = dir
  end

  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        copy_resources(dir)
        set_music_dir(dir)
        example.call
      end
    end
  end
end
