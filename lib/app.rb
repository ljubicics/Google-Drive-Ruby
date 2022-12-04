#require 'google_drive'
require './tableCol.rb'


class Table
   include Enumerable

   attr_accessor :table
   attr_reader :table

   def initialize(ws) 
      @ws = ws
      @skip_col = 0
      @skip_row = 0
      @table = load_table(ws)
   end

   def load_table(ws)
      flag = false
      (1..ws.num_rows).each do |row|
         (1..ws.num_cols).each do |col|
            if ws[row, col] != ""
               if !flag
                  flag = true
                  @skip_row = row-1
                  @skip_col = col-1
               end
            end
         end
      end
      nc = ws.num_cols
      table = ((1 + @skip_row)..ws.num_rows).map do |row|
        ((1 + @skip_col)..nc).map { |col| ws[row, col] }
      end
      flag = -1
      (0..(table.size - 1)).each do |row|
         (0..(table[row].size - 1)).each do |col|
            if (table[row][col] == "total" || table[row][col] == "subtotal")
               flag = row
            end
         end
      end
      if(flag != -1)
         (0..(table[flag].size - 1)).each do |col|
            table[flag][col] = ""
         end
      end
      table
   end

   def method_missing(key, *args)
      pom_key = key.to_s
         t = 0
         (0..(@table[0].size - 1)).each do |i|
            pom = @table[0][i].delete(" ")
            if (pom.casecmp(pom_key) == 0)
               t = i
            end
         end
         #Ako se pozove .index prosledjuje se red koji uopste nije bitan jer mozemo ivuci stvari iz tabele koju svakako prosledjujemo
      TableCol.new(self, @table.transpose[t], t, @skip_row + 1)
   end

   def row(i)
      @table[i]
   end

   def each 
      if block_given?
         yield @table
      end
   end
   
   def [](parametar)
      if parametar.is_a? String
         k = nil
         @table[0].each do |i|
            if i == parametar
               k = @table[0].find_index(i)
            end
         end
         TableCol.new(self, @table.transpose[k], k, @skip_row + 1)
      else
         @table[parametar]
      end
   end 

   def set(row, col, value)
      @table[row][col] = value
      @ws[row + @skip_row + 1, col + @skip_col + 1] = value
      @ws.save
   end

   def list
      @table
   end

   def +(t2)
      t1 = @table
      check_header = false
      if(t1[0].size < t2[0].size || t1[0].size > t2[0].size)
         return "Nije moguce spojiti tabele"
      else
         (0..(t1[0].size - 1)).each do |i|
            if t1[0][i] != t2[0][i] 
               return "Nije moguce spojiti tabele"
            end
         end
      end
      spread_sheet = @ws.spreadsheet
      spread_sheet.add_worksheet("Sheet3")
      new_ws = spread_sheet.worksheet_by_title("Sheet3")
      pom = t1
      pom += t2.table[1..-1]
      i = 1
      j = 1
      (0..(pom.size - 1)).each do |row|
         j = 1
         (0..(pom[row].size - 1)).each do |cell|
            new_ws[i, j] = pom[row][cell]
            j += 1
         end
         i += 1
      end
      new_ws.save
      newT = Table.new(new_ws)
      newT.table = pom
      return newT
   end

   def -(t2)
      t1 = @table
      if(t1[0].size < t2[0].size || t1[0].size > t2[0].size)
         return "Nije moguce oduzeti tabele 1"
      else
         (0..(t1[0].size - 1)).each do |i|
            if t1[0][i] != t2[0][i] 
               return "Nije moguce oduzeti tabele 2"
            end
         end
      end
      pom = @table
      pom -= t2.table[1..-1]
      spread_sheet = @ws.spreadsheet
      spread_sheet.add_worksheet("Sheet4")
      new_ws = spread_sheet.worksheet_by_title("Sheet4")
      new_ws.update_cells(@skip_row, @skip_col, pom)
      new_ws.save
      newT = Table.new(new_ws)
      newT.table = pom
      return newT
   end
end

