class @EntryForm

  constructor: (@form) ->
    @initDatepicker()

  initDatepicker: ->
    configuration = {
      showButtonPanel: true,
      dateFormat: 'dd/mm/yy'
    }
    @form.find('.datepicker').datepicker(configuration)
