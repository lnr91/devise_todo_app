
// jquery code for lists/show.html.erb page....which shows tasks for a spcfic list...and also a form to add a new task
jQuery.fn.submitOnCheck= function()
{
    $(this).find('input[type=submit]').remove();
    $(this).find('input[type=checkbox]').click(function() {
        $(this).closest('form').submit();
    });
    return $(this);        // why should I return this ? ...and why has ryan bates used "this" instead of $(this) ?
}



var showEmptyTasksMessage= function(){
    console.log($('#incomplete_tasks form').length);
    if($('#incomplete_tasks form').length > 0)      // If the nmbr of unfinished tasks becomes zero , we show a message...else we hide the message
        $('#tasks_empty').hide();
    else
        $('#tasks_empty').show();
};


$(function () {             /*This is same as $(document).ready()...also something to do with not conflicting with $ objects of other frameworks...dunno what that means ...should cjheck it out*/

    $('.edit_task').submitOnCheck();
    showEmptyTasksMessage();
    $(document).delegate(document,"ajaxSuccess",function(){
        showEmptyTasksMessage();
        $('.edit_task').submitOnCheck();      // we do this again because...somehow the newly added element is not being bound to the click action....

    });

});