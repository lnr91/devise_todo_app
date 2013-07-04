var showEmptyListsMessage = function () {

    if ($('ul.lists div').length > 1)
        $('div#lists_empty').hide();
    else
        $('div#lists_empty').show();
};




$(document).ready(function () {
    showEmptyListsMessage();
    $(document).delegate(document, "ajaxSuccess", function () {
        showEmptyListsMessage();
    });


});