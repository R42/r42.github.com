require "rubygems"
require 'rake'
require 'yaml'
require 'time'

SOURCE = "."
CONFIG = {
  'version' => "0.0.1",
  'team' => File.join(SOURCE, "_team"),
  'layouts' => File.join(SOURCE, "_layouts"),
  'posts' => File.join(SOURCE, "_posts"),
  'post_ext' => "md"
}

# Usage: rake member name="username"
# You can also specify a sub-directory path.
# If you don't specify a file extention we create an index.html at the path specified
desc "Create a new member."
task :member do
  name = ENV["name"] || "sample-person.md"
  slug = name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  
  filename = File.join(CONFIG['team'], "#{slug}.yml")
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{slug} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  
  mkdir_p File.dirname(filename)
  puts "Creating new member: #{filename}"
  open(filename, 'w') do |member|
    member.puts "active: true"
    member.puts "bio: This is a sample person's bio."
    member.puts "email: sample@person.com"
    member.puts "github: sampleperson"
    member.puts "image:"
    member.puts "  url: /url/to/sample-person.jpg"
    member.puts "  title: Sample Person"
    member.puts "  alt: Sample Person"
    member.puts "  attribution:"
    member.puts "layout: profile"
    member.puts "linkedin: sampleperson"
    member.puts "name: Sample Person"
    member.puts 'short: <a href="/team/sample-person">Sample Person</a> is the founder and CEO of the company.'
    member.puts "twitter: sampleperson"
    member.puts "type: member"
    member.puts "website: http://sampleperson.com/"
  end
end # task :member


# Usage: rake post title="A Title" author="username" [date="2012-02-09"]
desc "Begin a new post in #{CONFIG['posts']}"
task :post do
  abort("rake aborted: '#{CONFIG['posts']}' directory not found.") unless FileTest.directory?(CONFIG['posts'])
  title = ENV["title"] || "new-post"
  slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  author = ENV['author']

  begin
    date = (ENV['date'] ? Time.parse(ENV['date']) : Time.now).strftime('%Y-%m-%d')
  rescue Exception => e
    puts "Error - date format must be YYYY-MM-DD, please check you typed it correctly!"
    exit -1
  end
  filename = File.join(CONFIG['posts'], "#{date}-#{slug}.#{CONFIG['post_ext']}")
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  
  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/-/,' ')}\""
    post.puts 'description: ""'
    post.puts 'category: "posts"'
    post.puts "tags: []"
    post.puts "author: \"#{author}\""
    post.puts "---"
  end
end # task :post

# Usage: rake page name="about.html"
# You can also specify a sub-directory path.
# If you don't specify a file extention we create an index.html at the path specified
desc "Create a new page."
task :page do
  name = ENV["name"] || "new-page.md"
  filename = File.join(SOURCE, "#{name}")
  filename = File.join(filename, "index.html") if File.extname(filename) == ""
  title = File.basename(filename, File.extname(filename)).gsub(/[\W\_]/, " ").gsub(/\b\w/){$&.upcase}
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  
  mkdir_p File.dirname(filename)
  puts "Creating new page: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: page"
    post.puts "title: \"#{title}\""
    post.puts 'description: ""'
    post.puts "---"
  end
end # task :page

desc "Launch preview environment"
task :preview do
  system "jekyll --auto --server"
end # task :preview

def ask(message, valid_options)
  if valid_options
    answer = get_stdin("#{message} #{valid_options.to_s.gsub(/"/, '').gsub(/, /,'/')} ") while !valid_options.include?(answer)
  else
    answer = get_stdin(message)
  end
  answer
end

def get_stdin(message)
  print message
  STDIN.gets.chomp
end

#Load custom rake scripts
Dir['_rake/*.rake'].each { |r| load r }