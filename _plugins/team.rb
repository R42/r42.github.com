module Jekyll
  class MembersIndex < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir  = dir
      @name = "index.html"

      self.read_yaml(File.join(base, '_layouts'), 'members.html')
      self.data['members'] = self.get_members(site)
      self.process(@name)
    end

    def get_members(site)
      {}.tap do |members|
        Dir['_members/*.yml'].each do |path|
          name   = File.basename(path, '.yml')
          config = YAML.load(File.read(File.join(@base, path)))
          type   = config['type']

          if config['active']
            members[type] = {} if members[type].nil?
            members[type][name] = config
          end
        end
      end
    end
  end

  class PersonIndex < Page
    def initialize(site, base, dir, path)
      @site     = site
      @base     = base
      @dir      = dir
      @name     = "index.html"
      self.data = YAML.load(File.read(File.join(@base, path)))
      self.data['title'] = "#{self.data['name']} | #{self.data['role']}"

      self.process(@name)
    end
  end

  class GenerateMembers < Generator
    safe true
    priority :normal

    def generate(site)
      write_members(site)
    end

    # Loops through the list of members pages and processes each one.
    def write_members(site)
      if Dir.exists?('_members')
        Dir.chdir('_members')
        Dir["*.yml"].each do |path|
          name = File.basename(path, '.yml')
          self.write_person_index(site, "_members/#{path}", name)
        end

        Dir.chdir(site.source)
        self.write_members_index(site)
      end
    end

    def write_members_index(site)
      members = MembersIndex.new(site, site.source, "/members")
      members.render(site.layouts, site.site_payload)
      members.write(site.dest)

      site.pages << members
      site.static_files << members
    end

    def write_person_index(site, path, name)
      person = PersonIndex.new(site, site.source, "/members/#{name}", path)

      if person.data['active']
        person.render(site.layouts, site.site_payload)
        person.write(site.dest)

        site.pages << person
        site.static_files << person
      end
    end
  end

  class AuthorsTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text   = text
      @tokens = tokens
    end

    def render(context)
      site = context.environments.first["site"]
      page = context.environments.first["page"]

      if page
        authors = page['author']
        authors = [authors] if authors.is_a?(String)

        "".tap do |output|
          authors.each do |author|
            data     = YAML.load(File.read(File.join(site['source'], '_members', "#{author.downcase.gsub(' ', '-')}.yml")))
            template = File.read(File.join(site['source'], '_includes', 'author.html'))

            output << Liquid::Template.parse(template).render('author' => data)
          end
        end
      end
    end
  end
end

Liquid::Template.register_tag('authors', Jekyll::AuthorsTag)