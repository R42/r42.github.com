require "rubygems"
require "bundler/setup"
require "stringex"

# -- Deploy config -- #

source_branch = 'source'
deploy_branch = 'master'

# -- Misc Configs -- #

public_dir = 'public'
source_dir = 'source'
posts_dir = '_posts'
people_dir = '_people'
new_post_ext = 'md'
new_page_ext = 'md'
new_person_ext = 'yml'

##########
# Jekyll #
##########

desc "Generate jekyll site"
task :generate do
  puts "## Generating Site with Jekyll"
  Dir.chdir("#{source_dir}") do
    system "jekyll --no-server"
  end
end

desc "preview the site in a web browser"
task :preview do
  puts "Starting to watch source with Jekyll."
  Dir.chdir("#{source_dir}") do
    jekyllPid = Process.spawn("jekyll --server --auto")
    trap("INT") {
      [jekyllPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
      exit 0
    }
    [jekyllPid].each { |pid| Process.wait(pid) }
  end
end

# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post (defaults to "new-post")
desc "Begin a new post in #{source_dir}/#{posts_dir}"
task :new_post, :title do |t, args|
  mkdir_p "#{source_dir}/#{posts_dir}"
  args.with_defaults(:title => 'new-post')
  title = args.title
  filename = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end

  puts "Creating new post: #{filename}"
  open(filename, 'w:UTF-8') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
    post.puts "comments: false"
    post.puts "categories: "
    post.puts "author: "
    post.puts "---"
  end
end

# usage rake new_post[new-person] or rake new_post['my new post'] or rake new_post (defaults to "new-person")
desc "Insert a new person in #{source_dir}/#{people_dir}"
task :new_person, :name do |t, args|
  mkdir_p "#{source_dir}/#{people_dir}"
  args.with_defaults(:name => 'new-person')
  name = args.name
  filename = "#{source_dir}/#{people_dir}/#{name.to_url}.#{new_person_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end

  puts "Creating new post: #{filename}"
  open(filename, 'w:UTF-8') do |post|
    post.puts "active: true"
    post.puts "layout: person"
    post.puts "name: #{name}"
    post.puts "email: "
  end
end

#############
# Deploying #
#############

desc "Default deploy task"
task :deploy do
  # Check if preview posts exist, which should not be published
  if File.exists?(".preview-mode")
    puts "## Found posts in preview mode, regenerating files ..."
    File.delete(".preview-mode")
    Rake::Task[:generate].execute
  end

  commit = (`git rev-parse #{deploy_branch}`).strip
  message = "Static files generate for commit " + commit
  system "git update-ref refs/heads/#{deploy_branch} $(echo '#{message}' | git commit-tree #{source_branch}^{tree}:#{public_dir} -p $(cat .git/refs/heads/#{deploy_branch}))"
  system "git push origin #{deploy_branch}"
  
  puts "## Deploy successful for commit #{commit}"
end

desc "Generate website and deploy"
task :gen_deploy => [:generate, :deploy] do
end

desc "list tasks"
task :list do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:list]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end
