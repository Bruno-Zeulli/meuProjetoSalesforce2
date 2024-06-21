import { LightningElement, wire } from 'lwc';
import getUserInfos from '@salesforce/apex/PlacementController.getUserInfos';
import USER_ID from '@salesforce/user/Id';


export default class PlacementGlobalHeader extends LightningElement {
    currentUserName;
    currentUserNameInitials;
    currentUserNameRole;
    connectedCallback(){
        this.getUserInfos(USER_ID);
    }
    
    getUserInfos(userId) {
        getUserInfos({
            userId: userId,
        }).then(result => {
            if (result) {
                this.currentUserName = result.Name;
                this.currentUserNameInitials = result.Initials;
                this.currentUserNameRole = result.Function;
            }
        }).catch((error) => {
            console.log(`ERROR: ==> ${error}`);
        });
    }
}
