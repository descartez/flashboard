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

function initTimer() {
  setInterval(checkReload, 5000)
};

console.log('app.js loaded');

initTimer();
onYouTubeIframeAPIReady();

