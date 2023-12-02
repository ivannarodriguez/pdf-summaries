class LibraryController < ApplicationController
  def index
    render({:template => "library_templates/index"})
  end
end
