#!/usr/bin/env ruby
#
require 'csv'
require 'byebug'
require 'nokogiri'

plist_file = File.open("./iMarch/actions.plist", "w")

builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
  xml.doc.create_internal_subset(
    "plist",
    "-//Apple//DTD PLIST 1.0//EN", 
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd"
  )

  keys = []

  xml.plist(version: "1.0") do
    xml.array do
      CSV.foreach("data/actions.csv").with_index do |row, index|
        if index == 0
          keys = row
          next
        end

        xml.dict do
          row.each_with_index do |column, col_index|
            xml.key(keys[col_index])
            xml.string(column)
          end
        end
      end
    end
  end
end

plist_file.write(builder.to_xml)
