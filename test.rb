require 'rss'
require 'json'
require 'yaml'

REPOS = %w(wafoo
           furikake
           ec2ctrl
           amiCtrl
           tagCtrl
           wafoon
           pStore
           shinobi
           chihuahua
         )

def get_xml_content(element)
  # HTML タグを除去する (refer to: https://www.mk-mode.com/octopress/2013/02/13/regexp-html-tag/)
  element.gsub(/<(".*?"|'.*?'|[^'"])*?>/, '')
end

def parse_updated_time(updated_time)
  t = Time.parse(updated_time)
  t.strftime("%Y-%m-%d")
end

def parse_version_number(version_string)
  version_string.split(':')[0]
end

releases = []
REPOS.each do |repo|
  url = 'https://github.com/inokappa/' + repo + '/releases.atom'
  rss = RSS::Parser.parse(url)
  release = {}
  release['title'] = repo
  release['version'] = parse_version_number(get_xml_content(rss.items[0].title.to_s))
  release['updated'] = parse_updated_time(get_xml_content(rss.items[0].updated.to_s))
  # updated が過去 1 ヶ月以内であれば...という条件を追加する
  releases << release
end

# puts releases.to_json
puts YAML.dump(releases)
