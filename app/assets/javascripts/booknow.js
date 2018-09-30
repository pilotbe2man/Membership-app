$(document).ready(function()
{

$(function() {
$('.pro').click(function() { 
    $('.pink').show(); 
    $(".pro").css("background-color", "#id95ce");
    $(".pro").css("opacity", "0.9");
    $(".commit").css("opacity", "");
    $(".commit").css("background-color", "");
    $(".acc").css("background-color", "");
    $(".acc").css("opacity", "");
    $('.all').hide(); 
    $('.blue').hide(); 
});
});    

$(function() {
$('.commit').click(function() { 
    $('.blue').show(); 
    $('.pink').show();
    $(".commit").css("opacity", "0.9");
    $(".commit").css("background-color", "#id95ce");
    $(".pro").css("background-color", "");
    $(".pro").css("opacity", "");
    $(".acc").css("background-color", "");
    $(".acc").css("opacity", "");
    $('.all').hide(); 
});
});    

$(function() {
$('.acc').click(function() { 
    $('.blue').show(); 
    $('.pink').show();
    $('.all').show();
    $(".acc").css("background-color", "#id95ce");
    $(".acc").css("opacity", "0.9");
    $(".pro").css("background-color", "");
    $(".pro").css("opacity", "");
    $(".commit").css("background-color", "");
    $(".commit").css("opacity", "");
});
});

});    