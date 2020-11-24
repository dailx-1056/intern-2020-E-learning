module CategoriesHelper
  def categories
    Category.all
            .select(:id, :name)
            .map{|category| [category.name, category.id]}
  end
end
