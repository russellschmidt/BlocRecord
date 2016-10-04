def find_by (attribute, value)
    connection.execute <<-SQL
        SELECT (*) 
        FROM #{self.class.table} 
        WHERE #{attribute} = #{value};
    SQL
end
