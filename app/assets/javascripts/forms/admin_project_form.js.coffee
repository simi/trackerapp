class @AdminProjectForm

  constructor: (@form) ->
    initTokenInput()

  @initTokenInput: ->
    input = @form.find("#project_user_tokens")
    configuration = {
      crossDomain: false,
      prePopulate: input.data("pre"),
      theme: "facebook",
      minChars: 0
    }
    input.tokenInput("/admin/users.json", configuration)
