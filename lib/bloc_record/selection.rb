require 'sqlite3'

module Selection

	def ids_in_range?(*ids)
		min = 1
		max = connection.execute <<-SQL
			SELECT MAX(id) FROM #{table}
		SQL
		in_range = true

		ids.each do |id|
			if id < min
				puts "id out of range (id < 0)"
				return in_range = false
			elsif id > max
				puts "id out of range (id > max(id))"
				return in_range = false
			end
		end

		in_range
	end


  def find(*ids)
  	unless ids.nil?
  		if ids.is_a? String
  			begin
	  			ids = ids.to_i
  			rescue 
  				puts "Selection id is not a valid number"
  			else
  				ids = [ids]
  			end
  		elsif ids.is_a? Numeric
  			ids = [ids]
  		elsif ids.is_a? Array
  			ids.compact!
  		else
  			puts "Selection ID not a valid format"
  		end

  		if ids_in_range?(ids)
		  	if ids.length == 1
		  		find_one(ids.first)
		  	else
		  		rows = connection.execute <<-SQL
		  			SELECT #{columns.join ","} FROM #{table}
		  			WHERE id IN (#{ids.join(",")});
		  		SQL

		  		rows_to_array(rows)
		  	end
		  end
	  end
  end


  def find_one(id)
    row = connection.get_first_row <<-SQL
        SELECT #{columns.join ","} FROM #{table}
        WHERE id = #{id};
    SQL

    init_object_from_row(row)
  end


  def find_by(attribute, value)
  	begin 
  		value = value.to_s unless value.is_a? String
  	rescue
  		puts "Sorry, the value you are looking for is of an invalid data type."
  	else
	  	row = connection.get_first_row <<-SQL
	  		SELECT #{columns.join ","} FROM #{table}
	  		WHERE #{attribute} 
	  		IN #{BlocRecord::Utility.sql_strings(value)};
	  	SQL

	  	init_object_from_row(row)
	  end
  end


  # for checkpoint 3 assignment
  def find_all(attribute, value)
  	begin 
  		value = value.to_s unless value.is_a? String
  	rescue
  		puts "Sorry, the value you are looking for is of an invalid data type."
  	else
	  	rows = connection.execute <<-SQL
	  		SELECT #{columns.join ","} FROM #{table}
	  		WHERE #{attribute} 
	  		IN (#{BlocRecord::Utility.sql_strings(value)});
	  	SQL

	  	rows_to_array(rows)
	  end
  end


  def take(num=1)
  	max = connection.execute <<-SQL
			SELECT MAX(id) FROM #{table}
		SQL

		if num < 1
			puts "You must select more than zero items."
		elsif num > max
			puts "You want more items than exist in the database (maximum: #{max})."
		else
	  	if num > 1
	  		rows = connection.execute <<-SQL
	  			SELECT #{columns.join ","} FROM #{table}
	  			ORDER BY random()
	  			LIMIT #{num};
	  		SQL

	  		rows_to_array
	  	else
	  		take_one
	  	end
	  end
  end


  def take_one
  	row = connection.get_first_row <<-SQL
  		SELECT #{columns.join ","} FROM #{table}
  		ORDER BY random()
  		LIMIT 1;
  	SQL

  	init_object_from_row(row)
  end


  def first
  	row = connection.get_first_row <<-SQL
  		SELECT #{columns.join ","} FROM #{table}
  		ORDER BY id
  		ASC LIMIT 1;
  	SQL

  	init_object_from_row(row)
  end


  def last
  	row = connection.get_first_row <<-SQL
  		SELECT #{columns.join ","} FROM #{table}
  		ORDER BY id
  		DESC LIMIT 1;
  	SQL

  	init_object_from_row(row)
  end


  def all
  	rows = connection.execute <<-SQL
  		SELECT #{columns.join ","} FROM #{table};
  	SQL

  	rows_to_array(rows)
  end


  private
  def init_object_from_row(row)
  	if row
	  	data = Hash[columns.zip(row)]
		  new(data)
		end
  end

  def rows_to_array(rows)
  	rows.map { |row| new(Hash[columns.zip(row)]) }
  end

end
