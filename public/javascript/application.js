$(document).ready(function() {
  learningStyles()
});

function learningStyles() {
  $("#stylesResults").hide()
  $("#successInfo").hide()
  $("#saveResultMsg").hide()

  $("#calculateStyleBtn").click(function() {
    colEc = calcStyleColumn("ec")
    colOr = calcStyleColumn("or")
    colCa = calcStyleColumn("ca")
    colEa = calcStyleColumn("ea")

    // Update col result values
    $("#ec-result").text(colEc)
    $("#or-result").text(colOr)
    $("#ca-result").text(colCa)
    $("#ea-result").text(colEa)

    // Get and show learning style from server
    getLearningStyle(colEc, colOr, colCa, colEa)

    // Show computing message
    $("#stylesResults").show()
  });

  $("#saveResultsBtn").click(function() {
    saveResults($("#campus").val(), colEc, colOr, colCa, colEa, $("#styleResult").text())
  });
}

function calcStyleColumn (colName) {
  args = {};
  switch(colName) {
    case "ec":
      args = { colName: colName, subCols: [1,2,3,4,6,7] }
      break;

    case "or":
      args = { colName: colName, subCols: [0,2,5,6,7,8] }
      break;

    case "ca":
      args = { colName: colName, subCols: [1,2,3,4,7,8] }
      break;

    case "ea":
      args = { colName: colName, subCols: [0,2,5,6,7,8] }
      break;
  }

  return parseColumnValue(args.colName, args.subCols);
}

function parseColumnValue(colName, subCols) {
  sum = 0
  for (i = 0; i < subCols.length; i++) {
      sum += parseValue(colName, subCols[i]);
  }
  return sum
}

function parseValue(colName, subCol) {
  return parseInt($("#" + colName + "-" + subCol).val())
}

function getLearningStyle(ec, or, ca, ea) {
  $.post("/styles/compute.json", { ec: ec, or: or, ca: ca, ea: ea })
    .done(function(data) {
      $("#computingMessage").hide()

      // Scroll and show result
      $("#successInfo").show()
      $("html, body").animate({scrollTop: $('#successInfo').offset().top}, "slow");
      $("#styleResult").text(data.style)
    });
}

function saveResults(campus, ec, or, ca, ea, style) {
  ca_ec = ca - ec
  ea_or = ea - or
  payload = {campus, ec, or, ca, ea, ca_ec, ea_or, style}

  $.post("/styles/save.json", payload)
    .done(function(data) {
      $("#saveResultMsg").show()
      $("#saveResultMsg").text(data.code == "201" ? "Resultados guardados correctamente" : "Ocurrio un error intente mas tarde")
    });
}
