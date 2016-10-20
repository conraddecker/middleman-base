set :markdown_engine, :redcarpet
set :debug_assets,    true
set :css_dir,        'assets/stylesheets'
set :images_dir,     'assets/images'
set :js_dir,         'assets/javascripts'

activate :sprockets
activate :directory_indexes

configure :development do
  config[:host] = "http://localhost:4567"

  activate :livereload
end

configure :build do
  config[:host] = "https://cdevtech.com"

  activate :minify_css
  activate :minify_javascript
  activate :minify_html
  activate :asset_hash
  #activate :imageoptim

  after_build do
    Dir.glob( "#{config[:build_dir]}/**/*.html" ).each do |file|
      `critical #{file} --base #{config[:build_dir]} --inline --minify > #{file}.critical`

      File.rename(file, ['build/',File.basename(file, File.extname(file)), '.orig', File.extname(file)].join())
    end

    Dir.glob( "#{config[:build_dir]}/**/*.html.critical" ).each do |file|
      File.rename(file, file[0..-10])
    end
  end
end
