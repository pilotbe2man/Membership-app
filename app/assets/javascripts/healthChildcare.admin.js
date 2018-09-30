healthChildcare.admin =
{
    multiSelect: function()
    {
        $('select.chosen').chosen();
    },
    
    datepickers: function()
    {
        $('.datepicker').datetimepicker({
            format: 'd/m/Y',
            timepicker: false
        });

        $('.datetimepicker').datetimepicker({
            formatDate: 'd-m-Y',
            theme:'default'
        });

        $('.datetimeformatpicker').datetimepicker({
            format:'Y-m-d  H:i',
            timepicker: true
        });

        $('.datetimepicker-date').datetimepicker({
            timepicker: false,
            format: 'Y-m-d',
            theme:'default'
        });        
    }    
}
