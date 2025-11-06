#!/usr/bin/env ruby
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  ruby '2.7.8'
end

require 'json'
require 'fileutils'

PACKAGE_JSON_FILENAME = './package.json'

def main()
  if ARGV.length != 1 then
    puts "Usage:  #{$0} (major|minor|patch)"
    exit 1
  end
  
  case ARGV[0]
  when "major"
    level = :major
  when "minor"
    level = :minor
  when "patch"
    level = :patch
  else
    STDERR.puts "Unexpected argument: #{ARGV[0]}"
    exit 1
  end
  
  new_version = bump_version(level)
  
  puts new_version
  exit 0
end

private

def bump_version(level)
  package_json = JSON.parse(File.read(PACKAGE_JSON_FILENAME))
  version_bits = package_json["version"].split('.')
  
  if level == :major then
    version_bits[0] = version_bits[0].to_i + 1
    version_bits[1] = 0
    version_bits[2] = 0
  elsif level == :minor then
    version_bits[1] = version_bits[1].to_i + 1
    version_bits[2] = 0
  elsif level == :patch then
    version_bits[2] = version_bits[2].to_i + 1
  end

  new_version = version_bits.join('.')
  
  package_json["version"] = new_version
  
  File.write(PACKAGE_JSON_FILENAME, "#{JSON.pretty_generate(package_json)}\n")

  new_version
end

main()