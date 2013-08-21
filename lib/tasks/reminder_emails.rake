desc "Send reminder emails to all users who want 'em, at 7pm daily."

task :send_reminders => :environment do  
    require 'pony'
    f = File.new('/Users/jon/Sites/mail_pass.txt')
    pass= f.gets
    count = 0
    User.all.each do |user|
      count = count +1
      if count % 50 == 0
        puts "****** Sleeping for a minute...zzzzzzzzzzzz******"
        sleep 60 #sleep for 60 seconds after every 50 emails sent
        puts"******* Done sleeping! Let's get to it! **********"
      end
      if(!user.reminder_freq.nil? && !user.reminder_freq[Date.today.strftime("%a")].nil?)
        Pony.mail(:from => 'teamdietumd@gmail.com', :to => user.email, :subject => 'Here\'s your reminder email from the Diet Tracker!', 
                :html_body => "<p>Dear #{user.name}</p> <p>As you requested, here's an email reminding you to update your meals on the <a href='http://diettracker.umd.edu'> Diet Tracker</a>!</p> <p> You can change your email options at any time by going to <a href='http://diettracker.umd.edu/users/#{user.id}/edit'> your profile page</a>. </p><p>Sincerely,</br>Team DIET</br><a href='mailto:teamdietumd@gmail.com'>teamdietumd@gmail.com</a></p> <p>Please feel free to contact us with any questions, comments, or suggestions.</p>",
                :body => "Dear #{user.name},

                As you requested, here's an email reminding you to update your meals on the Diet Tracker: http://diettracker.umd.edu 
                            
                You can change your email options at any time by going to http://diettracker.umd.edu/users/#{user.id}/edit

                Sincerely, 
                Team DIET
                teamdietumd@gmail.com
                                                              
                Please feel free to contact us with any questions, comments, or suggestions." ,:via => :smtp, :via_options => {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => 'teamdietumd@gmail.com',
          :password             => pass,
          :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
          :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
        })
        puts "Sent mail to User #{user.id}, name: #{user.name}, email: #{user.email}"
      end
  end
end