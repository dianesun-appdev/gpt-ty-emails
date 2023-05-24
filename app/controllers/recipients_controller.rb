class RecipientsController < ApplicationController
  def index
    matching_recipients = Recipient.all

    @list_of_recipients = matching_recipients.order({ :created_at => :desc })

    render({ :template => "recipients/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_recipients = Recipient.where({ :id => the_id })

    @the_recipient = matching_recipients.at(0)

    render({ :template => "recipients/show.html.erb" })
  end

  def create
    the_recipient = Recipient.new
    the_recipient.company_id = params.fetch("query_company_id")
    the_recipient.email = params.fetch("query_email")
    the_recipient.messages_count = params.fetch("query_messages_count")

    if the_recipient.valid?
      the_recipient.save
      redirect_to("/recipients", { :notice => "Recipient created successfully." })
    else
      redirect_to("/recipients", { :alert => the_recipient.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_recipient = Recipient.where({ :id => the_id }).at(0)

    the_recipient.company_id = params.fetch("query_company_id")
    the_recipient.email = params.fetch("query_email")
    the_recipient.messages_count = params.fetch("query_messages_count")

    if the_recipient.valid?
      the_recipient.save
      redirect_to("/recipients/#{the_recipient.id}", { :notice => "Recipient updated successfully."} )
    else
      redirect_to("/recipients/#{the_recipient.id}", { :alert => the_recipient.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_recipient = Recipient.where({ :id => the_id }).at(0)

    the_recipient.destroy

    redirect_to("/recipients", { :notice => "Recipient deleted successfully."} )
  end
end
