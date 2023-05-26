class MessagesController < ApplicationController
  def index
    matching_messages = Message.all

    @list_of_messages = matching_messages.order({ :created_at => :desc })

    render({ :template => "messages/index.html.erb" })
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
    alerts = [] #set this up

    the_company_name = params.fetch("query_company_name")

    if Company.where(name: the_company_name).at(0).nil? #if there is no company name in DB already...
      #not really ideal, because one company can go by many names/abbreviations. Not really worth to validate for MVP though. Let's just save the data
      the_company = Company.new
      the_company.name = the_company_name
      if the_company.valid?
        the_company.save
        #want to add alerts and stuff here later
      else
        alerts << "Company name can't be blank"
      end
    else
      the_company = Company.where(name: the_company_name).at(0) #select the active company
    end

    the_recipient_email = params.fetch("query_email")

    if Recipient.where(email: the_recipient_email).at(0).nil? #if there is no email in DB already...
      #we make new record in DB
      the_recipient = Recipient.new
      the_recipient.company_id = the_company.id #save the company ID corresponding to company name
      the_recipient.email = params.fetch("query_email").squish
      if the_recipient.valid?
        the_recipient.save
        #want to add alerts and stuff here later
      else
        alerts << "Recipient email can't be blank"
      end
    else
      the_recipient = Recipient.where(email: the_recipient_email).at(0) #select the active recipient
    end

    the_message = Message.new
    the_message.sender_id = current_user.id
    the_message.occasion = params.fetch("query_occasion")
    the_message.discussion_topic = params.fetch("query_discussion_topic")
    the_message.recipient_name = params.fetch("query_recipient_name")
    the_message.recipient_id = the_recipient.id

    #the_message.length = params.fetch("query_length") #not implemented yet
    #the_message.llm_prompt = params.fetch("query_llm_prompt")
    #the_message.api_response = params.fetch("query_api_response")

    the_message.llm_prompt = "You're MBA student recruiting for #{current_user.default_industry}. Write succinct & not overly sentimental thank-you email to an employee after an interaction Start with Hi, [person name], end with Best, [my name]. Plain subject line. Format as Subject:[TEXT] Body:[TEXT]. use &nbsp; for breaks.
    Your Name: #{current_user.first_name}
    Employee's Name: #{the_message.recipient_name}
    Company: #{the_company.name}
    Context: #{the_message.occasion}
    What to mention from the interaction: #{the_message.discussion_topic}
    Additionally: #{params["query_additional_instructions"]}"

    if params["query_emulate_style"] == "true" #its not a boolean :T
      the_message.llm_prompt << "Emulate this writing style: #{current_user.writing_sample}"
    end

    #### Call upon CHATGPT ####

    client = OpenAI::Client.new(access_token: "#{ENV.fetch("CHATGPT_KEY")}")

    response = client.chat(
      parameters: {
        model: "gpt-4", # Required.
        messages: [{ role: "user", content: "#{the_message.llm_prompt}" }], # Required.
        temperature: 0.7,
      },
    )
    the_message.api_response = response
    the_message.email_body = response.dig("choices", 0, "message", "content")

    #### #### ####

    if !the_message.valid? #if message is not valid, exit
      alerts << the_message.errors.full_messages.to_sentence
      redirect_to("/generate_email", :alert => alerts)
    else
      the_message.save
      redirect_to("/display_email/#{the_message.id}", notice: "Email successfully generated.")
    end
  end

  def show
    the_id = params.fetch("path_id")

    matching_messages = Message.where({ :id => the_id })

    @the_message = matching_messages.at(0)

    #This should have been different 2 fields in the database model, oops!!!

    @email_subject
    @email_body

    render({ :template => "messages/show.html.erb" })
  end
end
