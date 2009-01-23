namespace :test do
  fact :drink, "tea"
  
  fact :food do 
    get_pizza
  end
  
  fact :beer, "420", { "test_drink" => "beer"}
  fact :tea, "oolong", { "test_drink" => "tea"}

end

def get_pizza
  "pizza"
end