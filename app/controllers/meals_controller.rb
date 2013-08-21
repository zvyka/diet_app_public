class MealsController < ApplicationController
  
  before_filter CASClient::Frameworks::Rails::Filter

    before_filter :authenticate, :only => [:create, :destroy]

    def index
      redirect_to user_path(current_user)
    end

  def show
    @meal = Meal.find(params[:id])
    @this_meal = Meal.find(params[:id])  
      
    @meal.ingredients.build :what_food => "_new_food"
    @meal.ingredients.sort! { |a,b| a.what_food.downcase <=> b.what_food.downcase }
    @meal.ingredients[0].what_food = nil
        
    @foods = Food.all
    
    @dvs = {:total_fat => current_user.rec_fats, :fa_sat => current_user.rec_fa_sat, :cholesterol => current_user.rec_chol, :sodium => current_user.rec_salt, :potassium => current_user.rec_pots, :tot_carbs => current_user.rec_carbs, :fiber => current_user.rec_fibr, :protein => current_user.rec_prot, :vit_c => current_user.rec_vit_c, :calcium => current_user.rec_calc, :iron => current_user.rec_iron, :sugar_total => current_user.rec_sugs, :calories => current_user.rec_cals, :f_and_vs => 5}  
     
     @cals =      @this_meal.total_cals 
     @salt =      @this_meal.total_salt 
     @fats =      @this_meal.total_fats 
     @sugs =      @this_meal.total_sugs 
     @f_and_vs =  @this_meal.total_f_vs  
            
      @chart_data = "#{'%1.2f' % (100*@cals/@dvs[:calories])},
                     #{'%1.2f' % (100*@salt/@dvs[:sodium])},
                     #{'%1.2f' % (100*@fats/@dvs[:total_fat])}, 
                     #{'%1.2f' % (100*@sugs/@dvs[:sugar_total])}, 
                     #{'%1.2f' % (100*@f_and_vs/@dvs[:f_and_vs])}"
      
            
    if @meal.user_id != current_user.id
      redirect_to user_path(current_user), :notice => "Access denied"
    end         
  end
  
  def new
    @meal = Meal.new
    @foods = Food.all
    
    @meal.ingredients.build
  end

  def create
    @meal = Meal.new(params[:meal])
    if @meal.save
      User.find(@meal.user_id).set_num_meals
      redirect_to @meal, :success => "Successfully created meal."
    else
      flash[:error] = "Oops, something didn't work! Remember, your food can't be blank, and you can't have more than one meal on any day. See the #{ActionController::Base.helpers.link_to "Help page", help_path} for more details".html_safe
      redirect_to user_path(current_user)#, :success => "Food can't be blank! Make sure you select a food from the list. See the #{ActionController::Base.helpers.link_to "Help page", help_path} for more details".html_safe
    end
  end

  def edit
    @meal = Meal.find(params[:id])
    
    @foods = Food.all
        
    if @meal.user_id != current_user.id
      redirect_to user_path(current_user), :warning => "Access denied"
    end
  end
  
  def make_clone
    old_meal = Meal.find(params[:id])
    new_meal = old_meal.clone :include => :ingredients
    new_meal.favorite = false
    new_meal.date_eaten = Date.today
    new_meal.save
    redirect_to edit_meal_path(new_meal), :notice => "Edit your duplicated meal here"
  end

  def update
    @meal = Meal.find(params[:id])
    if @meal.update_attributes(params[:meal])
        redirect_to @meal, :success  => "Successfully updated meal."
    else
      # render :action => 'edit'
      redirect_to @meal, :error => "Oops, something didn't work! Remember, your food can't be blank, and you can't have more than one meal on any day. See the #{ActionController::Base.helpers.link_to "Help page", help_path} for more details".html_safe
    end 
    
  end

  def destroy
    @meal = Meal.find(params[:id])
    if @meal.user_id != current_user.id
      redirect_to user_path(current_user), :notice => "Access denied"
    end
    @meal.destroy
    redirect_to user_path(current_user), :notice => "Successfully destroyed meal."
  end
end
