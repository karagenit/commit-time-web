var intervalUpdate;

function startUpdate() {
  intervalUpdate = setInterval(function() {
    $.ajax({
      type: 'post',
      url: window.location.pathname + '/read',
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
  }, 3000);
}

function stopUpdate() {
  clearInterval(intervalUpdate);
}

function formatTime(minutes) {
  if (minutes >= 60) {
    return Math.floor(minutes / 60) + " Hours, " + Math.round(minutes % 60) + " Minutes";
  } else {
    return Math.round(minutes) + " Minutes";
  }
}

function fillTable(entries) {
  entries.sort(function(a,b) {
    return b.total - a.total;
  });
  $("#tbody").empty();
  entries.forEach(function(entry, index) {
    if (entry.total > 0) {
      $("#tbody").append("<tr><th>" + 
        (index+1) + "</th><td>" +
        entry.name + "</td><td>" +
        formatTime(entry.total) + "</td><td>" +
        entry.commits + "</td><td>" +
        formatTime(entry.average) + "</td></tr>");
    }
  });
}

function forceUpdateCache() {
  $("#btn-update").prop('disabled', true);
  $("#btn-update").text("Working...");

  $.ajax({
    type: 'post',
    url: window.location.pathname + '/forceupdate',
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

function updateCache() {
  startUpdate();
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
      stopUpdate();
    }
  });
}

window.onload = function() {
  updateCache();
}
