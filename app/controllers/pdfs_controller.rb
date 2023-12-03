require 'pdf-reader'
require 'open-uri'

class PdfsController < ApplicationController
  before_action :authenticate_user!

  def index
    matching_pdfs = Pdf.where({ :saved => true })
    @list_of_pdfs = matching_pdfs.order({ :created_at => :desc })
    # @pdf_tags = PDF.tag.where({})
    render({ :template => "pdfs/index" })
  end

  def new_summary
    @list_of_tags = current_user.tags
    @pdf_url = session[:pdf_url]
    @pdf_id = session.fetch(:pdf_id, nil)
    if @pdf_id.present?
      the_pdf = Pdf.where({ :id => @pdf_id }).at(0)
      @extracted_text = the_pdf.parsed_text if the_pdf.present?
    end
    render({:template => "pdfs/new_summary"})
  end

  def create_summary
    @pdf_url = params[:pdf_url]
    session[:pdf_url] = @pdf_url
  
    if @pdf_url.present?
      begin
        io = URI.open(@pdf_url)
        reader = PDF::Reader.new(io)
        text_content = reader.pages.map(&:text).join("\n")
        
        the_pdf = current_user.pdfs.new
        the_pdf.url = @pdf_url
        the_pdf.parsed_text = text_content

        if the_pdf.save
          session[:pdf_id] = the_pdf.id
          redirect_to("/new")
        else
          # if save fails, log errors and redirect with an error message
          Rails.logger.info("PDF Save Error: #{the_pdf.errors.full_messages.join(', ')}")
          redirect_to("/new", alert: "Failed to save PDF. Please try again.")
        end

      rescue StandardError => e
        # if any other error occurs, log it and redirect with an error message
        Rails.logger.error("PDF Processing Error: #{e.message}")
        redirect_to("/new", alert: "Error processing PDF: #{e.message}")
      end
    else
      # if no URL is provided, redirect back with a message
      redirect_to("/new", alert: "Please provide a valid PDF URL.")
    end
  end

  def start_new_summary
    session.store(:pdf_url, nil)
    session.store(:extracted_text, nil)
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
