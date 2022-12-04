class TableCol
    def initialize(table, table_col, col_index, row_begin_index)
       @table_col = table_col
       @col_index = col_index
       @row_begin_index = row_begin_index
       @table = table
    end
 
    def [](par)
       @table_col[par]
    end
 
    def []=(index, value)
       @table_col[index] = value
       @table.set(index, @col_index, value)
    end
 
    def to_s
       "(#@table_col)"
    end
 
    def method_missing(key, *args)
       name = key.to_s
       if name == "sum"
          sum = 0
          (1..(@table_col.size-1)).each do |i|
             num = @table_col[i]
             sum += num.to_i
          end
          return sum
       elsif name == "avg"
          sum = 0
          (1..(@table_col.size-1)).each do |i|
             num = @table_col[i]
             sum += num.to_i
          end
          average = (sum*1.0) / (@table_col.size-1)
          return average
       else
          tabelica = @table.table
          flag = true
          (0..(tabelica.size - 1)).each do |row|
             (0..(tabelica[row].size - 1)).each do |col|
                if(name == tabelica[row][col].to_s)
                   flag = false
                   return tabelica[row]
                end
             end
          end
          if(flag)

          end
       end
    end
 
    def map(&b)
       br = 0
       new_ary = []
       @table_col.each do |i|
          if br == 0
              br += 1
          else
             new_ary.push(i.to_i)
          end
       end
       ary = new_ary.map &b
       return ary
    end
 
    def select(&b)
       br = 0
       new_ary = []
       @table_col.each do |i|
          if br == 0
              br += 1
          else
             new_ary.push(i.to_i)
          end
       end
       puts &b
       ary = new_ary.select &b
       return ary
    end
 
    def reduce(b)
       br = 0
       new_ary = []
       @table_col.each do |i|
          if br == 0
              br += 1
          else
             new_ary.push(i.to_i)
          end
       end
       ary = new_ary.reduce(b)
    end
 
 end