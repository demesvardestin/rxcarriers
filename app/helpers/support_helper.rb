module SupportHelper
    
    def issue(chosen_issue = nil)
        s = ''
        issues = ['Issue Type', 'Batch', 'Request', 'Patient', 'Billing', 'Password']
        issues.each do |i|
            s << "<option value='#{issues.index(i)}' #{'selected' unless i != chosen_issue}>#{i}</option>"
        end
        s.html_safe
    end
    
    def url
       current_url = request.original_url 
    end
    
end
