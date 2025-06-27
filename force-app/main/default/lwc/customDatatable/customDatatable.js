/*
 * @File Name          : customDatatable.js
 * @Description        : Common JS for all custom data type HTML templates, Contains 
 *                       logic to define custom data type and link with html template.
 * @Author             : Akshay Poddar
 * @Last Modified On   : 29/6/2020, 8:02:44 pm
**/
import LightningDatatable from 'lightning/datatable';
import richtextTemplate from './richtextTemplate.html';

//import richTextColumnTemplate from './richTextColumnTemplate.html';
//import iconColumnTemplate from './iconColumnTemplate.html';

export default class CustomDatatable extends LightningDatatable {
    static customTypes = {
        
        base64 : {
            template: richtextTemplate,
            standardCellLayout: true,
            typeAttributes: ['label','value'],
            
        },
        
    };
}