var data;
var request = $.getJSON('/board_config.json', function(response){
  data = response
  return data
}).fail(function(response){
  console.log('json not loaded')
});

function onYouTubeIframeAPIReady() {
  console.log('loaded and launched youtube')
  var player;
  player = new YT.Player('youtube_video', {
    videoId: data.youtube_id,
    width: 560,
    height: 316,
    playerVars: {
      autoplay: 1,
      controls: 1,
      showinfo: 0,
      modestbranding: 1,
      loop: 1,
      fs: 0,
      cc_load_policy: 0,
      iv_load_policy: 3,
      autohide: 0,
      playlist: data.youtube_id
    },
    events: {
      onReady: function(e) {
        e.target.mute();
      }
    }
  });
};

function checkReload() {
  data;
  request = $.getJSON('/board_config.json', function(response){
    data = response
    return data
  }).fail(function(response){
    console.log('json not loaded')
  });

  if (data.reload === "true") {
    console.log('reloading!')
    location.reload()
  } else {
    console.log('no need to reload')
  }
};

function startClock() {
  setInterval(function() {
    var date = new Date();
    var hour = date.getHours();
    var hour12 = hour % 12;
    var hourString = hour12 === 0 ? '12' : hour12.toString();
    var amPm = (hour < 12) ? ' am' : ' pm';
    var minutes = date.getMinutes().toString();
    var minutesString = (minutes.length === 1) ? '0' + minutes : minutes;
    var seconds = date.getSeconds().toString();
    var secondsString = (seconds.length === 1) ? '0' + seconds : seconds;
    var time = hourString + ':' + minutesString + ':' + secondsString + amPm;
    $('#clock').html(time);
  }, 1000);
}

function initTimer() {
  setInterval(checkReload, 5000)
};

console.log('app.js loaded');

initTimer();
startClock();
onYouTubeIframeAPIReady();

