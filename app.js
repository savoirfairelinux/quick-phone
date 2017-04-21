function load() {
  userListModel.clear();
  return openFile("userList.json");
}

function openFile(fileUrl) {
  var request = new XMLHttpRequest();
  request.open("GET", fileUrl);
  request.onreadystatechange = function(event) {
    if (request.readyState == XMLHttpRequest.DONE) {
      return loaded(request.responseText);
    }
  }
  request.send();
}

function loaded(userList) {
  var users = JSON.parse(userList);
  users.map(function(user) {
    userListModel.append({
      "name": user.name,
      "ext": user.ext,
      "jobTitle": user.jobTitle,
      "team": user.team
    })
  })
}

var component;

function createContactCard(name, ext, jobTitle, team, pictureLocation) {
  if (component == null) {
    component = Qt.createComponent("./content/UserContactCard.qml");
  }

  if (component.status == Component.Ready) {
    var dynamicObject = component.createObject(appWindow);

    if (dynamicObject == null) {
      console.log("error creating contactCard");
      console.log(component.errorString());
      return false;
    }
    dynamicObject.name = name;
    dynamicObject.ext = ext;
    dynamicObject.jobTitle = jobTitle;
    dynamicObject.team = team;
    dynamicObject.pictureLocation = pictureLocation;


  } else {
    console.info("error loading contactCard component");
    console.log(component.errorString());
    return false;
  }
  return true;
}

function deleteContactCard(contactCard) {
  contactCard.destroy();
}
