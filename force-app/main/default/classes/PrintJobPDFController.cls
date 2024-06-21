public without sharing class PrintJobPDFController {

    public String formId;
    public List<ConnectWizQuotationFormsTO.Shareholder>  lstShareHolder {get; set;}
    public List<ConnectWizQuotationFormsTO.InsuranceInformation> lstInsuranceInformation {get; set;}
    public List<ConnectWizQuotationFormsTO.ControlledCompany> lstControlledCompany {get; set;}
    public List<ConnectWizQuotationFormsTO.CurrentPlan> lstCurrentPlan {get; set;}

    public Boolean containsControlledCompany {get; set;}
    public Boolean containsInsuranceInformation {get; set;}
    public Boolean containsShareHolder {get; set;}
    public Boolean containsCurrentPlan {get; set;}

    public ConnectWizQuotationFormsTO.QuotationForms objQuotationFormsTO {get; set;}
    public PrintJobPDFController(){
        this.formId = ApexPages.currentPage().getParameters().get('formId');
        System.debug('Pegou' + this.formId);
        this.lstShareHolder = new List<ConnectWizQuotationFormsTO.Shareholder>();
        this.lstInsuranceInformation = new List<ConnectWizQuotationFormsTO.InsuranceInformation>();
        this.lstControlledCompany = new List<ConnectWizQuotationFormsTO.ControlledCompany>();
        this.lstCurrentPlan = new List<ConnectWizQuotationFormsTO.CurrentPlan>();

        this.objQuotationFormsTO = (ConnectWizQuotationFormsTO.QuotationForms)JSON.deserialize(ConnectWizQuotationFormsController.getQuotationFormsById(formId), ConnectWizQuotationFormsTO.QuotationForms.class);
        for(ConnectWizQuotationFormsTO.Shareholder objShareHolder : objQuotationFormsTO.Shareholders){
            lstShareHolder.add(objShareHolder);
        }
        for(ConnectWizQuotationFormsTO.ControlledCompany objControlledCompany : objQuotationFormsTO.ControlledCompanies){
            lstControlledCompany.add(objControlledCompany);
        }
        for(ConnectWizQuotationFormsTO.InsuranceInformation objInsuranceInformation : objQuotationFormsTO.InsuranceInformations){
            lstInsuranceInformation.add(objInsuranceInformation);
            for(ConnectWizQuotationFormsTO.CurrentPlan objCurrrentPlan : objInsuranceInformation.CurrentPlans){
                lstCurrentPlan.add(objCurrrentPlan);
            }
        }

        if(lstInsuranceInformation.isEmpty()){
            this.containsInsuranceInformation = false;
        }else{
            this.containsInsuranceInformation = true;
        }

        if(lstControlledCompany.isEmpty()){
            this.containsControlledCompany = false;
        }else{
            this.containsControlledCompany = true;
        }
        if(lstShareHolder.isEmpty()){
            this.containsShareHolder = false;
        }else{
            this.containsShareHolder = true;
        }
        if(lstCurrentPlan.isEmpty()){
            this.containsCurrentPlan = false;
        }else{
            this.containsCurrentPlan = true;
        }
        System.debug('FormTO' + JSON.serializePretty(lstShareHolder));
   } 
}