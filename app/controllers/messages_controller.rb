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

    if the_message.valid?
      the_message.save
      redirect_to("/messages/#{the_message.id}", { :notice => "Message updated successfully."} )
    else
      redirect_to("/messages/#{the_message.id}", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.destroy

    redirect_to("/messages", { :notice => "Message deleted successfully."} )
  end
end
