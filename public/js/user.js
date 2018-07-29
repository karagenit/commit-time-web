function formatTime(minutes) {
  return Math.floor(minutes / 60) + " Hours, " + Math.round(minutes % 60) + " Minutes";
}

function fillTable(entries) {
  $("#tbody").empty();
  entries.forEach(function(entry) {
    $("#tbody").append("<tr><td>" + entry.name + "</td><td>" +
                        formatTime(entry.times) + "</td></tr>");
  });
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
      fillTable(JSON.parse(result));
    }
  });
} // TODO: disable/change text of buttons

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
      fillTable(JSON.parse(result));
    }
  });
}

window.onload = function() {
  populateCache();
}
