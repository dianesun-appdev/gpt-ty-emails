class MessagesController < ApplicationController
  def index
    matching_messages = Message.all

    @list_of_messages = matching_messages.order({ :created_at => :desc })

    render({ :template => "messages/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_messages = Message.where({ :id => the_id })

    @the_message = matching_messages.at(0)

    render({ :template => "messages/show.html.erb" })
  end

  def create
    the_message = Message.new
    the_message.email_body = params.fetch("query_email_body")
    the_message.occasion = params.fetch("query_occasion")
    the_message.discussion_topic = params.fetch("query_discussion_topic")
    the_message.recipient_id = params.fetch("query_recipient_id")
    the_message.llm_prompt = params.fetch("query_llm_prompt")
    the_message.sender_id = params.fetch("query_sender_id")
    the_message.length = params.fetch("query_length")
    the_message.recipient_name = params.fetch("query_recipient_name")
    the_message.api_response = params.fetch("query_api_response")

    if the_message.valid?
      the_message.save
      redirect_to("/messages", { :notice => "Message created successfully." })
    else
      redirect_to("/messages", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.email_body = params.fetch("query_email_body")
    the_message.occasion = params.fetch("query_occasion")
    the_message.discussion_topic = params.fetch("query_discussion_topic")
    the_message.recipient_id = params.fetch("query_recipient_id")
    the_message.llm_prompt = params.fetch("query_llm_prompt")
    the_message.sender_id = params.fetch("query_sender_id")
    the_message.length = params.fetch("query_length")
    the_message.recipient_name = params.fetch("query_recipient_name")
    the_message.api_response = params.fetch("query_api_response")

    if the_message.valid?
      the_message.save
      redirect_to("/messages/#{the_message.id}", { :notice => "Message updated successfully." })
    else
      redirect_to("/messages/#{the_message.id}", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.destroy

    redirect_to("/messages", { :notice => "Message deleted successfully." })
  end

  #user form to input the data for ChatGPT
  def get_email_inputs
    render(template: "/messages/input_form.html.erb")
  end

  #send back the generated email
  def return_email_text
    the_message = Message.new
    the_message.sender_id = current_user.id
    the_message.occasion = params.fetch("query_occasion")
    the_message.discussion_topic = params.fetch("query_discussion_topic")
    the_message.recipient_name = params.fetch("query_recipient_name")

    the_company_name = params.fetch("query_company_name")
    the_recipient_email = params.fetch("query_email")

    if Company.where(name: the_company_name).at(0).null? #if there is no company name in DB already...
      #not really ideal, because one company can go by many names/abbreviations. Not really worth to validate for MVP though. Let's just save the data
      the_company = Company.new
      the_company.name = the_company_name
      the_company.save
    else
      the_company = Company.where(name: the_company_name).at(0) #select the active company
    end

    if Recipients.where(recipients: the_recipient_email).at(0).null? #if there is no email in DB already...
      #we make new record in DB
      the_recipient = Recipient.new
      the_recipient.company_id = the_company.name #save the company ID corresponding to company name
      the_recipient.email = params.fetch("query_email")
      the_recipient.messages_count = params.fetch("query_messages_count")
      the_recipient.save 

    else
      the_recipient = Recipient.where(email: the_recipient_email).at(0) #select the active recipient
    end

    #the_message.length = params.fetch("query_length") #not implemented yet

    #the_message.email_body = params.fetch("query_email_body")
    #the_message.recipient_id = params.fetch("query_recipient_id")
    #the_message.llm_prompt = params.fetch("query_llm_prompt")
    #the_message.api_response = params.fetch("query_api_response")

    @test = the_message

    if the_message.valid?
      the_message.save
      redirect_to("/display_email")
    else
      redirect_to("/generate_email", { :alert => the_message.errors.full_messages.to_sentence })
    end

    #save user inputs stuff in the database

    #create string to use as GPT prompt

    #save GPT response in the database OR throw error

    #create  template for email reply

    #page where you can generate another!

  end

  def display_email
    render(template: "/messages/display_email.html.erb")
  end
end
