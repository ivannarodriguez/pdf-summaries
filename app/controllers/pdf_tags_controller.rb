class PdfTagsController < ApplicationController
  def index
    matching_pdf_tags = PdfTag.all

    @list_of_pdf_tags = matching_pdf_tags.order({ :created_at => :desc })

    render({ :template => "pdf_tags/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_pdf_tags = PdfTag.where({ :id => the_id })

    @the_pdf_tag = matching_pdf_tags.at(0)

    render({ :template => "pdf_tags/show" })
  end

  def create
    the_pdf_tag = PdfTag.new
    the_pdf_tag.pdf_id = params.fetch("query_pdf_id")
    the_pdf_tag.tag_id = params.fetch("query_tag_id")

    if the_pdf_tag.valid?
      the_pdf_tag.save
      redirect_to("/pdf_tags", { :notice => "Pdf tag created successfully." })
    else
      redirect_to("/pdf_tags", { :alert => the_pdf_tag.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_pdf_tag = PdfTag.where({ :id => the_id }).at(0)

    the_pdf_tag.pdf_id = params.fetch("query_pdf_id")
    the_pdf_tag.tag_id = params.fetch("query_tag_id")

    if the_pdf_tag.valid?
      the_pdf_tag.save
      redirect_to("/pdf_tags/#{the_pdf_tag.id}", { :notice => "Pdf tag updated successfully."} )
    else
      redirect_to("/pdf_tags/#{the_pdf_tag.id}", { :alert => the_pdf_tag.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_pdf_tag = PdfTag.where({ :id => the_id }).at(0)

    the_pdf_tag.destroy

    redirect_to("/pdf_tags", { :notice => "Pdf tag deleted successfully."} )
  end
end
