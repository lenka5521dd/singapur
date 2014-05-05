is_typing_currently = false;

pusher = new Pusher("a471015e307928cc3acb")


$(document).ready ->

  parseUrl = (url) ->
    a = document.createElement("a")
    a.href = url
    a

  audio_start = () ->
    $('#audio_chat')[0].play()
    $('.messages').hover ->
      $('#audio_chat')[0].currentTime = 0
      $('#audio_chat')[0].pause()


  add_message = (data) ->
    data.new = '1'
    createMessage {id: data.id, message: {author: data.message.author, text: data.message.text}}
    alert data.message.text
    # audio_start()

  done = (data) ->
    localStorage.setItem('done', 'ok')

  review = () ->
    name = localStorage.getItem('na')
    text = localStorage.getItem('te')
    unless text is null
      r = '<div id="review" class="panel panel-danger"><div class="panel-heading">' + name + '<a id="deleteReview" class="btn btn-xs btn-danger pull-right">удалить</a></div>
            <div class="panel-body"><p>' + text + '</p></div></div>'
      $('#formReview').after $(r)

  $(window).load ->
    review()
    _on = localStorage.getItem('on')
    url = parseUrl document.URL
    if _on is null
      localStorage.setItem('on_start', url.pathname)
      console.log localStorage.getItem('on_start')
    else
      console.log localStorage.getItem('on_start')
    $.get "/dialogs/enter",
      status: 'enter',
      on: _on,
      path: document.URL,
      url: url.pathname
    , (data) ->
      localStorage.setItem('on', data.on)
      $('#send_message').attr('c', data.on)
      channel = pusher.subscribe(data.on)

      channel.bind "message_send", (data) ->
        add_message data

      channel.bind "done", (data) ->
        done data

      channel.bind "update_message", (data) ->
        update_message data


      if data.messages.length > 0
        $.each data.messages, (i, v) ->
          createMessage v


  createMessage = (data) ->
    m = '<div class="list-group-item" id="' + data.id + '">
        <b class="list-group-item-heading">' + data.message.text + '</b><br>
        <i class="list-group-item-text">' + data.message.author + '</i></div>'
    $('.list-group').prepend $(m)


  sendMessage = ->
    if $("#message").val() is ""
      alert "Пустое сообщение !"
      $("#message").focus()
      return false
    $("#message").css color: "#000000"
    message = $("#message").val()
    $("#loading").fadeIn()
    $("#message-overlay").fadeIn 200
    $("#message").blur()

    $.post "/messages",
      d: $(@).attr('c'),
      m: message,
      a: 'parya'
    , (data) ->
      $("#message").val ""
      $("#message-overlay").fadeOut 150
      $("#message").focus()
      $("#loading").fadeOut()
      is_typing_currently = false
      createMessage {id: data, message: {author: 'клиент', text: message}}

  sendEbana = ->
    name = $('#inputName').val()
    text = $('#inputText').val()
    r = '<div id="review" class="panel panel-danger"><div class="panel-heading">' + name + '<a id="deleteReview" class="btn btn-xs btn-danger pull-right">удалить</a></div>
           <div class="panel-body"><p>' + text + '</p></div></div>'
    localStorage.setItem('na', name)
    localStorage.setItem('te', text)
    $('#formReview').html $(r)
    false

  deleteReview = ->
    $('#review').html $('<h3>Отзыв удален</h3>')
    localStorage.removeItem('na')
    localStorage.removeItem('te')

  update_message = (data) ->
    $('#' + data.id + ' b').text data.text

  exitDialog = ->
    # $.get "/dialogs/exit",
    #   async: false,
    #   on: localStorage.on
    # return
    $.ajax
      type: "GET"
      async: false
      url: "/dialogs/exit"
      data:
        on: localStorage.on




  $(document).on "click", "#send_message", sendMessage
  $(document).on "click", "#sendEbana", sendEbana
  $(document).on "click", "#deleteReview", deleteReview
  # $(window).on 'beforeunload', exitDialog


  # window.onbeforeunload = (e) ->
  #   # message = "Ждем тебя еще бро, ок?"
  #   # e = e or window.event
  #   # # For IE and Firefox
  #   # e.returnValue = message  if e
  #
  #   $.get "/dialogs/exit",
  #     on: localStorage.on
  #   , (data) ->
  #     console.log data
  #     # localStorage.setItem('on', data.on)
  #   # For Safari
  #   # message
