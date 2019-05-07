<memes>
  <meme each={ myMeme in myPublicMemes }></meme>

  <script>
    var tag = this;
    this.myPublicMemes = [];
    var myRef = rootRef.child('memes/public/');
    myRef.on('value', function (snap) {
      let rawdata = snap.val();
      // console.log("rawdata", rawdata);
      let tempData = [];
      for (key in rawdata) {
        tempData.push(rawdata[key]);
      }
      // console.log("myMemes", tag.myMemes);
      tag.myPublicMemes = tempData;
      tag.update();
    });

  </script>

  <style>
  :scope {
    display: inline-block;
  }
  img {
    width: 100%;
  }
</style>
</memes>
