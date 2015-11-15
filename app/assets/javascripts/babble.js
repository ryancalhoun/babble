(function () {

  var enableMessageBox = function() {
    var entry = $('#entry');
    entry.prop('disabled', false);
    entry.focus();
  };
  var disableMessageBox = function() {
    var entry = $('#entry');
    entry.prop('disabled', true);
  };

  var updateHistory = function(type, text) {
    var elem = $($('#' + type).html());
    elem.text(text);

    var history = $('#history');
    history.append(elem);

    if(history.length)
      history.scrollTop(history[0].scrollHeight - history.height());
  };

  var getSentence = function() {
    $.ajax({
      type: 'GET',
      url: '/sentence'
    }).done(function (text) {
      updateHistory("reply", text);
      enableMessageBox();
    });
  };

  var sendText = function(text) {
    $.ajax({
      type: 'POST',
      url: '/sentence',
      data: {text: text}
    }).done(function() {
      getSentence();
    });
  };

  getSentence();

  $('#entry').keyup(function(e) {
    if(e.keyCode == 13)
    {
      var text = $(this).val();
      $(this).val('');

      updateHistory("message", text);
      disableMessageBox();
      sendText(text);
    }
  });

}) ();
