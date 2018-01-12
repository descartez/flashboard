var data;
var request = $.getJSON('/board_config.json', function(response){
  data = response
  console.log(data)
  return data
  }).fail(function(response){
  console.log('json not loaded')
});

function onYouTubeIframeAPIReady() {
  console.log('loaded and launched youtube script')
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
}
onYouTubeIframeAPIReady()