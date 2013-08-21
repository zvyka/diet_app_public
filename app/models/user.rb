# == Schema Information
# Schema version: 20110306021919
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  grad_year  :integer(4)
#  birth_year :integer(4)
#  UID        :string(255)
#  is_male    :boolean(1)
#  height     :integer(4)
#  is_special :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'

class User < ActiveRecord::Base
   attr_accessor :password
  attr_accessible :id, :name, :email, :UID, :birth_year, :grad_year, :is_male, :height, :is_special, :weight, :id_num, :reminder_freq, :activity_level, :num_meals

  has_many :meals , :dependent => :destroy

  #email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  email_regex = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i #newer regex, better?
  
  name_regex = /\A[a-zA-Z- ']+\z/
  
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 },
                    :format => { :with => name_regex, :message => "Invalid name format"}
                    
  validates :email, :presence => true#,
                    # :format   => { :with => email_regex, :message => "Not a valid email format" }#,
                    # :uniqueness => {:case_sensitive  => false }

  validates :UID, :presence => true, #UMD UID
                  :uniqueness => true
  validates :birth_year, :presence => true, #Year of birth
                         :numericality => true,
                         :inclusion => {:in => 1985..1995}
  validates :grad_year, :presence => true, #year of grad.
                        :numericality => true,
                        :inclusion => {:in => 2011..2017}
  
  def recommendation
    usda_facts = {
                  :male => {
                    :seventeen => {:sedentary => 2400.0, :moderate => 2800.0, :active => 3200.0 }, 
                    :eighteen => {:sedentary => 2400.0, :moderate => 2800.0, :active => 3200.0 }, 
                    :nineteen_twenty => {:sedentary => 2600.0, :moderate => 2800.0, :active => 3000.0 }, 
                    :twenty_one_twenty_five => {:sedentary => 2400.0, :moderate => 2800.0, :active => 3000.0 }
                    }, 
                  :female => { 
                    :seventeen => {:sedentary => 1800.0, :moderate => 2000.0, :active => 2400.0 }, 
                    :eighteen => {:sedentary => 1800.0, :moderate => 2000.0, :active => 2400.0 }, 
                    :nineteen_twenty => {:sedentary => 2000.0, :moderate => 2200.0, :active => 2400.0 }, 
                    :twenty_one_twenty_five => {:sedentary => 2000.0, :moderate => 2200.0, :active => 2400.0 }
                    }
                }
    
    if is_male
      gender = :male
    else
      gender = :female
    end
    
    case birth_year
    when 1995
      age = :seventeen
    when 1994
      age = :eighteen
    when 1993
      age = :nineteen_twenty
    when 1992
      age = :nineteen_twenty
    when 1991
      age = :twenty_one_twenty_five
    else
      age = :nineteen_twenty
    end
      
    case activity_level
    when 0
       rec = 1
    when 1 
       rec = usda_facts[gender][age][:sedentary]/2000
    when 2
       rec = usda_facts[gender][age][:moderate]/2000
    when 3 
       rec = usda_facts[gender][age][:active]/2000
    else
      rec = 1
    end
    rec
  end
          
  def rec_cals
    2000*recommendation
  end
  
  def rec_sugs
    (0.1*rec_cals)/4
  end
  
  def rec_fats
    (0.35*rec_cals)/9
  end
  
  def rec_fa_sat
    (0.10*rec_cals)/9
  end
  
  def rec_salt
    2300
  end        

  def rec_chol
    300
  end
  
  def rec_pots
    4700
  end

  def rec_carbs
    (0.53*rec_cals)/4
  end
  
  def rec_prot
    (0.12*rec_cals)/4
  end

  def rec_fibr
    if is_male
      rec = 56
    else
      rec = 46
    end
    rec
  end
  
  def rec_vit_c
    if is_male
      rec = 75
    else
      rec = 90
    end
    rec
  end

  def rec_calc
    1000
  end

  def rec_iron
    if is_male
      rec = 8
    else
      rec = 18
    end
    rec
  end

  def set_num_meals
    self.num_meals = Meal.find_all_by_user_id(self.id).size
    self.save!
  end

  def self.authenticate_with_UID(uid)
    user = find_by_UID(uid)
    if user.nil?
      return nil 
    else
      return user
    end
  end
     
   def index
     @meals = Meal.search(params[:search])
   end

   # def self.search(search)
   #   if search
   #     where('name LIKE ?', "%#{search}%")
   #   else
   #     scoped
   #   end
   # end
    
end

