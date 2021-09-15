require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @chef= Chef.create!(chefname: "Chronus" , email: "chron@gmail.com",
                        password:"password" , password_confirmation:"password")
    @recipe= Recipe.create(name: "Cake" , description: "recipe of a simple yet delicious cake" , chef: @chef)
  end

  test "reject invalid recipe update" do
    sign_in_as @chef, "password"
  get edit_recipe_path(@recipe)
  assert_template 'recipes/edit'
  patch recipe_path(@recipe), params: { recipe: { name: " ", description: "some description" } } 
  assert_template 'recipes/edit'
  assert_select 'h2.panel-title'
  assert_select 'div.panel-body'
end
  
  test "successful edit recipe" do
    sign_in_as @chef, "password"
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    updated_name ="Updated name"
    updated_description ="Updated description"
    patch recipe_path(@recipe), params:{recipe: {name: updated_name , description: updated_description}}
    assert_redirected_to @recipe
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
    end

end
