def convert_to_camel_case(str)
    # need to capitalize the first letter
    # need to capitalize every letter after an underscore
    # need to delete all underscores
    
    str.gsub!(/(^[a-z])/) { $1.upcase }
    str.gsub!(/(?<=_)[a-z]/){|x| x.capitalize}
    str.gsub!(/[_]/){|x| ''}
    # A different non-regex way to do this, replacing last two lines above 
    # str.split("_").map {|x| x.capitalize}.join

end
