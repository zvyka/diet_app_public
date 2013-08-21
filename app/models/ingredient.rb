class Ingredient < ActiveRecord::Base
  belongs_to :meal
  
  @@dvs = {:total_fat => 65, :fa_sat => 20, :cholesterol => 300, :sodium => 2400, :potassium => 3500,
          :tot_carbs => 300, :fiber => 25, :protein => 50, :vit_c => 60, :calcium => 1000, :iron => 18, 
          :sugar_total => 40, :calories => 2000, :f_and_vs => 5}
  
  def cals_dv 
    (Food.find(food_id).calories*multiplication_factor)/@@dvs[:calories]      <= 1 ? "green" : "red"  
  end
  
  def salt_dv 
    (Food.find(food_id).sodium*multiplication_factor)/@@dvs[:sodium]        <= 1 ? "green" : "red"  
  end
  
  def fats_dv 
    (Food.find(food_id).lipid_total*multiplication_factor)/@@dvs[:total_fat]     <= 1 ? "green" : "red"  
  end
  
  def sugs_dv 
    (Food.find(food_id).sugar_total*multiplication_factor)/@@dvs[:sugar_total]   <= 1 ? "green" : "red"  
  end
  
  def multiplication_factor
    m_factor = 0
     food = Food.find(food_id) 
		 if food.umd == 0
			 if serving_size.nil? 
				 m_factor = servings
			 else 
				 m_factor = servings*serving_size/100
			 end
		 else
		   m_factor = servings
		 end
		 m_factor
  end
  
  def food_name
    Food.find(food_id).name*multiplication_factor
  end
  
  def food_calories
    Food.find(food_id).calories*multiplication_factor
  end
  
  def food_sodium
    Food.find(food_id).sodium*multiplication_factor
  end
  
  def food_fats
    Food.find(food_id).lipid_total*multiplication_factor
  end
  
  def food_sugar
    Food.find(food_id).sugar_total*multiplication_factor
  end
  
  def f_vs
	  fruits_and_vegetables ? 1 : 0
	end
  
end
