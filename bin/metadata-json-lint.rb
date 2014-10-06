#!/usr/bin/env ruby

require "json"

if ARGV[0].nil?
  abort("Error: Must provide a metadata.json file to parse")
end

metadata = ARGV[0]

f = File.read(metadata)

begin
  parsed = JSON.parse(f)
rescue
  abort("Error: Unable to parse json. There is a syntax error somewhere.")
end

# Fields required to be in metadata.json
# From: https://docs.puppetlabs.com/puppet/latest/reference/modules_publishing.html#write-a-metadatajson-file
error_state = false

required_fields = [ "name", "version", "author", "license", "summary", "source", "dependencies" ]

required_fields.each do |field|
  if parsed[field].nil?
    puts "Error: Required field '#{field}' not found in metadata.json."
    error_state = true
  end
end



# Depricated fields
# From: https://docs.puppetlabs.com/puppet/latest/reference/modules_publishing.html#write-a-metadatajson-file

deprecated_fields = ["types", "checksum"]

deprecated_fields.each do |field|
  if not parsed[field].nil?
    puts "Error: Deprecated field '#{field}' found in metadata.json."
    error_state = true
  end
end


if error_state
  abort("Errors found in metadata.json")
end