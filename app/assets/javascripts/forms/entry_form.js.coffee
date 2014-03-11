class @EntryForm

  constructor: (@form, @locale) ->
    @initDatepicker()

  initDatepicker: ->
    configuration_en = {
      formatSubmit: 'dd/mm/yyyy',
      today: false,
      clear: false
    }
    configuration_cs = {
      formatSubmit: 'dd/mm/yyyy',
      today: false,
      clear: false,
      monthsFull: [ 'leden', 'únor', 'březen', 'duben', 'květen', 'červen', 'červenec', 'srpen', 'září', 'říjen', 'listopad', 'prosinec' ],
      monthsShort: [ 'led', 'úno', 'bře', 'dub', 'kvě', 'čer', 'čvc', 'srp', 'zář', 'říj', 'lis', 'pro' ],
      weekdaysFull: [ 'neděle', 'pondělí', 'úterý', 'středa', 'čtvrtek', 'pátek', 'sobota' ],
      weekdaysShort: [ 'ne', 'po', 'út', 'st', 'čt', 'pá', 'so' ]
    }

    if @locale == "cs"
      configuration = configuration_cs
    else
      configuration = configuration_en

    picker = @form.find('.datepicker').pickadate(configuration).pickadate('picker')
    $(picker._hidden).attr('name', 'entry_form[date]').attr('id', 'entry_form_date')
