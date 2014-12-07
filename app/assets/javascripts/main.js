var map;
var infowindow = null;
var activeMarker = null;
var autocompleteList= [];

function makeInfoWindow(item, marker) {
  var contentString = '<div class="infowindow"><p><img src="' + item.logo_json_url + '" width="30px" /><b>' + item.name +'</b></p><p>' + item.description +'</p><p><a href="'+ item.website +'" target="blank">' + item.website + '</a></p><p class="address">' + item.address + '</p></div>';

  if (infowindow)
    infowindow.close();

  infowindow = new google.maps.InfoWindow({
    content: contentString
  });

  google.maps.event.addListener(infowindow,'closeclick',function(){
     activeMarker.setAnimation(null);
  });

  infowindow.open(map,marker);
}

function appendToListing(item, marker) {

  var listItem = document.createElement('li');
  $(listItem).attr('data-name', item.name);
  $(listItem).append('<span>' + item.name + '</span>');

  $(listItem).click(function() {
    map.panTo( new google.maps.LatLng( (item.latitude + 0.02),item.longitude) );
    makeInfoWindow(item, marker);


    if(activeMarker)
      activeMarker.setAnimation(null);

    activeMarker = marker;
    marker.setAnimation(google.maps.Animation.BOUNCE);

    marker.setMap(map);
  });

  if(item.category.name == 'Startups')
    $('#startupsList').append(listItem);
  else if(item.category.name == 'Investors')
    $('#investorsList').append(listItem);
  else if(item.category.name == 'Incubators')
    $('#incubatorsList').append(listItem);
  else if(item.category.name == 'Coworking Space')
    $('#coworkingList').append(listItem);
  else if(item.category.name == 'Accelerators')
    $('#acceleratorsList').append(listItem);
}

$(function() {

  $('#logoClick').click(function() {
    location.reload();
  });

  //setup accordians

  $('.listing ul li span').click(function() {
    var $this = $(this);
    $this.siblings('.content').toggle();
  });

  //inital map options

  var mapOptions = {
    center: { lat: 19.049943, lng: 72.851061},
    zoom: 11
  };

  //get JSON file

  $.getJSON("/fetch", function( data ) {
    // initial map object
    map = new google.maps.Map(document.getElementById('map'), mapOptions);
    // iterate through the JSON data
    $.each(data, function( key, val ) {
      // lat long for current location
      var myLatlng = new google.maps.LatLng(val.latitude,val.longitude);

      //marker for current company
      var imgUrl = '/assets/marker-startup.png';
      if(val.category.name == 'Startups')
        imgUrl = '/assets/marker-startup.png';
      else if(val.category.name == 'Investors')
        imgUrl = '/assets/marker-investor.png';
      else if(val.category.name == 'Incubators')
        imgUrl = '/assets/marker-incubator.png';
      else if(val.category.name == 'Coworking Space')
        imgUrl = '/assets/marker-coworking.png';
      else if(val.category.name == 'Accelerators')
        imgUrl = '/assets/marker-accelerator.png';

      var marker = new google.maps.Marker({
          position: myLatlng,
          map: map,
          title: val.name,
          icon: { url: imgUrl, scaledSize: new google.maps.Size(32, 38) },
          animation: google.maps.Animation.DROP
        });

      //when marker is clicked
      google.maps.event.addListener(marker, 'click', function() {

        if(activeMarker)
          activeMarker.setAnimation(null);

        activeMarker = marker;
        marker.setAnimation(google.maps.Animation.BOUNCE);
        marker.setMap(map);

        // info window for current company
        makeInfoWindow(val, marker);
        map.panTo( new google.maps.LatLng( (val.latitude + 0.02), val.longitude ) );
      });

      marker.setMap(map);

      // append to listing
      appendToListing(val, marker);

      autocompleteList.push(val.name);
    });

    $( "#searchField" ).autocomplete({
      source: autocompleteList,
      minLength: 2,

    });

    $( "#searchField" ).on( "autocompleteselect", function( event, ui ) {
      var value = $(this).val()
      $('#searchField').val('');
      $('*[data-name="' + value + '"]').click();
    });

  });
});