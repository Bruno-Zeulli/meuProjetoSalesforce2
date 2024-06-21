import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { getRecord } from 'lightning/uiRecordApi'; //this scoped module get the record details
import checkIfUserHasTasks from '@salesforce/apex/ConnectWizNotificationController.checkIfUserHasTasks';
import {refreshApex} from '@salesforce/apex';
import Id from '@salesforce/user/Id';
import Name from '@salesforce/schema/User.Name';
import RoleName from '@salesforce/schema/User.UserRole.Name';
import ProfileName from '@salesforce/schema/User.Profile.Name';
import ManagerName from '@salesforce/schema/User.Manager.Name';

export default class ConnectWizNavBar extends NavigationMixin(LightningElement){
    selectedItemValue;

    @track userId = Id;
    @track userName;
    @track userRoleName;
    @track userProfileName;
    @track userManagerName;
    @track initials;
    @track lstNotification;
    @track containsNotification;

    @track showNotificationsPopover = false;

    connectedCallback(){
        // checkIfUserHasTasks({}).then(result => {
        //     console.log('backend retrieve notifications' + JSON.stringify(result));
        //     this.lstNotification = result;
        //     if(this.lstNotification.length >0){
        //         this.containsNotification = true;
        //     }else{
        //         this.containsNotification = false;
        //     }

        // })
        // .catch(error =>{
        //     console.log('Deu errado retrieve' + JSON.stringify(error));
        // });
    }

    // @wire(checkIfUserHasTasks) lstNotification({error,data}){
    //     if(data){
    //         console.log('backend retrieve notifications' + JSON.stringify(data));
    //         this.lstNotification = data;
    //         if(this.lstNotification.length >0){
    //             this.containsNotification = true;
    //         }else{
    //             this.containsNotification = false;
    //         }
    //     }else if(error){
    //         console.log('Deu errado retrieve' + JSON.stringify(error));
    //     }
    // }

    showNotifications(){
        this.changeShowNotificationsPopover();
        this.connectedCallback();
    }
    changeShowNotificationsPopover(){
        this.showNotificationsPopover = !this.showNotificationsPopover;
    }

    @track showLogoutPopover = false;
    showLogoutMenu(){
        this.changeShowLogoutPopover();
    }
    changeShowLogoutPopover(){
        this.showLogoutPopover = !this.showLogoutPopover;
    }

    @wire(getRecord, { recordId: Id, fields: [Name, RoleName, ProfileName, ManagerName] })
    userDetails({ error, data }){
        if(error){
            this.error = error;
        } else if(data){
            if(data.fields.Name.value != null){
                this.userName = data.fields.Name.value;
                this.initials = data.fields.Name.value.match(/(^\S\S?|\b\S)?/g).join("").match(/(^\S|\S$)?/g).join("").toUpperCase();
            }
            if(data.fields.UserRole.value != null){
                this.userRoleName = data.fields.UserRole.value.fields.Name.value;
            }
            if(data.fields.Profile.value != null){
                this.userProfileName = data.fields.Profile.value.fields.Name.value;
            }
            if(data.fields.Manager.value != null){
                this.userManagerName = data.fields.Manager.value.fields.Name.value;
            }
        }
    }


    handleOnselect(event){
        this.selectedItemValue = event.detail.value;
    }

    removeTaskHandler(event){
        let taskId = event.detail.taskId;
        console.log('Entrou no remove task' + taskId);
        for(let objTask of this.lstNotification){
            if(objTask.taskId == taskId){
                console.log('Entrou no remove task');
                const index = this.lstNotification.indexOf(objTask);
                this.lstNotification.splice(index,1);
                break;
            }
        }
    }
}