class PdfsController < ApplicationController
  def index
    matching_pdfs = Pdf.all

    @list_of_pdfs = matching_pdfs.order({ :created_at => :desc })

    render({ :template => "pdfs/index" })
  end

  def new_summary
    render({:template => "pdfs/new_summary"})
  end

  def show
    the_id = params.fetch("path_id")

    matching_pdfs = Pdf.where({ :id => the_id })

    @the_pdf = matching_pdfs.at(0)

    render({ :template => "pdfs/show" })
  end

  def create
    the_pdf = Pdf.new
    the_pdf.title = params.fetch("query_title")
    the_pdf.url = params.fetch("query_url")
    the_pdf.summary = params.fetch("query_summary")

    if the_pdf.valid?
      the_pdf.save
      redirect_to("/pdfs", { :notice => "Pdf created successfully." })
    else
      redirect_to("/pdfs", { :alert => the_pdf.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_pdf = Pdf.where({ :id => the_id }).at(0)

    the_pdf.title = params.fetch("query_title")
    the_pdf.url = params.fetch("query_url")
    the_pdf.summary = params.fetch("query_summary")

    if the_pdf.valid?
      the_pdf.save
      redirect_to("/pdfs/#{the_pdf.id}", { :notice => "Pdf updated successfully."} )
    else
      redirect_to("/pdfs/#{the_pdf.id}", { :alert => the_pdf.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_pdf = Pdf.where({ :id => the_id }).at(0)

    the_pdf.destroy

    redirect_to("/pdfs", { :notice => "Pdf deleted successfully."} )
  end
end
