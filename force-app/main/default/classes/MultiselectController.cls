/*
 * MultiselectController synchronizes the values of the hidden elements to the
 * SelectOption lists.
 */
global with sharing class MultiselectController {
    global SelectOption[] leftOptions { get; set; }
    global SelectOption[] rightOptions { get; set; }
    global Object targetFieldVar {get; set;}
    global String leftOptionsHidden { get; set; }
    global String rightOptionsHidden { get; set; }
}