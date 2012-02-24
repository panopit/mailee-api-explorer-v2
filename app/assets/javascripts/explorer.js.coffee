app = $.sammy ->
  this.get '#/get/:api_key', ->
    $('#api_key').val(this.params.api_key)
    return api_key_error() unless valid_api_key()
    api_key_success()

  this.get '#/get', ->
    $('#api_key').val(this.params.api_key)
    return api_key_error() unless valid_api_key()
    api_key_success()
    code = $('<pre class="prettyprint lang-js" />').html('<img src="/assets/ajax-loader.gif" />')
    $('#result').html('').append( code )
    return_url = 'explorer/return?'+$.param(this.params.toHash())
    this.render(return_url).replace(code).then(prettyPrint)
    $('#resources-row, #actions-row, #forms-row').show()
    $('a[href="#'+this.params.resource+'"]').click()
    $('a[href="#'+this.params.resource+'-'+this.params.aktion+'"]').click()
    # $('input[name="id"]').val( this.params.id )
  true

valid_api_key = ->
  api_key().match( /^[a-z0-9]{13}$/ )

api_key_error = ->
  console.log('err')
  $('#api_key').parents('.clearfix').addClass('error').removeClass('success')
  $('#resources-row, #actions-row, #forms-row').hide()

api_key_success = ->
  console.log('succ')
  $('#api_key').parents('.clearfix').addClass('success').removeClass('error')
  # Make all api_key fields in all forms get the api_key value
  $('.api_key').val(api_key())
  $('#resources-row').show()

api_key = ->
  $('#api_key').val()

$ ->
  app.run()
  $('#api_key').change ->
    if valid_api_key()
      api_key_success()
      $('a[href="#root"]').click()
      $('a[href="#root-valid_key"]').click()

    else
      api_key_error()

  $('#api_key').keyup ->
    api_key_success() if valid_api_key()

  $('#resources-row a').click ->
    $('#actions-row').show()

  $('#actions-row').click ->
    $('#forms-row').show()

  $('input, textarea').focus ->
    $(this).prev('.add-on').addClass('active')

  $('input, textarea').blur ->
    $(this).prev('.add-on').removeClass('active')

  $('a[href="#more"]').click ->
    $(this).hide().next('.more').show()