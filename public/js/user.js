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
  $("#btn-update").prop('disabled', true);
  $("#btn-update").text("Working...");

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
    },
    complete: function() {
      $("#btn-update").prop('disabled', false);
      $("#btn-update").text("Update All Repos");
    }
  });
}

function populateCache() {
  $("#btn-populate").prop('disabled', true);
  $("#btn-populate").text("Working...");
  
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
    },
    complete: function() {
      $("#btn-populate").prop('disabled', false);
      $("#btn-populate").text("Update Repo List");
    }
  });
}

window.onload = function() {
  populateCache();
}
