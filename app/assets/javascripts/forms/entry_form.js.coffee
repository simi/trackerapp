class @EntryForm

  constructor: (@form) ->
    @initDatepicker()

  initDatepicker: ->
    configuration = {
      formatSubmit: 'dd/mm/yyyy'
    }
    picker = @form.find('.datepicker').pickadate(configuration).pickadate('picker')
    $(picker._hidden).attr('name', 'entry[date]').attr('id', 'entry_id')
