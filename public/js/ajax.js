function forceUpdateCache() {
  $.ajax({
    type: 'post',
    url: window.location.pathname + '/update',
    timeout: 0,
    error: function(jqXHR, textStatus, errorThrown) {
      console.log("Error:");
      console.log(jqXHR.responseText);
      console.log(textStatus);
      console.log(errorThrown);
    },
    success: function(result) {
      location.reload();
    }
  });
}
