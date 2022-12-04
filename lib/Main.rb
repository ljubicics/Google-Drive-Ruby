require './app.rb'
require './tableCol'
require 'google_drive'

session = GoogleDrive::Session.from_config("../config.json")

workSheet1 = session.spreadsheet_by_key("1j4HsxksmPcVG0ND7PG2EZjgXFxCp0awY6CK_OqcmSNI").worksheets[0]
workSheet2 = session.spreadsheet_by_key("1j4HsxksmPcVG0ND7PG2EZjgXFxCp0awY6CK_OqcmSNI").worksheets[1]

t1 = Table.new(workSheet1)
t2 = Table.new(workSheet2)

#input = ""
#
#while input != "exit"
#    input = gets.chomp
#    if(input.size >= 2)
#        i = input.split(" ")
#    end
#    if input == "list" # list ispisuje dvodimenzionalni niz TEST KOMANDA: list
#        p t1.list
#    elsif i[0] == "row" # prima row(naziv pozivanja funkcije) i redni broj reda koji zelimo da ispisemo (0 = header, 1 = prvi red,...)
#                        # TEST KOMANDA: row 1
#        p t1.row(i[1].to_i)
#    elsif input == "each" # ispisivanje svega u tabeli putem each TEST KOMANDA: each
#        p t1.each {|x| print x }
#    elsif i[0] == "col" # ispisuje vrednosti iz kolone ciji je header prosledjen kao drugi parametar TEST KOMANDA: col Prva Kolona
#        p t1[i[1] + " " + i[2]]
#    elsif i[0] == "getCell" # vraca vrednost celije TEST KOMANDA: getCell Prva Kolona 1 
#        p t1[i[1] + " " + i[2]][i[3].to_i]
#    elsif 
#    end
#end

puts "2D ARRAY:"
p t1.list
puts "\n"
puts "ROW 1:" 
p t1.row(1)
puts "\n"
puts "EACH:"
p t1.each {|x| print x }
puts "\n"
puts "COLUMN:"
puts t1["Prva Kolona"]
puts "\n"
puts "CELL IN COLUMN:"
p t1["Prva Kolona"][2]
puts "\n"
puts "SET VALUE:"
p t1["Prva Kolona"][1] = 2556
p t1.list
puts "\n"
puts "HEADER FUNCTION:"
puts t1.prvaKolona
puts "\n"
puts "HEADER FUNCTION SUM:"
p t1.drugaKolona.sum
puts "\n"
puts "HEADER FUNCTION AVG:"
p t1.drugaKolona.avg
puts "\n"
puts "ROW FROM CELL:"
p t1.prvaKolona.strahinja
puts "\n"
puts "COLUMN MAP:"
p t1.prvaKolona.map { |cell| cell+=1 }
puts "\n"
puts "COLUMN SELECT:"
p t1.drugaKolona.select { |cell| cell % 2 == 0}
puts "\n"
puts "COLUMN REDUCE:"
puts t1.drugaKolona.reduce(:+)
puts "\n"
puts "TABLE1 + TABLE2 , NEW SHEET IS CREATED IN GOOGLE SHEETS:"
p t1+t2
puts "\n"
puts "TABLE1 - TABLE2 , NEW SHEET IS CREATED IN GOOGLE SHEETS:"
p t1-t2
