Rails.application.routes.draw do
  devise_for :users
  root to: "pdfs#index" # syntax for devise gem for user related info

  get("/new", {:controller=>"pdfs", :action=>"new_summary"})
  post("/get_summary_from_url", { :controller => "pdfs", :action => "get_summary_from_url" })
  get("/start_new_summary", { :controller => "pdfs", :action => "start_new_summary" })
  post("/save_pdf", { :controller => "pdfs", :action => "save_pdf"})
  get("/delete_pdfs/:pdf_id", { :controller => "pdfs", :action => "destroy" })

end
