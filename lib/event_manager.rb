# # require 'csv'
# # puts 'Event Manager Initialized!'
# # # contents = File.read('event_attendees.csv')
# # # puts contents
# # # lines = File.readlines('event_attendees.csv')
# # # row_index = 0
# # # lines.each do |line|
# # #     row_index = row_index + 1
# # #     next if row_index == 1
# # #     #next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"
# # #     columns = line.split(',')
# # #    # puts columns
# # #     name = columns[2]
# # #     puts name
# # #     #puts line

# # # lines = File.readlines('event_attendees.csv')
# # # lines.each_with_index do |line,index|
# # #   next if index == 0
# # #   columns = line.split(",")
# # #   name = columns[2]
# # #   puts name

# # contents = CSV.open('event_attendees.csv', headers: true,  header_converters: :symbol)
# # contents.each do |row|
# #   name = row[:first_name]
# #  # puts name
# #     zipcode = row[:zipcode]
# #     # if zipcode.nil?
# #     # zipcode = "00000"
# #     # elsif zipcode.length < 5
# #     # zipcode = zipcode.to_s.rjust(5, '0')
# #     # elsif zipcode.length > 5
# #     # zipcode = zipcode[0..4]
# #     # end
# #     zipcode = zipcode.to_s.rjust(5, '0')[0..4]
# #     puts "#{name} #{zipcode}"
  
# # end

# require 'csv'
# require 'google/apis/civicinfo_v2'

# civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
# civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

# def clean_zipcode(zipcode)
#   if zipcode.nil?
#     '00000'
#   elsif zipcode.length < 5
#     zipcode.to_s.rjust(5, '0')
#   elsif zipcode.length > 5
#     zipcode[0..4]
#   else
#     zipcode
#   end
# end

# puts 'EventManager initialized.'

# contents = CSV.open(
#   'event_attendees.csv',
#   headers: true,
#   header_converters: :symbol
# )

# contents.each do |row|
#   name = row[:first_name]

#   zipcode = clean_zipcode(row[:zipcode])

#   begin
#   legislators = civic_info.representative_info_by_address(
#     address: zipcode,
#     levels: 'country',
#     roles: ['legislatorUpperBody', 'legislatorLowerBody']
#   )
 
#   legislators = legislators.officials
#   legislator_names = legislators.map do |legislator|
#     legislator.name
#   end
#   legislator_names = legislators.map(&:name)
#   legislators_string = legislator_names.join(', ')
  
# rescue
#   'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
# end

#   puts "#{name} #{zipcode} #{legislators_string}"
# end

require 'csv'
require 'google/apis/civicinfo_v2'


def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators = legislators.officials
    legislator_names = legislators.map(&:name)
    legislator_names.join(", ")
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  puts "#{name} #{zipcode} #{legislators}"
end