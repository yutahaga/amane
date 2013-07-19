require "rubygems"
require 'rake'
require 'yaml'

config = YAML.load_file('_config.yml')

task :default => :preview

desc 'Clean up generated site'
task :clean do
  cleanup
end

desc 'Preview on local machine'
task :preview do
	jekyll('serve --watch')
end

desc 'Create a post'
task :post, [:slug, :date, :content] do |t, args|
  if args.slug == nil or
     (args.date and args.date.match(/[0-9]+-[0-9]+-[0-9]+/) == nil) then
    puts "Usage: rake 'post[SLUG]'"
    puts "Date is in the form: Y-m-d"
    exit 1
  end

  post_slug = args.slug.gsub(' ', '_')
  post_date = args.date || Time.new.strftime("%Y-%m-%d %H:%M:%S")

	filename = post_date[0..9] + "-" + post_slug + ".md"

  i = 1
  while File.exists?("_posts/" + filename) do
    filename = post_date[0..9] + "-" +
               post_slug + "-" + i.to_s +
               ".md"
    i += 1
  end

  post_path = "_posts/" + filename
  post_thumbnail = filename.gsub('.md', '.png')

	if not File.exists?(post_path) then
      File.open(post_path, 'w') do |f|
        f.puts "---"
        f.puts "title: \"\""
        f.puts "layout: post"
        f.puts "date: #{post_date}"
        f.puts "categories: []"
        f.puts "tags: []"
        f.puts "thumbnail: #{post_thumbnail}"
        f.puts "thumbnail_pos: left"
        f.puts "---"
        f.puts args.content if args.content != nil
      end

      puts "Post created under \"#{post_path}\""

      sh "open \"#{post_path}\"" if args.content == nil
  else
    puts "A post with the same name already exists. Aborted."
  end
end

desc 'Create a page'
task :page, [:slug, :date, :content] do |t, args|
  if args.slug == nil or
     (args.date and args.date.match(/[0-9]+-[0-9]+-[0-9]+/) == nil) then
    puts "Usage: rake 'page[SLUG]'"
    puts "Date is in the form: Y-m-d"
    exit 1
  end

  page_slug = args.slug.gsub(' ', '_')
  page_date = args.date || Time.new.strftime("%Y-%m-%d %H:%M:%S")

  filename = page_slug + ".md"

  i = 1
  while File.exists?(filename) do
    filename = page_slug + "-" + i.to_s + ".md"
    i += 1
  end

  page_path = filename
  page_thumbnail = filename.gsub('.md', '.png')

  if not File.exists?(page_path) then
      File.open(page_path, 'w') do |f|
        f.puts "---"
        f.puts "title: \"\""
        f.puts "layout: page"
        f.puts "date: #{page_date}"
        f.puts "categories: []"
        f.puts "tags: []"
        f.puts "thumbnail: #{page_thumbnail}"
        f.puts "thumbnail_pos: left"
        f.puts "---"
        f.puts args.content if args.content != nil
      end

      puts "Page created under \"#{page_path}\""

      sh "open \"#{page_path}\"" if args.content == nil
  else
    puts "A page with the same name already exists. Aborted."
  end
end

desc 'Check links for site already running on localhost:4000'
task :check_links do
  begin
    require 'anemone'
    root = 'http://localhost:4000/'
    Anemone.crawl(root, :discard_page_bodies => true) do |anemone|
      anemone.after_crawl do |pagestore|
        broken_links = Hash.new { |h, k| h[k] = [] }
        pagestore.each_value do |page|
          if page.code != 200
            referrers = pagestore.pages_linking_to(page.url)
            referrers.each do |referrer|
              broken_links[referrer] << page
            end
          end
        end
        broken_links.each do |referrer, pages|
          puts "#{referrer.url} contains the following broken links:"
          pages.each do |page|
            puts "  HTTP #{page.code} #{page.url}"
          end
        end
      end
    end

  rescue LoadError
    abort 'Install anemone gem: gem install anemone'
  end
end

desc 'Deploy site to remote repository'
task :deploy do
  if md = config['repository']['local'].match(/\/([^\/]+?)\/?$/)
    tmp_dir = config['repository']['local'].sub(/\/[^\/]+?\/?$/, '')
    site_name = md[1].sub(":url", config['url'].sub(/^https?:\/\//, ''))
    site_dir = File.dirname(__FILE__)
    cmds = <<-"EOS"
SITE_NAME=#{site_name}
SITE_DIR=#{site_dir}
TMP_DIR=#{tmp_dir}
REPO_URL=#{config['repository']['remote']}

if [ ! -d $TMP_DIR ]
then
  mkdir -p $TMP_DIR
fi

cd $TMP_DIR

if [ ! -d $SITE_NAME ]
then
  git clone $REPO_URL $SITE_NAME
fi

rm -rf "${SITE_NAME}/*"
cp -r "${SITE_DIR}/_site/" $SITE_NAME
cd $SITE_NAME
git add .
git add -u .
git commit -m "update"
git push -u origin master
  EOS

  sh cmds
  else
    puts "Aborted."
  end
end

def cleanup
  sh 'rm -rf _site'
end

def jekyll(directives = '')
  sh 'jekyll ' + directives
end
