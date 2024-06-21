import LightningDatatable from "lightning/datatable";
import percentFixedTemplate from "./percentFixed.html";
import percentFixedEditTemplate from "./percentFixedEdit.html";
import custonButtonIconTemplate from "./custonButtonIcon.html";
import textWithButton from "./textWithButtonType.html";
import badgeWithIcon from "./badgeWithIconType.html";

export default class ExtendedDataTable extends LightningDatatable {
    static customTypes = {
        percentFixed : {
            template : percentFixedTemplate,
            editTemplate : percentFixedEditTemplate,
            standardCellLayout: true,
        },
        custonButtonIcon: {
            template: custonButtonIconTemplate,
            standardCellLayout: true,
            
        },
        textWithButtonType: {
            template: textWithButton,
            typeAttributes: ['value', 'recordId', 'opportunityId']
        },
        badgeWithIconType: {
            template: badgeWithIcon,
            typeAttributes: ['value']
        }
    }

    handleButtonClick() {
        // Dispara um evento personalizado
        this.dispatchEvent(new CustomEvent('buttonclick'));
    }

}