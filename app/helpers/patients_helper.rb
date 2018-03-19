module PatientsHelper
    
    def patient_placeholder_text
        "Search patients by name, address, date of birth, or phone number"
    end
    
    def patient_sort
        url = request.original_url
        url_end = url[url.index("/patients")..-1]
        case url_end
            when "/patients?name=asc"
                return "az_patients"
            when "/patients?name=desc"
                return "za_patients"
            when "/patients?insured=true"
                return "insured"
            when "/patients?insured=false"
                return "uninsured"
            else
                if url.include?("month")
                    return "mob"
                else
                    return "all"
                end
        end
    end
    
    def current_patient
        id = params[:id]
        begin
            return Patient.find(id)
        rescue
            nil
        end
    end
    
    def name_placeholder
        current_patient.nil? ? ' ': current_patient.name
    end
    
    def phone_placeholder
        current_patient.nil? ? ' ': current_patient.phone
    end
    
    def address_placeholder
        current_patient.nil? ? ' ': current_patient.address
    end
    
    def instructions_placeholder
        current_patient.nil? ? ' ': current_patient.delivery_instructions
    end
    
    def patient_deliveries
        @id = params[:id]
    end
    
    def patients
        @pharma = current_pharmacy
        @patients = Patient.where(pharmacy_id: @pharma.id).all
        return @patients
    end
    
    def month(patients)
        url = request.original_url
        months = ['placeholder', 'january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december']
        month = url[(url.index("=") + 1)..-1]
        @patients = patients.select do |patient|
            if patient.dob
                month == months[patient.dob[0..1].to_i]
            end
        end
        return @patients
    end
    
    def asc_name
        @patients = Patient.where(pharmacy_id: current_pharmacy.id).order("name ASC").all
        return @patients
    end
    
    def desc_name
        @patients = Patient.where(pharmacy_id: current_pharmacy.id).order("name DESC").all
        return @patients
    end
    
    def find_driver(id)
        @request = Request.find_by(batch_id: id)
        if @request
            @driver = Driver.find_by(number: @request.driver)
            return @driver
        else
            'n/a'
        end
    end
    
    def submit_text
        begin
            @patient = Patient.find(params[:id])
        rescue
            return 'Register Patient'
        end
        if @patient
            'Update Patient Info'
        else
            'Register Patient'
        end
    end
    
end
