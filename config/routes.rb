Rails.application.routes.draw do
  devise_for :users
  root to: "pdfs#index" # syntax for devise gem for user related info

  get("/new", {:controller=>"pdfs", :action=>"new_summary"})
  post("/get_summary_from_url", { :controller => "pdfs", :action => "get_summary_from_url" })
  get("/start_new_summary", { :controller => "pdfs", :action => "start_new_summary" })
  post("/save_pdf", { :controller => "pdfs", :action => "save_pdf"})
  get("/pdfs/:pdf_id", { :controller => "pdfs", :action => "destroy" })


  # Routes for the Tag resource:

  # CREATE
  # post("/insert_tag", { :controller => "tags", :action => "create" })
          
  # READ
  get("/tags", { :controller => "tags", :action => "index" })
  get("/tags/:path_id", { :controller => "tags", :action => "show" })
  
  # UPDATE
  post("/modify_tag/:path_id", { :controller => "tags", :action => "update" })
  
  # DELETE
  get("/delete_tag/:path_id", { :controller => "tags", :action => "destroy" })

  # ----------------------------
    # Routes for the Pdf tag resource:

  # CREATE
  post("/save_summary", { :controller => "pdfs", :action => "create" })
          
  # READ
  get("/pdf_tags", { :controller => "pdf_tags", :action => "index" })
  get("/pdf_tags/:path_id", { :controller => "pdf_tags", :action => "show" })
  
  # UPDATE
  post("/modify_pdf_tag/:path_id", { :controller => "pdf_tags", :action => "update" })
  
  # # DELETE
  # get("/delete_pdf_tag/:path_id", { :controller => "pdf_tags", :action => "destroy" })


  #------------------------------

  # Routes for the Pdf resource:

  # CREATE
  post("/insert_pdf", { :controller => "pdfs", :action => "create" })
          
  # READ
  get("/pdfs", { :controller => "pdfs", :action => "index" })
  
  get("/pdfs/:path_id", { :controller => "pdfs", :action => "show" })
  
  # UPDATE
  
  post("/modify_pdf/:path_id", { :controller => "pdfs", :action => "update" })
  
  # DELETE
  get("/delete_pdf/:path_id", { :controller => "pdfs", :action => "destroy" })

  #------------------------------

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # get("/", {:controller => "library", :action => "index"})
end
