import { LightningElement } from 'lwc';
import getInformationPPW from '@salesforce/apex/PPWController.getInformationPPW';

let getInformation = () => {
   return new Promise((resolve, reject) => {
     getInformationPPW()
        .then(data => resolve(data))
        .catch(error => reject(error))
   })
}


let getHeaders = (token) => {
    var myHeaders = {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      };

    return myHeaders;
}

let getCompanyPartnes = (emailsList) => {

    return new Promise(async (resolve, reject) => {
        
             try{
                let data = JSON.parse(await getInformation());

                let urlGetCompanies = data['urlGetCompanies'];
                let dadosToken = data['token'];
                dadosToken = JSON.parse(dadosToken);

                let token = dadosToken.access_token;
                if(emailsList.length > 0){
                    var myHeaders = getHeaders(token);

                    var raw = JSON.stringify(emailsList);

                    var requestOptions = {
                        method: 'POST',
                        headers: myHeaders,
                        body: raw,
                        redirect: 'follow',
                        

                    };
                
                    fetch(urlGetCompanies, requestOptions)
                    .then(response => response.text())
                    .then(result => {  
                        resolve(result);
                    })
                    .catch(error => reject(error));
                }
            }catch (error){
                    reject(error);
                
            }
    })
}
export { getCompanyPartnes }