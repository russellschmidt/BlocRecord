def convert_to_camel_case(str)
    # need to capitalize the first letter
    # need to capitalize every letter after an underscore
    # need to delete all underscores
    
    str.gsub!(/(^[a-z])/) { $1.upcase }
    str.split("_").map {|x| x.capitalize}.join

end
