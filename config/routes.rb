Rails.application.routes.draw do
  root to: "pdfs#index" # syntax for devise gem for user related info

  # Routes for the Tag resource:

  # CREATE
  post("/insert_tag", { :controller => "tags", :action => "create" })
          
  # READ
  get("/tags", { :controller => "tags", :action => "index" })
  
  get("/tags/:path_id", { :controller => "tags", :action => "show" })
  
  # UPDATE
  
  post("/modify_tag/:path_id", { :controller => "tags", :action => "update" })
  
  # DELETE
  get("/delete_tag/:path_id", { :controller => "tags", :action => "destroy" })

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

  get("/", {:controller => "library", :action => "index"})
end
