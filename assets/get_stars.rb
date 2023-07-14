# This is a simple web scraping mechanism to patch all 'packages/*.yaml'
# with a star count from the respective repository hosting service
# (e.g. GitHub, GitLab) during the build time.
#
# NOTE: It is NOT intended to save this changing information to the original
#       YAML files.  Any star count given in them will be overwritten.

require 'nokogiri'
require 'open-uri'
require 'yaml'

def get_github_stars (url)
  html = URI.open(url + '/stargazers')
  doc = Nokogiri::HTML(html)
  return doc.css('nav.tabnav-tabs span.Counter').text.to_i
end

def get_gitlab_stars (url)
  html = URI.open(url)
  doc = Nokogiri::HTML(html)
  return doc.css('a.star-count').text.to_i
end

def get_star_count_from_url (url)
  stars = -1  # Means no star count was found.
  begin
    if url.include? 'github.com'
      stars = get_github_stars(url)
      puts '  --> Found %d GitHub stars' % [stars]
    elsif url.include? 'gitlab.com'
      stars = get_gitlab_stars(url)
      puts '  --> Found %d GitLab stars' % [stars]
    else
      puts '  --> No stars'
    end
  rescue OpenURI::HTTPError
    puts '  --> No stars, bad URL "%s"' % [url]
  end
  return stars
end

# Patch all package YAML-files with star count if possible.
Dir.glob('packages/*.yaml') do |filename|
  puts filename
  data = YAML.load(File.read(filename))

  # Find repository URL
  data['links'].each do |link|
    if link['label'] == 'repository'
      stars = get_star_count_from_url (link['url'])

      # Append star count to package YAML-file.
      open(filename, 'r+') { |f|
        last_line = 0
        f.each { last_line = f.pos unless f.eof? }
        f.seek(last_line, IO::SEEK_SET)
        f.puts 'stars: %d' % [stars]
        f.puts '---'
      }
    end
  end
end

