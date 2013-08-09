// Generated by CoffeeScript 1.6.3
(function() {
  var user;

  user = {
    name: "",
    list: null,
    isLoggedIn: function() {
      return name === "";
    },
    login: function(username, password, onSuccess, onFailure) {
      /* Ajax request*/

      return $.post("/login", {
        username: username,
        password: password
      }).success(function(data) {
        var params;
        params = $.parseJSON(data);
        user.name = params.name;
        user.list = params.list;
        if (typeof onSuccess === "function" && data !== "") {
          onSuccess(data);
        }
        if (typeof onFailure === "function" && data === "") {
          return onFailure();
        }
      }).fail(function() {
        var list;
        user.name = "";
        list = [];
        if (typeof onFailure === "function" && data === "") {
          return onFailure();
        }
      });
    },
    logout: function(username, password, callBack) {
      return $.post("/logout").fail((function() {
        user.name = "";
        user.list = [];
        if (typeof callBack === "function") {
          return callBack();
        }
      }).success(function() {
        user.name = "";
        user.list = [];
        if (typeof callBack === "function") {
          return callBack();
        }
      }));
    }
  };

  /* Dom ready*/


  $(function() {
    user.login("maan", "maan");
    return $("ul").sortable();
  });

}).call(this);