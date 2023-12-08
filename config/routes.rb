Rails.application.routes.draw do
  devise_for :users
  root to: "pdfs#index" # syntax for devise gem for user related info

  get("/new", {:controller=>"pdfs", :action=>"new_summary"})
  post("/get_summary_from_url", { :controller => "pdfs", :action => "get_summary_from_url" })
  get("/start_new_summary", { :controller => "pdfs", :action => "start_new_summary" })
  post("/save_pdf", { :controller => "pdfs", :action => "save_pdf"})
  get("/delete_pdf/:pdf_id", { :controller => "pdfs", :action => "destroy" })
  get("/edit/:pdf_id", { :controller => "pdfs", :action => "show_update_page" })
  post("/update_pdf/:pdf_id", { :controller => "pdfs", :action => "update" })
end
