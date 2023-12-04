class TagsController < ApplicationController
  before_action :authenticate_user!
  def index
    matching_tags = Tag.all

    @list_of_tags = matching_tags.order({ :created_at => :desc })

    render({ :template => "tags/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_tags = Tag.where({ :id => the_id })

    @the_tag = matching_tags.at(0)

    render({ :template => "tags/show" })
  end

  def create
    the_tag = Tag.new
    the_tag.name = params.fetch("tag_name")
    the_tag.color = params.fetch("tag_color")

    if the_tag.valid?
      the_tag.save
      redirect_to("/tags", { :notice => "Tag created successfully." })
    else
      redirect_to("/tags", { :alert => the_tag.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_tag = Tag.where({ :id => the_id }).at(0)

    the_tag.name = params.fetch("query_name")
    the_tag.color = params.fetch("query_color")

    if the_tag.valid?
      the_tag.save
      redirect_to("/tags/#{the_tag.id}", { :notice => "Tag updated successfully."} )
    else
      redirect_to("/tags/#{the_tag.id}", { :alert => the_tag.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_tag = Tag.where({ :id => the_id }).at(0)

    the_tag.destroy

    redirect_to("/tags", { :notice => "Tag deleted successfully."} )
  end
end
