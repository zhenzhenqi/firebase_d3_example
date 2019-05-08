<private_d3>
  <div class="login" if={currentUser}>
    <p>Welcome to the admin section, {currentUser.uid}</p>
    <button type="button" onclick={ logOut}>Log Out</button>
  </div>

  <div class="memeMaker">
    <input type="text" ref="urlEl" placeholder="Enter url">
    <input type="text" ref="captionEl" placeholder="Enter caption">
    <input type="text" ref="funnyEl" placeholder="Enter funness (0 to 5)">
    <button type="button" onclick={ saveMeme }>Add Meme</button>
  </div>

  <div show={ myMemes.length == 0 }>
    <p>NO MEMEs. Add a meme from above.</p>
  </div>

  <admin_entry each={ myMeme in myMemes }></admin_entry>

  <div class="chart-example" id="chart">
    <svg></svg>
  </div>


  <script>
    var tag = this;

    var totalCount = 9;
    var nofun = 3; //default count
    var somefun = 3; //default count
    var veryfun = 3; //default count

    // console.log("parent " ,this.parent.currentUser);
    this.currentUser = user.currentUser;
    // console.log(this.currentUser.uid); this.logOut = this.parent.logOut;

    this.logOut = function () {
      console.log("logging out...");
      user.signOut();
    }

    var myRef = rootRef.child('memes/private/' + tag.currentUser.uid);

    //local database is always empty, and read dynamicly from fb.
    this.myMemes = [];

    //prepare to push into memes subdirectory in our database
    this.saveMeme = function () {
      let key = myRef.push().key;
      let meme = {
        id: key,
        userID: this.currentUser.uid, //global google authenticated user object
        public: false,
        url: this.refs.urlEl.value,
        caption: this.refs.captionEl.value,
        funness: this.refs.funnyEl.value
      }

      //messagesRef.child(key).set(meme); set meme while catching potential error messages(optional)
      myRef.child(key).set(meme).then(function (result) {
        console.log(result);
      }).catch(function (error) {
        console.log(error.message);
      });
      this.reset();
      // this.count();
    }

    this.reset = function () {
      //clean up default input values
      this.refs.urlEl.value = "";
      this.refs.captionEl.value = "";
      this.refs.funnyEl.value = "";
    }

    // listen to database value change and update result
    myRef.on('value', function (snap) {
      let rawdata = snap.val();
      // console.log("rawdata", rawdata);
      let tempData = [];
      for (key in rawdata) {
        tempData.push(rawdata[key]);
      }
      // console.log("myMemes", tag.myMemes);
      tag.myMemes = tempData;
      tag.update();
      observable.trigger('updateMemes', tempData);

      tag.updateCount();
      tag.change();
    });

    myRef.orderByChild("funness").equalTo("0").on("value", function (snapshot) {
      nofun = snapshot.numChildren();
      console.log("nofun", nofun);
    });

    myRef.orderByChild("funness").startAt('1').endAt('4').on("value", function (snapshot) {
      somefun = snapshot.numChildren();
      console.log("somefun", somefun);
    });

    myRef.orderByChild("funness").equalTo("5").on("value", function (snapshot) {
      veryfun = snapshot.numChildren();
      console.log("veryfun", veryfun);
    });


    this.updateCount = function () {
      totalCount = nofun + somefun + veryfun;
      data[0]["value"] = nofun;
      data[1]["value"] = somefun;
      data[2]["value"] = veryfun;
      console.log("data", data);
    }

    ///////////////////// d3 starts here///// /////////////
    var data = [
      {
        "label": "nofun",
        "value": nofun
        // "value": nofun/totalCount*100
      }, {
        "label": "somefun",
        "value": somefun
        // "value": somefun/totalCount*100
      }, {
        "label": "veryfun",
        "value": veryfun
        // "value": veryfun/totalCount*100
      }
    ];



    var w = 300, //width
      h = 300, //height
      r = 100, //radius
      color = d3.scale.category20c(); //builtin range of colors

    this.change = function(){
    var vis = d3.select("body").append("svg:svg"). //create the SVG element inside the <body>
    data([data]). //associate our data with the document
    attr("width", w). //set the width and height of our visualization (these will be attributes of the <svg> tag
    attr("height", h).append("svg:g"). //make a group to hold our pie chart
    attr("transform", "translate(" + r + "," + r + ")") //move the center of the pie chart from 0, 0 to radius, radius

    var arc = d3.svg.arc(). //this will create <path> elements for us using arc data
    outerRadius(r);


    var pie = d3.layout.pie(). //this will create arc data for us given a list of values
    value(function (d) {
      return d.value;
    }); //we must tell it out to access the value of each element in our data array

    var arcs = vis.selectAll("g.slice"). //this selects all <g> elements with class slice (there aren't any yet)
    data(pie). //associate the generated pie data (an array of arcs, each having startAngle, endAngle and value properties)
    enter(). //this will create <g> elements for every "extra" data element that should be associated with a selection. The result is creating a <g> for every object in the data array
    append("svg:g"). //create a group to hold each slice (we will have a <path> and a <text> element associated with each slice)
    attr("class", "slice"); //allow us to style things in the slices (like text)

    arcs.append("svg:path").attr("fill", function (d, i) {
      return color(i);
    }). //set the color for each slice to be chosen from the color function defined above
    attr("d", arc); //this creates the actual SVG path using the associated data (pie) with the arc drawing function

    arcs.append("svg:text"). //add a label to each slice
    attr("transform", function (d) { //set the label's origin to the center of the arc
      //we have to make sure to set these before calling arc.centroid
      d.innerRadius = 0;
      d.outerRadius = r;
      return "translate(" + arc.centroid(d) + ")"; //this gives us a pair of coordinates like [50, 50]
    }).attr("text-anchor", "middle"). //center the text on it's origin
    text(function (d, i) {
      return data[i].label;
    }); //get the label from our original data array
}
  </script>

  <style>
    .slice text {
      font-size: 16pt;
      font-family: Arial;
    }
  </style>

</private_d3>
