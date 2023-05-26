Rails.application.routes.draw do
  # go to email generation by default
  get("/", controller: "messages", action: "get_email_inputs")

  get("/generate_email", controller: "messages", action: "get_email_inputs") #get the email inputs from the user

  post("/return_email_text", controller: "messages", action: "return_email_text") #LLM API call and return email body

  get("/display_email/:path_id", { :controller => "messages", :action => "show" }) #show one message

  get("/display_email", { :controller => "messages", :action => "index" }) #show all messages

  # ------------------------------

  # SIGN IN FORM
  get("/user_sign_in", { :controller => "user_authentication", :action => "sign_in_form" })
  # AUTHENTICATE AND STORE COOKIE
  post("/user_verify_credentials", { :controller => "user_authentication", :action => "create_cookie" })

  # SIGN OUT
  get("/user_sign_out", { :controller => "user_authentication", :action => "destroy_cookies" })

  #------------------------------

  # # Routes for the Company resource:

  # # CREATE
  # post("/insert_company", { :controller => "companies", :action => "create" })

  # # READ
  # get("/companies", { :controller => "companies", :action => "index" })

  # get("/companies/:path_id", { :controller => "companies", :action => "show" })

  # # UPDATE

  # post("/modify_company/:path_id", { :controller => "companies", :action => "update" })

  # # DELETE
  # get("/delete_company/:path_id", { :controller => "companies", :action => "destroy" })

  # #------------------------------

  # # Routes for the Recipient resource:

  # # CREATE
  # post("/insert_recipient", { :controller => "recipients", :action => "create" })

  # # READ
  # get("/recipients", { :controller => "recipients", :action => "index" })

  # get("/recipients/:path_id", { :controller => "recipients", :action => "show" })

  # # UPDATE

  # post("/modify_recipient/:path_id", { :controller => "recipients", :action => "update" })

  # # DELETE
  # get("/delete_recipient/:path_id", { :controller => "recipients", :action => "destroy" })

  #------------------------------

  # Routes for the Message resource:

  # CREATE
  post("/insert_message", { :controller => "messages", :action => "create" })

  # UPDATE

  post("/modify_message/:path_id", { :controller => "messages", :action => "update" })

  # DELETE
  get("/delete_message/:path_id", { :controller => "messages", :action => "destroy" })

  #------------------------------

  # Routes for the User account:

  # SIGN UP FORM
  get("/user_sign_up", { :controller => "user_authentication", :action => "sign_up_form" })
  # CREATE RECORD
  post("/insert_user", { :controller => "user_authentication", :action => "create" })

  # EDIT PROFILE FORM
  get("/edit_user_profile", { :controller => "user_authentication", :action => "edit_profile_form" })
  # UPDATE RECORD
  post("/modify_user", { :controller => "user_authentication", :action => "update" })

  # DELETE RECORD
  get("/cancel_user_account", { :controller => "user_authentication", :action => "destroy" })
end
