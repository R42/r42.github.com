# https://github.com/flatterline/jekyll-plugins

module Jekyll
  class PeopleIndex < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir  = dir
      @name = "index.html"

      self.read_yaml(File.join(base, '_layouts'), 'people.html')
      self.data['people'] = self.get_people(site)
      self.process(@name)
    end

    def get_people(site)
      {}.tap do |people|
        Dir['_people/*.yml'].each do |path|
          name   = File.basename(path, '.yml')
          config = YAML.load(File.read(File.join(@base, path)))

          if config['active']
            people = {} if people.nil?
            people[name] = config
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
      self.data['title'] = "#{self.data['name']}"

      self.process(@name)
    end
  end

  class GeneratePeople < Generator
    safe true
    priority :normal

    def generate(site)
      write_people(site)
    end

    # Loops through the list of person pages and processes each one.
    def write_people(site)
      if Dir.exists?('_people')
        Dir.chdir('_people')
        Dir["*.yml"].each do |path|
          name = File.basename(path, '.yml')
          self.write_person_index(site, "_people/#{path}", name)
        end

        Dir.chdir(site.source)
        self.write_people_index(site)
      end
    end

    def write_people_index(site)
      people = PeopleIndex.new(site, site.source, "/people")
      people.render(site.layouts, site.site_payload)
      people.write(site.dest)

      site.pages << people
      site.static_files << people
    end

    def write_person_index(site, path, name)
      person = PersonIndex.new(site, site.source, "/people/#{name}", path)

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
            name = "#{author.downcase.gsub(' ', '-')}"
            data = YAML.load(File.read(File.join(site['source'], '_people', "#{name}.yml")))
            
            data['url'] = "/people/#{name}"
            data['alias'] = author
            template = File.read(File.join(site['source'], '_includes', 'author.html'))

            output << Liquid::Template.parse(template).render('author' => data)
          end
        end
      end
    end
  end
end

Liquid::Template.register_tag('authors', Jekyll::AuthorsTag)