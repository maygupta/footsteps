
$(document).ready(function(){
  $('.timepicker').timepicker()
  $('#save_card').click(function(e){
    data = {
      rounds: $("#japa_rounds").val(),

    }
    console.log(data)
    
  });

  $("#update").click(function(e){
    data = {
      date: $('input#date').val(),
      japa_rounds: $('input#japa_rounds').val(),
      service: $('input#service').val(),
      hearing: $('input#hearing').val(),
      reading: $('input#reading').val(),
      service_type: $('#service_type').val(),
      hearing_type: $('#hearing_type').val(),
      reading_type: $('#reading_type').val(),
      chad: $('input#chad').val(),
      wake_up: $('input#wake_up').val(),
      slept_at: $('input#slept_at').val(),
      id: $("div#sc_id").text()
    }


    $.ajax({
      url: "/sadhna_cards/" + data.id, 
      method: "put",
      data: data,
      success: function(data){
        window.location.href = "/sadhna_cards/" + data.id
      },
      failure: function(e){
        alert(e)
      }
    });

  })

  $('#create').click(function(e){
    data = {
      date: $('input#date').val(),
      japa_rounds: $('input#japa_rounds').val(),
      service: $('input#service').val(),
      hearing: $('input#hearing').val(),
      reading: $('input#reading').val(),
      chad: $('input#chad').val(),
      service_type: $('#service_type').val(),
      hearing_type: $('#hearing_type').val(),
      reading_type: $('#reading_type').val(),
      wake_up: $('input#wake_up').val(),
      slept_at: $('input#slept_at').val()
    }

    $.ajax({
      url: "/sadhna_cards", 
      method: "post",
      data: data,
      success: function(data){
        window.location.href = "/sadhna_cards/" + data.id
      },
      failure: function(e){
        alert(e)
      }
    });

  })


});

