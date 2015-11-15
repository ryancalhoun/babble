(function () {

  var updateHistory = function(who, text) {
    var history = $('#history');
    history.append(who + ": " + text + "\n");
    if(history.length)
      history.scrollTop(history[0].scrollHeight - history.height());
  };

  var getSentence = function() {
    $.ajax({
      type: 'GET',
      url: '/sentence'
    }).done(function (text) {
      updateHistory("Babble", text);
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

      updateHistory("Me", text);
      sendText(text);
    }
  });  

}) ();
