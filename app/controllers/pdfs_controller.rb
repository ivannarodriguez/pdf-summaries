require 'pdf/reader'

class PdfsController < ApplicationController
  before_action :authenticate_user!

  def index
    matching_pdfs = Pdf.all
    @list_of_pdfs = matching_pdfs.order({ :created_at => :desc })
    render({ :template => "pdfs/index" })
  end

  def new_summary
    @list_of_tags = current_user.tags
    @pdf_url = session[:pdf_url]
    render({:template => "pdfs/new_summary"})
  end

  def create_summary
    @pdf_url = params[:pdf_url]
    session[:pdf_url] = @pdf_url
    redirect_to("/new")
  end

  def start_new_summary
    session.store(:pdf_url, nil)
    redirect_to("/new")
  end

  # def get_summary
  #   @pdf_url = params[:pdf_url]
  #   session[:pdf_url] = @pdf_url
  #   redirect_to("/new/summary")
  # end

  # def show_summary
  #   @pdf_url = session[:pdf_url]
  #   render({:template => "pdfs/new_summary_final"})
  # end

      # # --- if the user inputs a pdf url then this
    # @pdf_url = params[:pdf_url]
    # @list_of_tags = current_user.tags

    # if params[:pdf_file].present?
    #   @pdf_file = params[:pdf_file]
  
    #   reader = PDF::Reader.new(@pdf_file.tempfile)
    #   @text = ""
  
    #   reader.pages.each do |page|
    #     @text += page.text
    #   end
    # else
    #   flash[:error] = "No file uploaded"
    # end

  # def show
  #   the_id = params.fetch("path_id")
  #   matching_pdfs = Pdf.where({ :id => the_id })
  #   @the_pdf = matching_pdfs.at(0)
  #   render({ :template => "pdfs/show" })
  # end


  def create
    the_pdf = Pdf.new
    the_pdf.title = params.fetch("query_title")
    the_pdf.url = params.fetch("query_url")
    the_pdf.summary = params.fetch("
    ")

    if the_pdf.valid?
      the_pdf.save
      redirect_to("/pdfs", { :notice => "Pdf created successfully." })
    else
      redirect_to("/pdfs", { :alert => the_pdf.errors.full_messages.to_sentence })
    end
  end

  # def update
  #   the_id = params.fetch("path_id")
  #   the_pdf = Pdf.where({ :id => the_id }).at(0)
  #   the_pdf.title = params.fetch("query_title")
  #   the_pdf.url = params.fetch("query_url")
  #   the_pdf.summary = params.fetch("query_summary")

  #   if the_pdf.valid?
  #     the_pdf.save
  #     redirect_to("/pdfs/#{the_pdf.id}", { :notice => "Pdf updated successfully."} )
  #   else
  #     redirect_to("/pdfs/#{the_pdf.id}", { :alert => the_pdf.errors.full_messages.to_sentence })
  #   end
  # end

  # def destroy
  #   the_id = params.fetch("path_id")
  #   the_pdf = Pdf.where({ :id => the_id }).at(0)
  #   the_pdf.destroy
  #   redirect_to("/pdfs", { :notice => "Pdf deleted successfully."} )
  # end
end
