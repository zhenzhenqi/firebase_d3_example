<admin_entry>
  <!-- <img src={ url } alt="user image" /> -->
  <p>url: {myMeme.url}</p>
  <p>caption: { myMeme.caption }</p>
  <p>funness: { myMeme.funness }</p>
  <p>user id: {myMeme.userID}</p>
  <p>id: {myMeme.id}</p>

  <button type="button" onclick={ remove }>Remove This</button>
  <button type="button" onclick={ toggle }>{ myMeme.public ? "UNPUBLISH" : "PUBLISH"}</button>
  <style>
    :scope {
      display: block;
      background-color: pink;
      margin-top: 2em;
      padding: 2em;
    }
  </style>

  <script>
    var messagesRef = rootRef.child('/memes');
    // console.log("messagesRef", messagesRef);

    this.remove = function () {
      // console.log("this.id", this.id); remember how we pushed the unique key as a property of each meme?
      var updates = {};
      updates['public/' + this.myMeme.id] = null;
      updates['private/' + this.myMeme.userID + '/' + this.myMeme.id] = null;

      messagesRef.update(updates);
      // rootRef.child("/memes/private/test").remove();
    }

    // console.log("this.meme", this.meme);

    let updates = {};

    this.toggle = function () {
      this.myMeme.public = !this.myMeme.public;
      updates['private/' + this.myMeme.userID + '/' + this.myMeme.id] = this.myMeme;
      if (this.myMeme.public) {
        // console.log("this.myMeme".this.myMeme);
        updates['public/' + this.myMeme.id] = this.myMeme;
      } else {
        updates['public/' + this.myMeme.id] = null;
      }

      // console.log("this.myMeme", this.myMeme);
      // console.log("updates", updates);
      messagesRef.update(updates);
    }
  </script>

</admin_entry>
