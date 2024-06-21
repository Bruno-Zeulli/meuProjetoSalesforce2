import { ShowToastEvent } from 'lightning/platformShowToastEvent';


let showToast = (title, message, variant, scope) => {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        scope.dispatchEvent(evt);
    }

export { showToast }