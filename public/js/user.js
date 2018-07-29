function fillTable(entries) {
  console.log(entries);
}

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
      fillTable(result);
    }
  });
}

function populateCache() {
  $.ajax({
    type: 'post',
    url: window.location.pathname + '/populate',
    timeout: 0,
    error: function(jqXHR, textStatus, errorThrown) {
      console.log("Error:");
      console.log(jqXHR.responseText);
      console.log(textStatus);
      console.log(errorThrown);
    },
    success: function(result) {
      fillTable(result);
    }
  });
}
