$(document).ready(function() {
  $("td a").hover(function(){
    $(this).parent().css("background-color", "grey");
    }, function () {
    $(this).parent().css("background-color", "initial");
  });
});