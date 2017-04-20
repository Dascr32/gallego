// This went from a small js file to a monster real quick
// Best thing is to make it rails-style, but 'ain't nobody have time for that'
$(document).ready(function() {
  learningStyles()
  campus()
  genders()
  learningStylesAlt()
  professors()
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

function campus() {
  $("#campusSuccess").hide()

  $("#campusForm").on('submit', function(ev){
    ev.preventDefault();
    $("#campusSuccess").show()
    $("#computingMessage").show()

    style = $("#learningStyleSelect").val()
    gender = $("#genderSelect").val()
    gpa = parseGpaValue("gpaInput")

    $.post("/campus/compute.json", { style, gender, gpa })
      .done(function(data) {
        $("#campusSuccess").show()
        $("#campusResult").show()
        $("#computingMessage").hide()

        $("#campusResult").text(data.campus)
      });
  });
}

function genders() {
  $("#genderSuccess").hide()

  $("#genderForm").on('submit', function(ev){
    ev.preventDefault();
    $("#genderSuccess").show()
    $("#genderComputingMsg").show()

    style = $("#genderLearningStyleSelect").val()
    campus = $("#genderCampusSelect").val()
    gpa = parseGpaValue("genderGpaInput")

    $.post("/genders/compute.json", { style, campus, gpa })
      .done(function(data) {
        $("#genderSuccess").show()
        $("#genderComputingMsg").hide()

        $("#genderResult").text(data.gender == "M" ? "Masculino" : "Femenino")
      });
  });
}

function learningStylesAlt() {
  $("#styleAltSuccess").hide()

  $("#styleAltForm").on('submit', function(ev){
    ev.preventDefault();
    $("#styleAltSuccess").show()
    $("#styleAltComputingMsg").show()

    campus = $("#styleAltCampusSelect").val()
    gender = $("#styleAltGenderSelect").val()
    gpa = parseGpaValue("styleAltGpaInput")

    $.post("/styles/compute_alt.json", { campus, gender, gpa })
      .done(function(data) {
        $("#styleAltSuccess").show()
        $("#styleAltComputingMsg").hide()

        $("#styleAltResult").text(data.style)
      });
  });
}

function professors() {
  $("#profSuccess").hide()

  $("#guessProfBtn").click(function() {
    $("#profSuccess").show()
    $("#profComputingMsg").show()

    age = parseRadioValue("age")
    gender = parseRadioValue("gender")
    c = parseRadioValue("eval")
    d = parseRadioValue("teachTimes")
    e = parseRadioValue("background")
    f = parseRadioValue("pcSkills")
    g = parseRadioValue("webTech")
    h = parseRadioValue("webSites")

    payload = {age, gender, c, d, e, f, g, h}
    
    $.post("/professors/compute.json", payload)
      .done(function(data) {
        $("#profSuccess").show()
        $("#profComputingMsg").hide()

        $("#profResult").text(data.category)
      });
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
  payload = { campus, ec, or, ca, ea, ca_ec, ea_or, style }

  $.post("/styles/save.json", payload)
    .done(function(data) {
      $("#saveResultMsg").show()
      $("#saveResultMsg").text(data.code == "201" ? "Resultados guardados correctamente" : "Ocurrio un error intente mas tarde")
    });
}

function parseValue(colName, subCol) {
  return parseInt($("#" + colName + "-" + subCol).val())
}

function parseGpaValue(id) {
  // Suport GPA with format 75 or 7.5
  num = Number($("#" + id).val())

  if (num % 10 === 0)
    num /= 10

  return num
}

function parseRadioValue(id) {
  return $("input[name=" + id + "Radio]:checked", "#profForm").val()
}
