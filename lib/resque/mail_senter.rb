class MailSenter
		@queue = :mail_senter
			class << self
			  def perform(mail_address,vmail_id)
			  	  mail_address.each do |address|
			  	  	begin
			  	  		  VdaxueMailer.common_email(address,vmail_id).deliver!
			  	  	rescue Exception => e
			  	  		 logger.info "send email=>(#{address}) error."
			  	  	end
			  	  	 
			  	  end
			  end
	   end
end
