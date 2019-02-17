const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });


const admin = require('firebase-admin');

admin.initializeApp();

exports.addMessage = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
  const c = req.query.cat;
  const n = req.query.name;
  // Push the new message into the Realtime Database using the Firebase Admin SDK.
  return admin.firestore().collection("topics").add({
      category: c,
      name: n,
      lesson_text: "",
      video_url: "",
      depends: []
  }).then((snapshot) => {
    // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
    return res.status(200).send(snapshot.id);
  });
});

exports.getTopicsToLearn = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
  const e = req.query.email;
  console.log(e);
  return admin.firestore().collection("users").doc(e).get().then(function(user) {
    const learnedClasses = user.data().classesLearned.concat(user.data().classesProficient).concat(user.data().classesMastered);
    var finalList = {0: {}, 1: {}, 2: {}};
    return admin.firestore().collection("topics").get().then(function(querySnapshot) {
        querySnapshot.forEach(function(topic) {
            var canAdd = 1;
            topic.data().depends.forEach(function(c) {
              if(!learnedClasses.includes(c))
                canAdd = 0;
            });
            var mastery = 0;
            if(user.data().classesLearned.includes(topic.id))
              mastery = 1;
            else if(user.data().classesProficient.includes(topic.id))
              mastery = 2
            else if(user.data().classesMastered.includes(topic.id))
              mastery = 3;
            finalList[topic.data().category][topic.id] = {"id": topic.id, "name": topic.data().name, 'mastery': mastery, 'haveDependencies': canAdd};
        });
        newList = {0: {}, 1: {}, 2: {}};
        [0,1,2].forEach(function(d) {
          var count = 0;
          Object.keys(finalList[d]).sort(function(a,b){
            if(finalList[d][a]['mastery'] !== finalList[d][b]['mastery']) {
              return -finalList[d][b]['mastery'] + finalList[d][a]['mastery'];
            }
            else {
              return finalList[d][b]['haveDependencies'] - finalList[d][a]['haveDependencies'];
            }
          }).forEach(function(a) {
            newList[d][count] = finalList[d][a];
            count += 1;
          });
        });
        return res.status(200).send(newList);
    });
  });
});

exports.getTopicsToPractice = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
  const e = req.query.email;
  console.log(e);
  return admin.firestore().collection("users").doc(e).get().then(function(user) {
    const learnedClasses = user.data().classesLearned.concat(user.data().classesProficient).concat(user.data().classesMastered);
    var finalList = {0: {}, 1: {}, 2: {}};
    return admin.firestore().collection("topics").get().then(function(querySnapshot) {
        querySnapshot.forEach(function(topic) {
            var canAdd = 0;
            if(learnedClasses.includes(topic.id))
                canAdd = 1;
            var mastery = 0;
            if(user.data().classesLearned.includes(topic.id))
              master = 1;
            else if(user.data().classesProficient.includes(topic.id))
              master = 2
            else if(user.data().classesMastered.includes(topic.id))
              master = 3;
            finalList[topic.data().category][topic.id] = {"id": topic.id, "name": topic.data().name, 'mastery': mastery, 'haveAleadyLearned': canAdd};
        });
        newList = {0: {}, 1: {}, 2: {}};
        [0,1,2].forEach(function(d) {
          var count = 0;
          Object.keys(finalList[d]).sort(function(a,b){
            if(finalList[d][a]['mastery'] !== finalList[d][b]['mastery']) {
              return -finalList[d][b]['mastery'] + finalList[d][a]['mastery'];
            }
            else {
              return finalList[d][b]['haveAleadyLearned'] - finalList[d][a]['haveAleadyLearned'];
            }
          }).forEach(function(a) {
            newList[d][count] = finalList[d][a];
            count += 1;
          });
        });
        return res.status(200).send(newList);
    });
  });
});

exports.getLesson = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
  const l = req.query.lessonID;

  return admin.firestore().collection("topics").doc(l).get().then(function(topic) {
    return res.status(200).send({"id": topic.id, "cat": topic.data().category, "name": topic.data().name, "video": topic.data().video_url, "url": "https://nexgenmath.firebaseapp.com/" + topic.data().lesson_text});
  });
});

exports.markAsLearned = functions.https.onRequest((req, res) => {
  const l = req.query.lessonID;
  const e = req.query.email;
  return admin.firestore().collection("users").doc(e).get().then(function(info) {
    var c = info.data().classesLearned;
    c.push(l);
    admin.firestore().collection("users").doc(e).update({
      "classesLearned": c
    });
    return res.status(200).send("hello");
  });
});

exports.getPracticeProblem =  functions.https.onRequest((req, res) => {

  var reduce = function(numerator,denominator){
    var gcd = function gcd(a,b){
      return b ? gcd(b, a%b) : a;
    };
    gcd = gcd(numerator,denominator);
    return [numerator/gcd, denominator/gcd];
  }
  // Grab the text parameter.
  const l = req.query.lessonID;
  if(l === "w7N6Foj7vLd8q6l1j66R") { //solving linear equations
    var problem = "Solve for %5C(x%5C) : %5C(";
    //var a = Math.floor((Math.random()-0.5) * 40);
    var a = Math.floor((Math.random()-0.5) * 40);
    var b = Math.floor((Math.random()-0.5) * 40);
    var c = Math.floor((Math.random()-0.5) * 40);

    if(b > 0)
      problem += a + "x %2B" + b + "=" + c + "%5C)";
    else if (b < 0){
      problem += a + "x %2D" + -b + "=" + c + "%5C)";
    }
    else {
      problem += a + "x =" + c + "%5C)";
    }

    var solution = "";
    var answer = 0;
    if(a === 0)
      a = 2;
    else {
      if(b > 0) {
        solution = "First, isolate the variable term by subtracting %5C(" + b + "%5C) from both sides, leaving %5C(";
        solution += a + "x = " + (c-b) + "%5C). Next, divide by %5C(" + a + "%5C) to isolate the variable. ";
      }
      else if (b < 0) {
        solution = "First, isolate the variable term by adding %5C(" + -b + "%5C) to both sides, leaving %5C(";
        solution += a + "x = " + (c-b) + "%5C). Next, divide by %5C(" + a + "%5C) to isolate the variable. ";
      }
      else {
        solution = "First, divide by %5C(" + a + "%5C) to isolate the variable. ";
      }

      if((c-b) % a === 0) {
        solution += "This leaves you with %5C(x = " + (c-b)/a + "%5C), which is the solution.";
        answer = "{" + ((c-b)/a).toString() + "}{1}";
      }
      else {
        reduced = reduce(Math.abs(c-b), Math.abs(a));
        if(reduced[0] === Math.abs(c-b)) {
          if((c-b) < 0 && a < 0) {
            solution += "This leaves you with %5C(x = %5Cfrac{" + (-c+b) + "}{" + -a + "}%5C), which is the solution.";
            answer = "{" + reduced[0] + "}{" + reduced[1] + "}";
          }
          else if(a < 0 || (c-b) < 0) {
            solution += "This leaves you with %5C(x = %5Cfrac{" + (-c+b) + "}{" + -a + "}%5C), which is the solution.";
            answer = "{" + -reduced[0] + "}{" + reduced[1] + "}";
          }
          else {
            solution += "This leaves you with %5C(x = %5Cfrac{" + (c-b) + "}{" + a + "}%5C), which is the solution.";
            answer = "{" + reduced[0] + "}{" + reduced[1] + "}";
          }
        }
        else {
          if((c-b) < 0 && a < 0) {
            solution += "This leaves you with %5C(x = %5Cfrac{" + (-c+b) + "}{" + -a + "}%5C), which then can be reduced into ";
            solution += "%5C(%5Cfrac{" + reduced[0] + "}{" + reduced[1] + "}%5C)."
            answer = "{" + reduced[0] + "}{" + reduced[1] + "}";
          }
          else if(a < 0 || (c-b) < 0) {
            solution += "This leaves you with %5C(x = %5Cfrac{" + (-c+b) + "}{" + -a + "}%5C), which then can be reduced into ";
            solution += "%5C(%5Cfrac{" + -reduced[0] + "}{" + reduced[1] + "}%5C)."
            answer = "{" + -reduced[0] + "}{" + reduced[1] + "}";
          }
          else {
            solution += "This leaves you with %5C(x = %5Cfrac{" + (c-b) + "}{" + a + "}%5C), which then can be reduced into ";
            solution += "%5C(%5Cfrac{" + reduced[0] + "}{" + reduced[1] + "}%5C)."
            answer = "{" + reduced[0] + "}{" + reduced[1] + "}";
          }
        }
      }
    }
    var env = ["X = ", "&numberbox{infinitely Many Solutions, No Solutions}"];

    return res.status(200).send({question: "https://us-central1-nexgenmath.cloudfunctions.net/texRender?tex="+problem, answer: answer, solution: "https://us-central1-nexgenmath.cloudfunctions.net/texRender?tex="+solution, answerENV: env});
  }
  else if(l === "vEpLFEDV9uvWcsCN3pQ4") {
    var length = Math.floor((Math.random()) * 6) + 1;
    var width = Math.floor((Math.random()) * 6) + 1;
    var matrix = "";
    matrix += "Find the dimentions of: %5Cbegin{bmatrix}";
    for(var i = 0; i < length; i++) {
        var row = "";
        for(var j = 0; j < width; j++) {
          row += Math.floor((Math.random()-0.5) * 40);
          if(j !== (width-1)) {
            row += " %26";
          }
        }
        if(i !== (length - 1))
          row += "%5C%5C";
        matrix += row;
      }
      matrix += "%5Cend{bmatrix}"
      answer = "{" + length + "}{" + width + "}";
      solution = "The matrix has " + length + " rows and " + width + " columns, so the dimentions are %5C(" + length + " X " + width + "%5C).";
      return res.status(200).send({question: "https://us-central1-nexgenmath.cloudfunctions.net/texRender?tex="+matrix, answer: answer, solution: "https://us-central1-nexgenmath.cloudfunctions.net/texRender?tex="+solution});
    }
    else if(l === "cde3ga0zlmRWzPPyCFgV") {
      a = Math.floor((Math.random() - 0.5) * 12);
      b = Math.floor((Math.random() - 0.5) * 12);
      c = Math.floor((Math.random() - 0.5) * 12);
      d = Math.floor((Math.random() - 0.5) * 12);
      ans = a*d-b*c;
      ad = a*d;
      bc = b*c;
      matrix = "";
      matrix += "Find the determinant of: %5Cbegin{bmatrix} " + a + " %26" + b + " %5C%5C " + c + " %26" + d ;
      matrix += " %5Cend{bmatrix}"
      answer = "{" + ans + "}{" + 1 + "}";
      solution = "";
      solution += "Multiplying AD yields %5C(" + a + "*" + d + " = " + ad + "%5C). ";
      solution += "Multiplying BC yields %5C(" + b + "*" + c + " = " + bc + "%5C). ";
      if(bc >= 0)
        solution += "Subtracting BC from AD yields %5C(" + ad + "-" + bc + "=" + ans + "%5C), which is the determinant."
      else
        solution += "Subtracting BC from AD yields %5C(" + ad + "%2B" + -bc + "=" + ans + "%5C), which is the determinant."
      return res.status(200).send({question: "https://us-central1-nexgenmath.cloudfunctions.net/texRender?tex="+matrix, answer: answer, solution: "https://us-central1-nexgenmath.cloudfunctions.net/texRender?tex="+solution});
    }
  return res.status(200).send("ERROR");
});


exports.setupAccount = functions.auth.user().onCreate((user) => {
  admin.firestore().collection("users").doc(user.email).update({
      classesLearned: [],
      classesProficient: [],
      classesMastered: []
  });
});

exports.texRender = functions.https.onRequest((req, res) => {
  const tex = req.query.tex;
  var s = "";
  s += "<!DOCTYPE html>";
  s += "<html>";
  s += "<head>";
  s += "<script src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML' async></script>";
  s += "</head>"
  s += "<body style='background-color:#dcdcdd'>";
  s += "<div id=\"math\">";
  s += tex.replace("$$", String.raw`\(`);
  s += "</div></body></html>"
  return res.status(200).send(s);
});
