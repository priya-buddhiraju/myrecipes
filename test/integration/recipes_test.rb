require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @chef= Chef.create!(chefname: "Chronus" , email: "chron@gmail.com")
    @recipe= Recipe.create(name: "Cake" , description: "recipe of a simple yet delicious cake" , chef: @chef)
    @recipe2=@chef.recipes.build(name: "Biryani" , description: "Hyderabadi Biryani")
    @recipe2.save
   end
  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end

  test "should get recipes listing" do
  get recipes_path
  assert_template 'recipes/index'
  assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
  assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end

  test "should show recipes" do
    get recipe_path(@recipe2)
    assert_template 'recipes/show'
    assert_match @recipe2.name, response.body
    assert_match @recipe2.description, response.body
    assert_match @chef.chefname, response.body
  end

  test "create new valid recipe" do
  get new_recipe_path
  assert_template 'recipes/new'
  name_of_recipe = "chicken saute"
  description_of_recipe = "add chicken, add vegetables, 

  cook for 20 minutes, serve delicious meal"
  assert_difference 'Recipe.count', 1 do
  post recipes_path, params: { recipe: { name: name_of_recipe, 

  description: description_of_recipe}}
  end
  follow_redirect!
  assert_match name_of_recipe.capitalize, response.body
  assert_match description_of_recipe, response.body
end

  test "reject invalid recipe" do
    get new_recipe_path
  assert_template 'recipes/new'
  assert_no_difference 'Recipe.count' do
    post recipes_path, params: { recipe: { name: " ", description: " " } }
  end
  assert_template 'recipes/new'
  assert_select 'h2.panel-title'
  assert_select 'div.panel-body'
end

end