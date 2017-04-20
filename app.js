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
