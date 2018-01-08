function load() {

}

function onYouTubeIframeAPIReady() {
  console.log('loaded and launched youtube script')
  var player;
  player = new YT.Player('youtube_video', {
    videoId: 'p8VcXbt08mU',
    width: 560,
    height: 316,
    playerVars: {
      autoplay: 1,
      controls: 0,
      showinfo: 0,
      modestbranding: 1,
      loop: 1,
      fs: 0,
      cc_load_policy: 0,
      iv_load_policy: 3,
      autohide: 0,
      playlist: 'p8VcXbt08mU'
    },
    events: {
      onReady: function(e) {
        e.target.mute();
      }
    }
  });
}

onYouTubeIframeAPIReady()