require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @chef= Chef.create!(chefname: "Chronus" , email: "chron@gmail.com",
                        password:"password" , password_confirmation:"password")
    @recipe= Recipe.create(name: "Cake" , description: "recipe of a simple yet delicious cake" , chef: @chef)
  end

  test "successful deletion of recipe" do
    sign_in_as @chef , "password"
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select "a[href=?]" , recipe_path(@recipe), text: "Delete this recipe"
    assert_difference 'Recipe.count' , -1 do
      delete recipe_path(@recipe) 
    end
      assert_redirected_to recipes_path
      assert_not flash.empty?
    end
end
