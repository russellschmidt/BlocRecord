def find_by (attribute, value)
    connection.execute <<-SQL
        SELECT #{self.class.table} 
        WHERE #{attribute} = #{value};
    SQL
end
