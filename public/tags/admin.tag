<admin>
  <div class="login" if={!currentUser}>
    <p>Thanks for visiting. Please proceed to Google Authentication</p>
    <button type="button" onclick={ logIn }>Login</button>
  </div>

  <private_d3 if={currentUser}></private_d3>
  
  
  <script>
    var tag = this;

    // Firebase provide us with easy methods to sign-in and sign-out. We can access all Firebase authentication methods by creating an Auth Object via the following:
    this.currentUser = firebase.auth().currentUser;

    // Listener
    user.onAuthStateChanged(function (userObj) {
      tag.currentUser = firebase.auth().currentUser;
      console.log("on stage change: this.currentUser", this.currentUser);
      tag.update();
    });

    //sign-in with google
    this.logIn = function () {
      console.log("logging in...");
      var provider = new firebase.auth.GoogleAuthProvider();
      user.signInWithPopup(provider);
      // firebase.auth()
    }

  </script>

  <style>
    :scope {
      display: block;
      padding: 2em;
    }

    .login {
      background-color: lightgrey;
      padding: 2em;
      margin-top: 2em;
    }

    .memeMaker {
      padding: 2em;
      margin-top: 2em;
      background-color: grey;
    }

    .order {
      padding: 2em;
      margin-top: 2em;
      background-color: powderblue;
    }

    .filter {
      padding: 2em;
      margin-top: 2em;
      background-color: steelblue;
    }
  </style>
</admin>
