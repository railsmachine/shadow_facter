module TestFacts
  extend ShadowFacter
  
  fact :drink, "tea"
  fact :uname, exec("uname")
  fact :food do 
    "p" + "izz" + "a"
  end
  
  fact :beer, "420", :test_drink => "beer"
  fact :tea, "oolong", :test_drink => "tea"
  
end
  
