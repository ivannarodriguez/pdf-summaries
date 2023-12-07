require 'pdf-reader'
require 'open-uri'
require 'openai'

class PdfsController < ApplicationController
  before_action :authenticate_user!

  def index
    matching_pdfs = Pdf.includes(:tags).where({ :saved => true, :user_id => current_user.id})
    @list_of_pdfs = matching_pdfs.order({ :created_at => :desc })
    render({ :template => "pdfs/index" })
  end


  def new_summary
    @list_of_tags = current_user.tags
    @pdf_url = session[:pdf_url]
    @pdf_id = session.fetch(:pdf_id, nil) # at the start when /new gets rendered, pdf_id doesnt exist
    if @pdf_id.present?
      the_pdf = Pdf.where({ :id => @pdf_id })[0]
      @text_summary = the_pdf.summary if the_pdf.present?
    end
    render({:template => "pdfs/new_summary"})
  end


  def get_summary_from_url
    # delete all pdfs that don't need to be saved
    current_user.pdfs.where({ saved: false }).destroy_all

    @pdf_url = params[:pdf_url]
    session[:pdf_url] = @pdf_url # store url in session to be able to retrieve it in save_pdf action
    
    # parse pdf from url
    if @pdf_url.present?
      begin
        io = URI.open(@pdf_url)
        reader = PDF::Reader.new(io)
        text_content = reader.pages.map(&:text).join("\n")
        text_content = text_content.gsub(/\s+/, ' ')

        message = '''Please concisely summarize the text i will be giving you, in at most two short paragraphs. the text
                    you are receiving is parsed from a PDF that is likely a research paper. As such, your
                    brief summary should include: the main idea of the PDF, the research question, the main
                    findings, and a brief sentence of the methodology. make this summary as concise as possible.
                    here is the text: ''' + text_content

        # check if parsed text is Nil and throw an alert
        if text_content.blank?
          redirect_to("/new", {:alert => "Unable to parse PDF"})
        end

        # initialize openai client
        client = OpenAI::Client.new
        response = client.chat(
            parameters: {
                model: "gpt-3.5-turbo", # Required.
                messages: [{ role: "user", content: message}], # Required.
                temperature: 0.7,
            })

        text_summary = response["choices"][0]["message"]["content"]
        text_summary = text_summary.sub(/\A\s*/, '') # remove indentation

        # create new pdf belonging to current user
        the_pdf = current_user.pdfs.new
        the_pdf.url = @pdf_url
        the_pdf.parsed_text = text_content
        the_pdf.summary = text_summary
        the_pdf.save
      
        if the_pdf.save
          session.store(:pdf_id, the_pdf.id)
          redirect_to("/new")
        else
          # log the full error messages
          Rails.logger.info(the_pdf.errors.full_messages)
          redirect_to("/new", {:alert => "Failed to save PDF. Please try again."})
        end

      rescue StandardError => e
        # suggested by chatgpt
        Rails.logger.error("PDF Processing Error: #{e.message}")
        redirect_to("/new", {:alert => "Error processing PDF: #{e.message}"})
      end
    else
      # if no URL is provided, redirect back with a message
      redirect_to("/new", {:alert => "Please provide a valid PDF URL."})
    end
  end

  def start_new_summary
    # reset the session so these are removed and aren't displayed on html
    session.store(:pdf_url, nil)
    session.store(:text_summary, nil)
    redirect_to("/new")
  end


  def save_pdf
    the_pdf = Pdf.where(:id => params[:pdf_id])[0]
    
    if the_pdf.nil?
      redirect_to("/new", {:alert => "PDF not found."})      
    end

    # update pdf attributes
    the_pdf.title = params[:pdf_title]

    if params[:tag_name] == 'enterNew'
      tag_name_input = params[:new_tag_name]
    else
      tag_name_input = params[:tag_name]
    end

    tag_color_input = params[:tag_color]

    matching_tags = Tag.where({ :name => tag_name_input, :user_id => current_user.id })
    if matching_tags.any? # check if tag already present
      the_tag = matching_tags[0]
    else
      the_tag = current_user.tags.new
      the_tag.name = tag_name_input
    end

    the_tag.color = tag_color_input
    the_tag.save

    new_pdf_tag = PdfTag.new
    new_pdf_tag.pdf_id = the_pdf.id
    new_pdf_tag.tag_id = the_tag.id
    new_pdf_tag.save!

    # change pdf saved attribute to true
    the_pdf.saved = true
    the_pdf.save!

    redirect_to("/", {:notice => "PDF updated successfully."})
  end

  def destroy
    the_id = params[:pdf_id]
    the_pdf = Pdf.where({ :id => the_id })[0]

    # destroy any tags that are no longer associated with a pdf
    the_pdf_tags = the_pdf.tags.to_a

    the_pdf.destroy

    the_pdf_tags.each do |a_tag|
      tag = Tag.where({:id => a_tag.id})[0]
      if tag.present? && tag.pdfs.empty?
        tag.destroy
      end
    end

    redirect_to("/", {:notice => "Summary deleted successfully."})
  end

end  
